alias cpu="cpuid -i | grep uarch | head -n 1"

#moving your personal files and folders from /personal to ~

function personal1
   	cp -rf /personal/1/ ~
    cp -rf /personal/1/.* ~
end

function personal2
   	cp -rf /personal/2/ ~
    cp -rf /personal/2/.* ~
end

function personal3
   	cp -rf /personal/3/ ~
    cp -rf /personal/3/.* ~
end


function personal4
   	cp -rf /personal/4/ ~
    cp -rf /personal/4/.* ~
end

alias var="cp ~/DATA/arcolinux-nemesis/Personal/settings/variety/variety.conf ~/.config/variety/variety.conf"