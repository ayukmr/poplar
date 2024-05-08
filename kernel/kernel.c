#define VIDEO_ADDR 0xb8000
#define WHT_ON_BLK 0x0f

// print character
void print_char(char character, int col, int row) {
    // pointer to video memory
    char* video_mem = (char*) VIDEO_ADDR;

    // convert to cell offset
    int offset = ((row * 80) + col) * 2;

    // store char at cell
    video_mem[offset] = character;
    video_mem[offset + 1] = WHT_ON_BLK;
}

// print at location
void print_at(char* message, int col, int row) {
    for (int i = 0; message[i] != '\0'; i++) {
        print_char(message[i], col + i, row);
    }
}

// entry function
void main() {
    print_at("running kernel!", 0, 1);
}
