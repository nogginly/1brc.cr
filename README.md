# One Billion Row Challenge (1brc) using Crystal

## Motivation

While Gunnar Morling originally posed [The One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/) for Java developers, over time folks have started implementing it in different languages which are [showcased here](https://github.com/gunnarmorling/1brc/discussions/categories/show-and-tell).

While reviewing the results in Java I ran across [one implementation in C](https://github.com/gunnarmorling/1brc/discussions/46) that made me wonder what I could do with Crystal.

## Dependencies

None. Plain ol' Crystal.

## Build, with `ops`

First [install `crops`](https://github.com/nickthecook/crops) and then

* `ops up`
* `ops cbr 1brc_bypar3 -Dpreview_mt`

## Build, with `shards`

* `shards build --release  -Dpreview_mt`

## Run

Setup the concurrency as follows:

* `export CRYSTAL_WORKERS=32`
* `export BUF_DIV_DENOM=24`

With your measurements file, run

* `time bin/1brc_bypar3 measurements.txt out/1brc_bypar3.txt`

If you have a `N` cores, then try `6 * N` workers. Try different combinations until you get a config that seems optimal for your machine.

> If your machine is different from mine (see results below), send me your results.

## My Results

### i7-9750H CPU | @ 2.60GHz, 6 cores HT, 16GB RAM with macOS

#### Trials

These trials were used to select the concurrency / buffer division configuration to benchmark.

| Threads | Buf Denom. | Performance |               |              |                   | Peak memory  |
| ------- | ---------- | ----------- | ------------- | ------------ | ----------------- | ------------ |
| 16      | 8          | 66.89s user | 9.11s system  | 593% cpu     | *12.802 total*    | 3.966 GB     |
| 16      | 10         | 67.15s user | 7.94s system  | 672% cpu     | *11.161 total*    | 3.174 GB     |
| 16      | 12         | 62.33s user | 6.75s system  | 553% cpu     | *12.479 total*    | 2.647 GB     |
| 16      | 14         | 58.79s user | 6.14s system  | 503% cpu     | *12.901 total*    | 2.295 GB     |
| 24      | 12         | 79.81s user | 9.40s system  | 802% cpu     | *11.110 total*    | 3.968 GB     |
| 24      | 16         | 72.38s user | 8.41s system  | 768% cpu     | *10.512 total*    | 3.008 GB     |
| 24      | 18         | 67.34s user | 7.76s system  | 714% cpu     | *10.505 total*    | 2.673 GB     |
| 32      | 16         | 79.99s user | 11.17s system | 886% cpu     | *10.285 total*    | 4.008 GB     |
| **32**  | **24**     | 80.48s user | 9.66s system  | **939% cpu** | ***9.592 total*** | **2.669 GB** |
| 32      | 32         | 70.99s user | 7.59s system  | 831% cpu     | *9.454 total*     | 2.014 GB     |

#### Benchmark

Using 32 threads (workers) and `Int32::MAX / 24` buffer size per part ...

```txt
hyperfine --warmup 1 --min-runs 3 'bin/1brc_bypar3 ~/Downloads/1brc/measurements-1b.txt out_1brc_bypar3.txt'
Benchmark 1: bin/1brc_bypar3 ~/Downloads/1brc/measurements-1b.txt out_1brc_bypar3.txt
  Time (mean ± σ):     10.692 s ±  0.293 s    [User: 85.036 s, System: 10.085 s]
  Range (min … max):   10.382 s … 10.965 s    3 runs
```

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

This shard is available as open source under the terms of the [CC-BY-4.0](./LICENSE) license.

## Contributors

* [nogginly](https://github.com/nogginly) - creator and maintainer
