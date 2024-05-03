#define VIDEO_ADDR 0xb8000
#define WHT_ON_BLK 0x0f

// print character
void print_char(char character, int col, int row) {
    // pointer to video memory
    char* video_mem = (char*) VIDEO_ADDR;

    // convert to cell offset
    int offset = ((row * 80) + col + 1) * 2;

    // store char at cell
    video_mem[offset + 1] = character;
    video_mem[offset + 2] = WHT_ON_BLK;
}

// entry function
void main() {
    for (int i = 0; i < 4; i++) {
        print_char((char) i + 3, i, 1);
    }
}
