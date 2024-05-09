#include "ports.c"

#define VIDEO_ADDR 0xb8000

#define MAX_ROWS 25
#define MAX_COLS 80

#define WHT_ON_BLK 0x0f

// screen device io ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

// convert rows and cols to offset
int to_offset(int col, int row) {
    return ((row * MAX_COLS) + col) * 2;
}

// get cursor offset
int get_cursor() {
    // read high byte from reg 14
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;

    // read low byte from reg 15
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);

    // convert to cell offset
    return offset * 2;
}

// set cursor offset
void set_cursor(int offset) {
    // convert to char offset
    offset /= 2;

    // write high byte to reg 14
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));

    // write low byte to reg 15
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset & 0x00ff));
}

void print_char(char character, int col, int row, char attr) {
    // create pointer to video memory
    char* video_mem = (char*) VIDEO_ADDR;

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
        video_mem[offset] = character;
        video_mem[offset + 1] = attr;
    }

    // move to next char
    offset += 2;
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
