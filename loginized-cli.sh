#!/bin/bash

# Core functionalities to alter login theme
# This application provides easy access api to install specific theme as login theme for GNOME desktop 
# environment. 

# Global variables
defaultBackground=noise-texture.png
gs=gnome-shell-theme.gresource
executionPath=`pwd`
workDir=/tmp/shell
gdm3=/etc/alternatives/gdm3.css

# Determine this dynamically later
installPath=""

function notRecognized {
    echo "action $1 was not recogninzed, use ?, -h, --help flags for help" && exit 1
}

function help {
    echo "Usage: loginized-cli.sh [-h | --help | ?] | [action] [theme] [image]
Provides functionality to alternate login gnome shell theme. Theme must be found under /usr/share/themes in order to
list as option.
Definition of arguments.
 -h ............ Shows help
 --help ........ Shows help
 ? ............. Shows help
 install ....... Install action. This needs two additional parameters such as theme and image
 list .......... Lists themes available in /usr/share/themes folder
 start ......... This is startup action, usually there is no need to call this manually
 reboot ........ Reboots system no questions asked, there is no need to call this manually
 
Examples.
 loginized-cli.sh list    This example will list available themes
 
 loginized-cli.sh install Adapta my-background.png    This example will install Adapta theme from /usr/share/themes with 
                                                      my-bakcground.png as background image
 
 loginized-cli.sh install Default    This example will install default theme as login theme
 
 loginized-cli.sh install Adapta    This example will install Adapta theme as login theme without any modifications"
}

function extract {
    theme=$1
    location=/usr/share/themes/$theme/gnome-shell
    gsl=$location/$gs
    
    test ! -d $workDir/theme/assets/dot && mkdir -p $workDir/theme/assets/dot
    # test ! -d $workDir && mkdir $workDir
    # test ! -d $workDir/theme && mkdir $workDir/theme
    # test ! -d $workDir/theme/assets && mkdir $workDir/theme/assets
    # test ! -d $workDir/theme/assets/dot && mkdir $workDir/theme/assets/dot
    test ! -d $workDir/theme/icons && mkdir -p $workDir/theme/icons
    for r in $(gresource list $gsl); do
        gresource extract $gsl $r > $workDir${r/#\/org\/gnome\/shell}
    done
}

# Install gdm3 css file if it is being used by the operating system. Ubuntu newer than 16.10 uses it.
function installGdm3Css {
    from=$1
    if [ -f $gdm3 ]; then 
        cp $from $gdm3
    fi;
}

# Install specific theme with defaults as login theme
function installThemeWithDefaults {
    theme=$1
    test ! -d /usr/share/themes/$theme && echo "Theme not found (/usr/share/themes/$theme), cannot perform install" && exit 1;
    cp /usr/share/themes/$theme/gnome-shell/$gs $/usr/share/gnome-shell/$gs
    installGdm3Css /usr/share/themes/$theme/gnome-shell/gnome-shell.css
}

# Install default theme what has been backed up during initial startup
function installDefault {
    test ! -f $installPath/default/$gs && echo "Default theme not found ($installPath/default/$gs), cannot perform install" && exit 1;
    cp $installPath/default/$gs.bak /usr/share/gnome-shell/$gs
    installGdm3Css $installPath/default/gdm3.css.bak
}

# Install theme $1=theme, $2=image
function install {
    theme=$1
    image=$2
    if [ "$theme" == "Default" ]; then 
        installDefault
    
    elif [ "$image" == "" ]; then 
        installThemeWithDefaults $theme
    
    else 
        test ${#theme} -eq 0 && echo "Theme is not defined $theme, cannot continue installation" && exit 1;
        test ${#image} -eq 0 && echo "Image is not defined $image, cannot continue installation" && exit 1;
        extract $theme

        dialogCss="#lockDialogGroup { background: #2e3436 url(\"$image\"); background-repeat: none; background-size: cover; }"

        location=/usr/share/gnome-shell
        workLocation=$workDir/theme
        
        # cd $workDir/theme
        cp $installPath/$gs.xml $workLocation/.
        cp $installPath/$image $workLocation/.
        
        sed -i "s/$defaultBackground/$image/" $workLocation/$gs.xml

        sed -i "/#lockDialogGroup/,/}/ { /#lockDialogGroup/ { s/.*// }; /}/ ! { s/.*// }; /}/ { s/.*/$dialogCss/ }; }" $workLocation/gnome-shell.css
        
        glib-compile-resources $workLocation/$gs.xml
        
        cp $workLocation/$gs $location/$gs
        installGdm3Css $workLocation/gnome-shell.css
        
        #rm $gs
        #cd -
        #rm -r $workDir
    fi
}

# List themes available
function list {
    ls /usr/share/themes
}

# On start functionality
function onStart {
    installPath=${HOME}/.config/loginized
    test ! -d $installPath && mkdir -p $installPath
    # Take a backup at the beginning if back up does not exists
    if [ ! -f $installPath/default/$gs.bak ]; then
        test ! -d $installPath/default && mkdir -p $installPath/default
        cp /usr/share/gnome-shell/$gs $installPath/default/$gs.bak
    fi

    if [[ -f $gdm3 &&  ! -f $installPath/default/gdm3.css ]]; then
        cp $gdm3 $installPath/default/gdm3.css.bak
    fi;

    echo $installPath
}

# Reboots system no questions asked
function fastReboot {
    rebootBin=$(which reboot)
    $rebootBin now
}

function reboot {
    read -p "Changes will take affect after reboot, Reboot now? [Y/n]: " decision
    echo $decision
    if [[ "$decision" == "" || "$decision" == "y" || "$decision" == "Y" ]]; then 
        fastReboot
    fi;
}

# Determine whether we need help
if [[  "$1" == "" || "$1" == "-h" || "$1" == "--help" || "$1" == "?" ]]; then help && exit 0; fi

# Main functions
# $1 = option, $2 = gui, $3 = installPath, $4 = theme, $5 = image
case $1 in
    extract)
        extract $2
    ;;
    reboot)
        fastReboot
    ;;
    install)
        if [ "$2" == "gui" ]; then
            installPath=$3
            install $4 $5
        else
            installPath=$2
            install $3 $4
            # Only offer reboot option if this was executed non GUI
            reboot
        fi;
    ;;
    list)
        list
    ;;
    start)
        onStart
    ;;
    *)
        notRecognized $1
    ;;
esac

# If we are not in execution path, return to execution path
if [ "$executionPath" != "$(pwd)" ]; then cd $executionPath; fi;
