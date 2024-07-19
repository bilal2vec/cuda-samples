#include "stdio.h"

#include <cuda.h>

#define SIZE (1e9)
#define ITERS (1e3)

int main(void) {

    float* src;
    float* dst;
    cudaEvent_t start, stop;
    
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaMalloc((void**)&src, SIZE);
    cudaMalloc((void**)&dst, SIZE);

    cudaEventRecord(start, 0);

    for (int i = 0; i < ITERS; i++) {
        cudaMemcpy((void*)dst, (void*)src, SIZE, cudaMemcpyDeviceToDevice);
    }

    cudaEventRecord(stop, 0);
    cudaDeviceSynchronize();
    
    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    float s = ms / 1000.0;
    float mem_transferred = (2.0f * SIZE * ITERS) / (float)1e9;
    float mem_bw = mem_transferred / s;

    printf("s: %f\n", s);
    printf("mem_transferred: %f\n", mem_transferred);
    printf("mem_bw: %f\n", mem_bw);

    return 0;
}
