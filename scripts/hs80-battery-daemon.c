#define _POSIX_C_SOURCE 200809L

#include "hs80-daemon-common.h"

#include <stdint.h>

#define OUTPUT_PATH "/run/hs80-battery"

enum {
    BATTERY_REPORT_KIND = 0x0f,
    BATTERY_RAW_HIGH_OFFSET = 6,
    BATTERY_REPORT_MIN_SIZE = 7,
};

static Hs80StatusCache status_cache;

static int publish_battery(const char *state) {
    const int result = hs80_publish_status(OUTPUT_PATH, state, &status_cache);

    if (result < 0)
        perror("hs80-battery: write status");

    return result;
}

static void handle_report(const uint8_t *report, ssize_t size) {
    if (size < BATTERY_REPORT_MIN_SIZE)
        return;

    if (report[HS80_REPORT_KIND_OFFSET] != BATTERY_REPORT_KIND)
        return;

    const uint16_t raw_percentage =
        (uint16_t)report[HS80_REPORT_VALUE_OFFSET]
        | ((uint16_t)report[BATTERY_RAW_HIGH_OFFSET] << 8);
    const unsigned int percentage = raw_percentage / 10;

    if (percentage > 100)
        return;

    char state[8];
    snprintf(state, sizeof(state), "%u%%", percentage);
    publish_battery(state);
}

int main(void) {
    if (publish_battery("") < 0)
        return EXIT_FAILURE;

    for (;;) {
        const int file_descriptor = hs80_wait_for_device();

        for (;;) {
            uint8_t report[HS80_REPORT_SIZE];
            const ssize_t size = read(file_descriptor, report, sizeof(report));

            if (size > 0) {
                handle_report(report, size);
                continue;
            }

            if (size < 0 && errno == EINTR)
                continue;

            if (size < 0)
                perror("hs80-battery: read");
            else
                fprintf(stderr, "hs80-battery: device disconnected\n");

            break;
        }

        close(file_descriptor);
        publish_battery("");
        sleep(HS80_RECONNECT_DELAY_SECONDS);
    }
}
