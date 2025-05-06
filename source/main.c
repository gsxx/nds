#include <nds.h>
#include <stdio.h>

int main(void) {
    // Initialize consoles
    consoleDemoInit();
    videoSetMode(MODE_0_2D);
    
    // Print to both screens
    iprintf("\n\n    Hello, Nintendo DS!\n");
    iprintf("    ------------------\n\n");
    iprintf("    Developer: You!\n");
    iprintf("    Date: %s\n", __DATE__);
    
    // Draw a colored pixel on bottom screen
    u16* vram = BG_GFX;
    vram[10 + 10 * 256] = RGB15(31,0,0); // Red pixel
    
    while(1) {
        swiWaitForVBlank();
        scanKeys();
        if(keysDown() & KEY_START) break;
    }
    return 0;
}