#ifndef RINGBUF_H
#define RINGBUF_H

#include <stdint.h>

/*************************************************************************
 * Ring Buffers for UART
 *************************************************************************/

typedef struct
{
    uint8_t data[256];
    uint8_t write_index;
    uint8_t read_index;
} ringbuffer_t;

void buf_init(volatile ringbuffer_t *buf);
void buf_write_byte(volatile ringbuffer_t *buf, uint8_t c);
uint8_t buf_read_byte(volatile ringbuffer_t *buf);
uint8_t buf_has_byte(volatile ringbuffer_t *buf);

#endif
