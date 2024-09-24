#include <stdint.h>

#define SECTOR_SIZE 512
#define KERNEL_OFFSET 0x10000

void disk_read(uint32_t lba, uint8_t sectors, void *buffer) {
    asm volatile (
        "mov $0x02, %%ah\n"           // BIOS read sectors
        "mov %[sectors], %%al\n"      // Number of sectors to read
        "mov %[lba], %%bx\n"          // Logical block address (LBA)
        "mov %[buffer], %%bx\n"       // Destination buffer
        "int $0x13\n"                 // BIOS disk interrupt
        :
        : [sectors] "r" (sectors), [lba] "r" (lba), [buffer] "r" (buffer)
        : "eax", "ebx", "memory"
    );
}

void enable_protected_mode() {
    asm volatile (
        "cli\n"              // Disable interrupts
        "lgdt [gdt_descriptor]\n"
        "mov %%cr0, %%eax\n"
        "or $1, %%eax\n"     // Enable protected mode bit in CR0
        "mov %%eax, %%cr0\n"
        "jmp $0x08, $kernel_main\n"  // Far jump to protected mode
        :
        :
        : "eax", "memory"
    );
}

void boot_main() {
    // Load kernel sectors into memory at 0x10000
    disk_read(1, 10, (void*)KERNEL_OFFSET);  // Read 10 sectors
    enable_protected_mode();
}

__attribute__((section(".text"), used))
void _start() {
    boot_main();
    while (1);  // Infinite loop to prevent returning
}

// GDT structure
__attribute__((aligned(16)))
struct gdt_entry {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_middle;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} __attribute__((packed));

struct gdt_entry gdt[3];  // Null, Code, Data segments

struct {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed)) gdt_descriptor = {sizeof(gdt) - 1, (uint32_t)&gdt};

void setup_gdt() {
    gdt[0] = (struct gdt_entry){0};  // Null segment
    gdt[1] = (struct gdt_entry){     // Code segment
        .limit_low = 0xFFFF,
        .base_low = 0,
        .base_middle = 0,
        .access = 0x9A,  // Present, kernel, executable, read
        .granularity = 0xCF,  // 4 KB granularity
        .base_high = 0
    };
    gdt[2] = (struct gdt_entry){     // Data segment
        .limit_low = 0xFFFF,
        .base_low = 0,
        .base_middle = 0,
        .access = 0x92,  // Present, kernel, read/write
        .granularity = 0xCF,
        .base_high = 0
    };
}
