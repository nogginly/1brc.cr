# Compare different

| command                             | mean               | stddev               |
| ----------------------------------- | ------------------ | -------------------- |
| ./calculate_average_merykittyunsafe | 1.3731531913399997 | 0.04445930820906459  |
| ./calculate_average_merykitty       | 1.5263957833400001 | 0.034382946135534866 |
| dannyvankooten/analyze              | 1.28599224174      | 0.01613285976790795  |
| **1brc_parallel_mmap2b 64 8**       | ** 2.28868977854** | 0.024446179192799067 |
| 1brc_parallel_mmap2b 32 4           | 2.3561572355399996 | 0.027036956269126788 |
| 1brc_parallel_mmap2b 16 2           | 2.5898512893400003 | 0.012356261466824503 |
| serkan-ozal                         | 1.06250354374      | 0.0816364288869122   |

## Results

See [this CSV](/perfdata/compare1brc.csv) for details.

```txt
  serkan-ozal ran
    1.21 ± 0.09 times faster than dannyvankooten/analyze
    1.29 ± 0.11 times faster than merykittyunsafe
    1.44 ± 0.12 times faster than merykitty
    2.15 ± 0.17 times faster than 1brc_parallel_mmap2b 64 8
    2.22 ± 0.17 times faster than 1brc_parallel_mmap2b 32 4
    2.44 ± 0.19 times faster than 1brc_parallel_mmap2b 16 2
```
