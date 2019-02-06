/*
 * This file is part of the MicroPython project, http://micropython.org/
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Scott Shawcroft for Adafruit Industries
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "boards/board.h"
#include "mpconfigboard.h"
#include "hal/include/hal_gpio.h"
#include "py/obj.h"
#include "shared-bindings/microcontroller/Processor.h"
#include "hal/include/hal_spi_m_sync.h"
#include "hal/include/hpl_spi_m_sync.h"
#include "shared-bindings/busio/SPI.h"
#include "shared-bindings/microcontroller/Pin.h"
#include "samd/dma.h"
#include "samd/sercom.h"
#include "supervisor/shared/stack.h"
#include "supervisor/filesystem.h"
#include "supervisor/shared/autoreload.h"
#include "supervisor/port.h"
#include <string.h>

#define BOARD_CS_BTN_PORT                 (1)
#define BOARD_CS_BTN_PIN                  (3)

#define CS_BTN_INIT()   PORT->Group[BOARD_CS_BTN_PORT].DIRSET.reg = (1UL<<BOARD_CS_BTN_PIN)
#define CS_BTN_H()   PORT->Group[BOARD_CS_BTN_PORT].OUT.reg |= (1UL<<BOARD_CS_BTN_PIN)
#define CS_BTN_L()   PORT->Group[BOARD_CS_BTN_PORT].OUT.reg &= ~(1UL<<BOARD_CS_BTN_PIN)

void board_init(void) {
    WDT->CTRL.bit.ENABLE = 0;
}

bool board_requests_safe_mode(void) {
    return false;
}

void gamebuino_meta_reset(void);
void gamebuino_meta_begin(void);
void gamebuino_meta_titlescreen(void);
void start_mp(supervisor_allocation* heap);
void stop_mp(void);
bool firstReset = true;
void reset_board(void) {
    if (firstReset) {
        stack_resize();
        filesystem_flush();
        supervisor_allocation* heap = allocate_remaining_memory();
        start_mp(heap);
        autoreload_suspend();
        
        // code here
        gamebuino_meta_begin();
        gamebuino_meta_titlescreen();
        
        reset_port();
//        reset_board();
        gamebuino_meta_reset();
        stop_mp();
        free_memory(heap);
    }
    firstReset = false;
}

void shared_modules_random_seed(mp_uint_t);

void gamebuino_meta_pick_random_seed(void) {
    unsigned int seed = 42;
    shared_modules_random_seed(seed);
}

void* gb_malloc(size_t size) {
    return m_malloc(size, true);
}

void gb_free(void* ptr) {
    m_free(ptr);
}

busio_spi_obj_t spi_obj;
bool inited_spi = false;
void spi_init(void) {
    if (inited_spi) {
        return;
    }
    common_hal_busio_spi_construct(&spi_obj, &pin_PB11, &pin_PB10, &pin_PA12);
    common_hal_busio_spi_never_reset(&spi_obj);
    inited_spi = true;
}

// button functions
void gamebuino_meta_buttons_init(void) {
    spi_init();
    CS_BTN_INIT();
    CS_BTN_H();
}
uint8_t gamebuino_meta_buttons_update(void) {
    CS_BTN_L();
    common_hal_busio_spi_configure(&spi_obj, 12000000, 0, 0, 8);
    uint8_t r;
    common_hal_busio_spi_read(&spi_obj, &r, 1, 0xFF);
    CS_BTN_H();
    return r;
}

// tft functions
void gamebuino_meta_tft_spi_begin(void) {
    spi_init();
}
void gamebuino_meta_tft_spi_begin_transaction(void) {
    common_hal_busio_spi_configure(&spi_obj, 24000000, 0, 0, 8);
}
void gamebuino_meta_tft_spi_end_transaction(void) {
    // do nothing for now
}
void gamebuino_meta_tft_spi_transfer(uint8_t d) {
    common_hal_busio_spi_write(&spi_obj, &d, 1);
}
void gamebuino_meta_tft_send_buffer(uint16_t* buf, uint16_t size) {
    sercom_dma_write_nowait(spi_obj.spi_desc.dev.prvt, (uint8_t*)buf, size*2);
}
void gamebuino_meta_tft_wait_for_transfers_done(void) {
    sercom_dma_transfer_wait(spi_obj.spi_desc.dev.prvt);
}
void gamebuino_meat_tft_wait_for_desc_available(const uint32_t num) {
    gamebuino_meta_tft_wait_for_transfers_done();
}


// delay functions
extern volatile uint64_t ticks_ms;
uint32_t millis(void) {
    return ticks_ms;
}

uint32_t micros(void) {
    uint32_t ticks, ticks2;
    uint32_t pend, pend2;
    uint32_t count, count2;

    ticks2  = SysTick->VAL;
    pend2   = !!(SCB->ICSR & SCB_ICSR_PENDSTSET_Msk)  ;
    count2  = ticks_ms ;

    do
    {
        ticks=ticks2;
        pend=pend2;
        count=count2;
        ticks2  = SysTick->VAL;
        pend2   = !!(SCB->ICSR & SCB_ICSR_PENDSTSET_Msk)  ;
        count2  = ticks_ms ;
    } while ((pend != pend2) || (count != count2) || (ticks < ticks2));

    return ((count+pend) * 1000) + (((SysTick->LOAD  - ticks)*(1048576/(common_hal_mcu_processor_get_frequency()/1000000)))>>20) ;
}

void yield(void);
void delay(uint32_t ms) {
    if (ms == 0) {
        return;
    }
    uint32_t start = ticks_ms;
    do {
        yield();
    } while (ticks_ms - start < ms);
}

void __cxa_pure_virtual(void) { while(1); }
void __cxa_deleted_virtual(void) { while(1); }
