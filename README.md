# One Billion Row Challenge (1brc) using Crystal

## Motivation

While Gunnar Morling originally posed [The One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/) for Java developers, over time folks have started implementing it in different languages which are [showcased here](https://github.com/gunnarmorling/1brc/discussions/categories/show-and-tell).

While reviewing the results in Java I ran across [one implementation in C](https://github.com/gunnarmorling/1brc/discussions/46) that made me wonder what I could do with Crystal.

> See discussion in Crystal forum [here](https://forum.crystal-lang.org/t/1brc-in-crystal/6467). This led me to create [TODO](/TODO.md) list of things to try.
>
> See post in Gunnar's "Show & Tell" discussion area [here](https://github.com/gunnarmorling/1brc/discussions/711)

## Overall performance (so far)

> Updated 2024 Feb 11

On a PC with AMD Ryzen 7 7735HS CPU, 16 cores, 32 GB, and running Linux, comparing with some other `1brc` contenders there's still room to do. See the [TODO](/TODO.md) list for changes so far and possible further improvements.
See [this CSV](/perfdata/compare1brc240211.csv) for the detailed results.

| relative         | command                      | Lang        | mean (s)             | stddev               |
| ---------------- | ---------------------------- | ----------- | -------------------- | -------------------- |
| 1.0x             | *serkan-ozal*                | *Java*      | *1.1661091954200002* | 0.10359078275160513  |
|                  | dannyvankooten/analyze       | C           | 1.24137285062        | 0.003261490844545827 |
|                  | merykittyunsafe.sh           | Java        | 1.34270993842        | 0.036888174169103186 |
|                  | merykitty.sh                 | Java        | 1.51770504842        | 0.021277280568716347 |
| **1.74x slower** | **1brc_parallel_ptr4 16 48** | **Crystal** | **2.03081785402**    | 0.06009663760371807  |
| 1.77x slower     | 1brc_parallel_mmap2b 16 32   | Crystal     | 2.06915509142        | 0.01875921473395469  |

It's worth noting that there is no significant different between my two best results; given the way the file is read in parallel and in chunks, using `mmap` or not doesn't make a big difference.

## Dependencies

None. Plain ol' Crystal.

## Build all

### ... with `shards`

* `shards build --release  -Dpreview_mt`

### ... with `ops`

> Use if you have `brew` on macOS or Linux.

First [install `crops`](https://github.com/nickthecook/crops) and then

* `ops up`
* `ops cbr -Dpreview_mt`

## Run

| Status      | Implementation         | Description                                                                                      | Performance                      |
| ----------- | ---------------------- | ------------------------------------------------------------------------------------------------ | -------------------------------- |
| **Fastest** | `1brc_parallel_ptr4`   | Variant of `ptr3b` using long word name parsing                                                  | slightly faster                  |
|             | `1brc_parallel_ptr3b`  | Variant of `ptr3` using optimized hash map                                                       | much faster                      |
|             | `1brc_parallel_ptr3`   | Variant of `ptr2` which only launched _N_ fibres and loops over _D / N_ chunks.                  | faster                           |
|             | `1brc_parallel_ptr2b`  | Variant of `ptr2` using optimized hash map                                                       | much faster                      |
|             | `1brc_parallel_ptr2`   | Variant using page-aligned part size in anticipation of `mmap`-based implementation.             | faster again                     |
|             | `1brc_parallel_ptr`    | Replaces `Slice` with `Pointer` to the buffer, to remove bounds checking when parsing.           | faster                           |
| **Fastest** | `1brc_parallel_mmap3`  | Variant of `mmap2b` using long word name parsing                                                 | slightly faster                  |
|             | `1brc_parallel_mmap2b` | Variant of `mmap2` using optimized hash map                                                      | much faster                      |
|             | `1brc_parallel_mmap2`  | Variant of `mmap` which only launched _N_ fibres and loops over _D / N_ chunks.                  | slightly faster but not always   |
|             | `1brc_parallel_mmap`   | Using `mmap` to load the file                                                                    | faster                           |
|             | `1brc_parallel2`       | Variant using page-aligned part size in anticipation of `mmap`-based implementation.             | faster                           |
|             | `1brc_parallel`        | Parallel multi-threaded implementation that chunks up the file and spawns fibres to process them | much faster                      |
|             | `1brc_serial2`         | Serial implementation optimized to use byte slices (`Bytes`)                                     | a little faster, but still slow. |
| *Slowest*   | `1brc_serial1`         | A very simple serial implementation using `String` lines                                         | slowest.                         |

> While you are welcome to run the serial implementatios, my focus from now on will on the parallel implementations.

The parallel implementations,

* given   the buffer division is _D_ (via `BUF_DIV_DENOM`), and
* given the number of threads is _N_ (via `CRYSTAL_WORKERS`), and
* given _N < q_ where _q_ is the number of chunks based on `file_size / (Int32::MAX / D)`

works as follows:

* spawns _q_ fibres, and
* allocates _N_ buffers, and
* processes _N_ chunks concurrently.

Note that since _D_ is the denominator, we have the following number of chunks (and their sizes) based on _D_.

|  _D_ | _q_ chunks | chunk size |
| ---: | ---------: | ---------: |
|    4 |         26 |     512 MB |
|    5 |         33 |     410 MB |
|    6 |         39 |     341 MB |
|    7 |         46 |     293 MB |
|    8 |         52 |     256 MB |
|   12 |         78 |     171 MB |
|   16 |        104 |     128 MB |
|   24 |        156 |      85 MB |
|   32 |        208 |      64 MB |
|   48 |        312 |      43 MB |

> A script `run.sh` is provided to conveniently run one of the implementations and specify the concurrency values.

Make sure you have `measurements.txt` in the current folder, and then execute `./run.sh 1brc_parallel 32 24` to run the implementation with the specific threads (32) and buffer division (24).

> If your machine is different from mine (see results below), send me your results.

## Results

See the various file in `/perfdata` for results and analyses over time.

## Contributing

Bug reports and sugestions are welcome.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://www.contributor-covenant.org/version/1/4/code-of-conduct/).

## License

This project is available as open source under the terms of the [CC-BY-4.0](./LICENSE) license.

## Contributors

* [nogginly](https://github.com/nogginly) - creator and maintainer
