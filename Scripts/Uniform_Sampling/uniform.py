import sys
import cv2
import os
import time
# System Arguments
# Argument 1: Location of the video
# Argument 2: Percent of summary required
# Argument 3: Directory where indices will be saved

def getSampledFrameList(video, new_fps):
	t1 = time.time()
	print("Sampling to {} FPS".format(new_fps))
	FRAME_RATE = video.get(cv2.CAP_PROP_FPS)
	skip = int(FRAME_RATE / new_fps)
	print('{}/{} -> {}'.format(FRAME_RATE,new_fps,skip))
	
	frame_list = []
	ret, frame = video.read()
	i = 0
	while ret:
		if skip < 1 or i%skip == 0:
			frame_list.append(frame)
		ret, frame = video.read()
		i += 1
	print('{} frames read from {} total'.format(len(frame_list), video.get(cv2.CAP_PROP_FRAME_COUNT)))
	video.set(cv2.CAP_PROP_POS_FRAMES, 0)
	
	print("Done in {} Sec".format(round(time.time()-t1)))
	return frame_list

def main(video, outdir, fps, percent):
	print ("Opening Video!")
	capture=cv2.VideoCapture(os.path.abspath(os.path.expanduser(video)))
	print ("Video opened\nGenerating uniformly sampled summary")
	# frame_count = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))
	# print frame_count
	frame_list = getSampledFrameList(capture, fps)

	sampling_rate=100/percent
	if 100%percent:
		sampling_rate=sampling_rate+1
	frames = []
	frame_indices = []
	for i,frame in enumerate(frame_list):
		if i%int(sampling_rate)==0:
			frames.append(frame)
			frame_indices.append(i)

	print ("Saving frames and indices")
	idx_file=open(outdir+f"/frame_indices_{fps}_{percent}.txt",'w')
	for idx in frame_indices:
		idx_file.write(str(idx)+'\n')
	print ("Saved indices")
	
	os.makedirs(outdir+"/_keyframes_/", exist_ok=True)
	for i,frame in enumerate(frames):
		cv2.imwrite(str(outdir)+"/_keyframes_/frame%d.jpg"%i, frame)
	print ("Frames saved")

if __name__ == '__main__':
	video = sys.argv[1]
	fps = 1
	percent=int(sys.argv[2]) # percent of video for summary 
	outdir = sys.argv[3]
	main(video, outdir, fps, percent)