#include "uart.h"

#define TRUE 1
#define FALSE 0
#define UART1_RX_BUF_LEN 32
#define UART1_TX_BUF_LEN 32
volatile char uart_rx_buf[ UART1_RX_BUF_LEN ];
volatile char uart_tx_buf[ UART1_TX_BUF_LEN ];
uint8_t uart_rx_cnt = 0;//how many bytes stored in the buffer(counter)
uint8_t uart_rx_put_ptr = 0;//pointer to next byte to be placed into RX buffer
uint8_t uart_rx_get_ptr = 0;//pointer to next byte for getting from RX buffer
uint8_t uart_tx_cnt = 0;
uint8_t uart_tx_put_ptr = 0;
uint8_t uart_tx_get_ptr = 0;
volatile uint8_t uart_tx_flag = FALSE;


volatile char state_ = 0, curr_serv_ = 0, adc_state = 0;
/* http://www.cs.mun.ca/~rod/Winter2007/4723/notes/serial/serial.html */

void uart_init(void) {
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
    
#if USE_2X
    UCSR0A |= _BV(U2X0);
#else
    UCSR0A &= ~(_BV(U2X0));
#endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); /* 8-bit data */ 
    UCSR0B = _BV(RXEN0) | _BV(TXEN0) | _BV(RXCIE0);   /* Enable RX and TX */    
}

void uart_putchar(char c, FILE *stream) {
    /*if (c == '\n') {
        uart_putchar('\r', stream);
    }*/
    loop_until_bit_is_set(UCSR0A, UDRE0);
    UDR0 = c;
}

//char uart_getchar(FILE *stream) {
/*char uart_getchar(void) {
    loop_until_bit_is_set(UCSR0A, RXC0);
    return UDR0;
}*/

/*--------------------------------------------------------
Get next byte from TX buffer
Взять байт из буфера передачи
---------------------------------------------------------*/
char uart_tx_getbuffer( void )
{
    char data;

    data = uart_tx_buf[ uart_tx_get_ptr++ ];
    uart_tx_cnt--;

    if( uart_tx_get_ptr >= UART1_TX_BUF_LEN )
        uart_tx_get_ptr = 0;

    return data;
}


/*--------------------------------------------------------
Put byte into TX buffer
Поместить байт в буфер передачи
---------------------------------------------------------*/
void uart_tx_putbuffer( char data, FILE *stream )
{
    while( uart_tx_cnt >= UART1_TX_BUF_LEN);//подождать пока в буфере не освободится место
    //cli();//disable IRQ for atomic access
    
    uart_tx_cnt++;
    uart_tx_buf[ uart_tx_put_ptr++ ] = data;

    if( uart_tx_flag == FALSE )//если передача еще не идет - начать ее  
        {
        //UART_DIR_TX();//переключить RS485 на TX
        uart_tx_flag = TRUE;
        UDR0 = uart_tx_getbuffer();//init TX procedure
        }

    if( uart_tx_put_ptr >= UART1_TX_BUF_LEN )//кольцевой буфер передачи требует корректировку индекса
        uart_tx_put_ptr = 0;

    //sei();//restore IRQ
}

/*--------------------------------------------------------
Put received byte into RX buffer
---------------------------------------------------------*/
void uart_rx_putbuffer( char data )
{
    if( uart_rx_cnt < UART1_RX_BUF_LEN )
        {
        uart_rx_cnt++;
        uart_rx_buf[ uart_rx_put_ptr++ ] = data;
        if( uart_rx_put_ptr >= UART1_RX_BUF_LEN )
            uart_rx_put_ptr = 0;
        }
}

/*--------------------------------------------------------
Get byte from RX buffer
---------------------------------------------------------*/
char uart_getchar( void )
{
    char data;

    cli();//disable IRQ for atomic access
    if( uart_rx_cnt > 0 )//buffer has bytes - overflow protection
        {
        data = uart_rx_buf[ uart_rx_get_ptr++ ];
        if( uart_rx_get_ptr >= UART1_RX_BUF_LEN )
            uart_rx_get_ptr = 0;
        --uart_rx_cnt;
        }   
    sei();

    return data;
} 



/*ISR(USART_RX_vect) {
    if(CHECKBIT(UCSR0A, RXC0)) {
    char data = UDR0; 

    if( uart_rx_cnt < UART1_RX_BUF_LEN ) 
        uart_rx_buf[ uart_rx_cnt++ ] = data; 
    UDR0 = data;
    //uart_tx_putbuffer(data);
    }
}*/

// Commands
    //V - Version - returns 1
    //S000000E - servo update all
    //A - ADC - return actual angle
    //Nn0E - set one srvo manualy

ISR(USART_RX_vect) {
    cli();
    if(CHECKBIT(UCSR0A, RXC0)) {
        char data = UDR0; 
        switch(state_) {
            case 0:
                switch(data) {
                    case 'V': UDR0 = '1'; break; 
                    case 'S': if(mode==1) state_ = 1; break;
                    case 'E': Servo_sort(); Servo_upd(); break;
                    case 'A': adc_state = 1; break;
                    case 'N': state_ = 2; break;
                    case 'M': state_ = 4; break;
                }
            break;
            case 1:
                Servo[curr_serv_].Position = map(data , 0, 180, MIN_PULSE, MAX_PULSE);
                curr_serv_++;
                if(curr_serv_ == 6) // повторять будем, сколько у нас серв
                {
                    curr_serv_ = 0; // обнуление счетчика, для следующего раза
                    state_ = 0; // будем ожидать команды
                }
            break;
            case 2:
                curr_serv_ = data;
                state_ = 3;
            break;
            case 3:
                Servo[curr_serv_].Position = map(data , 0, 180, MIN_PULSE, MAX_PULSE);
                curr_serv_ = 0;
                state_ = 0; 
            break;
            case 4:
                mode = data;
                state_ = 0; 
            break;

        }
        //UDR0 = data;
    }
    sei();
}

/*ISR(USART_TX_vect) {
    //cli();
    if(CHECKBIT(UCSR0A,UDRE0)) {
        if( uart_tx_flag == TRUE ) {
            UDR0 = uart_tx_getbuffer();
            if( uart_tx_cnt == 0 ){
                uart_tx_flag = FALSE;
            }
        }
    }
    //sei();
}*/