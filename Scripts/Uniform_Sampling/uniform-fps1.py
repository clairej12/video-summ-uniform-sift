import sys
import cv2
import os
import time
import pdb
# System Arguments
# Argument 1: Location of the video
# Argument 2: Percent of summary required
# Argument 3: Directory where indices will be saved

def main(video_file, outdir, percent):
    print ("Opening Video!")
    # pdb.set_trace()
    video=cv2.VideoCapture(os.path.abspath(os.path.expanduser(video_file)))
    print ("Video opened\nGenerating uniformly sampled summary")
    sampling_rate=100/percent
    
    if 100%percent:
        sampling_rate=sampling_rate+1
    frames = []
    frame_indices = []
    i = 0
    ret, frame = video.read()
    while ret:
        if i%int(sampling_rate)==0:
            frames.append(frame)
            frame_indices.append(i)
        ret, frame = video.read()
        i += 1

    print ("Saving frames and indices")
    idx_file=open(outdir+f"/frame_indices_{percent}.txt",'w')
    for idx in frame_indices:
        idx_file.write(str(idx)+'\n')
    print ("Saved indices")
	
    os.makedirs(outdir+"/_keyframes_/", exist_ok=True)
    for i,frame in enumerate(frames):
        cv2.imwrite(str(outdir)+"/_keyframes_/frame%d.jpg"%i, frame)
    print ("Frames saved")

if __name__ == '__main__':
    video = sys.argv[1]
    percent=int(sys.argv[2]) # percent of video for summary 
    outdir = sys.argv[3]
    main(video, outdir, percent)