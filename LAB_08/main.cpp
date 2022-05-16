#include <iostream>
#include <cstdlib>

using namespace std;

extern "C"
{
    char *copyString(
                    const char *const dst,
                    const char *const src,
                    const size_t size);
}

size_t stringLength(const char *str)
{
    size_t length = 0;

    __asm__ ("movb $0, %%al\n\t"
            "movq %1, %%rdi\n\t"
            "movq $-1, %%rcx\n\t"
            "repne scasb\n\t"
            "negq %%rcx\n\t"
            "subq $2, %%rcx\n\t"
            "movq %%rcx, %0\n\t"
            : "=r" (length)
            : "r" (str)
            : "al", "rdi", "rcx");
    
    return length;
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
