#include <iostream>
#include <cstdlib>

using namespace std;

extern "C"
{
    copyString(
        const char *const dst,
        const char *const src,
        const size_t size);
}

size_t stringLength(const char *str)
{
    size_t lenght = 0;

    __asm__(".intel_syntax noprefix\n\t"
            "mov al, 0\n\t"
            "mov rdi, %1\n\t"
            "mov rcx, -1\n\t"
            "repne scasb\n\t"
            "neg rcx\n\t"
            "sub rcx, 2\n\t"
            "mov %0, rcx\n\t"
            : "=r" (len)
            : "r" (str)
            : "al", "rdi", "rcx");
}

int main(void)
{
    char str[] = "qwerty";

    size_t length = stringLength(str);

    cout << length << endl;

    char cpy[10];

    copyString(cpy, str, 6);

    cout << cpy << endl;

    return EXIT_SUCCESS;
}
