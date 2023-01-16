#!/bin/bash
DIR=/data/jielin/msmo/video/;
OUT=/home/jielin/claire/video-summ/keyframes/sift/;
HOMEDIR=$PWD;
sampling_rate="1";

for category in $DIR*/;do 
    # echo $category
    for subcat in $category*/;do
        # echo $subcat
        for video in `find $subcat -name "*2[1-9].mp4"`;do
            # echo $video
            cd $HOMEDIR
            name=${video##*/};
            folder_name=${name%.mp4};
            echo $name
            # echo $folder_name
            trunc=$(dirname "$subcat")
            subfolder=$(basename "$trunc")/$(basename "$subcat")
            mkdir -p $OUT$subfolder/$folder_name
            # echo $OUT$subfolder/$folder_name/
            python videoSumSIFT.py $video $OUT$subfolder/$folder_name/
            
            # cd ../Evaluation
            # pwd 
            # echo "printing the stuff"
            # echo $filename
            # echo $sampling_rate
            # echo $percent
            # echo $OUT$folder_name"/" $OUT$folder_name"/final_results_uniform_"$percent".txt"
            # python evaluate.py $filename $sampling_rate $percent $OUT$folder_name"/" $OUT$folder_name"/final_results_uniform_"$percent".txt" uniform;
        done
    done
done

# Original script
# pwd=dir/
# name=$1;
# folder_name=${name%.mp4};
# allFrames=allFrames;
# keyFrames=keyFrames;
# rm -r $folder_name"/"
# mkdir $folder_name
# cd $folder_name		#pwd=dir/$folder_name
# mkdir $allFrames
# cd $allFrames		#pwd=dir/$folder_name/$allFrames
# ffmpeg -i ../../../../Data/SumMe/videos/$name image%d.jpg
# mkdir ../$keyFrames
# cd ../../			#pwd=dir/
# python videoSumSIFT.py ../../Data/SumMe/videos/$name $folder_name
# # cd $folder_name/$keyFrames/		#pwd=dir/$folder_name/$keyFrames
# # ffmpeg -i image%d.jpg ../summary_modified.mp4