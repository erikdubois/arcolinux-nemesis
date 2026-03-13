#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

log_section "Start of the removal process"

log_warn "Move configs for all - backup"

[[ -f /etc/skel/.bashrc-nemesis ]] || [[ ! -f /etc/skel/.bashrc ]] || sudo mv -v /etc/skel/.bashrc /etc/skel/.bashrc-nemesis
[[ -f /etc/skel/.zshrc-nemesis ]] || [[ ! -f /etc/skel/.zshrc ]] || sudo mv -v /etc/skel/.zshrc /etc/skel/.zshrc-nemesis

log_warn "Removing the driver for xf86-video-vmware if possible"

if command -v systemd-detect-virt >/dev/null 2>&1; then
    if ! systemd-detect-virt | grep -q "oracle"; then
        if pacman -Qi xf86-video-vmware >/dev/null 2>&1; then
            sudo pacman -Rs --noconfirm xf86-video-vmware
        fi
    fi
fi

if ! grep -q "kiro" /etc/os-release; then
    log_warn "Removing software"

    remove_matching_packages rofi-lbonn-wayland
    remove_matching_packages rofi-lbonn-wayland-git
    remove_matching_packages neofetch
    remove_matching_packages fastfetch
    remove_matching_packages yay
    remove_matching_packages paru
    remove_matching_packages picom
    remove_matching_packages lxappearance

    root_fs="$(findmnt -no FSTYPE /)"

    case "${root_fs}" in
        xfs)
            remove_matching_packages btrfs-progs
            remove_matching_packages jfsutils
            ;;
        btrfs)
            remove_matching_packages xfsprogs
            remove_matching_packages jfsutils
            ;;
        jfs)
            remove_matching_packages xfsprogs
            remove_matching_packages btrfs-progs
            ;;
        *)
            remove_matching_packages xfsprogs
            remove_matching_packages btrfs-progs
            remove_matching_packages jfsutils
            ;;
    esac

    remove_matching_packages mkinitcpio-nfs-utils
    remove_matching_packages xfburn
    remove_matching_packages parole
    remove_matching_packages_deps pamac-git

    log_warn "Software removed"
fi

log_warn "Launch of get-me-started - kernels - conkys - broadcom/realtek"
[[ -f "${SCRIPT_DIR}/get-me-started" ]] && bash "${SCRIPT_DIR}/get-me-started"

log_warn "Removing ArcoLinux packages"

remove_matching_packages arcolinux-pipemenus-git
remove_matching_packages arcolinux-meta-sddm-themes

remove_matching_packages a-candy-beauty-icon-theme-git
remove_matching_packages adobe-source-han-sans-cn-fonts
remove_matching_packages adobe-source-han-sans-jp-fonts
remove_matching_packages adobe-source-han-sans-kr-fonts
remove_matching_packages archlinux-kernel-manager
remove_matching_packages arcolinux-alacritty-git
remove_matching_packages arcolinux-app-glade-git
remove_matching_packages arcolinux-arc-dawn-git
remove_matching_packages arcolinux-arc-kde
remove_matching_packages arcolinux-bin-git
remove_matching_packages arcolinux-btop-git
remove_matching_packages arcolinux-bootloader-systemd-boot-git
remove_matching_packages arcolinux-common-git
remove_matching_packages arcolinux-config-all-desktops-git
remove_matching_packages arcolinux-cron-git
remove_matching_packages arcolinux-dconf-all-desktops-git
remove_matching_packages arcolinux-desktop-trasher-git
remove_matching_packages arcolinux-faces-git
remove_matching_packages arcolinux-fastfetch-git
remove_matching_packages arcolinux-fish-git
remove_matching_packages arcolinux-fonts-git
remove_matching_packages arcolinux-gtk-sardi-arc-git
remove_matching_packages arcolinux-gtk-surfn-arc-git
remove_matching_packages arcolinux-hblock-git
remove_matching_packages arcolinux-hyfetch-git
remove_matching_packages arcolinux-kvantum-git
remove_matching_packages arcolinux-local-applications-all-hide-git
remove_matching_packages arcolinux-local-applications-git
remove_matching_packages arcolinux-local-xfce4-git
remove_matching_packages arcolinux-logo-git
remove_matching_packages arcolinux-meta-log
remove_matching_packages arcolinux-neofetch-git
remove_matching_packages arcolinux-openbox-themes-git
remove_matching_packages arcolinux-pacman-git
remove_matching_packages arcolinux-paleofetch-git
remove_matching_packages arcolinux-paru-git
remove_matching_packages arcolinux-plank-git
remove_matching_packages arcolinux-plank-themes-git
remove_matching_packages arcolinux-polybar-git
remove_matching_packages arcolinux-powermenu-git
remove_matching_packages arcolinux-qt5-git
remove_matching_packages arcolinux-reflector-simple-git
remove_matching_packages arcolinux-rofi-git
remove_matching_packages arcolinux-rofi-themes-git
remove_matching_packages arcolinux-root-git
remove_matching_packages arcolinux-sddm-simplicity-git
remove_matching_packages arcolinux-system-config-git
remove_matching_packages arcolinuxd-system-config-git
remove_matching_packages arcolinux-systemd-services-git
remove_matching_packages arcolinux-teamviewer
remove_matching_packages arcolinux-termite-themes-git
remove_matching_packages arcolinux-variety-autostart-git
remove_matching_packages arcolinux-volumeicon-git
remove_matching_packages arcolinux-wallpapers-git
remove_matching_packages arcolinux-wallpapers-candy-git
remove_matching_packages arcolinux-welcome-app-git
remove_matching_packages arcolinuxd-welcome-app-git
remove_matching_packages arcolinux-xfce-panel-profiles-git
remove_matching_packages arcolinux-zsh-git
remove_matching_packages arconet-variety-config
remove_matching_packages arcopro-wallpapers
remove_matching_packages arconet-wallpapers
remove_matching_packages arconet-xfce
remove_matching_packages sofirem-git

remove_matching_packages simplicity-sddm-theme-git

if [[ -f /usr/share/wayland-sessions/plasma.desktop ]]; then
    remove_matching_packages arcolinux-plasma-keybindings-git
    remove_matching_packages arcolinux-plasma-servicemenus-git
    remove_matching_packages arcolinux-plasma-theme-candy-beauty-arc-dark-git
    remove_matching_packages arcolinux-plasma-theme-candy-beauty-nordic-git
    remove_matching_packages arcolinux-gtk-surfn-plasma-dark-git
fi

log_warn "Removing 3rd party packages on ArcoLinux"

remove_matching_packages bibata-cursor-theme-bin
remove_matching_packages mintstick-git
remove_matching_packages nomacs-qt6-git
remove_matching_packages rate-mirrors-bin
remove_matching_packages xfce4-artwork

if pacman -Qq fastfetch 2>/dev/null | grep -qx "fastfetch"; then
    sudo pacman -R --noconfirm fastfetch >/dev/null 2>&1
fi

log_warn "Software removal for ArcoLinux done"

if grep -q "Arch Linux" /etc/os-release && [[ ! -e /bootloader ]]; then
    log_warn "Nothing to do - we are on Arch Linux"
fi

if grep -q "ezarch" /etc/os-release; then
    log_warn "Removing software for Ezarch"
    sudo systemctl disable firewalld || true
    remove_matching_packages firewalld
    remove_matching_packages abiword
    log_warn "Software removed"
fi

if grep -q "EndeavourOS" /etc/os-release; then
    log_warn "Removing software for EOS"

    sudo systemctl disable firewalld || true
    remove_matching_packages firewall-applet
    remove_matching_packages firewall-config
    remove_matching_packages firewalld
    remove_matching_packages arc-gtk-theme-eos
    remove_matching_packages eos-settings-xfce4

    sudo rm -f /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
    remove_matching_packages yay

    log_warn "Software removed"
fi

if grep -q "Garuda" /etc/os-release; then
    log_warn "Removing btrfs pacman hooks"
    sudo rm -f /etc/systemd/system/timers.target.wants/btrfs*

    log_warn "Removing touchpad"
    sudo rm -f /etc/X11/xorg.conf.d/30-touchpad.conf

    log_warn "Removing software for Garuda"

    remove_matching_packages garuda-common-settings
    remove_matching_packages abiword
    remove_matching_packages audacity
    remove_matching_packages blueman
    remove_matching_packages celluloid
    remove_matching_packages fastfetch
    remove_matching_packages garuda-browser-settings
    remove_matching_packages garuda-fish-config
    remove_matching_packages garuda-icons
    remove_matching_packages garuda-wallpapers
    remove_matching_packages garuda-xfce-settings
    remove_matching_packages geary
    remove_matching_packages gestures
    remove_matching_packages gtkhash
    remove_matching_packages linux-wifi-hotspot
    remove_matching_packages garuda-network-assistant
    remove_matching_packages modemmanager
    remove_matching_packages modem-manager-gui
    remove_matching_packages networkmanager-support
    remove_matching_packages neofetch
    remove_matching_packages onboard
    remove_matching_packages paru
    remove_matching_packages pitivi
    remove_matching_packages redshift
    remove_matching_packages transmission-gtk
    remove_matching_packages veracrypt
    remove_matching_packages vim
    remove_matching_packages vim-runtime
    remove_matching_packages xfburn

    log_section "Software on Garuda removed"
fi

if grep -q "Archman" /etc/os-release; then
    log_warn "Removing software for Archman"

    sudo systemctl disable firewalld || true
    remove_matching_packages firewalld
    remove_matching_packages imagewriter
    remove_matching_packages surfn-icons
    remove_matching_packages grml-zsh-config

    sudo rm -rf /etc/skel/.config/Thunar
    sudo rm -rf /etc/skel/.config/xfce4

    sudo rm -f /etc/skel/.config/mimeapps.list
    sudo rm -f /etc/skel/.face
    sudo rm -f /etc/skel/.xinitrc

    sudo rm -f /etc/X11/xorg.conf.d/99-killX.conf
    sudo rm -f /etc/modprobe.d/disable-evbug.conf
    sudo rm -f /etc/modprobe.d/nobeep.conf

    log_section "Software on Archman removed"
fi

if grep -q "archcraft" /etc/os-release; then
    log_warn "Removing software for Archcraft - FREE ISO
Choosing only BSPWM during installation"

    sudo rm -rf /etc/skel/.config/*
    sudo rm -f /etc/skel/.dmrc
    sudo rm -f /etc/skel/.face
    sudo rm -f /etc/skel/.gtkrc-2.0

    remove_matching_packages archcraft-skeleton
    remove_matching_packages archcraft-omz
    remove_matching_packages archcraft-openbox
    remove_matching_packages archcraft-bspwm
    remove_matching_packages archcraft-gtk-theme-arc
    remove_matching_packages archcraft-config-qt
    remove_matching_packages archcraft-neofetch
    remove_matching_packages archcraft-arandr
    remove_matching_packages simplescreenrecorder

    log_section "Software on Archcraft removed"
fi

if grep -q "BigLinux" /etc/os-release; then
    log_warn "Removing software for BigLinux"
    remove_matching_packages big-skel
    log_section "Software on BigLinux removed"
fi

if grep -q "RebornOS" /etc/os-release; then
    log_warn "Removing software for RebornOS"
    sudo pacman -Rdd --noconfirm v4l-utils || true
    log_section "Software on RebornOS removed"
fi

if grep -q "cachyos" /etc/os-release; then
    log_warn "Removing software for CachyOS"

    remove_matching_packages cachyos-kernel-manager
    remove_matching_packages cachyos-kde-settings
    remove_matching_packages cachyos-fish-config
    remove_matching_packages btrfs-progs
    remove_matching_packages cachy-browser
    remove_matching_packages fastfetch
    remove_matching_packages cachyos-alacritty-config
    remove_matching_packages cachyos-hello
    remove_matching_packages cachyos-micro-settings
    remove_matching_packages cachyos-packageinstaller
    remove_matching_packages cachyos-rate-mirrors
    remove_matching_packages cachyos-wallpapers
    remove_matching_packages cachyos-zsh-config
    remove_matching_packages octopi
    remove_matching_packages paru
    remove_matching_packages ufw

    remove_matching_packages cachyos-emerald-kde-theme-git
    remove_matching_packages cachyos-iridescent-kde
    remove_matching_packages cachyos-nord-kde-theme-git
    remove_matching_packages cachyos-themes-sddm

    remove_matching_packages noto-color-emoji-fontconfig
    remove_matching_packages noto-fonts-cjk
    remove_matching_packages ttf-meslo-nerd

    log_warn "Software removed"
fi

if grep -q "Manjaro" /etc/os-release; then
    log_warn "Removing software for Manjaro"
    remove_matching_packages manjaro-xfce-settings
    log_section "Software on Manjaro removed"
fi

if grep -q "artix" /etc/os-release; then
    log_warn "Removing software for Artix"
    remove_matching_packages artix-qt-presets
    remove_matching_packages artix-gtk-presets
    remove_matching_packages artix-desktop-presets
    log_section "Software on Artix removed"
fi

if [[ -f /etc/plymouth/plymouthd.conf ]] && grep -q "omarchy" /etc/plymouth/plymouthd.conf; then
    log_warn "Removing software for Omarchy"

    remove_matching_packages 1password-beta
    remove_matching_packages 1password-cli
    remove_matching_packages docker
    remove_matching_packages docker-buildx
    remove_matching_packages docker-compose
    remove_matching_packages gnome-calculator
    remove_matching_packages kdenlive
    remove_matching_packages lazydocker
    remove_matching_packages libreoffice-fresh
    remove_matching_packages localsend-bin
    remove_matching_packages mpv
    remove_matching_packages omarchy-chromium
    remove_matching_packages pinta
    remove_matching_packages typora
    remove_matching_packages xournalpp

    remove_file_if_exists "$HOME/.local/share/applications/X.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/WhatsApp.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Zoom.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/HEY.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/typora.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Google Contacts.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Google Messages.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Google Photos.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Figma.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Docker.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Discord.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/ChatGPT.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Basecamp.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/brave-browser.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/YouTube.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/GitHub.desktop"
    remove_file_if_exists "$HOME/.local/share/applications/Disk Usage.desktop"

    log_section "Software on Omarchy removed"
fi

remove_matching_packages mpv
remove_matching_packages clapper

if grep -q "Liya" /etc/os-release; then
    log_warn "We are on a Liya iso"

    remove_matching_packages_deps timeshift-autosnap
    remove_matching_packages_deps timeshift
    remove_matching_packages_deps pika-backup
    remove_matching_packages_deps deluge-gtk
    remove_matching_packages_deps celluloid
    remove_matching_packages_deps geary
    remove_matching_packages_deps onlyoffice-bin
    remove_matching_packages_deps exaile
    remove_matching_packages_deps pamac
    remove_matching_packages_deps newelle
    remove_matching_packages_deps gufw

    sudo rm -f /etc/skel/.config/mimeapps.list
    sudo rm -f /etc/X11/xorg.conf.d/30-touchpad.conf
    sudo mv /etc/skel/.config/fish/config.fish /etc/skel/.config/fish/config.fish.liya
    sudo rm -f /etc/skel/.config/autostart/xfce4-clipman-plugin-autostart.desktop
fi

if grep -q "LinuxHub" /etc/os-release; then
    log_warn "We are on a LinuxHub Prime iso"

    remove_matching_packages_deps waybar
    remove_matching_packages_deps gpsd
    remove_matching_packages_deps pika-backup
fi

log_subsection "$(script_name) done"