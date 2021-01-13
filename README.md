# Gleam language support in Kakoune 💫

### Features:

- 🎨 Syntax highlighting for Gleam source.
- 👔 Optionally run `gleam format` on save.

![highlighting demo](https://github.com/itsgreggreg/kakoune-gleam/blob/main/images/highlighting_demo.jpg?raw=true)

## Installation

For formatting to work you must have `gleam` installed on your computer.
Follow these instructions for installing `gleam`: https://gleam.run/getting-started/

To use these files in [kakoue](http://kakoune.org/) you can either:

- copy them or symlink them into your `autoload` directory
- source them in your `kakrc` like so:

```kak
source kakoune-gleam/gleam.kak
source kakoune-gleam/gleam-format.kak
```

### Gleam executable absolute path

`gleam-format.kak` tries to use a `gleam` executable installed system wide. If
you want to use a different path replace `gleam` with the path of your gleam
executable in `gleam-format.kak`

If you know `gleam` is installed but formatting is not working, try running
`which gleam` in the terminal and pasting the output of that command into
`Executable`.

### Contributions:

Are welcome and appreciated! Please fork this repository and open a pull request to make highlighter tweaks, etc.
