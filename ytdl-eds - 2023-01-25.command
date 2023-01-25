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
	# With 2023-01-25 version I experimented with ChatGPT and it helped with making
	# the script shorter and easier to understand. Thanks to ChatGPT!
    #
    # #####
    #
    # Software required:                 yt-dlp, ffmpeg, jq, printf
    #
    # macOS:       1. Install Homebrew:  https://brew.sh
    #              2. Terminal command:  brew install yt-dlp jq ffmpeg
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
	# 2023-01-25
	#   - Updated and simplified the script with lot of help from ChatGPT.
	#   - Fixed the issue with _ in directory and file names.
	#
    # 2021-12-11
    #   - Replaced youtube-dl with yt-dlp.
    #   - Bad youtube-dl fix: Changed to all small files downloaded before video
    #     if the download stops, or to slow and stops and download it with another
    #     program instead.
    #
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
	#     Had problems get it working. It's a very minor issue, so I will ignore it.
    #
    ################################################################################



    clear



    # - WELCOME MESSAGE -

    echo

    COLUMNS=$(tput cols)
    title1="-= Youtube-dl Easy Download Script =-"
    title2="Version 2023-01-25"
    printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
    printf "%*s\n" $(((${#title2}+$COLUMNS)/2)) "$title2"

    # - PASTE URL -

    echo -e "\n*** - Paste URL address and hit RETURN. Example:\nhttps://www.youtube.com/watch?v=XXXXXXXXXXX --OR-- https://youtu.be/XXXXXXXXXXX\n"

    read url



    # - DOWNLOAD LOCATION -

    echo -e "\n\n*** - Choose download folder:\n"

    # Enter the main directory where to save. Do NOT end it with /	
    dir=~/Downloads/ytdl

    # List of directories under the main download directory
    COLUMNS=0
    PS3='Enter choice : '
    select directory in "$dir/Directory 1/" "$dir/Directory 2/" "$dir/Directory 3/"; do
    echo -e "\nOption $REPLY selected. Download directory is:\n $directory"



    # - AUDIO/VIDEO SETTINGS -

    echo -e "\n\n*** - Choose download settings:\n"
	
	# Prompt user for download format
	echo "Select download format:"
	echo "1. Audio & Video (Mp4, max 1920x1080, thumbnail, informative text file)"
	echo "2. Audio only    (Mp3)"
	echo "3. Audio only    (Best audio quality)"
	echo -n "Enter choice: "
	read format

	# Set options for download based on user choice
	case $format in

	  1) textfile=$(yt-dlp --get-filename -o "$directory%(title)s/%(title)s.txt" $url)
	  
	     yt-dlp --write-thumbnail --write-info-json --all-subs -f 'bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4]/best' --merge-output-format mp4 -o "$directory%(title)s/%(title)s.%(ext)s" $url
		 yt-dlp -j $url | jq -r '"- TITLE -", .title, "", "- CHANNEL / UPLOADER -", .uploader, "", "- VIDEO URL -", .webpage_url, "", "- CHANNEL & UPLOADER URL - (Often the same)", .channel_url, .uploader_url, "", "- UPLOAD DATE-", .upload_date, "", "- TAGS -", .tags, "", "- DESCRIPTION -", .description' >> "$textfile";;


	  2) yt-dlp -f bestaudio[ext=m4a]/bestaudio -o "$directory%(title)s/%(title)s.%(ext)s" $url;;


	  3) yt-dlp -f bestaudio -o "$directory%(title)s/%(title)s.%(ext)s" $url;;


	  *) echo "Invalid choice" && exit 1;;
	esac
	


    # - THE END -

    echo
    COLUMNS=$(tput cols) 
    ending="Download Complete!"
    printf "%*s\n\n" $(((${#ending}+$COLUMNS)/2)) "$ending"

    exit

    done
    done