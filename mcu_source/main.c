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

#define SWAP(A, B) { int t = A; A = B; B = t; }
#define MIN_PULSE 16
#define MAX_PULSE 74

// Прототипы задач ============================================================
void Servo_add(u08 Number, u08 Pos);
void Servo_sort(void);
void Servo_upd(void);
void Servo_Init(void);

long map(long x, long in_min, long in_max, long out_min, long out_max);

//============================================================================
//MultiServo
#define MaxServo 6 // Число сервомашинок
u08 servo_need_update = 0; 
u08 servo_state=0;      // Состояние конечного автомата. 
u08  ServoPortState[MaxServo+1]; // Значение порта которое надо вывести
u08 ServoNextOCR[MaxServo+1];   // Время вывода значения

u08 servo_on = 0;

typedef struct  {
                u08 Position;
                u08 Bit;
                }  SArray_def;
 
SArray_def Servo[MaxServo];
SArray_def *Servo_sorted[MaxServo];
//============================================================================
ISR(TIMER0_COMPB_vect)                           // Прерывание по совпадению
{
if (servo_state)                                // Если не нулевое состояние то
        {
            if(ServoNextOCR[servo_state] == 0)
                servo_state++;
            OCR0B = ServoNextOCR[servo_state];       // В регистр сравнения кладем следующий интервал

      PORTB &= ~ServoPortState[servo_state];  // Сбрасываем биты в порту, в соответствии с маской в массиве масок.          


        servo_state++;                          // Увеличиваем состояние автомата
 
        if (OCR0B == 0xFF)                               // Если значение сравнения равно FF значит это заглушка
                {                               // И мы достигли конца таблицы. И пора обнулить автомат
                servo_state = 0;                        // Выставляем нулевое состояние.
 
                TCNT0 = 105;                    // Программируем задержку 
                TCCR0B &= 0b11111000;            // Сбрасываем предделитель таймера
                TCCR0B = _BV(CS02) | _BV(CS00);                  // Устанавливаем предделитель 
 
                if (servo_need_update)          // Если поступил приказ обновить таблицы автомата
                        {
                        Servo_upd();            // Обновляем таблицы.
                        servo_need_update = 0;  // Сбрасываем сигнал обновления.
                        }
                }
        }
else                                            // Нулевое состояние автомата. Новый цикл
        {
        if(ServoNextOCR[servo_state] == 0)
            servo_state++;
        OCR0B = ServoNextOCR[servo_state];               // Берем первую выдержку.
 
        TCCR0B &= 0b11111000;                    // Сбрасываем предделитель
        TCCR0B |= 0x04;                          // Предделитель 
        PORTB = servo_on;
        servo_state++;                          // Увеличиваем состояние конечного автомата. 
        }
        
}
//============================================================================
void Servo_add(u08 Number, u08 Pos)
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
        }                                               // На глубину зарывания в повторы
}       
ServoNextOCR[k] = 0xFF;                                 // В последний элемент вписываем заглушку FF.
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
Servo[0].Bit   = 0b000000000000000000000001;
Servo[1].Bit   = 0b000000000000000000000010;
Servo[2].Bit   = 0b000000000000000000000100;
Servo[3].Bit   = 0b000000000000000000001000;
Servo[4].Bit   = 0b000000000000000000010000;
Servo[5].Bit   = 0b000000000000000000100000;

Servo[0].Position   = map(90, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[1].Position   = map(90, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[2].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[3].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[4].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);
Servo[5].Position   = map(10, 0, 179, MIN_PULSE, MAX_PULSE);


Servo_sort();
Servo_upd();

TIMSK0 |= 1<<OCIE0B;      
TCCR0B |= 0x4;
}
//============================================================================
/*void usart_tx (unsigned char data) {
    while ( !(UCSRA & (1<<5)) );    //ждём очистки регистра данных USART       
    UDR=data;    //отправить
} 
 unsigned char usart_rx (void) { 
    while ( !(UCSRA & (1<<7)) );    //ждём очистки регистра данных USART      
    return UDR;    //читаем данные
} */
//============================================================================
/*void Accept (void) {  //Принятие посылки
static unsigned char curr_serv,usart_data,state;
u08 Num,Pos;


        if(UCSRA&_BV(RXC)) {  //есть данные в usart
                         usart_data = UDR;

    switch(state) { // автомат с 2 состояниями
        case 0: // принимаем коды команд
            switch(usart_data)
            {
                case 'E': Servo_sort(); Servo_upd(); break; // конец посылки, обновление серв
                case 'B': state = 1; break; // переход в другое состояние, будем принимать параментры команды B
                                case 0xFF:  
                                Num = usart_rx ();  
                                Pos = usart_rx (); 
                                Servo[Num].Position = Pos; 
                                state = 0;      
                                Servo_sort(); 
                                Servo_upd();    
                                break;

            }
            break;
        case 1: // обработка параметров команды B
            Servo[curr_serv].Position = usart_data; // кладем в массив аргумент команды
            curr_serv++;
                        if(curr_serv == 6) // повторять будем, сколько у нас серв
            {
                curr_serv = 0; // обнуление счетчика, для следующего раза
                state = 0; // будем ожидать команды
            }
            break;
                                }
}}*/
//============================================================================

int i;

void servo_flush() 
{
        Servo_sort(); 
        //Servo_upd(); 
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


// USART0 settings: 9600 baud 8-n-1
// WARNING: real baud = 9622: err = 0,229166666666658%
       // UBRRH = 0;
       // UBRRL = 92;
      //  UCSRB = (1<<RXEN) | (1<<TXEN);
      //  UCSRC = (1<<URSEL) | (1<<UCSZ1) | (1<<UCSZ0); 


Servo_Init();
DDRD |= 1 << PORTD6;
sei();                     
while (1) {
  for (i=0; i<180; i++) {  
    servo_write(0, i);
    servo_write(1, 180-i);
    servo_flush();
    //printf("angle: %d  pulse: %d\n", i, Servo[0].Position);    
    _delay_ms(50);
  }
  _delay_ms(100);

  for (i=180; i>0; i--) {  
    servo_write(0, i);
    servo_write(1, 180-i);
    servo_flush();
    //printf("angle: %d pulse: %d\n", i, Servo[0].Position); 
    _delay_ms(50);
  }
  _delay_ms(100);

}

return 0;
}
//============================================================================