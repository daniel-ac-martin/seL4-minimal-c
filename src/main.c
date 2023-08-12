#include <sel4/sel4.h>

int main(int argc, char *argv[]) {
	seL4_DebugPutChar('H');
	seL4_DebugPutChar('e');
	seL4_DebugPutChar('l');
	seL4_DebugPutChar('l');
	seL4_DebugPutChar('o');
	seL4_DebugPutChar(',');
	seL4_DebugPutChar(' ');
	seL4_DebugPutChar('W');
	seL4_DebugPutChar('o');
	seL4_DebugPutChar('r');
	seL4_DebugPutChar('l');
	seL4_DebugPutChar('d');
	seL4_DebugPutChar('!');
	seL4_DebugPutChar('\n');

	seL4_TCB_Suspend(seL4_CapInitThreadTCB);
}
