#include "ringbuf.h"

/*************************************************************************
 * Ring Buffers for UART
 *************************************************************************/

void buf_init(volatile ringbuffer_t *buf)
{
    buf->read_index = 0;
    buf->write_index = 0;
}

void buf_write_byte(volatile ringbuffer_t *buf, uint8_t c)
{
    buf->data[buf->write_index++] = c;
}

uint8_t buf_read_byte(volatile ringbuffer_t *buf)
{
    uint8_t c = buf->data[buf->read_index++];
    return c;
}

uint8_t buf_has_byte(volatile ringbuffer_t *buf)
{
    return buf->read_index != buf->write_index;
}
