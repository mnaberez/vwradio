#include "kwp1281.h"
#include "technisat.h"
#include "uart.h"
#include <string.h>
#include <util/delay.h>

static void _print_hex16(char *label, uint16_t word)
{
    uart_puts(UART_DEBUG, label);
    uart_puthex16(UART_DEBUG, word);
    uart_puts(UART_DEBUG, "\r\n");
}

static void _crack_clarion(void)
{
    uint16_t safe_code;
    kwp_result_t result = kwp_p4_read_safe_code_bcd(&safe_code);
    kwp_panic_if_error(result);

    result = kwp_disconnect();
    kwp_panic_if_error(result);

    _print_hex16("\r\nSAFE Code: ", safe_code);
}

static void _crack_delco_vw_premium_5(void)
{
    kwp_disconnect();

    kwp_result_t result = kwp_connect(KWP_RADIO_MFG);
    kwp_panic_if_error(result);

    result = kwp_p5_login_mfg();
    kwp_panic_if_error(result);

    uint16_t safe_code;
    result = kwp_p5_read_safe_code_bcd(&safe_code);
    kwp_panic_if_error(result);

    result = kwp_disconnect();
    kwp_panic_if_error(result);

    _print_hex16("\r\nSAFE Code: ", safe_code);
}

static void _crack_delco_vw_sam_2002(void)
{
    kwp_result_t result = kwp_disconnect();
    kwp_panic_if_error(result);

    result = kwp_connect(KWP_RADIO_MFG);
    kwp_panic_if_error(result);

    result = kwp_sam_2002_login_mfg();
    kwp_panic_if_error(result);

    uint16_t safe_code;
    result = kwp_sam_2002_read_safe_code_bcd(&safe_code);
    kwp_panic_if_error(result);

    result = kwp_disconnect();
    kwp_panic_if_error(result);

    _print_hex16("\r\nSAFE Code: ", safe_code);
}

static void _crack_delco_seat_liceo_or_vw_konzern_2004(void)
{
    kwp_result_t result = kwp_disconnect();
    kwp_panic_if_error(result);

    result = kwp_connect(KWP_RADIO_MFG);
    kwp_panic_if_error(result);

    result = kwp_sl_login_mfg();
    kwp_panic_if_error(result);

    uint16_t safe_code;
    result = kwp_sl_read_safe_code_bcd(&safe_code);
    kwp_panic_if_error(result);

    result = kwp_disconnect();
    kwp_panic_if_error(result);

    _print_hex16("\r\nSAFE Code: ", safe_code);
}

static void _crack_technisat(void)
{
    kwp_result_t result = kwp_disconnect();
    kwp_panic_if_error(result);

    // vw rhapsody and skoda symphony cd radios move the cd mechanism
    // after kwp1281 disconnect.  we have to wait long enough for this
    // to finish to ensure the radio is ready for another connection.
    _delay_ms(2000);

    tsat_result_t tresult;
    tresult = tsat_connect(KWP_RADIO_MFG, kwp_baud_rate);
    tsat_panic_if_error(tresult);

    tresult = tsat_disable_eeprom_filter_0x4d();
    tsat_panic_if_error(tresult);

    uint16_t safe_code;
    tresult = tsat_read_safe_code_bcd(&safe_code);

    if (tresult == TSAT_SAFE_CODE_FILTERED) {
        // on skoda symphony, disabling the eeprom filtering
        // with command 0x4d above fails silently.  we try to
        // disable the filter again here with command 0x45.
        tresult = tsat_disable_eeprom_filter_0x45();
        tsat_panic_if_error(tresult);

        tresult = tsat_read_safe_code_bcd(&safe_code);
        tsat_panic_if_error(tresult);

    } else if (tresult != TSAT_SUCCESS) {
        tsat_panic_if_error(tresult);
    }

    tresult = tsat_disconnect();
    tsat_panic_if_error(tresult);

    _print_hex16("\r\nSAFE Code: ", safe_code);
}

void crack(void)
{
    if (memcmp(&kwp_component_1[7], "3CP", 3) == 0) {
        uart_puts(UART_DEBUG, "VW PREMIUM 4 (CLARION) DETECTED\r\n");
        _crack_clarion();

    } else if (memcmp(&kwp_vag_number, "5X0035119C", 10) == 0) {
        uart_puts(UART_DEBUG, "VW SAM 2002 (DELCO) DETECTED\r\n");
        _crack_delco_vw_sam_2002();

    } else if (memcmp(&kwp_vag_number, "6KE035119", 9) == 0) {
        uart_puts(UART_DEBUG, "VW KONZERN 2004 (DELCO) DETECTED\r\n");
        _crack_delco_seat_liceo_or_vw_konzern_2004();

    } else if (memcmp(&kwp_component_1[7], "DE2", 3) == 0) {
        uart_puts(UART_DEBUG, "VW PREMIUM 5 (DELCO) DETECTED\r\n");
        _crack_delco_vw_premium_5();

    } else if (memcmp(&kwp_component_1[7], "FF6", 3) == 0) {
        uart_puts(UART_DEBUG, "SEAT LICEO (DELCO) DETECTED\r\n");
        _crack_delco_seat_liceo_or_vw_konzern_2004();

    } else if (memcmp(&kwp_vag_number, "1J0035156", 9) == 0) {
        uart_puts(UART_DEBUG, "VW RHAPSODY (TECHNISAT) DETECTED\r\n");
        _crack_technisat();

    } else if (memcmp(&kwp_vag_number, "1U0035156", 9) == 0) {
        uart_puts(UART_DEBUG, "SKODA SYMPHONY (TECHNISAT) DETECTED\r\n");
        _crack_technisat();

    } else if (memcmp(&kwp_component_1[7], "YD5", 3) == 0) {
        uart_puts(UART_DEBUG, "VW GAMMA 5 (TECHNISAT) DETECTED\r\n");
        _crack_technisat();

    } else {
        uart_puts(UART_DEBUG, "UNKNOWN RADIO\r\n");
        uart_puts(UART_DEBUG, "UNCRACKABLE\r\n");
    }

    uart_puts(UART_DEBUG, "Done.\r\n");
}
