# animated-caffeinate

A zsh plugin that shows an animated coffee cup while macOS `caffeinate` keeps your Mac awake.

```
    )  (  )
   (  )  )
  .--------.
  |~~~~~~~~|]
  \        /
   `------`
  awake 00:12:41  (^C to stop)
```

Press Ctrl-C to stop. The plugin then stops `caffeinate` and prints how long your Mac stayed awake.

The plugin works on macOS only. On other systems it does nothing.

## Install

### oh-my-zsh

1. Clone the repository into your custom plugins folder:

   ```sh
   git clone https://github.com/lawrence79/animated-caffeinate \
     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/animated-caffeinate
   ```

2. Add the plugin to the `plugins` list in `~/.zshrc`:

   ```sh
   plugins=(... animated-caffeinate)
   ```

3. Open a new terminal.

### antidote

```sh
antidote install lawrence79/animated-caffeinate
```

### zinit

```sh
zinit light lawrence79/animated-caffeinate
```

### Manual

```sh
git clone https://github.com/lawrence79/animated-caffeinate ~/.animated-caffeinate
echo 'source ~/.animated-caffeinate/animated-caffeinate.plugin.zsh' >> ~/.zshrc
```

## Usage

```sh
coffee            # same as: caffeinate -dis
coffee -i         # any caffeinate flags work
coffee -t 3600    # stops after one hour
```

The flags in `coffee` with no arguments mean:

| Flag | Effect |
|------|--------|
| `-d` | Keep the display awake. |
| `-i` | Stop the Mac from idle-sleeping. |
| `-s` | Stay awake on AC power, even with the lid closed. |

The cup does not appear in these cases. The plugin runs `caffeinate` without it:

- You give a command for `caffeinate` to run, as in `coffee -i make build`.
- The output goes to a pipe or a file.
- The terminal is shorter than 8 lines.

## Settings

Set these in `~/.zshrc` **before** the plugin loads. With oh-my-zsh, that means above the `source $ZSH/oh-my-zsh.sh` line.

```sh
# Make plain `caffeinate` show the cup too. Off by default.
zstyle ':animated-caffeinate' override yes

# Flags `coffee` uses when you give none. Default: -dis
zstyle ':animated-caffeinate' default-flags -di

# Seconds per animation frame. Default: 0.4
zstyle ':animated-caffeinate' interval 0.3

# ANSI colour code for the steam. Default: 33 (yellow)
zstyle ':animated-caffeinate' steam-color 36
```

## License

MIT
