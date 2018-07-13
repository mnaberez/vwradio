#include "kwp1281.h"
#include "technisat.h"
#include "uart.h"
#include "main.h"
#include <string.h>

uint16_t bcd_to_bin(uint16_t bcd)
{
    uint16_t bin = 0;
    bin +=  (bcd & 0x000f);
    bin += ((bcd & 0x00f0) >>  4) * 10;
    bin += ((bcd & 0x0f00) >>  8) * 100;
    bin += ((bcd & 0xf000) >> 12) * 1000;
    return bin;
}

void print_hex16(char *label, uint16_t word)
{
    uart_puts(UART_DEBUG, label);
    uart_puthex16(UART_DEBUG, word);
    uart_puts(UART_DEBUG, "\n");
}

void crack()
{
    kwp_result_t result;

    if (memcmp(&kwp_component_1[7], "3CP", 3) == 0) {
        uart_puts(UART_DEBUG, "VW PREMIUM 4 (CLARION) DETECTED\n");

        uint16_t safe_code;
        result = kwp_p4_read_safe_code_bcd(&safe_code);
        kwp_panic_if_error(result);

        print_hex16("\nSAFE Code: ", safe_code);

    } else if (memcmp(&kwp_component_1[7], "DE2", 3) == 0) {
        uart_puts(UART_DEBUG, "VW PREMIUM 5 (DELCO) DETECTED\n");
        kwp_disconnect();
        result = kwp_autoconnect(KWP_RADIO_MFG);
        kwp_panic_if_error(result);
        result = kwp_p5_login_mfg();
        kwp_panic_if_error(result);

        uint16_t safe_code;
        result = kwp_p5_read_safe_code_bcd(&safe_code);
        kwp_panic_if_error(result);

        print_hex16("SAFE Code: ", safe_code);

    } else if (memcmp(&kwp_component_1[7], "YD5", 3) == 0) {
        uart_puts(UART_DEBUG, "VW GAMMA 5 (TECHNISAT) DETECTED\n");
        kwp_disconnect();

        tsat_result_t tresult;
        tresult = tsat_connect();
        tsat_panic_if_error(tresult);

        tresult = tsat_disable_eeprom_filter();
        tsat_panic_if_error(tresult);

        uint16_t safe_code;
        tresult = tsat_read_safe_code_bcd(&safe_code);
        tsat_panic_if_error(tresult);

        tresult = tsat_disconnect();
        tsat_panic_if_error(tresult);

        print_hex16("\nSAFE Code: ", safe_code);

    } else {
        uart_puts(UART_DEBUG, "UNKNOWN RADIO\n");
        uart_puts(UART_DEBUG, "UNCRACKABLE\n");
    }

    uart_puts(UART_DEBUG, "Done.\n");
}
