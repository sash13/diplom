#ifndef ADC_H
#define ADC_H

#include <avr/io.h>
//#include <avr/interrupt.h>
#include "misc.h"

//void init_adc(void);
//void adc_init();
int analogRead(u08 pin);
int getFeedback(u08 pin);

//typedef unsigned short u16;

//#define MaxServo 6
extern u08 servo_adc_val[MaxServo];


#endif /* ADC_H */