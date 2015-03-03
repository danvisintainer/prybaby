# Prybaby

## What is this?

I love Pry, but I've also found that I'm rather trigger-happy with using their breakpoints. It helps a lot to use them, but getting rid of them all in the end (especially if they are across multiple files) gets rather tedious.

I also wanted to try and make a Ruby gem of my own (my first one!), so I decided to make one that removes every instance of `binding.pry` from my code. And thus, Prybaby was born.

## Installation

Just run `gem install prybaby` to get it installed.

## Using it

In your terminal, just run `prybaby`. By default, it'll search your current working directory, including subdirectories, for Ruby source files and comment out any line containing `binding.pry` in it. It'll put the `#` in the right place even if your code is indented, but your tabs must be made of spaces - this doesn't yet work for `\t` tabs (it'll just place the `#` at the start of the line). You can undo this by running Prybaby with `-u`, which will uncomment the commented-out lines (Prybaby will only uncomment a line with `binding.pry` in it).

Invoking `-r` will search for any instances of `binding.pry` and remove them. Note that **it will remove the entire line** that a pry breakpoint is found on, even if the breakpoint instruction is inside a comment. 

You can invoke `-h` for a quick rundown of the options.

Prybaby will only do its work on Ruby source files (ending in `.rb`). It'll scan your source files line-by-line, and it'll copy your code into a temporary file named `prybaby_temp` as it scans. Your original code file isn't replaced by the temporary one until Prybaby has finished scanning the current file.

## Todo

- add a verbose mode
- add scanning for `.erb` files as well, maybe
- refactor the code in #comment_out_breakpoints
- comment aligning in breakpoints only works when tabs are spaces
- better the code so it's more in line with the Ruby style guide
- add proper Rake tests