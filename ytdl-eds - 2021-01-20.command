    #! /bin/bash
    ################################################################################
    # Script Name: Youtube-dl Easy Download Script
    # Description: Easy to use script to download YouTube videos with a couple of
    #              options.
    #
    # What this script do:
    #   - Downloads video in MP4 with highest quality and max resolution 1920x1080.
    #   - Downloads thumbnail, subtitles and json data file.
    #   - Gives user directory option where to save the data.
    #   - Creates a folder with same name as video title and puts all files there.
    #   - Creates a .txt file with information about the video.
    #
    #
    # Author:      Wogol - Stackoverflow.com, Github.com
    # License:     The GNU General Public License v3.0 - GNU GPL-3
    #
    #
    # I created this script because I can't find any download software where the
    # user easy can choose what quality and where to save the data with easy fast
    # keyboard pressed. My hope is that software developers implement these
    # features in their software.
    # 
    # Big thanks to the people at youtube-dl GitHub and Stack Overflow. Without
    # their help this would never ever been possible for me.
    #
    # #####
    #
    # Software required:                 youtube-dl, ffmpeg, jq, printf
    #
    # macOS:       1. Install Homebrew:  https://brew.sh
    #              2. Terminal command:  brew install youtube-dl jq ffmpeg
    #
    #              Copy this code to TextEdit and save it as a .command file.
    #              Then run terminal command on the file:
    #                                    chmod 744 FILENAME.command
    #
    #              Now you have a .command file that you can click on in macOS.
    #
    #
    # Linux:       Depends on package manager your distribution use.
    #
    # #####
    #
    # Version history:
    # 2021-01-10
    #   - Replaced xidel, that has been blocked in Homebrew, with jq.
    #   - Added -—write-info-json so json file also gets downloaded.
    #   - Added ffmpeg in required software because youtube-dl use it to
    #     merge files.
    #   - Other minor changes.
    #
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
    #   - Running information file creation in background of media download.
    #
    #   - Script creates underscore _ instead of spaces in directories and
    #     file names youtube-dl creates.
    #
    ################################################################################



    clear



    # - WELCOME MESSAGE -

    echo

    COLUMNS=$(tput cols)
    title="-= Youtube-dl Easy Download Script =-"
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title" 



    # - PASTE URL -

    echo -e "\n*** - Paste URL address and hit RETURN. Example:\nhttps://www.youtube.com/watch?v=PFSMvvbbDLw --OR-- https://youtu.be/PFSMvvbbDLw\n"

    read url



    # - DOWNLOAD LOCATION -


    # DIRECTORY MUST END WITH SLASH: /


    echo -e "\n\n*** - Choose download folder:\n"

    COLUMNS=0
    PS3='Choose: '
    select directory in "~/Downloads/ytdl/Directory 1/" "~/Downloads/ytdl/Directory 2/" "~/Downloads/ytdl/Directory 3/"  "~/Downloads/ytdl/Directory 4/"  "~/Downloads/ytdl/Directory 5/"; do
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

    echo -e "\nOption $REPLY selected.\n $settingsopt"



    # - THE DOWNLOAD SCRIPT -

    echo -e "\n\n*** - Starting download:\n"

    youtube-dl $av --write-thumbnail --write-info-json --all-subs --restrict-filenames -o "$directory%(title)s/%(title)s.%(ext)s" $url



    # - THE INFORMATION FILE -

    textfile=$(youtube-dl --get-filename --restrict-filenames -o "$directory%(title)s/%(title)s.txt" $url)

    youtube-dl -j $url | jq -r '"- TITLE -", .title, "", "- CHANNEL / UPLOADER -", .uploader, "", "- VIDEO URL -", .webpage_url, "", "- CHANNEL & UPLOADER URL - (Often the same)", .channel_url, .uploader_url, "", "- UPLOAD DATE-", .upload_date, "", "- TAGS -", .tags, "", "- DESCRIPTION -", .description' >> "$textfile"



	# - THE END -

    echo
    COLUMNS=$(tput cols) 
    ending="Download Complete!"
    printf "%*s\n\n" $(((${#ending}+$COLUMNS)/2)) "$ending"

    exit

    done
    done