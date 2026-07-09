#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>

#define OUT "/run/hs80-battery"
#define PID "00000A6B"

static int is_hs80_hidraw(const char *name) {
    char path[256];
    snprintf(path, sizeof(path), "/sys/class/hidraw/%s/device/uevent", name);

    FILE *f = fopen(path, "r");
    if (!f) return 0;

    char line[256];
    int found = 0;

    while (fgets(line, sizeof(line), f)) {
        if (strstr(line, "HID_ID=") && strstr(line, PID)) {
            found = 1;
            break;
        }
    }

    fclose(f);
    return found;
}

static int open_hs80(void) {
    DIR *dir = opendir("/sys/class/hidraw");
    if (!dir) return -1;

    struct dirent *entry;
    int best_num = 9999;

    while ((entry = readdir(dir))) {
        if (strncmp(entry->d_name, "hidraw", 6) != 0)
            continue;

        if (!is_hs80_hidraw(entry->d_name))
            continue;

        int num = atoi(entry->d_name + 6);

        if (num < best_num)
            best_num = num;
    }

    closedir(dir);

    if (best_num == 9999)
        return -1;

    char dev[64];
    snprintf(dev, sizeof(dev), "/dev/hidraw%d", best_num);

    int fd = open(dev, O_RDONLY);
    if (fd >= 0)
        fprintf(stderr, "Using %s\n", dev);

    return fd;
}

int main(void) {
    int fd = open_hs80();

    if (fd < 0) {
        perror("open_hs80");
        return 1;
    }

    unsigned char buf[65];

    while (1) {
        ssize_t n = read(fd, buf, sizeof(buf));

        if (n < 0) {
            perror("read");
            close(fd);

            sleep(1);
            fd = open_hs80();
            continue;
        }

        if (n == 0) {
            sleep(1);
            continue;
        }

        if (n >= 7 && buf[3] == 0x0f) {
            int raw = buf[5] | (buf[6] << 8);
            int percent = raw / 10;

            FILE *out = fopen(OUT, "w");
            if (out) {
                fprintf(out, "%d%%\n", percent);
                fclose(out);
            }
        }
    }
}