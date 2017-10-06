/**
 * @author Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
 */

#include <fitkitlib.h>


void print_user_help(void) {}
void fpga_initialized(void) {}


unsigned char decode_user_cmd(char *cmd_ucase, char *cmd)
{
	return (CMD_UNKNOWN);
}


int main(void)
{
	initialize_hardware();

	while (42) {
		terminal_idle();
	}
}
