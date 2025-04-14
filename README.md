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
├── open.sh
└── rmindex.sh
```
### open.sh
Automatically open the specified file. By default, a file is assumed to be named `file` with extension `xlsx` so that `open -n 1` opens the first file matching `downloads/*/downloads/file1.xlsx`. You can customize the prefix, extension, and default program using flags. For example, `open -n 2 -e csv -f table -p libreoffice` uses LibreOffice to open the first file matching `downloads/*/downloads/table2.csv`.
### rmindex.sh
Print and delete all the index files. That is, any file matching `downloads/*/index.txt*`.
