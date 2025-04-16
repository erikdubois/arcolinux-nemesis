###
# https://fishshell.com/docs/current/index.html
# https://github.com/jorgebucaran/cookbook.fish

# themes
# https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md

# Plugins
# https://github.com/jethrokuan/fzf
# https://github.com/IlanCosman/tide.git - fisher install IlanCosman/tide@v5
# https://github.com/jhillyerd/plugin-git

# tools
# https://github.com/jorgebucaran/fisher
# https://github.com/oh-my-fish/oh-my-fish
# https://github.com/danhper/fundle

#set VIRTUAL_ENV_DISABLE_PROMPT "1"

if not status --is-interactive
  exit
end

# Load private config
if [ -f $HOME/.config/fish/private.fish ]
    source $HOME/.config/fish/private.fish
end

# Git
if [ -f $HOME/.config/fish/git.fish ]
    source $HOME/.config/fish/git.fish
end

# Aliases
if [ -f $HOME/.config/fish/alias.fish ]
    source $HOME/.config/fish/alias.fish
end

# reload fish config
function reload
    exec fish
    set -l config (status -f)
    echo "reloading: $config"
end

# User paths
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/Applications $fish_user_paths

# Starship prompt
#if command -sq starship
#    starship init fish | source
#end

# sets tools
set -x EDITOR nano
set -x VISUAL nano
#set -x TERM alacritty
# Sets the terminal type for proper colors
set TERM "xterm-256color"

# Suppresses fish's intro message
set fish_greeting
#function fish_greeting
#    fish_logo
#end

# Prevent directories names from being shortened
set fish_prompt_pwd_dir_length 0
set -x FZF_DEFAULT_OPTS "--color=16,header:13,info:5,pointer:3,marker:9,spinner:1,prompt:5,fg:7,hl:14,fg+:3,hl+:9 --inline-info --tiebreak=end,length --bind=shift-tab:toggle-down,tab:toggle-up"
# "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | batcat -l man -p'"
set -x MANROFFOPT "-c"
set -g theme_nerd_fonts yes


if status --is-login
    set -gx PATH $PATH ~/.bin
end

if status --is-login
    set -gx PATH $PATH ~/.local/bin
end

if type -q batcat
    alias cat="batcat --paging=never"
end

if command -sq fzf && type -q fzf_configure_bindings
  fzf_configure_bindings --directory=\ct
end

if not set -q -g fish_user_abbreviations
  set -gx fish_user_abbreviations
end

#if type -f fortune >/dev/null
#  set -l fortune "fortune -a"
#  if type -f lolcat >/dev/null
#    set fortune "$fortune | lolcat"
#  end
#  eval $fortune
#  echo
#end

if test tree >/dev/null
    function l1;  tree --dirsfirst -ChFL 1 $argv; end
    function l2;  tree --dirsfirst -ChFL 2 $argv; end
    function l3;  tree --dirsfirst -ChFL 3 $argv; end
    function ll1; tree --dirsfirst -ChFupDaL 1 $argv; end
    function ll2; tree --dirsfirst -ChFupDaL 2 $argv; end
    function ll3; tree --dirsfirst -ChFupDaL 3 $argv; end
end

if type -q direnv
    eval (direnv hook fish)
end



### FUNCTIONS ###
# Fish command history
function history
    builtin history --show-time='%F %T ' | sort
end

# Make a backup file
function backup --argument filename
    cp $filename $filename.bak
end

# recently installed packages
function ripp --argument length -d "List the last n (100) packages installed"
    if test -z $length
        set length 100
    end
    expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n $length | nl
end

function gl
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $argv | fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` --bind "ctrl-m:execute: echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always % | less -R'"
end

function ex --description "Extract bundled & compressed files"
    if test -f "$argv[1]"
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z $argv[1]
            case '*.deb'
                ar $argv[1]
            case '*.tar.xz'
                tar xf $argv[1]
            case '*.tar.zst'
                tar xf $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via ex"
        end
   else
       echo "'$argv[1]' is not a valid file"
   end
end

function less
    command less -R $argv
end

function cd
    builtin cd $argv; and ls
end

### ALIASES ###

#list
alias ls="ls --color=auto"
alias la="ls -a"
alias ll="ls -alFh"
alias l="ls"
alias l.="ls -A | egrep '^\.'"
alias listdir="ls -d */ > list"

#fix obvious typo's
alias cd..="cd .."
alias pdw="pwd"

## Colorize the grep command output for ease of use (good for log files)##
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

#readable output
alias df="df -h"

#free
alias free="free -mt"

#userlist
alias userlist="cut -d: -f1 /etc/passwd | sort"

#merge new settings
alias merge="xrdb -merge ~/.Xresources"

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#add new fonts
alias update-fc="sudo fc-cache -fv"

# hardware info --short
alias hw="hwinfo --short"

# neofetch --short
alias neo="neofetch"

#check vulnerabilities microcode
alias microcode="grep . /sys/devices/system/cpu/vulnerabilities/*"

#approximation of how old your hardware is
alias howold="sudo lshw | grep -B 3 -A 8 BIOS"

#check cpu
alias cpu="cpuid -i | grep uarch | head -n 1"

#search content with ripgrep
alias rg="rg --sort path"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

### EXPORT ###
export EDITOR=nano
export VISUAL=nano
export HISTCONTROL=ignoreboth:erasedups
export PAGER=most

alias update="sudo dnf upgrade -y"
alias probe="sudo -E hw-probe -all -upload"
alias nenvironment="sudo $EDITOR /etc/environment"
alias nfstab="sudo $EDITOR /etc/fstab"
alias nnsswitch="sudo $EDITOR /etc/nsswitch.conf"
alias nsamba="sudo $EDITOR /etc/samba/smb.conf"
alias nhosts="sudo $EDITOR /etc/hosts"
alias nb="$EDITOR ~/.bashrc"
alias nz="$EDITOR ~/.zshrc"
alias nf="$EDITOR ~/.config/fish/config.fish"
alias nfastfetch="$EDITOR ~/.config/fastfetch/config.jsonc"
alias nalacritty="nano /home/$USER/.config/alacritty/alacritty.toml"

#shutdown or reboot
alias ssn="sudo shutdown now"
alias sr="reboot"

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"
alias xdw="ls /usr/share/wayland-sessions"
alias ff="fastfetch"


set fish_color_autosuggestion "#969896"
set fish_color_cancel -r
set fish_color_command "#0782DE"
set fish_color_comment "#f0c674"
set fish_color_cwd "#008000"
set fish_color_cwd_root red
set fish_color_end "#b294bb"
set fish_color_error "#fb4934"
set fish_color_escape "#fe8019"
set fish_color_history_current --bold
set fish_color_host "#85AD82"
set fish_color_host_remote yellow
set fish_color_match --background=brblue
set fish_color_normal normal
set fish_color_operator "#fe8019"
set fish_color_param "#81a2be"
set fish_color_quote "#b8bb26"
set fish_color_redirection "#d3869b"
set fish_color_search_match bryellow background=brblack
set fish_color_selection white --bold background=brblack
set fish_color_status red
set fish_color_user brgreen
set fish_color_valid_path --underline
set fish_pager_color_completion normal
set fish_pager_color_description "#B3A06D" yellow
set fish_pager_color_prefix normal --bold underline
set fish_pager_color_prefix white --bold --underline
set fish_pager_color_progress brwhite --background=cyan
set fish_color_search_match --background="#60AEFF"

