// i am includeing any builtin header files
typedef unsigned int uint32_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;

#include "./string.h"
#include "./string.c"

static inline void outb(uint16_t port, uint8_t val) {
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}


#define PIT_FREQUENCY 1193182
#define PIT_COMMAND_PORT 0x43
#define PIT_CHANNEL_0    0x40

volatile uint32_t pit_ticks = 0;

// This function will be called on each timer interrupt (ISR handler)
void pit_interrupt_handler() {
    pit_ticks++;
}


// This function sets the PIT's countdown rate
void pit_set_frequency(uint32_t hz) {
    uint32_t divisor = PIT_FREQUENCY / hz;
    
    // Send command byte (0x36 = Channel 0, Access mode: lobyte/hibyte, Mode 2)
    outb(PIT_COMMAND_PORT, 0x36);

    // Set the frequency divisor
    outb(PIT_CHANNEL_0, (uint8_t)(divisor & 0xFF));       // Low byte
    outb(PIT_CHANNEL_0, (uint8_t)((divisor >> 8) & 0xFF)); // High byte
}

// Sleep function in microseconds
void usleep(uint32_t microseconds) {
    // Convert microseconds to PIT ticks (PIT ticks at 1.193182 MHz)
    uint32_t sleep_ticks = (microseconds * PIT_FREQUENCY) / 1000000;

    // Record starting tick count
    uint32_t start_ticks = pit_ticks;

    // Wait until the desired number of ticks has passed
    while ((pit_ticks - start_ticks) < sleep_ticks) {
        // Optional: You could use a HLT instruction here to halt the CPU
        // asm volatile("hlt");
    }
}

// Initialize PIT to a known frequency (1000 Hz = 1 ms per tick)
void pit_init() {
    pit_set_frequency(1000);  // Set PIT frequency to 1000 Hz (1 ms per tick)
}

void kernel_main(void)
{
    pit_init();
//    __asm__("sti");
    /*
        this line makes windows flashing
        this is first i seen in supperOS root repo
    */
    const char *string = "                           Yes I am a Useless kernel                            ";
    char *videomemptr = (char *)0xb8000; // this is text mamory not video memory

/*
Total permutation for font and background colour is 256
which is two hex-dicit value, so that first dicit is background colour
and secend dicit is font color and each dicit cat hold 16 value
*/

for(unsigned char _p=0; 1; _p++) {
    unsigned int i = 0;
    unsigned int j = 0;

    // loop to clear the screen - writing the blank character
    // the memory mapped supports 25 lines with 80ascii char with 2bytes of mem each
    while (j < 80 * 25 * 2)
    {
        videomemptr[j] = ' ';      // blank character
        videomemptr[j + 1] = 0x00; // attribute-byte 0 - black background 2 - green font
        j = j + 2;
    }
    j = 0;
    // loop to write the string to the video memory - each character with 0x02 attribute(green)
    while (string[j] != '\0')
    {
        videomemptr[i] = string[j];
        videomemptr[i + 1] = _p;
        ++j;
        i = i + 2;
    }

    #define INT_STRING_BUFFER 12
    /*
        the max value is 4294967296 = 10 disits + one null byte
        and for signed value it is = one minus + 10 disits + one null byte
    */

    char num_buffer_str[INT_STRING_BUFFER];
    intToStr(_p, num_buffer_str);

	/*
    j = 0;
    while (num_buffer_str[j] != '\0')
    {
        videomemptr[i] = num_buffer_str[j];
        videomemptr[i + 1] = _p;
        ++j;
        i = i + 2;
    }*/


    for (int _DELAY_VAR=0; _DELAY_VAR<40000000; _DELAY_VAR++) {}

}
    return;
}
