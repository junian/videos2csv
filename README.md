# videos2csv

## Example Usage

```shell
$ ./videos2csv.sh ./test-projects
"Year","Month","Project Name","Filename","Modified Date","Path"
2024,03,Project B,"""the joker"".mkv",2024-09-19 15:53:50,"2403 Project B/""the joker"".mkv"
2024,03,Project B,def.m4v,2024-09-19 15:53:50,2403 Project B/def.m4v
2024,03,Project B,"this,is.Mp4",2024-09-19 15:53:50,"2403 Project B/this,is.Mp4"
2024,02,Project A,The Batman.MOV,2024-09-19 15:53:50,2402 Project A/batman/The Batman.MOV
2024,02,Project A,file.mov,2024-09-19 15:53:50,2402 Project A/subs/file.mov
2024,02,Project A,file.mp4,2024-09-19 15:53:50,2402 Project A/file.mp4
```

Or output as csv.

```shell
./videos2csv.sh ./test-projects > output.csv
```
