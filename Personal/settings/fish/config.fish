### EXPORT ###
set fish_greeting          # Suppresses fish's intro message
set TERM "xterm-256color"  # Sets the terminal type for proper colors
#set fish_escape_delay_ms 500

if status is-interactive
    # Commands to run in interactive sessions can go here
end
if status --is-login
    set -gx PATH $PATH ~/.bin
end

### COLORS ###
if type -t set_colors > /dev/null 2>&1
    ### load colors from flavours
    set_colors
else
    # Base16 Gruvbox dark, medium defaults
    set fish_color_autosuggestion "#665c54"
    set fish_color_cancel -r
    set fish_color_command "#83a598"
    set fish_color_comment "#504945"
    set fish_color_cwd green
    set fish_color_cwd_root red
    set fish_color_end "#8ec07c"
    set fish_color_error "#fb4934"
    set fish_color_escape "#fe8019"
    set fish_color_history_current --bold
    set fish_color_host normal
    set fish_color_host_remote yellow
    set fish_color_match --background=brblue
    set fish_color_normal normal
    set fish_color_operator "#fe8019"
    set fish_color_param "#ebdbb2"
    set fish_color_quote "#b8bb26"
    set fish_color_redirection "#d3869b"
    set fish_color_search_match bryellow --background=brblack
    set fish_color_selection white --bold --background=brblack
    set fish_color_status red
    set fish_color_user brgreen
    set fish_color_valid_path --underline
    set fish_pager_color_completion normal
    set fish_pager_color_description "#8ec07c" yellow
    set fish_pager_color_prefix white --bold --underline
    set fish_pager_color_progress brwhite --background=cyan
end
### END OF COLORS ###

### FUNCTIONS ###
# recently installed packages
function rip --argument length -d "List the last n (100) packages installed"
    if test -z $length
        set length 100
    end
    expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n $length | nl
end


### ALIASES ###
# colorize grep output (good for log files)
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'

alias xls 'exa -a --icons --color=always --group-directories-first'
alias xll 'exa -lag --icons --color=always --group-directories-first --octal-permissions'

alias tofish 'sudo chsh $USER -s /bin/fish && echo "Now log out."'
alias tobash 'sudo chsh $USER -s /bin/bash && echo "Now log out."'
alias tozsh 'sudo chsh $USER -s /bin/zsh && echo "Now log out."'

alias clean 'clear; seq 1 (tput cols) | sort -R | sparklines | lolcat'

# merge new settings in Xresources
alias merge "xrdb -merge ~/.Xresources"

# generate a new grub.cfg
alias update-grub "sudo grub-mkconfig -o /boot/grub/grub.cfg"

#starship init fish | source