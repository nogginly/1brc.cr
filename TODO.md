# TODO

> Based on feedback from my [post in the Crystal Forum](https://forum.crystal-lang.org/t/1brc-in-crystal/6467)

- [x] Replace use of `Slice` (which does index boundary checking) with `Pointer` since I can ensure indices are valid[^stsh]
- [ ] Instead of passing buffers around, consider a limited number of fibers that sit in a loop over some number of chunks[^stsh]
- [x] Look into memory mapping in chunks; there is no reason to mmap the entire file[^stsh]
        - Was able to `mmap` the whole file and then let the OS deal with paging out what we don't need
- [ ] Optimize the use of `Hash` ... replace with what?

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