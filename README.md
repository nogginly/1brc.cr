# One Billion Row Challenge (1brc) using Crystal

## Motivation

While Gunnar Morling originally posed [The One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/) for Java developers, over time folks have started implementing it in different languages which are [showcased here](https://github.com/gunnarmorling/1brc/discussions/categories/show-and-tell).

While reviewing the results in Java I ran across [one implementation in C](https://github.com/gunnarmorling/1brc/discussions/46) that made me wonder what I could do with Crystal.

> See discussion in Crystal forum [here](https://forum.crystal-lang.org/t/1brc-in-crystal/6467). This led me to create [TODO](/TODO.md) list of things to try.
>
> See post in Gunnar's "Show & Tell" discussion area [here](https://github.com/gunnarmorling/1brc/discussions/711)

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

| Implementation      | Description                                                                                      | Performance                      |
| ------------------- | ------------------------------------------------------------------------------------------------ | -------------------------------- |
| `1brc_serial1`      | A very simple serial implementation using `String` lines                                         | slowest.                         |
| `1brc_serial2`      | Serial implementation optimized to use byte slices (`Bytes`)                                     | a little faster, but still slow. |
| `1brc_parallel`     | Parallel multi-threaded implementation that chunks up the file and spawns fibres to process them | much faster                      |
| `1brc_parallel_ptr` | Replaces `Slice` with `Pointer` to the buffer, to remove bounds checking when parsing.           | faster, albeit slightly          |

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

### M1 CPU, 8 cores, 8GB RAM with macOS

See the detailed results [here](/perfdata/DATA_m1_8cores_8GB.md). The following shows the best results within 10% of each other.

| Command                      | _N_    | _D_    |          Mean [s] |   Min [s] |   Max [s] |    Relative |
| :--------------------------- | ------ | ------ | ----------------: | --------: | --------: | ----------: |
| `./run.sh 1brc_parallel_ptr` | 32     | 24     |     8.038 ± 0.417 |     7.558 |     8.313 | 1.07 ± 0.06 |
| `./run.sh 1brc_parallel`     | 32     | 32     |     8.127 ± 0.034 |     8.101 |     8.166 | 1.08 ± 0.01 |
| `./run.sh 1brc_parallel_ptr` | **32** | **32** | **7.507 ± 0.059** | **7.448** | **7.567** |    **1.00** |
| `./run.sh 1brc_parallel`     | 48     | 32     |     8.140 ± 0.141 |     7.982 |     8.254 | 1.08 ± 0.02 |
| `./run.sh 1brc_parallel_ptr` | 48     | 32     |     7.824 ± 0.247 |     7.545 |     8.016 | 1.04 ± 0.03 |
| `./run.sh 1brc_parallel`     | 48     | 48     |     7.798 ± 0.135 |     7.646 |     7.905 |        1.04 |
| `./run.sh 1brc_parallel_ptr` | 48     | 48     |     7.468 ± 0.252 |     7.226 |     7.728 |        1.02 |

> The last two results were run separately because I missed it in the original command and wanted to be sure.

### i7-9750H CPU | @ 2.60GHz, 6 cores HT, 16GB RAM with macOS

> Running while plugged into power

| Command                      | _N_    | _D_    |          Mean [s] |   Min [s] |   Max [s] |    Relative |
| :--------------------------- | ------ | ------ | ----------------: | --------: | --------: | ----------: |
| `./run.sh 1brc_parallel_ptr` | **48** | **48** | **9.542 ± 0.268** | **9.321** | **9.840** |    **1.00** |
| `./run.sh 1brc_parallel_ptr` | 32     | 24     |     9.899 ± 0.379 |     9.547 |    10.301 | 1.04 ± 0.05 |
| `./run.sh 1brc_parallel`     | 32     | 24     |    11.571 ± 0.350 |    11.361 |    11.974 | 1.21 ± 0.05 |
| `./run.sh 1brc_parallel`     | 48     | 48     |    10.582 ± 0.039 |    10.554 |    10.626 | 1.11 ± 0.03 |

These results were obtain by running the following:

```txt
hyperfine --warmup 1 --min-runs 3 --export-markdown tmp.md './run.sh 1brc_parallel_ptr 32 24' './run.sh 1brc_parallel 32 24' './run.sh 1brc_parallel_ptr 48 48' './run.sh 1brc_parallel 48 48
```

## Comparisons

### M1 CPU, 8 cores, 8GB RAM with macOS

> Running whiled plugged into power

| Lang        | Config         | Command                                  |          Mean [s] |   Min [s] |   Max [s] |
| ----------- | -------------- | :--------------------------------------- | ----------------: | --------: | --------: |
| **Crystal** | 32 ths, buf/32 | `bin/1brc_parallel ...`                  | **8.376 ± 0.244** | **8.171** | **8.646** |
| Java        |                | `./calculate_average_merykitty.sh`       |    15.094 ± 0.076 |    15.007 |    15.149 |
| Java        |                | `./calculate_average_merykittyunsafe.sh` |    14.873 ± 0.042 |    14.835 |    14.917 |

It's quite amazing that the M1 Macbook Air outperforms the Macbook Pro running the i7.

### i7-9750H CPU | @ 2.60GHz, 6 cores HT, 16GB RAM with macOS

| Approach                                    | Config (if any) | Performance  |                |          |               |
| ------------------------------------------- | --------------- | ------------ | -------------- | -------- | ------------- |
| `1brc_serial1`  using string lines          | n/a             | 271.07s user | 185.62s system | 165% cpu | 4:36.70 total |
| `1brc_serial2` using byte lines             | n/a             | 74.29s user  | 3.06s system   | 99% cpu  | 1:18.10 total |
| `1brc_parallel` using bytes and concurrency | 32 ths buf/24   | 87.65s user  | 9.16s system   | 986% cpu | *9.812 total* |

#### Java: `merykitty`

```txt
% hyperfine --warmup 1 --min-runs 3 './calculate_average_merykittyunsafe.sh'
Benchmark 1: ./calculate_average_merykittyunsafe.sh
  Time (mean ± σ):     18.358 s ±  0.335 s    [User: 24.036 s, System: 25.011 s]
  Range (min … max):   18.093 s … 18.734 s    3 runs

hyperfine --warmup 1 --min-runs 3 './calculate_average_merykitty.sh'
Benchmark 1: ./calculate_average_merykitty.sh
  Time (mean ± σ):     18.849 s ±  0.660 s    [User: 30.953 s, System: 23.819 s]
  Range (min … max):   18.157 s … 19.472 s    3 runs
```

## Contributing

Bug reports and sugestions are welcome.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://www.contributor-covenant.org/version/1/4/code-of-conduct/).

## License

This project is available as open source under the terms of the [CC-BY-4.0](./LICENSE) license.

## Contributors

* [nogginly](https://github.com/nogginly) - creator and maintainer
