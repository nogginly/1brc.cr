# AMD Ryzen 7 7735HS CPU, 16 cores, 32 GB, with Linux

> Updated 2024-02-11

See [this CSV](/perfdata/parmmap2_amd_7735HS_16c_32gb.csv) for detailed results. 

| command                       | _N_ | _D_ | mean               | stddev               |
| ----------------------------- | --- | --- | ------------------ | -------------------- |
| ./run.sh 1brc_parallel_mmap3  | 16  | 32  | 1.81223936802      | 0.010641893538444113 |
| ./run.sh 1brc_parallel_mmap3  | 16  | 48  | 1.8124395733533334 | 0.025204295077901798 |
| ./run.sh 1brc_parallel_mmap3  | 16  | 24  | 1.8368723893533332 | 0.013546516645281849 |
| ./run.sh 1brc_parallel_mmap3  | 32  | 48  | 1.8582098443533333 | 0.009143857373650572 |
| ./run.sh 1brc_parallel_mmap3  | 32  | 32  | 1.8702906126866665 | 0.025440750732756902 |
| ./run.sh 1brc_parallel_mmap3  | 32  | 24  | 1.88539149402      | 0.016638412704802416 |
| ./run.sh 1brc_parallel_mmap3  | 16  | 16  | 1.89390683402      | 0.015744340864729173 |
| ./run.sh 1brc_parallel_mmap3  | 24  | 48  | 1.9165033426866664 | 0.02913031014921986  |
| ./run.sh 1brc_parallel_mmap3  | 24  | 24  | 1.9173128173533334 | 0.012058646943863154 |
| ./run.sh 1brc_parallel_mmap3  | 32  | 16  | 1.9287347866866666 | 0.005990832996194345 |
| ./run.sh 1brc_parallel_mmap3  | 24  | 16  | 1.9364241643533333 | 0.028796730421491862 |
| ./run.sh 1brc_parallel_mmap3  | 24  | 32  | 1.9517046993533331 | 0.04603274094312159  |
| ./run.sh 1brc_parallel_ptr4   | 16  | 48  | 1.9860852070200001 | 0.036552582355871645 |
| ./run.sh 1brc_parallel_ptr4   | 16  | 32  | 2.048094108686667  | 0.022017097642112623 |
| ./run.sh 1brc_parallel_ptr4   | 24  | 48  | 2.050099128353333  | 0.01405313428169441  |
| ./run.sh 1brc_parallel_mmap2b | 16  | 48  | 2.052253801686667  | 0.013836257705981809 |
| ./run.sh 1brc_parallel_ptr4   | 32  | 48  | 2.05387243302      | 0.01625264239831073  |
| ./run.sh 1brc_parallel_mmap2b | 16  | 32  | 2.070212400686667  | 0.013296134404275487 |

Relative performance results below.

```txt
  ./run.sh 1brc_parallel_mmap3 16 32 ran
    1.00 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap3 16 48
    1.01 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap3 16 24
    1.03 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap3 32 48
    1.03 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap3 32 32
    1.04 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap3 32 24
    1.05 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap3 16 16
    1.06 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap3 24 48
    1.06 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap3 24 24
    1.06 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap3 32 16
    1.07 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap3 24 16
    1.08 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap3 24 32
    1.10 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr4 16 48
    1.13 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr4 16 32
    1.13 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr4 24 48
    1.13 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 48
    1.13 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr4 32 48
    1.14 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 32
    1.15 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr4 16 24
    1.16 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 16 24
    1.17 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr4 16 16
    1.17 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr4 32 32
    1.18 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr4 24 32
    1.18 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 32 48
    1.18 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 32 24
    1.20 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 32 32
    1.20 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr4 24 24
    1.20 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 24 48
    1.23 ± 0.01 times faster than ./run.sh 1brc_parallel_mmap2b 24 32
    1.23 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 24 24
    1.23 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr4 32 24
    1.24 ± 0.10 times faster than ./run.sh 1brc_parallel_mmap2b 16 16
    1.24 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap2b 32 16
    1.24 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 16 48
    1.27 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr4 24 16
    1.27 ± 0.02 times faster than ./run.sh 1brc_parallel_mmap2b 24 16
    1.28 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr4 32 16
    1.29 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 16 32
    1.30 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 32 48
    1.32 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 24 32
    1.33 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 24 48
    1.33 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr3b 16 24
    1.34 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 32 32
    1.35 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 32 24
    1.38 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3b 16 16
    1.39 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3b 24 24
    1.43 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 24 16
    1.44 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr3b 32 16
    1.60 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 32 24
    1.61 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2b 32 16
    1.71 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2b 32 32
    1.78 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2b 24 16
    1.86 ± 0.16 times faster than ./run.sh 1brc_parallel_ptr2b 32 48
    2.12 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2b 24 24
    2.37 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 24 32
    2.73 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2b 16 16
    2.83 ± 0.36 times faster than ./run.sh 1brc_parallel_ptr2b 24 48
    3.49 ± 0.08 times faster than ./run.sh 1brc_parallel_ptr2b 16 24
    4.07 ± 0.08 times faster than ./run.sh 1brc_parallel_ptr2b 16 32
    5.10 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2b 16 48


```