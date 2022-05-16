#include <cstdlib>
#include <cstdio>
#include <cmath>

#define PI1 3.14
#define PI2 3.141596

double FPUSin(const double pi)
{
    double res;

    __asm__("fld %1\n"
            "fsin\n"
            "fstp %0\n"
            : "=r" (res)
            : "r" (pi));
        
    return res;
}

double FPUSinPi()
{
    double res;

    __asm__("fldpi\n"
            "fsin\n"
            "fstp %0\n"
            : "=r" (res));
        
    return res;
}

double FPUSinHalfPi()
{
    double res;
    double div = 2;

    __asm__("fldpi\n"
            "fld %0\n"
            "fdivp\n"
            "fsin\n"
            "fstp %1\n"
            : "=r" (res)
            : "r" (div));
        
    return res;
}

int main()
{
    printf("PI:\n");
    printf("3.14: %lf\n", FPUSin(PI1));
    printf("3.141596: %lf\n", FPUSin(PI2));
    printf("FPU PI: %lf\n\n", FPUSinPi());

    printf("PI / 2:\n");
    printf("3.14: %lf\n", FPUSin(PI1 / 2));
    printf("3.141596: %lf\n", FPUSin(PI2 / 2));
    printf("FPU PI: %lf\n\n", FPUSinHalfPi());

    return EXIT_SUCCESS;
}
