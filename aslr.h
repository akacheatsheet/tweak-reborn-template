#include <mach-o/dyld.h>
#include <stdlib.h>
#include <string.h>

__attribute__((always_inline)) static uint64_t get_address(const char *image_name, uint64_t offset) {
    if (image_name == nullptr) {
        const char *progname = getprogname();
        if (progname) {
            return get_address(progname, offset);
        }
        return _dyld_get_image_vmaddr_slide(1) + offset;
    }

    const uint32_t image_count = _dyld_image_count();
    for (uint32_t i = 0; i < image_count; ++i) {
        if (strstr(_dyld_get_image_name(i), image_name)) {
            return _dyld_get_image_vmaddr_slide(i) + offset;
        }
    }

    return offset;
}