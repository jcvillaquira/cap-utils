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
├── updatedm.sh
├── getlast.sh
├── open.sh
└── rmindex.sh
```
### getname.sh
Copy the name of the current automation to clipboard.
### getlast.sh
Get the path of the last file opened with the funtion `open`.
### open.sh
Automatically open the specified file. By default, a file is assumed to be named `file` so that `open -n 1` opens the first file matching `downloads/*/downloads/file1.*`. You can customize the prefix and default program using flags. For example, `open -n 2 -f table -p libreoffice` uses LibreOffice to open the first file matching `downloads/*/downloads/table2.*`.
### rmindex.sh
Print and delete all the index files. That is, any file matching `downloads/*/index.txt*`.
### updatedm.sh
Get the download mapping options.json from BPA.
### comment.sh
`comment.sh` is a utility script that comments or uncomments all `nch.js` files located under the `downloads/` directory, except for the first one found (based on alphabetical order).
To use it, run `./comment.sh -c` to comment the files, or `./comment.sh -u` to reverse the operation.
