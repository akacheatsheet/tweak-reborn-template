#include <ctime>
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <string>

__attribute__((always_inline)) static std::string uintptrToHex(uintptr_t value) {
    std::stringstream ss;
    ss << "0x" << std::hex << value;
    return ss.str();
}

__attribute__((always_inline)) static bool writeLogToFile(const std::string &filename, const std::string &message) {
    if (FILE *file = fopen(filename.c_str(), "a")) {
        std::time_t now = std::time(nullptr);
        char buffer[100];
        std::strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S",
                      std::localtime(&now));

        fprintf(file, "[%s] %s\n", buffer, message.c_str());
        fclose(file);
        return true;
    } else {
        std::cerr << "Unable to open the log file." << std::endl;
        return false;
    }
}