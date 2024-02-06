# Performance data with `mmap` files

## Background

- Implement a variant that uses `mmap` to read the files
- Faster than just reading in Linux

## Results

The best result on the AMD 7735HS with Linux was

```txt
Benchmark 19: ./run.sh 1brc_parallel_mmap 64 8
  Time (mean ± σ):      3.244 s ±  0.034 s    [User: 46.215 s, System: 0.718 s]
  Range (min … max):    3.208 s …  3.275 s    3 runs
```
See [the CSV here](/perfdata/mmappar_amd_7735HS_16c_32gb.csv) for the detailed results. Summary below.
~~~~
```txt
  ./run.sh 1brc_parallel_mmap 64 8 ran
    1.00 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap 64 16
    1.01 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 32 4
    1.01 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap 64 4
    1.03 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 32 8
    1.03 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 48 24
    1.03 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap 64 48
    1.04 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap 64 24
    1.04 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap 48 16
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 48 4
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 32 16
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 64 32
    1.05 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 48 32
    1.07 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 48 48
    1.10 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap 48 8
    1.10 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 64 48
    1.11 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 16 4
    1.11 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr2 64 32
    1.12 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 48 24
    1.14 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 48 32
    1.15 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 64 24
    1.15 ± 0.04 times faster than ./run.sh 1brc_parallel_mmap 24 8
    1.15 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 48 48
    1.15 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 32 24
    1.19 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 64 16
    1.22 ± 0.07 times faster than ./run.sh 1brc_parallel_mmap 24 4
    1.24 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 48 16
    1.25 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2 32 16
    1.26 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 32 24
    1.26 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 24 16
    1.27 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 32 32
    1.31 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2 32 8
    1.32 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 64 8
    1.36 ± 0.07 times faster than ./run.sh 1brc_parallel_mmap 16 8
    1.37 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2 24 8
    1.38 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 24 16
    1.39 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 32 32
    1.40 ± 0.10 times faster than ./run.sh 1brc_parallel_ptr2 48 8
    1.46 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 48 4
    1.47 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 64 4
    1.50 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 32 4
    1.50 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 16 4
    1.50 ± 0.20 times faster than ./run.sh 1brc_parallel_ptr2 32 48
    1.50 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap 32 48
    1.53 ± 0.04 times faster than ./run.sh 1brc_parallel_mmap 24 24
    1.57 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2 16 8
    1.64 ± 0.08 times faster than ./run.sh 1brc_parallel_ptr2 24 24
    1.64 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 24 4
    1.73 ± 0.04 times faster than ./run.sh 1brc_parallel_mmap 24 32
    1.92 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 24 32
    2.04 ± 0.05 times faster than ./run.sh 1brc_parallel_mmap 16 16
    2.16 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 16 16
    2.33 ± 0.11 times faster than ./run.sh 1brc_parallel_mmap 24 48
    2.35 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2 24 48
    2.54 ± 0.10 times faster than ./run.sh 1brc_parallel_mmap 16 24
    2.67 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 16 24
    3.08 ± 0.08 times faster than ./run.sh 1brc_parallel_mmap 16 32
    3.20 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2 16 32
    3.95 ± 0.06 times faster than ./run.sh 1brc_parallel_mmap 16 48
    4.06 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2 16 48
```
