#include "yc_file.h"
#include <iostream>
#include <unistd.h>
#include <limits.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

int common_test()
{
    std::cout << "common test" << std::endl;
    return 0;
}

bool yc_makesure_dir_exit(const char* target_dir)
{
    if (target_dir == nullptr) {
        return false;
    }

    if (access(target_dir, F_OK) == 0) {
        return true;
    }

    char dir[PATH_MAX] = {0};
    if (-1 == snprintf(dir, sizeof(dir), "%s", target_dir) ) {
        return false;
    }

    size_t len = strlen(dir);
    if (dir[len - 1] != '/') {
        strcat(dir, "/");
    }

    len = strlen(dir);
    for (size_t i = 1; i < len; i++) {
        if (dir[i] != '/') {
            continue;
        }

        dir[i] = '\0'; // 截断后面的路径，处理当前目录
        if (access(dir, F_OK) != 0) {
            mode_t old = umask(022);
            int ret = mkdir(dir, 0755);
            umask(old);
            if (-1 == ret) {
                return false;
            }
        }
        dir[i] = '/';
    }

    return true;
}