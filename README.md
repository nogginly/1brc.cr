# One Billion Row Challenge (1brc) using Crystal

## Motivation

While Gunnar Morling originally posed [The One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/) for Java developers, over time folks have started implementing it in different languages which are [showcased here](https://github.com/gunnarmorling/1brc/discussions/categories/show-and-tell).

While reviewing the results in Java I ran across [one implementation in C](https://github.com/gunnarmorling/1brc/discussions/46) that made me wonder what I could do with Crystal.

## Dependencies

None. Plain ol' Crystal.

## Build all

### ... with `ops`

First [install `crops`](https://github.com/nickthecook/crops) and then

* `ops up`
* `ops cbr -Dpreview_mt`

### ... with `shards`

* `shards build --release  -Dpreview_mt`

## Run

| Implementation      | Description                                                                                      | Performance                      |
| ------------------- | ------------------------------------------------------------------------------------------------ | -------------------------------- |
| `1brc_serial1`      | A very simple serial implementation using `String` lines                                         | slowest.                         |
| `1brc_serial2`      | Serial implementation optimized to use byte slices (`Bytes`)                                     | a little faster, but still slow. |
| `1brc_parallel`     | Parallel multi-threaded implementation that chunks up the file and spawns fibres to process them | much faster                      |
| `1brc_parallel_ptr` | Replaces `Slice` with `Pointer` to the buffer, to remove bounds checking when parsing.           | faster, albeit slightly          |

> While you are welcome to run the serial implementatios, my focus from now on will on the parallel implementations.

The parallel implementations,

* given   the buffer division is _D_ (via `BUF_DIV_DENOM`), and number of threads is _N_ (via `CRYSTAL_WORKERS`), and
* given _N < q_ where _q_ is the number of chunks based on `file_size / (Int32::MAX / D)`

works as follows:

* spawns _q_ fibres, and
* allocates _N_ buffers, and
* processes _N_ chunks concurrently.

> A script `run.sh` is provided to conveniently run one of the implementations and specify the concurrency values.

Make sure you have `measurements.txt` in the current folder, and then execute `./run.sh 1brc_parallel 32 24` to run the implementation with the specific threads (32) and buffer division (24).

> If your machine is different from mine (see results below), send me your results.

## Results

### M1 CPU, 8 cores, 8GB RAM with macOS

> Running while plugged into power

The following results produced by the following command:

```sh
hyperfine --warmup 1 --runs 3 --export-markdown tmp.md --prepare 'sleep 20'  -L name parallel,parallel_ptr -L N 12,16,24,32,48 -L D 4,8,16,24,32 './run.sh 1brc_{name} {N} {D}' 
```

| Command                      | _N_    | _D_    |          Mean [s] |   Min [s] |   Max [s] |    Relative |
| :--------------------------- | ------ | ------ | ----------------: | --------: | --------: | ----------: |
| `./run.sh 1brc_parallel`     | 12     | 4      |    33.969 ± 3.912 |    30.774 |    38.331 | 4.53 ± 0.52 |
| `./run.sh 1brc_parallel_ptr` | 12     | 4      |    27.581 ± 0.389 |    27.164 |    27.935 | 3.67 ± 0.06 |
| `./run.sh 1brc_parallel`     | 16     | 4      |    40.674 ± 1.127 |    39.623 |    41.863 | 5.42 ± 0.16 |
| `./run.sh 1brc_parallel_ptr` | 16     | 4      |    40.005 ± 0.689 |    39.264 |    40.628 | 5.33 ± 0.10 |
| `./run.sh 1brc_parallel`     | 24     | 4      |    39.725 ± 3.691 |    35.719 |    42.987 | 5.29 ± 0.49 |
| `./run.sh 1brc_parallel_ptr` | 24     | 4      |    42.835 ± 1.108 |    41.607 |    43.760 | 5.71 ± 0.15 |
| `./run.sh 1brc_parallel`     | 32     | 4      |    31.792 ± 1.302 |    30.318 |    32.788 | 4.24 ± 0.18 |
| `./run.sh 1brc_parallel_ptr` | 32     | 4      |    31.495 ± 1.041 |    30.852 |    32.696 | 4.20 ± 0.14 |
| `./run.sh 1brc_parallel`     | 48     | 4      |    31.848 ± 0.495 |    31.395 |    32.376 | 4.24 ± 0.07 |
| `./run.sh 1brc_parallel_ptr` | 48     | 4      |    32.700 ± 0.903 |    31.666 |    33.338 | 4.36 ± 0.13 |
| `./run.sh 1brc_parallel`     | 12     | 8      |    11.472 ± 0.208 |    11.244 |    11.653 | 1.53 ± 0.03 |
| `./run.sh 1brc_parallel_ptr` | 12     | 8      |    11.066 ± 0.438 |    10.562 |    11.362 | 1.47 ± 0.06 |
| `./run.sh 1brc_parallel`     | 16     | 8      |    10.499 ± 0.301 |    10.281 |    10.842 | 1.40 ± 0.04 |
| `./run.sh 1brc_parallel_ptr` | 16     | 8      |    10.253 ± 0.193 |    10.077 |    10.459 | 1.37 ± 0.03 |
| `./run.sh 1brc_parallel`     | 24     | 8      |    24.334 ± 2.722 |    21.876 |    27.260 | 3.24 ± 0.36 |
| `./run.sh 1brc_parallel_ptr` | 24     | 8      |    22.522 ± 0.853 |    21.540 |    23.077 | 3.00 ± 0.12 |
| `./run.sh 1brc_parallel`     | 32     | 8      |    36.026 ± 1.848 |    34.857 |    38.157 | 4.80 ± 0.25 |
| `./run.sh 1brc_parallel_ptr` | 32     | 8      |    34.556 ± 1.096 |    33.307 |    35.358 | 4.60 ± 0.15 |
| `./run.sh 1brc_parallel`     | 48     | 8      |    35.160 ± 2.109 |    33.885 |    37.595 | 4.68 ± 0.28 |
| `./run.sh 1brc_parallel_ptr` | 48     | 8      |    34.533 ± 0.805 |    33.652 |    35.231 | 4.60 ± 0.11 |
| `./run.sh 1brc_parallel`     | 12     | 16     |    14.699 ± 0.218 |    14.562 |    14.951 | 1.96 ± 0.03 |
| `./run.sh 1brc_parallel_ptr` | 12     | 16     |    13.607 ± 0.598 |    12.983 |    14.176 | 1.81 ± 0.08 |
| `./run.sh 1brc_parallel`     | 16     | 16     |    11.341 ± 0.438 |    10.854 |    11.705 | 1.51 ± 0.06 |
| `./run.sh 1brc_parallel_ptr` | 16     | 16     |    10.481 ± 0.313 |    10.122 |    10.694 | 1.40 ± 0.04 |
| `./run.sh 1brc_parallel`     | 24     | 16     |     9.105 ± 0.309 |     8.763 |     9.364 | 1.21 ± 0.04 |
| `./run.sh 1brc_parallel_ptr` | 24     | 16     |     8.776 ± 0.208 |     8.562 |     8.979 | 1.17 ± 0.03 |
| `./run.sh 1brc_parallel`     | 32     | 16     |     9.778 ± 0.151 |     9.633 |     9.934 | 1.30 ± 0.02 |
| `./run.sh 1brc_parallel_ptr` | 32     | 16     |     9.235 ± 0.260 |     8.963 |     9.482 | 1.23 ± 0.04 |
| `./run.sh 1brc_parallel`     | 48     | 16     |    16.772 ± 1.660 |    14.855 |    17.753 | 2.23 ± 0.22 |
| `./run.sh 1brc_parallel_ptr` | 48     | 16     |    17.504 ± 1.899 |    15.345 |    18.919 | 2.33 ± 0.25 |
| `./run.sh 1brc_parallel`     | 12     | 24     |    17.716 ± 0.353 |    17.411 |    18.102 | 2.36 ± 0.05 |
| `./run.sh 1brc_parallel_ptr` | 12     | 24     |    16.842 ± 0.215 |    16.643 |    17.070 | 2.24 ± 0.03 |
| `./run.sh 1brc_parallel`     | 16     | 24     |    13.127 ± 0.133 |    13.018 |    13.276 | 1.75 ± 0.02 |
| `./run.sh 1brc_parallel_ptr` | 16     | 24     |    12.423 ± 0.339 |    12.032 |    12.646 | 1.65 ± 0.05 |
| `./run.sh 1brc_parallel`     | 24     | 24     |     9.369 ± 0.058 |     9.310 |     9.424 | 1.25 ± 0.01 |
| `./run.sh 1brc_parallel_ptr` | 24     | 24     |     8.404 ± 0.260 |     8.106 |     8.579 | 1.12 ± 0.04 |
| `./run.sh 1brc_parallel`     | 32     | 24     |     8.273 ± 0.336 |     7.889 |     8.516 | 1.10 ± 0.05 |
| `./run.sh 1brc_parallel_ptr` | 32     | 24     |     8.038 ± 0.417 |     7.558 |     8.313 | 1.07 ± 0.06 |
| `./run.sh 1brc_parallel`     | 48     | 24     |     9.632 ± 0.113 |     9.566 |     9.762 | 1.28 ± 0.02 |
| `./run.sh 1brc_parallel_ptr` | 48     | 24     |     9.180 ± 0.462 |     8.891 |     9.713 | 1.22 ± 0.06 |
| `./run.sh 1brc_parallel`     | 12     | 32     |    20.036 ± 0.585 |    19.676 |    20.711 | 2.67 ± 0.08 |
| `./run.sh 1brc_parallel_ptr` | 12     | 32     |    19.305 ± 0.787 |    18.405 |    19.864 | 2.57 ± 0.11 |
| `./run.sh 1brc_parallel`     | 16     | 32     |    14.724 ± 0.357 |    14.362 |    15.076 | 1.96 ± 0.05 |
| `./run.sh 1brc_parallel_ptr` | 16     | 32     |    13.966 ± 0.292 |    13.684 |    14.268 | 1.86 ± 0.04 |
| `./run.sh 1brc_parallel`     | 24     | 32     |     9.787 ± 0.133 |     9.704 |     9.940 | 1.30 ± 0.02 |
| `./run.sh 1brc_parallel_ptr` | 24     | 32     |     9.216 ± 0.117 |     9.085 |     9.313 | 1.23 ± 0.02 |
| `./run.sh 1brc_parallel`     | 32     | 32     |     8.127 ± 0.034 |     8.101 |     8.166 | 1.08 ± 0.01 |
| `./run.sh 1brc_parallel_ptr` | **32** | **32** | **7.507 ± 0.059** | **7.448** | **7.567** |    **1.00** |
| `./run.sh 1brc_parallel`     | 48     | 32     |     8.140 ± 0.141 |     7.982 |     8.254 | 1.08 ± 0.02 |
| `./run.sh 1brc_parallel_ptr` | 48     | 32     |     7.824 ± 0.247 |     7.545 |     8.016 | 1.04 ± 0.03 |
| `./run.sh 1brc_parallel`     | 48     | 48     |     7.798 ± 0.135 |     7.646 |     7.905 |        1.04 |
| `./run.sh 1brc_parallel_ptr` | 48     | 48     |     7.468 ± 0.252 |     7.226 |     7.728 |        1.02 |

> The last two results were run separately because I missed it in the original command and wanted to be sure.

### i7-9750H CPU | @ 2.60GHz, 6 cores HT, 16GB RAM with macOS

> Running whiled plugged into power

| Command                      |    _N_ |    _D_ |          Mean [s] |   Min [s] | Max [s]   | Relative    |
| :--------------------------- | -----: | -----: | ----------------: | --------: |
| `./run.sh 1brc_parallel_ptr` | **48** | **48** | **9.542 ± 0.268** | **9.321** | **9.840** | **1.00**    |
| `./run.sh 1brc_parallel_ptr` |     32 |     24 |     9.899 ± 0.379 |     9.547 | 10.301    | 1.04 ± 0.05 |
| `./run.sh 1brc_parallel`     |     32 |     24 |    11.571 ± 0.350 |    11.361 | 11.974    | 1.21 ± 0.05 |
| `./run.sh 1brc_parallel`     |     48 |     48 |    10.582 ± 0.039 |    10.554 | 10.626    | 1.11 ± 0.03 |

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
