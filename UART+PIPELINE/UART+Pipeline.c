#define     UART_STATUS_R        (*((volatile unsigned int*)0x00000220))
#define     UART_CONTROL_R       (*((volatile unsigned int*)0x00000002))
#define     UART_RX_DATA_R       (*((volatile unsigned int*)0x00000002))
#define     UART_TX_DATA_R       (*((volatile unsigned int*)0x00000002))
 //  txff txfe rxff rxfe
#define     UART_TX_FF           0x08                              
#define     UART_RX_FE           0x01    
#define     DELAY                100

int main() {

    // Data to be transmitted
    UART_STATUS_R  = 0x00;  
    UART_CONTROL_R = 0x00;
    UART_RX_DATA_R = 0x00;
    UART_TX_DATA_R = 0x00;
 unsigned int data[9];
    data[0] = 0x12;
    data[1] = 0x34;
    data[2] = 0x56;
    data[3] = 0x78;
    data[4] = 0x9A;
    data[5] = 0xBC;
    data[6] = 0xDE;
    data[7] = 0xF1;
    data[8] = 0x23;

    // [11:0] baudrate  [15:12]config
    UART_CONTROL_R = 0x2003;    

    for (int i = 0; i < 9; i++)
    {    
        while((UART_STATUS_R & UART_TX_FF) != 0);
        UART_TX_DATA_R = data[i];
    }

    // Wait to observe IDLE behavior of Tx
    for (int i = 0; i < DELAY; i++);

    // Read to free up one byte in Rx FIFO
    while((UART_STATUS_R & UART_RX_FE) != 0);
    int received_data = UART_RX_DATA_R;

    // Transmit again
    while((UART_STATUS_R & UART_TX_FF) != 0);
        UART_TX_DATA_R = 0x45;

    while(1);
}





