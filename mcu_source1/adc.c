#include "adc.h"

volatile u16 ADCvalue; 
int reading[20], result, done, test, mean;

int getFeedback(u08 pin){

   for (int j=0; j<20; j++){
      reading[j] = analogRead(pin);    //get raw data from servo potentiometer
      _delay_ms(3);
    }                                // sort the readings low to high in array                                
    done = 0;                    // clear sorting flag             
    while(done != 1){             // simple swap sorts numbers from lowest to highest
    done = 1;
    for (int j=0; j<20; j++){
      if (reading[j] > reading[j + 1]){     // sorting numbers here
        test = reading[j + 1];
        reading [j+1] = reading[j] ;
        reading[j] = test;
        done = 0;
       }
     }
   }
    mean = 0;
    for (int k=6; k<14; k++){        //discard the 6 highest and 6 lowest readings
      mean += reading[k];
    }
    result = mean/8;                  //average useful readings
    return (result);
}

int analogRead(u08 pin)
{
  int ADCval;

    ADMUX = pin;         // use #1 ADC
    ADMUX |= (1 << REFS0);    // use AVcc as the reference
    ADMUX &= ~(1 << ADLAR);   // clear for 10 bit resolution
    
    ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);    // 128 prescale for 8Mhz
    ADCSRA |= (1 << ADEN);    // Enable the ADC

    ADCSRA |= (1 << ADSC);    // Start the ADC conversion

    while(ADCSRA & (1 << ADSC));      // Thanks T, this line waits for the ADC to finish 


    ADCval = ADCL;
    ADCval = (ADCH << 8) + ADCval;    // ADCH is read so ADC can be updated again
    return ADCval;
}


/*void init_adc(void) 
{
    ADMUX = 0;                // use ADC0
    ADMUX |= (1 << REFS0);    // use AVcc as the reference
    ADMUX |= (1 << ADLAR);    // Right adjust for 8 bit resolution

    ADCSRA |= (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0); // 128 prescale for 16Mhz
    ADCSRA &= ~(1 << ADATE);   // Set ADC Auto Trigger Enable
    
    ADCSRB = 0;               // 0 for free running mode

    ADCSRA |= (1 << ADEN);    // Enable the ADC
    ADCSRA |= (1 << ADIE);    // Enable Interrupts 

    ADCSRA |= (1 << ADSC);    // Start the ADC conversion
    printf("adc: %d\n", ADCvalue); 
}*/

/*ISR(ADC_vect)
{
    ADCvalue = ADCH;          // only need to read the high value for 8 bit
    servo_adc_val[0] = ADCvalue;
    ///printf("adc: %d\n", ADCvalue); 
    // REMEMBER: once ADCH is read the ADC will update
    
    // if you need the value of ADCH in multiple spots, read it into a register
    // and use the register and not the ADCH

}*/

/*ISR(ADC_vect)
{
	cli();
    uint8_t tmp;            // temp register for storage of misc data

    tmp = ADMUX;            // read the value of ADMUX register
    tmp &= 0x0F;            // AND the first 4 bits (value of ADC pin being used) 

    ADCvalue = ADCL;
    ADCvalue = (ADCH << 8) + ADCvalue;     // read the sensor value

    servo_adc_val[tmp] = ADCvalue;
	printf("adc: %d\n", ADCvalue); 

	ADMUX++;
	if (tmp == 6) {
        // put ADCvalue into whatever register you use for ADC2 sensor
        ADMUX &= 0xF8;      // clear the last 4 bits to reset the mux to ADC0
    } 
    sei();
    ADCSRA |= (1 << ADSC);

}*/

