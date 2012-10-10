Blackmagic Intensity AVFoundation Issue Demo
============================================

This is a quickie demonstration of an audio sync issue with a Blackmagic
Intensity Extreme and AVFoundation. It's the base case as far as I can tell.
The audio lags quite a bit behind the video, and the video has an artifact at
the beginning of the recording session.

Although it's not demonstrated here, I see identical results with a custom setup
that uses sample buffers via data output delegates.

