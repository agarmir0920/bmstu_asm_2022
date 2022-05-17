#include <cstdlib>
#include <cstdio>
#include <ctime>

#define MEASURMENTS_COUNT 1e6

double scMultC(const double *a, const double *b, const size_t n)
{
    double res = 0.0;

    for (size_t i = 0; i < n; ++i)
        res += *(a + i) * *(b + i);
    
    return res;
}

double scMultSSE(const double *a, const double *b, const size_t n)
{
    double res = 0.0;

    for (size_t i = 0; i < n; ++i)
    {
        double sum = 0.0;

        __asm__(
                "movaps xmm0, %1\n"
                "movaps xmm1, %2\n"
                "mulps xmm0, xmm1\n"
                "haddps xmm0, xmm0\n"
                "haddps xmm0, xmm0\n"
                "movss %0, xmm0\n"
                : "=m"(sum)
                : "m"(*a), "m"(*b)
                : "xmm0", "xmm1");
        
        res += sum;
    }

    return res;
}

int main()
{
    double a[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    double b[10] = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1};

    clock_t time = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        scMultC(a, b, 10);
    
    time = (double)(clock() - time) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    printf("C: %.20lf\n", time);

    time = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        scMultSSE(a, b, 10);
    
    time = (double)(clock() - time) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    printf("SSE: %.20lf\n", time);

    return EXIT_SUCCESS;
}
