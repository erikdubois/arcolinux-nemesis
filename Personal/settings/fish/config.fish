### EXPORT ###
set fish_greeting          # Suppresses fish's intro message
set TERM "xterm-256color"  # Sets the terminal type for proper colors
#set fish_escape_delay_ms 500

set PS1 '[\u@\h \W]\$ '

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

export EDITOR='nano'
export VISUAL='nano'

### ALIASES ###

#list
alias ls 'ls --color=auto'
alias la 'ls -a'
alias ll 'ls -alFh'
alias l 'ls'
alias l. "ls -A | egrep '^\.'"

#fix obvious typo's
alias cd.. 'cd ..'
alias pdw 'pwd'
alias udpate 'sudo pacman -Syyu'
alias upate 'sudo pacman -Syyu'
alias updte 'sudo pacman -Syyu'
alias updqte 'sudo pacman -Syyu'
alias upqll 'paru -Syu --noconfirm'
alias upal 'paru -Syu --noconfirm'

# colorize grep output (good for log files)
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'

#readable output
alias df 'df -h'

#keyboard
alias give-me-azerty-be 'sudo localectl set-x11-keymap be'
alias give-me-qwerty-us 'sudo localectl set-x11-keymap us'

#pacman unlock
alias unlock 'sudo rm /var/lib/pacman/db.lck'
alias rmpacmanlock 'sudo rm /var/lib/pacman/db.lck'

#arcolinux logout unlock
alias rmlogoutlock 'sudo rm /tmp/arcologout.lock'

#which graphical card is working
alias whichvga '/usr/local/bin/arcolinux-which-vga'

#free
alias free 'free -mt'

#continue download
alias wget 'wget -c'

#userlist
alias userlist 'cut -d: -f1 /etc/passwd'

#merge new settings
alias merge 'xrdb -merge ~/.Xresources'

# Aliases for software managment
# pacman or pm
alias pacman 'sudo pacman --color auto'
alias update 'sudo pacman -Syyu'

# paru as aur helper - updates everything
alias pksyua 'paru -Syu --noconfirm'
alias upall 'paru -Syu --noconfirm'

#ps
alias psa 'ps auxf'
alias psgrep 'ps aux | grep -v grep | grep -i -e VSZ -e'

#grub update
alias update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

#add new fonts
alias update-fc 'sudo fc-cache -fv'

#copy/paste all content of /etc/skel over to home folder - backup of config created - beware
alias skel '[ -d ~/.config ] || mkdir ~/.config && cp -Rf ~/.config ~/.config-backup-(date +%Y.%m.%d-%H.%M.%S) && cp -rf /etc/skel/* ~'
#backup contents of /etc/skel to hidden backup folder in home/user
alias bupskel 'cp -Rf /etc/skel ~/.skel-backup-(date +%Y.%m.%d-%H.%M.%S)'

#copy bashrc-latest over on bashrc - cb= copy bashrc
alias cb 'sudo cp /etc/skel/.bashrc ~/.bashrc && source ~/.bashrc'
#copy /etc/skel/.zshrc over on ~/.zshrc - cb= copy zshrc
#alias cz 'sudo cp /etc/skel/.zshrc ~/.zshrc && exec zsh'

#switch between bash, zsh and fish
alias tobash 'sudo chsh $USER -s /bin/bash && echo "Now log out."'
alias tozsh 'sudo chsh $USER -s /bin/zsh && echo "Now log out."'
alias tofish 'sudo chsh $USER -s /bin/fish && echo "Now log out."'

#switch between lightdm and sddm
alias tolightdm 'sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm --needed ; sudo systemctl enable lightdm.service -f ; echo "Lightm is active - reboot now"'
alias tosddm 'sudo pacman -S sddm --noconfirm --needed ; sudo systemctl enable sddm.service -f ; echo "Sddm is active - reboot now"'
alias toly 'sudo pacman -S ly --noconfirm --needed ; sudo systemctl enable ly.service -f ; echo "Ly is active - reboot now"'
alias togdm 'sudo pacman -S gdm --noconfirm --needed ; sudo systemctl enable gdm.service -f ; echo "Gdm is active - reboot now"'
alias tolxdm 'sudo pacman -S lxdm --noconfirm --needed ; sudo systemctl enable lxdm.service -f ; echo "Lxdm is active - reboot now"'

# kill commands
# quickly kill conkies
alias kc 'killall conky'
# quickly kill polybar
alias kp 'killall polybar'

#hardware info --short
alias hw 'hwinfo --short'

#skip integrity check
alias paruskip 'paru -S --mflags --skipinteg'
alias yayskip 'yay -S --mflags --skipinteg'
alias trizenskip 'trizen -S --skipinteg'

#check vulnerabilities microcode
alias microcode 'grep . /sys/devices/system/cpu/vulnerabilities/*'

#get fastest mirrors in your neighborhood
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirrord 'sudo reflector --latest 30 --number 10 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors 'sudo reflector --latest 30 --number 10 --sort score --save /etc/pacman.d/mirrorlist'
alias mirrora 'sudo reflector --latest 30 --number 10 --sort age --save /etc/pacman.d/mirrorlist'
#our experimental - best option for the moment
alias mirrorx 'sudo reflector --age 6 --latest 20  --fastest 20 --threads 5 --sort rate --protocol https --save /etc/pacman.d/mirrorlist'
alias mirrorxx 'sudo reflector --age 6 --latest 20  --fastest 20 --threads 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist'
alias ram 'rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist'

#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm 'sudo /usr/local/bin/arcolinux-vbox-share'

#enabling vmware services
alias start-vmware 'sudo systemctl enable --now vmtoolsd.service'
alias sv 'sudo systemctl enable --now vmtoolsd.service'


alias xls 'exa -a --icons --color=always --group-directories-first'
alias xll 'exa -lag --icons --color=always --group-directories-first --octal-permissions'

#youtube download
alias yta-aac 'yt-dlp --extract-audio --audio-format aac '
alias yta-best 'yt-dlp --extract-audio --audio-format best '
alias yta-flac 'yt-dlp --extract-audio --audio-format flac '
alias yta-mp3 'yt-dlp --extract-audio --audio-format mp3 '
alias ytv-best 'yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 '

#Recent Installed Packages
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'
alias riplong 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -3000 | nl'

#iso and version used to install ArcoLinux
alias iso 'cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}''

#Cleanup orphaned packages
alias cleanup 'sudo pacman -Rns (pacman -Qtdq)'

#clear
alias clean 'clear; seq 1 (tput cols) | sort -R | sparklines | lolcat'

#search content with ripgrep
alias rg 'rg --sort path'

#get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

#nano for important configuration files
#know what you do in these files
alias nlxdm 'sudo $EDITOR /etc/lxdm/lxdm.conf'
alias nlightdm 'sudo $EDITOR /etc/lightdm/lightdm.conf'
alias npacman 'sudo $EDITOR /etc/pacman.conf'
alias ngrub 'sudo $EDITOR /etc/default/grub'
alias nconfgrub 'sudo $EDITOR /boot/grub/grub.cfg'
alias nmkinitcpio 'sudo $EDITOR /etc/mkinitcpio.conf'
alias nmirrorlist 'sudo $EDITOR /etc/pacman.d/mirrorlist'
alias narcomirrorlist 'sudo nano /etc/pacman.d/arcolinux-mirrorlist'
alias nsddm 'sudo $EDITOR /etc/sddm.conf'
alias nsddmk 'sudo $EDITOR /etc/sddm.conf.d/kde_settings.conf'
alias nfstab 'sudo $EDITOR /etc/fstab'
alias nnsswitch 'sudo $EDITOR /etc/nsswitch.conf'
alias nsamba 'sudo $EDITOR /etc/samba/smb.conf'
alias ngnupgconf 'sudo nano /etc/pacman.d/gnupg/gpg.conf'
alias nhosts 'sudo $EDITOR /etc/hosts'
alias nb '$EDITOR ~/.bashrc'
alias nz '$EDITOR ~/.zshrc'
alias nf '$EDITOR ~/.config/fish/config.fish'

#gpg
#verify signature for isos
alias gpg-check 'gpg2 --keyserver-options auto-key-retrieve --verify'
alias fix-gpg-check 'gpg2 --keyserver-options auto-key-retrieve --verify'
#receive the key of a developer
alias gpg-retrieve 'gpg2 --keyserver-options auto-key-retrieve --receive-keys'
alias fix-gpg-retrieve 'gpg2 --keyserver-options auto-key-retrieve --receive-keys'
alias fix-keyserver '[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo "done"'

#fixes
alias fix-permissions 'sudo chown -R $USER:$USER ~/.config ~/.local'
alias keyfix '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias key-fix '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias keys-fix '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias fixkey '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias fixkeys '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias fix-key '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias fix-keys '/usr/local/bin/arcolinux-fix-pacman-databases-and-keys'
alias fix-sddm-config '/usr/local/bin/arcolinux-fix-sddm-config'
alias fix-pacman-conf '/usr/local/bin/arcolinux-fix-pacman-conf'
alias fix-pacman-keyserver '/usr/local/bin/arcolinux-fix-pacman-gpg-conf'

#maintenance
alias big 'expac -H M '%m\t%n' | sort -h | nl'
alias downgrada 'sudo downgrade --ala-url https://ant.seedhost.eu/arcolinux/'

#hblock (stop tracking with hblock)
#use unhblock to stop using hblock
alias unhblock 'hblock -S none -D none'

#systeminfo
alias probe 'sudo -E hw-probe -all -upload'
alias sysfailed 'systemctl list-units --failed'

#shutdown or reboot
alias ssn 'sudo shutdown now'
alias sr 'sudo reboot'

#update betterlockscreen images
alias bls 'betterlockscreen -u /usr/share/backgrounds/arcolinux/'

#give the list of all installed desktops - xsessions desktops
alias xd 'ls /usr/share/xsessions'

#Leftwm aliases
alias lti 'leftwm-theme install'
alias ltu 'leftwm-theme uninstall'
alias lta 'leftwm-theme apply'
alias ltupd 'leftwm-theme update'
alias ltupg 'leftwm-theme upgrade'

#arcolinux applications
alias att 'arcolinux-tweak-tool'
alias adt 'arcolinux-desktop-trasher'
alias abl 'arcolinux-betterlockscreen'
alias agm 'arcolinux-get-mirrors'
alias amr 'arcolinux-mirrorlist-rank-info'
alias aom 'arcolinux-osbeck-as-mirror'
alias ars 'arcolinux-reflector-simple'
alias atm 'arcolinux-tellme'
alias avs 'arcolinux-vbox-share'
alias awa 'arcolinux-welcome-app'

#remove
alias rmgitcache 'rm -r ~/.cache/git'

#moving your personal files and folders from /personal to ~
alias personal 'cp -Rf /personal/* ~'

#create a file called ~/.config/fish/config-personal.fish and put all your personal aliases
#in there. They will not be overwritten by skel.

#[[ -f ~/.config/fish/config-personal.fish]] && . ~/.config/fish/config-personal.fish

# reporting tools - install when not installed
#neofetch
#screenfetch
#alsi
#paleofetch
#fetch
#hfetch
sfetch
#ufetch
#ufetch-arco
#pfetch
#sysinfo
#sysinfo-retro
#cpufetch
#colorscript random


