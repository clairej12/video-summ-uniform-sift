#!/bin/bash
cat=$1
DIR=/data/jielin/claire/video-summ-segments/; # /data/jielin/msmo/video/;
OUT=/data/jielin/claire/seg_uniform/; # /home/jielin/claire/video-summ/keyframes/uniform/;
HOMEDIR=$PWD;
sampling_rate="1";
percent="5"

for subcat in $DIR$cat/*/;do
    echo $subcat
    for vidname in $subcat*/;do
    echo $vidname
        for video in $vidname"downsample"/*.mp4;do
            # echo $video
            # echo $percent
            cd $HOMEDIR
            name=${video##*/};
            folder_name=${name%_fps_1.mp4};
            # echo $folder_name
            number="${folder_name##*[!-0-9]}"
            echo $number
            echo $name
            echo $folder_name
            videoID=$(basename "$vidname")
            trunc=$(dirname "$subcat")
            subfolder=$(basename "$trunc")/$(basename "$subcat")
            outfolder=$OUT$subfolder/$videoID/$folder_name
            # echo $videoID
            mkdir -p $outfolder
            # echo $outfolder
            python uniform-fps1.py $video $percent $outfolder;
            
            cd /home/jielin/claire/video-summ/evaluation
            # pwd
            pred_path=$outfolder/_keyframes_
            gt_path=/data/jielin/msmo/keyframe/$subfolder/$videoID/keyframe_$number.jpg
            # echo $pred_path
            # echo $gt_path
            python get_imgs_seg.py $gt_path $pred_path
        done
    done
done