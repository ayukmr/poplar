#include <sys/io.h>

#define VIDEO_ADDR 0xb8000

#define MAX_ROWS 25
#define MAX_COLS 80

#define WHT_ON_BLK 0x0f

// screen device io ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

// convert rows and cols to offset
int to_offset(int col, int row) {
    return (row * MAX_COLS) + col;
}

// get cursor offset
int get_cursor() {
    // read high byte from reg 14
    outb(14, REG_SCREEN_CTRL);
    int offset = inb(REG_SCREEN_DATA) << 8;

    // read low byte from reg 15
    outb(15, REG_SCREEN_CTRL);
    offset += inb(REG_SCREEN_DATA);

    return offset;
}

// set cursor offset
void set_cursor(int offset) {
    // write high byte to reg 14
    outb(14, REG_SCREEN_CTRL);
    outb(offset >> 8, REG_SCREEN_DATA);

    // write low byte to reg 15
    outb(15, REG_SCREEN_CTRL);
    outb(offset & 0x00ff, REG_SCREEN_DATA);
}

void print_char(unsigned char character, int col, int row, unsigned char attr) {
    // create pointer to video memory
    unsigned char* video_mem = (unsigned char*) VIDEO_ADDR;

    int offset;

    if (col >= 0 && row >= 0) {
        offset = to_offset(col, row);
    } else {
        // current cursor position
        offset = get_cursor();
    }

    if (character == '\n') {
        // move to next row
        offset = to_offset(
            MAX_COLS - 1,
            offset / (MAX_COLS * 2)
        );
    } else {
        // write char to memory
        video_mem[offset * 2] = character;
        video_mem[(offset * 2) + 1] = attr;
    }

    // move to next char
    offset += 1;
    set_cursor(offset);
}

// print at position
void print_at(char* message, int col, int row) {
    if (col >= 0 && row >= 0) {
        // set cursor position
        set_cursor(to_offset(col, row));
    }

    int i = 0;

    // print chars
    while (message[i] != 0) {
        print_char(message[i], col, row, WHT_ON_BLK);
        i++;
    }
}

// print message
void print(char* message) {
    print_at(message, -1, -1);
}

// clear screen
void clear_screen() {
    for (int row = 0; row < MAX_ROWS; row++) {
        for (int col = 0; col < MAX_COLS; col++) {
            print_char(' ', col, row, WHT_ON_BLK);
        }
    }

    set_cursor(0);
}
