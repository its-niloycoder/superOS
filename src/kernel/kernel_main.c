#define ARCH_superOS x86

// #ifdef ARCH_superOS x86 // 32 bit intel code
//     #include "x86/kernel_init.h"
//     #include "x86/usr_init.h"
// #endif
// #elif ARCH_superOS x86_64 // 32 bit intel code

// #elif ARCH_superOS arm_cortex_A // 32 bit intel code
// #elif ARCH_superOS arm_cortex_R // 32 bit intel code
// #elif ARCH_superOS arm_cortex_M // 32 bit intel code
// #else 
//     #error "no supported architure"
// #endif




void kernel_main(void)
{
    char* video_memory = (char*) 0xB8000;  // Memory address for VGA text mode
    const char* message = "Hello from C Kernel!";

    // Display message
    for (int i = 0; message[i] != '\0'; ++i) {
        video_memory[i * 2] = message[i];   // ASCII character
        video_memory[i * 2 + 1] = 0x07;     // Attribute byte (color)
    }


    while (1);
    
//     /*
//         init tilizing kernal
//     */
//     kernel_init();

//     /*
//         this is for staring user land
//    */

//     usr_init();
//     return 0;
}

void _start(void){
    kernel_main();
}