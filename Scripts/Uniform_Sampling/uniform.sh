#!/bin/bash
cat=$1
DIR=/mnt/data1/jielin/msmo/video/; # /data/jielin/msmo/video/;
OUT=/mnt/data1/claire/video-summ/uniform-samp/; # /home/jielin/claire/video-summ/keyframes/uniform/;
HOMEDIR=$PWD;
sampling_rate="1";
percent='5'

for subcat in $DIR$cat/*/;do
    echo $subcat
	for video in `find $subcat -name "*2[1-9].mp4"`;do
		# echo $video
		# echo $percent
		cd $HOMEDIR
		name=${video##*/};
		folder_name=${name%.mp4};
		# echo $folder_name
		trunc=$(dirname "$subcat")
		subfolder=$(basename "$trunc")/$(basename "$subcat")
		outfolder=$OUT$subfolder/$folder_name
		# echo $videoID
		mkdir -p $outfolder
		echo $outfolder
		python uniform.py $video $percent $outfolder;
		
		cd /home/claire/video-summ/video-summ-eval/
		# pwd
		pred_path=$outfolder/_keyframes_
		gt_path=/mnt/data1/jielin/msmo/keyframe/$subfolder
		# echo $pred_path
		# echo $gt_path
		python get_imgs.py $gt_path $pred_path
	done
done