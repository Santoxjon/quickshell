#define _POSIX_C_SOURCE 200809L

#include "hs80-daemon-common.h"

#include <stdint.h>

#define OUTPUT_PATH "/run/hs80-charging"

enum {
    CHARGING_REPORT_KIND = 0x10,
    CHARGING_REPORT_MIN_SIZE = 6,
    CHARGING_STATE = 0x01,
    DISCHARGING_STATE = 0x02,
};

static Hs80StatusCache status_cache;

static int publish_charging_state(const char *state) {
    const int result = hs80_publish_status(OUTPUT_PATH, state, &status_cache);

    if (result < 0)
        perror("hs80-charging: write status");

    return result;
}

static void handle_report(const uint8_t *report, ssize_t size) {
    if (size < CHARGING_REPORT_MIN_SIZE)
        return;

    if (report[HS80_REPORT_KIND_OFFSET] != CHARGING_REPORT_KIND)
        return;

    switch (report[HS80_REPORT_VALUE_OFFSET]) {
        case CHARGING_STATE:
            publish_charging_state("charging");
            break;
        case DISCHARGING_STATE:
            publish_charging_state("discharging");
            break;
        default:
            publish_charging_state("unknown");
            break;
    }
}

int main(void) {
    if (publish_charging_state("unknown") < 0)
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
                perror("hs80-charging: read");
            else
                fprintf(stderr, "hs80-charging: device disconnected\n");

            break;
        }

        close(file_descriptor);
        publish_charging_state("unknown");
        sleep(HS80_RECONNECT_DELAY_SECONDS);
    }
}
