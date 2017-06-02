#!/bin/bash
# # SUBTITLE DOWNLOADER
# # By Fahad Ahammed
# # WEB: www.fahad.space
# # 
# # https://github.com/obakfahad/yifisubtitledownloader
# #
# #

# # RANDOM
rand1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
rand2=$(date +%H%M%S)
rand3=$(echo "$rand1""$rand2")
folder=$(echo /tmp/"$rand3")

# CREATE DIRECTORY
mkdir $folder

# CHANGE DIRECTORY
cd $folder

# # REOVE JUNK
# file1="url1.txt"
# file2="url3.txt"

# if [ -f "$file1" ]
# then
# 	rm $file1
# fi

# if [ -f "$file2" ]
# then
#         rm $file2
# fi





# # SEARCH FOR MOVIE
echo "Which Movie?"
read movie

# # PROCESS
curl -Ss http://www.yifysubtitles.com/search?q=$movie > temp.html
grep -B 1 "media-left media-middle" temp.html > temp1.html
cat temp1.html | grep "href" | awk '{print $5}' | cut -c 7- | rev | cut -c 2- | rev > url.txt
cat temp1.html | grep -oP 'alt="\K.*(?=itemprop)' | sed "s| |_|g" | sed 's|"||g' | sed 's/\(.*\)_/\1 /' > name.txt
cat url.txt | while read u1;do echo "http://www.yifysubtitles.com"$u1 >> url1.txt; done



# # CHOSE EXACT MOVIE
echo "Which one exactly ? e.g 1"
paste name.txt url1.txt | column -t | nl

read num

# # PROCESS
sed -n $num"p" url1.txt | while read u2;
do
    curl -Ss "$u2" > temp2.html;
    cat temp2.html | grep 'class="sub-lang">' | grep -Po '(?<=href=")[^"]*' | grep "subtitles" > url2.txt;
    cat url2.txt | while read u3;do echo "http://www.yifysubtitles.com"$u3 >> url3.txt; done;
done

# # CHOSE EXACT SUBTITLE
echo "Which subtitle exactly ? e.g 1"
cat url3.txt | column -t | nl

read sub

# # PROCESS
sed -n $sub"p" url3.txt | while read u4;
do
    curl -Ss "$u4" > temp3.html;
    sd=$(cat temp3.html | grep 'btn-icon download-subtitle' | grep -Po '(?<=href=")[^"]*');
    sdn=$(cat temp3.html | grep 'btn-icon download-subtitle' | grep -Po '(?<=href=")[^"]*' | cut -c 39-);
    wget --no-verbose -O /home/$USER/Desktop/$sdn $sd;
    cd /home/$USER/Desktop/;
    unzip /home/$USER/Desktop/$sdn ;
    rm /home/$USER/Desktop/$sdn;
    cd;
done


echo "Download Completed in Desktop."



# REMOVE FOLDER
rm -r $folder