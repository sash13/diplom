#ifndef MISC_H
#define MISC_H

#include <stdio.h>
#include <avr/io.h>                                 
#include <util/delay.h>
#include <avr/interrupt.h>//библиотека прерываний

// datatype definitions macros
typedef unsigned char  u08;
typedef   signed char  s08;
typedef unsigned short u16;
typedef   signed short s16;
typedef unsigned long  u32;
typedef   signed long  s32;
typedef unsigned long long u64;
typedef   signed long long s64;
typedef struct  {
                u16 Position;
                u08 Bit;
                }  SArray_def;

//============================================================================
//MultiServo
#define MaxServo 6 // Число сервомашинок
#define SETBIT(P, BIT)	((P) |= (1<<(BIT)))
#define CLEARBIT(P,BIT)	((P) &= ~(1<<(BIT)))
#define CHECKBIT(P,BIT) ((P) & (1<<BIT)) 


u08 servo_adc_val[MaxServo];   // adc

#endif /* MISC_H */