# TODO

> Based on feedback from my [post in the Crystal Forum](https://forum.crystal-lang.org/t/1brc-in-crystal/6467)

- [x] Replace use of `Slice` (which does index boundary checking) with `Pointer` since I can ensure indices are valid[^stsh]
- [x] Instead of passing buffers around, consider a limited number of fibers that sit in a loop over some number of chunks[^stsh]
  - See [results](/perfdata/DATA_1brc_loopoverchunks.md)
- [x] Look into memory mapping in chunks; there is no reason to mmap the entire file[^stsh]
  - Was able to `mmap` the whole file and then let the OS deal with paging out what we don't need
- [x] Optimize the use of `Hash` ... replace with custom optimized hash map
  - The `merykitty` implementation identified a hashing function based on FxHash used in the Rust compiler
  - After reviewing [this article by Nicholas Nethercote](https://nnethercote.github.io/2021/12/08/a-brutally-effective-hash-function-in-rust.html) I implemented `FxHashMap` and created the `b` variants using that instead of `Hash`.
- [ ] Re-run the benchmarks using 1B row data file on Linux using the `b` variants.

## FxHashMap is faster

Note that this replacement `FxHashMap` isn't expected to be the best for general use. It has a fixed sized array and also uses a `HASH_SEED` that was selected after trials with the known city names as keys to ensure least collisions. Also, creation time of `FxHashMap` is poor, but since we only create one per thread, this isn't a bottleneck. The performance is much better across all the variants.

Using a 500M row data file, which is a 6GB file that doesn't cause my i7 Macbook to swap memory, we can see that `mmap`-based implemented is the fastest, and the use of `FxHashMap` makes that even better.

```txt
Summary
  ./run.sh 1brc_parallel_mmap2b 24 16 ran
    1.12 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr3b 24 16
    1.30 ± 0.18 times faster than ./run.sh 1brc_parallel_ptr2b 24 16
    1.39 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap2 24 16
    1.54 ± 0.07 times faster than ./run.sh 1brc_parallel_ptr3 24 16
    1.83 ± 0.06 times faster than ./run.sh 1brc_parallel_ptr2 24 16
```

## Hashmap is expensive

Now that I have `mmap` implemented, I wanted to figure out what was taking up time. I commented out the code where I use a `Hash` to store the stats and look them up by name.

Without `Hash` map use ...

```txt
% time ./run.sh 1brc_parallel_mmap 64 8
./run.sh 1brc_parallel_mmap 64 8  17.58s user 0.66s system 1276% cpu 1.429 total
```

With `Hash` map use ...

```txt
% time ./run.sh 1brc_parallel_mmap 64 8
./run.sh 1brc_parallel_mmap 64 8  45.62s user 0.76s system 1443% cpu 3.214 total
```

[^stsh]: Per comment by `straightshoota` [here](https://forum.crystal-lang.org/t/1brc-in-crystal/6467/3)