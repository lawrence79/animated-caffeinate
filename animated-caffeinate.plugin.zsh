# animated-caffeinate — a little animated coffee cup while caffeinate keeps your Mac awake.
#
# Commands:
#   coffee [flags]      run caffeinate with an animated cup (default flags: -dis)
#
# Settings (set these BEFORE the plugin loads, e.g. above `source $ZSH/oh-my-zsh.sh`):
#   zstyle ':animated-caffeinate' override yes      # make plain `caffeinate` animate too
#   zstyle ':animated-caffeinate' default-flags -di # flags `coffee` uses when given none
#   zstyle ':animated-caffeinate' interval 0.4      # seconds per frame
#   zstyle ':animated-caffeinate' steam-color 33    # ANSI colour code for the steam

[[ $OSTYPE == darwin* ]] || return 0

_animated_caffeinate() {
  emulate -L zsh
  setopt localtraps

  # Pass straight through when a utility command is given (`caffeinate -i make`),
  # when output isn't a terminal, or when the terminal is too short to draw in.
  local a skip=0
  for a in "$@"; do
    if (( skip )); then skip=0; continue; fi
    if [[ $a == -* ]]; then
      [[ $a == -*[tw] ]] && skip=1   # -t <secs> and -w <pid> take a value
    else
      command caffeinate "$@"; return
    fi
  done
  if [[ ! -t 1 ]] || (( LINES < 8 )); then
    command caffeinate "$@"; return
  fi

  local interval color
  zstyle -s ':animated-caffeinate' interval interval || interval=0.4
  zstyle -s ':animated-caffeinate' steam-color color || color=33

  command caffeinate "$@" &!
  local pid=$! start=$SECONDS i=0 stop=0 s
  local -a steam=('   (  )  (   ' '    )  (  )  ' '   (  )  )    ' '    ) (  (   ')

  trap 'stop=1' INT TERM
  tput civis
  while (( ! stop )) && kill -0 $pid 2>/dev/null; do
    s=$(( SECONDS - start ))
    printf '\e[%sm%s\e[0m\n\e[%sm%s\e[0m\n' \
      $color "${steam[i%4+1]}" $color "${steam[(i+1)%4+1]}"
    printf '  .--------.\n  |~~~~~~~~|]\n  \\        /\n   `------`\n'
    printf '  awake %02d:%02d:%02d  (^C to stop)\e[K\n' $((s/3600)) $((s%3600/60)) $((s%60))
    sleep $interval
    (( stop )) || printf '\e[7A'   # move back up over the 7 lines just drawn
    (( i++ ))
  done

  kill $pid 2>/dev/null
  tput cnorm
  s=$(( SECONDS - start ))
  printf '\n☕ done — awake %02d:%02d:%02d\n' $((s/3600)) $((s%3600/60)) $((s%60))
}

coffee() {
  local -a flags
  if (( $# )); then
    flags=("$@")
  else
    zstyle -a ':animated-caffeinate' default-flags flags || flags=(-dis)
  fi
  _animated_caffeinate "${flags[@]}"
}

if zstyle -t ':animated-caffeinate' override; then
  caffeinate() { _animated_caffeinate "$@" }
fi
