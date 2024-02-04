# Performance data with page-aligned memory buffers

## Background

- Added page-aligned variations `1brc_parallel2` and `1brc_parallel_ptr2`
- Out of curiosity decided to benchmark to see if that made a difference in performance
- Aaaand, yes it did.

## Results

See [the CSV here](/perfdata/memalignpar_i7_macos.csv) for the detailed results. Summary below.

```txt
  ./run.sh 1brc_parallel_ptr2 24 16 ran
    1.03 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr 24 16
    1.05 ± 0.08 times faster than ./run.sh 1brc_parallel_ptr2 24 12
    1.09 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2 24 24
    1.14 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 24 32
    1.15 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 16 12
    1.18 ± 0.10 times faster than ./run.sh 1brc_parallel_ptr 24 24
    1.22 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr 24 32
    1.22 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr 16 12
    1.29 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 16 16
    1.37 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr 16 16
    1.38 ± 0.45 times faster than ./run.sh 1brc_parallel_ptr 24 12
    1.54 ± 0.02 times faster than ./run.sh 1brc_parallel_ptr2 16 24
    1.62 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr 16 24
    1.80 ± 0.01 times faster than ./run.sh 1brc_parallel_ptr2 16 32
    1.94 ± 0.09 times faster than ./run.sh 1brc_parallel_ptr 16 32
```
