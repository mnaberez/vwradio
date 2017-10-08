#ifndef MAIN_H
#define MAIN_H
#define F_CPU 20000000UL
#define BAUD 115200

#include <stdint.h>

#define STATE_IDLE_TAPE_OUT 0
#define STATE_STARTING_PLAY 1
#define STATE_PLAYING 2
#define STATE_IDLE_TAPE_IN 3

#endif
