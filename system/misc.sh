#!/bin/bash

# EXT4: reduce reserved space to 1 GB
tune2fs -r $((1 * 1024**3 / 4096)) /dev/sd

# RDP connect to Cloud VM
xfreerdp /u:Administrator /d:hostname /size:1700x1200 /v:hostname.domain.tld:443

# use alternate device (headset) in firefox
export APULSE_PLAYBACK_DEVICE=logi
export APULSE_CAPTURE_DEVICE=logir
apulse /usr/bin/firefox

# load kernel model to use DSLR as webcam
sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2
# turn on webcam
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0

# compress pdf
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf input.pdf

# cut out part of a movie
ffmpeg -ss 00:25 -i 2022-10-09_154900_Happy_Birthday_r1.mov -c copy foo.mov

# find broken symlinks
find . -xtype l
