#include "misc.h"
#include "main.h"
#include "uart.h"
#include "adc.h"



//============================================================================
ISR(TIMER1_COMPB_vect)                           // Прерывание по совпадению
{
    //cli();
if (servo_state)                                // Если не нулевое состояние то
        {
            /*if(ServoNextOCR[servo_state] )
                servo_state++;*/
            OCR1B = ServoNextOCR[servo_state];       // В регистр сравнения кладем следующий интервал

            PORTB &= ~ServoPortState[servo_state];  // Сбрасываем биты в порту, в соответствии с маской в массиве масок.          


        servo_state++;                          // Увеличиваем состояние автомата
 
        if (OCR1B == 0xFFFF)                               // Если значение сравнения равно FF значит это заглушка
                {          
                //PORTD |= 1 << PORTD6;                     // И мы достигли конца таблицы. И пора обнулить автомат
                servo_state = 0;                        // Выставляем нулевое состояние.
 
                TCNT1 = 65430;                    // Программируем задержку 
                TCCR1B &= 0b11111000;            // Сбрасываем предделитель таймера
                TCCR1B = _BV(CS02) | _BV(CS00);                  // Устанавливаем предделитель 
 
                if (servo_need_update)          // Если поступил приказ обновить таблицы автомата
                        {
                        Servo_upd();            // Обновляем таблицы.
                        servo_need_update = 0;  // Сбрасываем сигнал обновления.
                        }
                }
        }
else                                            // Нулевое состояние автомата. Новый цикл
        {
        /*if(ServoNextOCR[servo_state] == 0)
            servo_state++;*/
        OCR1B = ServoNextOCR[servo_state];               // Берем первую выдержку.
 
        TCCR1B &= 0b11111000;                    // Сбрасываем предделитель
        TCCR1B |= 0x03;                          // Предделитель 
        PORTB = 0xFF;
        //PORTB = servo_on;
        servo_state++;                          // Увеличиваем состояние конечного автомата. 
        }
     // sei();
}


//============================================================================
void Servo_add(u08 Number, u16 Pos)
{
u08 i,k;
SArray_def *tmp;
Servo[Number].Position = Pos;
// Сортируем массив
for(i=1;i<MaxServo;i++)
        {
        for(k=i;((k>0)&&(Servo_sorted[k]->Position < Servo_sorted[k-1]->Position));k--)
                {
                tmp = Servo_sorted[k];                                  // Swap [k,k-1] 
                Servo_sorted[k]=Servo_sorted[k-1];
                Servo_sorted[k-1]=tmp;
                }
        }
}
//============================================================================
void Servo_sort(void) 
{
u08 i,k;
SArray_def *tmp;

for(i=1;i<MaxServo;i++)
        {
        for(k=i;((k>0)&&(Servo_sorted[k]->Position < Servo_sorted[k-1]->Position));k--)
                {       
                tmp = Servo_sorted[k];                                  // Swap [k,k-1] 
                Servo_sorted[k]=Servo_sorted[k-1];
                Servo_sorted[k-1]=tmp;
                }

        }
}
//============================================================================
void Servo_upd(void)
{
    u08 i,j,k;
 
    for(i=0,k=0;i<MaxServo;i++,k++)
    {
        if(Servo_sorted[i]->Position)
            servo_on |= Servo_sorted[i]->Bit;//kostyli

        if(Servo_sorted[i]->Position!=Servo_sorted[i+1]->Position)      //Если значения уникальные
        {
            ServoNextOCR[k] = Servo_sorted[i]->Position;                    // Записываем их как есть
            ServoPortState[k+1] = Servo_sorted[i]->Bit;                     // И битмаску туда же
        }
        else                                                            // Но если совпадает со следующим
        {
            ServoNextOCR[k] = Servo_sorted[i]->Position;                    // Позицию записываем
            ServoPortState[k+1] = Servo_sorted[i]->Bit;                     // Записываем битмаску
        
            // И в цикле ищем все аналогичные позиции, склеивая их битмаски в одну.
 
            for(j=1;(Servo_sorted[i]->Position == Servo_sorted[i+j]->Position)&&(i+j<MaxServo);j++)
            {
                ServoPortState[k+1] |= Servo_sorted[i+j]->Bit;
            }
            i+=j-1;                                         // Перед выходом корректируем индекс
        }                                          // На глубину зарывания в повторы
    }       
    ServoNextOCR[k] = 0xFFFF;                                 // В последний элемент вписываем заглушку FF.
}
//============================================================================

void Servo_Init(void)
{
Servo_sorted[0]   = &Servo[0];
Servo_sorted[1]   = &Servo[1];
Servo_sorted[2]   = &Servo[2];
Servo_sorted[3]   = &Servo[3];
Servo_sorted[4]   = &Servo[4];
Servo_sorted[5]   = &Servo[5];

//PORT B
Servo[0].Bit   = 0b00000001;
Servo[1].Bit   = 0b00000010;
Servo[2].Bit   = 0b00000100;
Servo[3].Bit   = 0b00001000;
Servo[4].Bit   = 0b00010000;
Servo[5].Bit   = 0b00100000;

Servo[0].Position   = map(90, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[1].Position   = map(90, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[2].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[3].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[4].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[5].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);


Servo_sort();
Servo_upd();

TIMSK1 |= 1<<OCIE1B;      
TCCR1B |= 0x3;
}

int i;

void servo_flush(void) 
{
        Servo_sort(); 
        servo_need_update = 1;
}

long map(long x, long in_min, long in_max, long out_min, long out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void servo_write(int servo_num, int angle) 
{
  Servo[servo_num].Position   = map(angle, 0, 179, MIN_PULSE, MAX_PULSE);
}


int main (void) {

    DDRB=0b00111111;
    PORTB=0b00000000;

    uart_init();
    stdout = &uart_output;
    stdin  = &uart_input;



   /* puts("Hi!\n\r");
    puts("Long test!\n\r");
    puts("POK POK\n\r");
    puts("2Hi!\n\r");
    puts("2Long test!\n\r");
    puts("2POK POK\n\r");*/




Servo_Init();
//adc_init();
//init_adc() ;

DDRD |= 1 << PORTD6;
sei();                     
while (1) {
    if(adc_state == 1)
    {
        for (i=0; i<6; i++) 
        {  
            adc_val = 0;
            adc_val = analogRead(i);
            //adc_val = getFeedback(i);
            servo_adc_val[i] = map(adc_val, MIN_ADC_SERVO, MAX_ADC_SERVO, 0, 180);
            printf(" %d:%d",i,  servo_adc_val[i] );
        }
        puts("\n\r");    

        adc_state = 2;
    }



    switch(mode)
    {
        case 0: // free mode
            PORTD |= 1 << PORTD6;
            angle0to180(); custom_delay = 60;
            
        break;
        case 1: // angle control
            PORTD |= 1 << PORTD6;
            _delay_ms(200);
            PORTD &= ~(1 << PORTD6);

        break;
        case 2:
            prog1();
        break;
        case 3:
            prog2();
        break;

    }

    if(adc_state == 2) 
    {
        puts("A");
        for (i=0; i<6; i++) {
            puts(servo_adc_val[i]); 
            //printf(" %d:%d", servo_adc_val[i]);
        }
        puts("\n\r");    
        adc_state = 0;
    }

    if(custom_delay)
    {
        //puts("A");
        _delay_ms(custom_delay);  
        PORTD &= ~(1 << PORTD6);
        custom_delay = 0;
    }

} // END OF WHILE

return 0;
}

int angle_new = 0, up_down = 1;
void angle0to180(void)
{
    if(angle_new<=180 && up_down)
    {
        servo_write(0, angle_new);
        servo_write(1, 180-angle_new);
        servo_flush();

        angle_new++;

        if (angle_new>=180)
        {
        up_down = 0;
        }
    }
    if(angle_new>=0 && up_down == 0)
    {
        servo_write(0, angle_new);
        servo_write(1, 180-angle_new);
        servo_flush();

        angle_new--;

        if (angle_new<=0)
        {
        up_down = 1;
        }
    }

    adc_state = 1;
}

void prog1(void){}
void prog2(void){}


//============================================================================