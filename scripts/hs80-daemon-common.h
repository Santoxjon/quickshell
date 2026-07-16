#ifndef HS80_DAEMON_COMMON_H
#define HS80_DAEMON_COMMON_H

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

enum {
    HS80_REPORT_SIZE = 65,
    HS80_REPORT_KIND_OFFSET = 3,
    HS80_REPORT_VALUE_OFFSET = 5,
    HS80_RECONNECT_DELAY_SECONDS = 1,
    HS80_STATUS_CAPACITY = 32,
};

typedef struct {
    bool initialized;
    char value[HS80_STATUS_CAPACITY];
} Hs80StatusCache;

static bool hs80_parse_hidraw_index(const char *name, int *index) {
    static const char prefix[] = "hidraw";
    const size_t prefix_length = sizeof(prefix) - 1;

    if (strncmp(name, prefix, prefix_length) != 0 || name[prefix_length] == '\0')
        return false;

    errno = 0;
    char *end = NULL;
    const long value = strtol(name + prefix_length, &end, 10);

    if (errno != 0 || *end != '\0' || value < 0 || value > INT_MAX)
        return false;

    *index = (int)value;
    return true;
}

static bool hs80_matches_device(const char *name) {
    static const char expected_id[] = "HID_ID=0003:00001B1C:00000A6B";
    char path[512];

    const int path_length = snprintf(
        path,
        sizeof(path),
        "/sys/class/hidraw/%s/device/uevent",
        name
    );

    if (path_length < 0 || (size_t)path_length >= sizeof(path))
        return false;

    FILE *file = fopen(path, "r");

    if (file == NULL)
        return false;

    char line[256];
    bool matches = false;
    const size_t expected_length = sizeof(expected_id) - 1;

    while (fgets(line, sizeof(line), file) != NULL) {
        if (strncmp(line, expected_id, expected_length) != 0)
            continue;

        const char terminator = line[expected_length];

        if (terminator == '\0' || terminator == '\n' || terminator == '\r') {
            matches = true;
            break;
        }
    }

    fclose(file);
    return matches;
}

static int hs80_open_device(void) {
    DIR *directory = opendir("/sys/class/hidraw");

    if (directory == NULL)
        return -1;

    int selected_index = INT_MAX;
    struct dirent *entry = NULL;

    while ((entry = readdir(directory)) != NULL) {
        int index = 0;

        if (!hs80_parse_hidraw_index(entry->d_name, &index))
            continue;

        if (index < selected_index && hs80_matches_device(entry->d_name))
            selected_index = index;
    }

    closedir(directory);

    if (selected_index == INT_MAX) {
        errno = ENODEV;
        return -1;
    }

    char path[64];
    const int path_length = snprintf(path, sizeof(path), "/dev/hidraw%d", selected_index);

    if (path_length < 0 || (size_t)path_length >= sizeof(path)) {
        errno = ENAMETOOLONG;
        return -1;
    }

    const int file_descriptor = open(path, O_RDONLY | O_CLOEXEC);

    if (file_descriptor >= 0)
        fprintf(stderr, "hs80: using %s\n", path);

    return file_descriptor;
}

static int hs80_wait_for_device(void) {
    bool error_reported = false;

    for (;;) {
        const int file_descriptor = hs80_open_device();

        if (file_descriptor >= 0)
            return file_descriptor;

        if (!error_reported) {
            fprintf(stderr, "hs80: waiting for device: %s\n", strerror(errno));
            error_reported = true;
        }

        sleep(HS80_RECONNECT_DELAY_SECONDS);
    }
}

static int hs80_write_status(const char *path, const char *state) {
    char output[HS80_STATUS_CAPACITY + 1];
    const int output_length = snprintf(output, sizeof(output), "%s\n", state);

    if (output_length < 0 || (size_t)output_length >= sizeof(output)) {
        errno = EOVERFLOW;
        return -1;
    }

    const int file_descriptor = open(
        path,
        O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC,
        0644
    );

    if (file_descriptor < 0)
        return -1;

    if (fchmod(file_descriptor, 0644) < 0) {
        const int saved_errno = errno;
        close(file_descriptor);
        errno = saved_errno;
        return -1;
    }

    size_t written = 0;

    while (written < (size_t)output_length) {
        const ssize_t result = write(
            file_descriptor,
            output + written,
            (size_t)output_length - written
        );

        if (result > 0) {
            written += (size_t)result;
            continue;
        }

        if (result < 0 && errno == EINTR)
            continue;

        const int saved_errno = result == 0 ? EIO : errno;
        close(file_descriptor);
        errno = saved_errno;
        return -1;
    }

    return close(file_descriptor);
}

static int hs80_publish_status(
    const char *path,
    const char *state,
    Hs80StatusCache *cache
) {
    const size_t state_length = strlen(state);

    if (state_length >= sizeof(cache->value)) {
        errno = EOVERFLOW;
        return -1;
    }

    if (cache->initialized && strcmp(cache->value, state) == 0)
        return 0;

    if (hs80_write_status(path, state) < 0)
        return -1;

    memcpy(cache->value, state, state_length + 1);
    cache->initialized = true;
    return 1;
}

#endif
