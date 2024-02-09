# Performance data with `mmap` files

## Background

- Implement a better hash map
- See [TODO](/TODO.md) for details

## Results

The best result on the AMD 7735HS with Linux was

```txt
Benchmark 92: ./run.sh 1brc_parallel_ptr2b 16 48
  Time (mean ± σ):      9.049 s ±  0.077 s    [User: 20.642 s, System: 1.728 s]
  Range (min … max):    8.979 s …  9.132 s    3 runs
```
See [the CSV here](/perfdata/DATA_1brc_parallel_fxhashmap.md) for the detailed results. Summary below shows that the `mmap2b` variant performs best.

```txt
  ./run.sh 1brc_parallel_mmap2b 16 48 ran
    1.00 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 32
    1.02 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 24
    1.03 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 12
    1.03 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap2b 32 48
    1.04 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 48 48
    1.04 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap2b 32 24
    1.04 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 16
    1.04 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 64 48
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 48 32
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 48 24
    1.05 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 64 32
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 32 32
    1.06 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 64 24
    1.06 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 24 48
    1.07 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 24 32
    1.08 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 64 16
    1.08 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 24 24
    1.09 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap2b 48 16
    1.09 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 32 8
    1.09 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 48 12
    1.09 ± 0.04 times faster than ./run.sh 1brc_parallel_mmap2b 24 16
    1.10 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 16 48
    1.10 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 32 16
    1.11 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 64 8
    1.12 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 64 12
    1.12 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 32 4
    1.12 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 32 48
    1.12 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 16 32
    1.12 ± 0.05 times faster than ./run.sh 1brc_parallel_mmap2b 24 12
    1.13 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 32 12
    1.14 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 24 48
    1.15 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 16 24
    1.15 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 48 4
    1.16 ± 0.06 times faster than ./run.sh 1brc_parallel_mmap2b 16 8
    1.17 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 32 32
    1.17 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 64 4
    1.17 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 48 48
    1.18 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 4
    1.18 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 32 24
    1.18 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 24 32
    1.19 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 16 16
    1.20 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 48 8
    1.20 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 64 48
    1.21 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 24 24
    1.21 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 24 8
    1.22 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 48 32
    1.23 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 24 16
    1.25 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 48 24
    1.25 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 16 12
    1.27 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 64 32
    1.28 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 32 16
    1.30 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 64 32
    1.30 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr2b 48 32
    1.30 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 48 48
    1.31 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 64 48
    1.31 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 64 24
    1.31 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr2b 48 24
    1.33 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 24 12
    1.34 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 48 16
    1.34 ± 0.08 times faster than ./run.sh 1brc_parallel_mmap2b 24 4
    1.35 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2b 64 24
    1.35 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 32 12
    1.40 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 32 16
    1.42 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 64 16
    1.42 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 16 8
    1.43 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2b 32 24
    1.43 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 32 12
    1.43 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 48 16
    1.45 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr2b 64 16
    1.45 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 48 12
    1.45 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr3b 24 8
    1.46 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 48 12
    1.47 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 64 12
    1.47 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 32 8
    1.49 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2b 32 32
    1.50 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 64 12
    1.54 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2b 24 12
    1.55 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 48 8
    1.56 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 32 8
    1.56 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 64 8
    1.57 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 48 8
    1.62 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2b 24 8
    1.63 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2b 24 16
    1.66 ± 0.17 times faster than ./run.sh 1brc_parallel_ptr2b 32 48
    1.69 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 16 4
    1.77 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 16 4
    1.77 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr2b 32 4
    1.78 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 48 4
    1.80 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 64 8
    1.81 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2b 16 8
    1.82 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2b 24 24
    1.83 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2b 64 4
    1.86 ± 0.09 times faster than ./run.sh 1brc_parallel_ptr3b 24 4
    1.90 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 24 4
    2.08 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2b 24 32
    2.09 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2b 16 12
    2.17 ± 0.08 times faster than ./run.sh 1brc_parallel_ptr3b 32 4
    2.46 ± 0.10 times faster than ./run.sh 1brc_parallel_ptr2b 16 16
    2.66 ± 0.14 times faster than ./run.sh 1brc_parallel_ptr2b 24 48
    2.85 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 48 4
    3.00 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2b 16 24
    3.50 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2b 16 32
    4.26 ± 0.19 times faster than ./run.sh 1brc_parallel_ptr3b 64 4
    4.34 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2b 16 48
```
