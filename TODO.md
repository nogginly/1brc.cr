# TODO

> Based on feedback from my [post in the Crystal Forum](https://forum.crystal-lang.org/t/1brc-in-crystal/6467)

- [x] Replace use of `Slice` (which does index boundary checking) with `Pointer` since I can ensure indices are valid[^stsh]
- [ ] Instead of passing buffers around, consider a limited number of fibers that sit in a loop over some number of chunks[^stsh]
- [ ] Look into memory mapping in chunks; there is no reason to mmap the entire file[^stsh]

[^stsh]: Per comment by `straightshoota` [here](https://forum.crystal-lang.org/t/1brc-in-crystal/6467/3)