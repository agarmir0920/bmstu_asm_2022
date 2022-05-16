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
            : "=m" (res)
            : "m" (pi));
        
    return res;
}

double FPUSinPi()
{
    double res;

    __asm__("fldpi\n"
            "fsin\n"
            "fstp %0\n"
            : "=m" (res));
        
    return res;
}

double FPUSinHalfPi()
{
    double res;
    double div = 2.;

    __asm__("fldpi\n"
            "fld %1\n"
            "fdivp\n"
            "fsin\n"
            "fstp %0\n"
            : "=m" (res)
            : "m" (div));
        
    return res;
}

int main()
{
    printf("PI:\n");
    printf("3.14: %.20lf\n", FPUSin(PI1));
    printf("3.141596: %.20lf\n", FPUSin(PI2));
    printf("FPU PI: %.20lf\n\n", FPUSinPi());

    printf("PI / 2:\n");
    printf("3.14: %.20lf\n", FPUSin(PI1 / 2));
    printf("3.141596: %.20lf\n", FPUSin(PI2 / 2));
    printf("FPU PI: %.20lf\n\n", FPUSinHalfPi());

    return EXIT_SUCCESS;
}
