# CAP Utils
## Installation
Run
```bash
git clone https://github.com/jcvillaquira/cap-utils.git ~/dev/utils
```
and then add to your `.bashrc` file the following
```bash
for fl in ~/dev/utils/*.sh; do
    chmod +x $fl
    filename=$(basename $fl)
    alias "${filename%.*}"=$fl
done
```
## Functions
```bash
utils/
├── getname.sh
├── comment.sh
├── cparser.sh
├── updatedm.sh
├── getlast.sh
├── open.sh
├── wparser.sh
└── rmindex.sh
```
### getname.sh
Copy the name of the current automation to clipboard.
### getlast.sh
Get the path of the last file opened with the funtion `open`. Deprecated. Use `open [-options] -c` instead.
### open.sh
Open the specified file. By default, opens the first file matching `downloads/*/downloads/*.*`. If a number is specified with the flag `-n N` it searches for `downloads/*/downloads/{file,table}N.*`. The prefix and the default program can be customized using flags. For example, `open -n 2 -f table -p libreoffice` uses LibreOffice to open the first file matching `downloads/*/downloads/table2.*`. Passing the `-c` flag does not open the file but copies its path to clipboard.
### rmindex.sh
Print and delete all the index files. That is, any file matching `downloads/*/index.txt*`.
### updatedm.sh
Get the download mapping options.json from BPA.
### wparser.sh
Monitor whether the `parser.py` file has been modified, and automatically run `cap run -p` after each save. You can pass options to grep using the `-g` flag. For example, `wparser -g Saved` will display lines containing the word Saved along with the line preceding them.
### comment.sh
`comment.sh` is a utility script that comments or uncomments all `nch.js` files located under the `downloads/` directory, except for the first one found (based on alphabetical order).
To use it, run `./comment.sh -c` to comment the files, or `./comment.sh -u` to reverse the operation.
### cparser.sh
`cparser.sh` is a utility script that comments (`-c`) all classes decorated with `@parser.source` in the `parser.py` file, including their full body; it also supports skipping the first N matches with `-n`.
