# Compare implementation that loops over chunks

Added `1brc_parallel_mmap2` and `1brc_parallel_ptr3` which replace the use a `Channel` to manage the work across `file_parts` fibres, instead creating _N_ fibres and having each step through every _Nth_ chunk of the file.

Results were inconclusive, for the most looking like it doesn't matter.

- [ ] Haven't tested looping with `mmap` based implementation yet.

## Results

See [this CSV](/perfdata/loopoverchunks_i7_macos.csv) for details.

```txt
  ./run.sh 1brc_parallel_ptr2 24 16 ran
    1.04 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 24 24
    1.05 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 24 12
    1.07 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 24 12
    1.08 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 16 32
    1.09 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 24 24
    1.09 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 16 16
    1.09 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 24 32
    1.10 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 16 24
    1.12 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr3 16 12
    1.14 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 24 32
    1.15 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr3 24 16
    1.24 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2 16 12
    1.29 ± 0.03 times faster than ./run.sh 1brc_parallel_ptr2 16 16
    1.57 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2 16 24
    1.87 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr2 16 32```
