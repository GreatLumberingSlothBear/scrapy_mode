# scrapy_mode
Scrapy mode is an emacs minor mode for interfacing with the scrapy python library. Provides keybindings to execute common shell commands with the scrapy CLI to speed up scrapy workflow in your editor. It is mostly for personal use and is unfinished but I may add more features to it eventually. This mode is for development and testing of spiders and is not intended for running spiders in production.

## Installation
In your init file:
(add-to-path 'load-path "/path/to/scrapy_mode.el")

(require 'scrapy-mode)

## Usage
M-x scrapy-mode turns on scrapy minor mode in current buffer and all new python buffers.

Use M-x customize and look up scrapy to make changes to the scrapy group configuration variables. You will need to set pyvenv-path if scrapy is installed in a virtual environment. You will also need to set spider-output-path to the location of an output file for spider crawl data and set new-spider-module-path to the directory you want newly generated spiders to appear in.

C-c . c crawls the spider in the current buffer and opens the output in a new buffer.
C-c . s opens a scrapy shell using the url at point.
C-c . g generates a new spider from a selected template and opens the new spider file in a new buffer.
C-c . v downloads the response from the url at point with the scrapy downloader and opens the result in your web browser.
C-c . e lets you edit the selected spider from the list of all spiders in your project.
NOTE: It is highly recommended you set your $EDITOR environment variable in your shell to emacsclient and start the emacs server for the best experience.
C-c . l lists all available spiders in the project.
C-c . r runs the spider file in the buffer as a stand-alone spider outside of a scrapy project and opens the output in a new buffer.
C-c . p starts a new scrapy project at the selected directory.

## TODO

### EZ
- Create functions for remaining CLI commands that don't have one yet
- Clickable menu bar items that run the functions in scrapy-mode
- Run scrapy view and scrapy shell with a special click in addition to keybindings
- File picker to customize pathing instead of string input
- Error handling

### Harder
- Get spider names by loading the file in python and getting the name attribute out of the spider class instead of grepping them, need a good way to interface between emacs and python processes
- Get the pathing out of settings.py instead of custom set variables
