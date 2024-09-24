#include <stdint.h>

// Kernel entry point in protected mode
void _start() {
    const char *message = "Hello from the kernel!\n";
    
    // Print message using BIOS (inline assembly)
    // for (const char *p = message; *p; ++p) {
    //     asm volatile (
    //         "mov $0x0E, %%ah\n"
    //         "mov %[char], %%al\n"
    //         "int $0x10\n"
    //         :
    //         : [char] "r" (*p)
    //         : "ah", "al"
    //     );
    // }
    
    while (1);  // Infinite loop to halt the CPU
}
