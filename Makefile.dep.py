import os
import math


BLOCK_SIZE = SECTOR_SIZE = 512

boot_nasm_PATH = "./src/startup/x86.nasm"


# make applets

boot_nasm_loader_sectors = math.ceil(os.stat(boot_nasm_PATH).st_size / SECTOR_SIZE)