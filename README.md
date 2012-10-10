Blackmagic Intensity AVFoundation Issue Demo
============================================

This is a quickie demonstration of an audio sync issue with a Blackmagic
Intensity Extreme and AVFoundation. It's the base case as far as I can tell.
The audio lags quite a bit behind the video, and the video has an artifact at
the beginning of the recording session.

Although it's not demonstrated here, I see identical results with a custom setup
that uses sample buffers via data output delegates.

## Using it

Run the ./bm_problem_demo:

```
./bm_problem_demo 'Blackmagic' 'Blackmagic Audio' '720p - Uncompressed 8-bit 4:2:2' '59.94 FPS'
```

The arguments are the video device, audio device, video format, and video frame
rate. FPS is written as `59.94 FPS` or `60 FPS`. The others are the names that
the AVFoundation driver reports.

The sample output will be in `~/Movies/output.mov`.


