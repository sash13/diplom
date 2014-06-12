#ifndef UART_H
#define UART_H

#include <avr/io.h>
#include <stdio.h>
#include "misc.h"

#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#ifndef BAUD
#define BAUD 9600
#endif
#include <util/setbaud.h>

#ifndef MIN_PULSE
#define MIN_PULSE 67
#endif
#ifndef MAX_PULSE
#define MAX_PULSE 299
#endif

void uart_putchar(char c, FILE *stream);
char uart_getchar(void);

void uart_init(void);
char buffer_not_empty( void );
void uart_tx_putbuffer( char data, FILE *stream );

extern void Servo_sort(void);
extern void Servo_upd(void);

extern SArray_def Servo[MaxServo];

extern long map(long x, long in_min, long in_max, long out_min, long out_max);

extern u08 mode;

/*FILE uart_output = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);*/

#endif /* UART_H */