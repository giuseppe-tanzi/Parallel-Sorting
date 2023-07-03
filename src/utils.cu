#include "../lib/utils.cuh"

void gpuAssert(cudaError_t code, const char *file, int line, bool abort)
{
    if (code != cudaSuccess)
    {
        fprintf(stderr, "GPUerror: %s\nCode: %d\nFile: %s\nLine: %d\n", cudaGetErrorString(code), code, file, line);
        if (abort)
            exit(code);
    }
}

/*
    Function that returns the current time
*/
double gettime(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (ts.tv_sec + (double)ts.tv_nsec / 1e9);
}

/*
    Function that randomly initializes an array from 0 to N
*/
void init_array(unsigned short *data, const unsigned long long N)
{
    srand(42); // Ensure the determinism

    for (unsigned long long i = 0; i < N; i++)
    {
        data[i] = rand() % (MAX_VALUE - MIN_VALUE + 1) + MIN_VALUE;;
    }
}

/*
    Function that prints an array
*/
__host__ __device__ void print_array(const unsigned short *data, const unsigned long long N) //TODO: delete __device__
{
    for (unsigned long long i = 0; i < N; i++)
    {
        printf("%hu ", data[i]);
    }
    printf("\n");
}

/*
    Function that checks if the array is ordered
*/
int check_result(unsigned short *results, const unsigned long long N)
{
    for (unsigned long long i = 0; i < N - 1; i++)
    {
        if (results[i] > results[i + 1])
        {
            printf("Check failed: data[%llu] = %hu, data[%llu] = %hu\n", i, results[i], i + 1, results[i + 1]);
            printf("%hu is greater than %hu\n", results[i], results[i + 1]);
            return 0;
        }
    }
    printf("Check OK\n");
    return 1;
}

bool IsPowerOfTwo(const unsigned long x)
{
    return (x & (x - 1)) == 0;
}

/*
    Function that finds the maximum number in an array
*/
__device__ void get_max(unsigned short *data, const unsigned long long N, unsigned short *max)
{
    *max = -INFINITY;
    for (unsigned long long i = 0; i < N; i++)
    {
        if (data[i] > *max)
        {
            *max = data[i];
        }
    }
}

/*
    Function useful to compute the base to the power of exp
*/
__device__ void power(unsigned base, unsigned exp, unsigned long *result)
{
    *result = 1;
    for (;;)
    {
        if (exp & 1)
            *result *= base;
        exp >>= 1;
        if (!exp)
            break;
        base *= base;
    }
}