#include "yc_file.h"
#include <iostream>

int main()
{
    if (!yc_makesure_dir_exit("/home/christian/test_common")) {
        std::cout << "create path failed" << std::endl;
    }
    return 0;
}