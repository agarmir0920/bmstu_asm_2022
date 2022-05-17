#include <cstdlib>
#include <cstdio>
#include <ctime>

#define MEASURMENTS_COUNT 1e6

float scMultC(const float *a, const float *b, const size_t n)
{
    float res = 0.0;

    for (size_t i = 0; i < n; ++i)
        res += *(a + i) * *(b + i);
    
    return res;
}

float scMultSSE(const float *src_a, const float *src_b, const size_t n)
{
    float res = 0.0;

    __float128 *a = (__float128 *)src_a;
    __float128 *b = (__float128 *)src_b;

    for (size_t i = 0; i < n; i += sizeof(__float128) / sizeof(float), a++, b++)
    {
        float sum = 0.0;

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
    float a[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    float b[10] = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1};

    clock_t start = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        scMultC(a, b, 10);
    
    float time = (float)(clock() - start) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    printf("C: %.20f\n", time);

    start = clock();

    for (size_t i = 0; i < MEASURMENTS_COUNT; ++i)
        scMultSSE(a, b, 10);
    
    time = (float)(clock() - start) / MEASURMENTS_COUNT / CLOCKS_PER_SEC;

    printf("SSE: %.20f\n", time);

    return EXIT_SUCCESS;
}
