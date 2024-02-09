# One Billion Row Challenge (1brc) using Crystal

## Motivation

While Gunnar Morling originally posed [The One Billion Row Challenge](https://www.morling.dev/blog/one-billion-row-challenge/) for Java developers, over time folks have started implementing it in different languages which are [showcased here](https://github.com/gunnarmorling/1brc/discussions/categories/show-and-tell).

While reviewing the results in Java I ran across [one implementation in C](https://github.com/gunnarmorling/1brc/discussions/46) that made me wonder what I could do with Crystal.

> See discussion in Crystal forum [here](https://forum.crystal-lang.org/t/1brc-in-crystal/6467). This led me to create [TODO](/TODO.md) list of things to try.
>
> See post in Gunnar's "Show & Tell" discussion area [here](https://github.com/gunnarmorling/1brc/discussions/711)

## Overall performance (so far)

> TODO: results not yet updated with `b` variants which are fastest now. Coming soon.

On a PC with AMD Ryzen 7 7735HS CPU, 16 cores, 32 GB, and running Linux, comparing with some other `1brc` contenders there's still room to do. See the [TODO](/TODO.md) list for changes so far and possible further improvements.

| command                          | Lang        | mean                  | stddev               |
| -------------------------------- | ----------- | --------------------- |
| `merykittyunsafe`                | Java        | 1.3731531913399997    | 0.04445930820906459  |
| `merykitty`                      | Java        | 1.5263957833400001    | 0.034382946135534866 |
| `dannyvankooten/analyze`         | C           | 1.28599224174         | 0.01613285976790795  |
| **`1brc_parallel_mmap2b` 16 48** | **Crystal** | **2.086254866033333** | 0.010981046860831643 |
| `serkan-ozal`                    | Java        | 1.06250354374         | 0.0816364288869122   |

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

| Implementation        | Description                                                                                      | Performance                      |
| --------------------- | ------------------------------------------------------------------------------------------------ | -------------------------------- |
| `1brc_serial1`        | A very simple serial implementation using `String` lines                                         | slowest.                         |
| `1brc_serial2`        | Serial implementation optimized to use byte slices (`Bytes`)                                     | a little faster, but still slow. |
| `1brc_parallel`       | Parallel multi-threaded implementation that chunks up the file and spawns fibres to process them | much faster                      |
| `1brc_parallel2`      | Variant using page-aligned part size in anticipation of `mmap`-based implementation.             | faster                           |
| `1brc_parallel_ptr`   | Replaces `Slice` with `Pointer` to the buffer, to remove bounds checking when parsing.           | faster                           |
| `1brc_parallel_ptr2`  | Variant using page-aligned part size in anticipation of `mmap`-based implementation.             | faster again                     |
| `1brc_parallel_ptr3`  | Variant of `ptr3` which only launched _N_ fibres and loops over _D / N_ chunks.                  | slightly faster but not always   |
| `1brc_parallel_mmap`  | Using `mmap` to load the file; this is fastest on Linux, but not so much on macOS.               | fastest so far (Linux)           |
| `1brc_parallel_mmap2` | Variant of `mmap` which only launched _N_ fibres and loops over _D / N_ chunks.                  | slightly faster but not always   |

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

- [ ] Re-do results now that we have additional variants with `mmap` use and an optimized (targeted) hashing function.

### i7-9750H CPU | @ 2.60GHz, 6 cores HT, 16GB RAM with macOS

> Running while plugged into power

Switching to use a 500M row file (half of the 1B row target) allowed the `mmap` version to perform as expected. The slowdown with the 1B row file was because this Mac has 16GB of RAM and the 1B row file was 13GB vs 6.5GB for the 500M row one. The latter avoided the performance impact (likely due to memory swapping when memory mapping 13GB) while being large enough to compare across the different implementations.

| command                             | _N_ | _D_ | mean               | stddev               |
| ----------------------------------- | --- | --- | ------------------ | -------------------- |
| `./run.sh 1brc_parallel_ptr2`       | 24  | 16  | 5.558918822380001  | 0.170067271820256    |
| `./run.sh 1brc_parallel_ptr2b`      | 24  | 16  | 3.9470529990466665 | 0.5510786821823522   |
| `./run.sh 1brc_parallel_ptr3`       | 24  | 16  | 4.683466047713334  | 0.21193570410203796  |
| `./run.sh 1brc_parallel_ptr3b`      | 24  | 16  | 3.393969176713334  | 0.14363023887130558  |
| `./run.sh 1brc_parallel_mmap2`      | 24  | 16  | 4.2296142580466665 | 0.08368848325957651  |
| `./run.sh 1brc_parallel_mmap2b`     | 24  | 16  | 3.0336407297133334 | 0.03818391214985246  |
| `./run.sh 1brc_parallel_ptr2`       | 32  | 24  | 4.4981794123266665 | 0.0858118631465522   |
| `./run.sh 1brc_parallel_ptr2b`      | 32  | 24  | 3.3329625026600005 | 0.10266644355281297  |
| `./run.sh 1brc_parallel_ptr3`       | 32  | 24  | 4.0748595059933335 | 0.0665015884770029   |
| `./run.sh 1brc_parallel_ptr3b`      | 32  | 24  | 3.1637588746599996 | 0.1182784395928098   |
| `./run.sh 1brc_parallel_mmap2`      | 32  | 24  | 3.8826917923266664 | 0.022379442294207894 |
| **`./run.sh 1brc_parallel_mmap2b`** | 32  | 24  | **2.84953530266**  | 0.060889703801659714 |

The following summary shows the improvement in performance, will all the `b` variants at the top:

```txt
Summary
  ./run.sh 1brc_parallel_mmap2b 32 24 ran
    1.11 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr3b 32 24
    1.17 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr2b 32 24
    1.36 ± 0.03 times faster than ./run.sh 1brc_parallel_mmap2 32 24
    1.43 ± 0.04 times faster than ./run.sh 1brc_parallel_ptr3 32 24
    1.58 ± 0.05 times faster than ./run.sh 1brc_parallel_ptr2 32 24
```


## Contributing

Bug reports and sugestions are welcome.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://www.contributor-covenant.org/version/1/4/code-of-conduct/).

## License

This project is available as open source under the terms of the [CC-BY-4.0](./LICENSE) license.

## Contributors

* [nogginly](https://github.com/nogginly) - creator and maintainer
