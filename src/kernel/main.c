#define ARCH_superOS x86

#ifdef ARCH_superOS x86 // 32 bit intel code
    #include "x86/kernel_init.h"
    #include "x86/usr_init.h"
#endif
// #elif ARCH_superOS x86_64 // 32 bit intel code

// #elif ARCH_superOS arm_cortex_A // 32 bit intel code
// #elif ARCH_superOS arm_cortex_R // 32 bit intel code
// #elif ARCH_superOS arm_cortex_M // 32 bit intel code
// #else 
//     #error "no supported architure"
// #endif



int kernel_main(int argc, char const *argv[])
{
    /*
        init tilizing kernal
    */
    kernel_init();

    /*
        this is for staring user land
   */

    usr_init();
    return 0;
}