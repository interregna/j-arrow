# J language addon for Apache Arrow
Read (and eventually write) Apache Arrow and Parquet files to and from J.
Uses C API.
## Usage
```j
   install 'github:interregna/JArrow@main'

   load 'data/arrow'
   readParquetTable '~addons/data/arrow/test/test1.parquet'
┌─┬───────────────┐
│a│0 1 2 3 4 5 6 7│
├─┼───────────────┤
│b│8 7 6 5 4 3 2 1│
└─┴───────────────┘
   readsParquetTable '~addons/data/arrow/test/test2.parquet'
┌────────┬──────────┬────────┬─────────┬───────┬────────┬───────┬───────┬────────┬────────┬────────┬──────────┬──────────┬───────────┬────────────┬─────────┬─────────┬───────┬───────────────┐
│Column 1│Column Two│shortCol│ushortCol│intcCol│uintcCol│int_Col│uintCol│int16Col│int32Col│int64Col│float32Col│float64Col│longlongCol│ulonglongCol│DoubleCol│StringCol│boolCol│datetime64Col  │
├────────┼──────────┼────────┼─────────┼───────┼────────┼───────┼───────┼────────┼────────┼────────┼──────────┼──────────┼───────────┼────────────┼─────────┼─────────┼───────┼───────────────┤
│0       │  100     │0       │0        │0      │100     │100    │100    │300     │500     │100     │   600    │   700    │100        │100         │  100    │This     │1      │946684800000000│
│1       │88.75     │1       │1        │1      │ 88     │ 90    │ 88    │263     │443     │ 88     │531.25    │613.75    │ 88        │ 88         │88.75    │ is      │0      │946771200000000│
│2       │ 77.5     │2       │2        │2      │ 77     │ 80    │ 77    │227     │387     │ 77     │ 462.5    │ 527.5    │ 77        │ 77         │ 77.5    │all      │0      │946857600000000│
│3       │66.25     │3       │3        │3      │ 66     │ 70    │ 66    │191     │331     │ 66     │393.75    │441.25    │ 66        │ 66         │66.25    │ valid   │0      │946944000000000│
│4       │   55     │4       │4        │4      │ 55     │ 60    │ 55    │155     │275     │ 55     │   325    │   355    │ 55        │ 55         │   55    │text     │1      │947030400000000│
│5       │43.75     │5       │5        │5      │ 43     │ 50    │ 43    │118     │218     │ 43     │256.25    │268.75    │ 43        │ 43         │43.75    │         │0      │947116800000000│
│6       │ 32.5     │6       │6        │6      │ 32     │ 40    │ 32    │ 82     │162     │ 32     │ 187.5    │ 182.5    │ 32        │ 32         │ 32.5    │data.    │0      │947203200000000│
│7       │21.25     │7       │7        │7      │ 21     │ 30    │ 21    │ 46     │106     │ 21     │118.75    │ 96.25    │ 21        │ 21         │21.25    │         │0      │947289600000000│
└────────┴──────────┴────────┴─────────┴───────┴────────┴───────┴───────┴────────┴────────┴────────┴──────────┴──────────┴───────────┴────────────┴─────────┴─────────┴───────┴───────────────┘
   
```
`datetime64` is compatible with `(6!:16)` and `(6!:17)` to convert to and from ISO 8601 format (e.g. 2000-01-11T22:58:04).
`date32` is compatible with `fromdate32` to convert from 

## Installation
Ensure that you have [installed the appropriate libraries for your OS](https://arrow.apache.org/install/).

From your J session:
```j
   install 'github:interregna/JArrow@main'
```

## Development
1) In Jqt, set your path for JPackageDev
   File > Configure > Folders
   `JPackageDev /code/JPackageDev`
   (or the path of your choice in, then modify build.ijs)

2) Clone the JArrow repo in JPackageDev

3) Restart Jqt and open the Arrow project
   Project > Open > JPackageDev > arrow

4) Re-build the addon.
   Ctrl + F9

5) Run the addon.
   F9 (Re-build addon scripts, reload and run tests)

Examples:
see `test/test1.ijs`

##### TODO
* [ ] NULL handling for null values within arrays
* [ ] Tensors
* [ ] Document functions (see: ~/addons/gui/cobrowser/scriptdoc.ijs)
* [ ] Error catch missing files (empty pointers)
* [ ] IPC fixed length
* [ ] IPC streaming
* [ ] JSONL reader demo
* [x] readArray full length (50x read speedup)
* [x] Finish shims for array reading
* [x] CSV reader demo
* [ ] Flight server
* [x] Flight client demo
* [ ] Read web-based reader for parquet, arrow, and IPC


##### Notes

`readsTable` minimizes display time in the UI but uses more space
`readTable`  minimizes space but can take more time to display
