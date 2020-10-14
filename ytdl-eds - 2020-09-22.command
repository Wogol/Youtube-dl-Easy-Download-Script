    #! /bin/bash
    ################################################################################
    # Script Name: Youtube-dl Easy Download Script
    # Description: Easy to use script to download YouTube videos with a couple of
    #              options.
    #
    # What this script do:
    #   - Downloads video in MP4 with highest quality and max resolution 1920x1080.
    #   - Downloads thumbnail and subtitles.
    #   - Gives user option where to download the video and video or only audio.
    #   - Creates a folder with same name as video title and puts all files there.
    #   - Creates a .txt file with information about the video.
    #
    #
    # Author:      Wogol - Stackoverflow.com, Github.com
    # License:     The GNU General Public License v3.0 - GNU GPL-3
    #
    # 
    # Big thanks to the people at youtube-dl GitHub and Stack Overflow. Without
    # their help this would never ever been possible for me.
    #
    # #####
    #
    # Software required:                 youtube-dl, xidel, printf
    #
    # macOS:       1. Install Homebrew:  https://brew.sh
    #              2. Terminal command:  brew install youtube-dl xidel
    #
    #              Copy this code to TextEdit and save it as a .command file.
    #              Then run termianl command on the file:
    #                chmod 744 FILENAME.command
    #              Now you have a .command file that you can click on in macOS.
    #
    # Linux:       Depends on package manager your distribution use.
    #
    # #####
    #
    # Version history:
    # 2020-09-22
    #   - Select menus is now one column.
    #   - Minor fixes.
    #   - Now all the bugs is fixed. Issues left is only optimizations.
    #
    # 2020-09-17
    #   - Folders can now have spaces in them.
    #
    # 2020-09-05
    #   - First working version.
    #
    # #####
    #
    # Issues left:
    #   - In the beginning there is a confirmation that show the title of the
    #     video so user know they got the correct video. It takes youtube-dl a
    #     couple of seconds. To speed up the script it is DISABLED by default.
    #
    #   - Have found out that the script dont need xidel to get json information
    #     but youtube-dl can get it. Dont know how to use youtube-dl --dump-json
    #     to get the same result.
    #
    #   - To get the path to the .txt file script use youtube-dl. This gives the
    #     script a pause for a few seconds. Best would get to get the path some how
    #     without connecting to YouTube again but use the output from youtube-dl
    #     some how. ... or run it in the background when video is downloading.
    #
    ################################################################################



    clear



    # - WELCOME MESSAGE -

    echo

    COLUMNS=$(tput cols)
    title="-= Youtube-dl Easy Download Script =-" 
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"



    # - PASTE URL -

    echo -e "\n*** - Paste URL address and hit RETURN. Example:\nhttps://www.youtube.com/watch?v=dQw4w9WgXcQ --OR-- https://youtu.be/dQw4w9WgXcQ\n"

    read url



    # - VIDEO TITLE -

    # So users know they have the correct URL.

    #echo -e "\nThe video is: (This takes 3-4 seconds, or more ...)"
    #youtube-dl -e $url
    #echo



    # - DOWNLOAD LOCATION -


    # DIRECTORY MUST END WITH SLASH: /


    echo -e "\n\n*** - Choose download folder:\n"

    COLUMNS=0
    PS3='Choose: '
    select directory in "~/Downloads/ytdl/Rick Astley/" "~/Downloads/ytdl/Never Gonna Give You Up/" "~/Downloads/ytdl/Other Rick Videos/" ; do
    echo -e "\nOption $REPLY selected. Download directory is:\n $directory"



    # - AUDIO/VIDEO SETTINGS -

    echo -e "\n\n*** - Choose download settings:\n"

    COLUMNS=0
    PS3='Choose: '
    options=("Audio & Video" "Audio only")
    select settingsopt in "${options[@]}"
    do
    case $settingsopt in

    "Audio & Video")
    av="-f bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4]/best --merge-output-format mp4"

    ;;

    "Audio only")
    av="-f bestaudio[ext=m4a]/bestaudio"

    ;;

    esac

    echo -e "\nOption $REPLY selected:\n $settingsopt"



    # - THE DOWNLOAD SCRIPT -

    echo -e "\n\n*** - Starting download:\n"
    youtube-dl $av --write-thumbnail --all-subs --restrict-filenames -o "$directory%(title)s/%(title)s.%(ext)s" $url



    # - INFORMATION FILE -

    textfile=$(youtube-dl --get-filename --restrict-filenames -o "$directory%(title)s/%(title)s.txt" $url)

    xidel -s "$url" -e '
    let $json:=json(
        //script/extract(.,"ytplayer.config = (.+?\});",1)[.]
      )/args,
      $a:=json($json/player_response)/videoDetails,
      $b:=json($json/player_response)/microformat
    return (
    "- TITLE -",
    $a/title,"",
    "- CHANNEL -",
    $a/author,"",
    "- CHANNEL URL -",
    $b//ownerProfileUrl,"",
    "- UPLOAD DATE -",
    $b//publishDate,"",
    "- URL -",
    $json/loaderUrl,"",
    "- TAGS -",
    $a/keywords,"",
    "- DESCRIPTION -",
    $a/shortDescription
    )
    ' --printed-json-format=compact >> "$textfile"



	# - THE END -

    echo
    COLUMNS=$(tput cols) 
    ending="Download Complete!"
    printf "%*s\n\n" $(((${#ending}+$COLUMNS)/2)) "$ending"

    exit

    done
    done