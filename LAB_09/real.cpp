#include <cstdlib>
#include <cstdio>
#include <ctime>

#define MEASURMENTS_COUNT 100

#ifdef FPU
#define getAddTime(Type) getTimeFPU<Type>
#define getMultTime(Type) getMultTimeFPU<Type>
#else
#define getAddTime(Type) getTimeC<Type>
#define getMultTime(Type) getMultTimeC<Type>
#endif

template <typename Type>
double getAddTimeC(const Type a, const Type b)
{
    Type res;

    clock_t start = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        res = a + b;
    
    clock_t end = clock();

    double time = (double)(end - start) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    return time;
}

template <typename Type>
double getMultTimeC(const Type a, const Type b)
{
    Type res;

    clock_t start = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        res = a * b;
    
    clock_t end = clock();

    double time = (double)(end - start) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    return time;
}

template <typename Type>
double getAddTimeFPU(const Type a, const Type b)
{
    Type res;

    clock_t start = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        __asm__("fld %1\n"
                "fld %2\n"
                "faddp\n"
                "fstp %0\n"
                : "=r" (res)
                : "r" (a),
                "r" (b));
    
    clock_t end = clock();

    double time = (double)(end - start) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    return time;
}

template <typename Type>
double getMultTimeFPU(const Type a, const Type b)
{
    Type res;

    clock_t start = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        __asm__ ("fld %1\n"
                 "fld %2\n"
                 "fmulp\n"
                 "fstp %0\n"
                 : "=r" (res)
                 : "r" (a),
                   "r" (b));
    
    clock_t end = clock();

    double time = (double)(end - start) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    return time;
}

int main()
{
    float a = 2.5, b = 3.56;

    printf("SUM\n");
    printf("float: %lf s\n", getAddTime(float)(a, b));
    printf("double: %lf s\n", getAddTime(double)(a, b));
    printf("float80: %lf s\n", getAddTime(__float80)(a, b));
    printf("long double: %lf s\n\n", getAddTime(long double)(a, b));

    printf("MULT\n");
    printf("float: %lf s\n", getMultTime(float)(a, b));
    printf("double: %lf s\n", getMultTime(double)(a, b));
    printf("float80: %lf s\n", getMultTime(__float80)(a, b));
    printf("long double: %lf s\n", getMultTime(long double)(a, b));

    return EXIT_SUCCESS;
}
