# scrapy_mode
Scrapy mode is an emacs minor mode for interfacing with the scrapy python library. Provides keybindings to execute common shell commands with the scrapy CLI to speed up scrapy workflow in your editor. It is mostly for personal use and is unfinished but I may add more features to it eventually.

## Installation
In your init file:
(add-to-path 'load-path "/path/to/scrapy_mode.el")
(require 'scrapy-mode)

## Usage
M-x scrapy-mode turns on scrapy minor mode in current buffer and all new python buffers.
C-c . c crawls the spider in the current buffer and opens the output in a new buffer.
C-c . s opens a scrapy shell using the url at point.
C-c . g generates a new spider from a selected template and opens the new spider file in a new buffer.
C-c . v downloads the response from the url at point with the scrapy downloader and opens the result in your web browser.
C-c . e lets you edit the selected spider from the list of all spiders in your project.
NOTE: It is highly recommended you set your $EDITOR environment variable in your shell to emacsclient and start the emacs server for the best experience.
C-c . l lists all available spiders in the project.
C-c . r runs the spider file in the buffer as a stand-alone spider outside of a scrapy project and opens the output in a new buffer.
C-c . p starts a new scrapy project at the selected directory.
