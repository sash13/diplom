#ifndef MAIN_H
#define MAIN_H

#define SWAP(A, B) { int t = A; A = B; B = t; }
#define MIN_PULSE 67
#define MAX_PULSE 299

#define MIN_ADC_SERVO 56
#define MAX_ADC_SERVO 590

// Прототипы задач ============================================================
void Servo_add(u08 Number, u16 Pos);
void Servo_sort(void);
void Servo_upd(void);
void Servo_Init(void);

void servo_flush(void);
long map(long x, long in_min, long in_max, long out_min, long out_max);

//============================================================================
u08 servo_need_update = 0; 
u08 servo_state=0;      // Состояние конечного автомата. 
u08 ServoPortState[MaxServo+1]; // Значение порта которое надо вывести
u16 ServoNextOCR[MaxServo+1];   // Время вывода значения

u08 servo_on = 0;

u08 mode = 0;

int adc_val;
int custom_delay;

SArray_def Servo[MaxServo];
SArray_def *Servo_sorted[MaxServo];

void angle0to180(void);
void prog1(void);
void prog2(void);

extern void uart_tx_putbuffer( char data, FILE *stream );
//extern char uart_getchar(FILE *stream);
extern char uart_getchar(void);
extern void uart_putchar(char c, FILE *stream);
extern volatile char adc_state;

FILE uart_output = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);

#endif /* MAIN_H */