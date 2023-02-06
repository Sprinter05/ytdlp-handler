# YT-DLP Handler
A frontend for [yt-dlp](https://github.com/yt-dlp/yt-dlp) created by [Sprinter05](https://github.com/Sprinter05) with a Linux/MacOS version created by [tulip-sudo](https://github.com/tulip-sudo).
# Installation
## Dependencies
### Windows 10/11
Download [FFMPEG](https://www.gyan.dev/ffmpeg/builds/) essentials and place the `ffmpeg` and `ffprobe` binaries (located inside the bin folder) within your PATH. Then download the [yt-dlp](https://github.com/yt-dlp/yt-dlp/#installation) .exe file (If you get any problems, it is recommended to try the x86 binary, but remember to rename it when using it) and also place it within your PATH (Unless you want to use `LEGACY` mode, in which case you will need the [youtube-dl](https://github.com/ytdl-org/youtube-dl/) binaries).
### Linux/BSD
Install Python 3.7+ from your package manager.
#### Rolling Release Distributions
Download both FFMPEG and yt-dlp from your package manager.
#### Stable Release Distributions
Download FFMPEG (from your package manager) and then download yt-dlp from pip using `python3 -m pip install --user -U yt-dlp` (Note: This won't be in PATH by default. Make sure to add it!) <br>
This is recommended as on some distributions (Like Ubuntu 22.04 LTS), the version of yt-dlp that is provided has bugs relating to downloading .mkv files.
### MacOS
Install Python 3.7+ from your package manager.
Install a package manager (e.g. [Brew](https://brew.sh)) then install FFMPEG. <br>
Next, install yt-dlp either from pip (`python3 -m pip install --user -U yt-dlp`) or from your installed package manager.
## Post-Dependencies
After installing the necessary dependencies, execute the file specific to your OS after downloading it from the **Releases** page. <br>
For Windows 10/11, the executable is the start.cmd file. <br>
For older versions of Windows, the executable is the start_win.cmd file. <br>
For both Linux and MacOS, the executable is the start.sh file.
# Settings
## Program Settings
`LEGACY` - Enables Legacy mode which uses [youtube-dl](https://github.com/ytdl-org/youtube-dl/) instead of the default [yt-dlp](https://github.com/yt-dlp/yt-dlp) binaries. Some settings might not work in Legacy mode (check .ini file for more information). <br>
`MUSICDIR` - This is where audio-only downloads are stored. Value is a path. <br>
`VIDEODIR` - This is where video files are stored. Value is a path. <br>
`EXPLORER` - Opens your file browser after download audio/video. Value is a number that is either 1 or 0 (1 being enabled).<br>
`REOPEN` - Launches the executable again after finishing the operation instead of closing the program (if the value is set to 1).<br>
## YouTube Download
`RATELIMIT` - Determines if a download speed limiter should be applied. Value is a number that is either 1 or 0 (1 being enabled).<br>
`SPEED` - Affects the download speed limit if `RATELIMIT` is enabled. Value should be a number followed by a single letter to indicate the unit being used (K for Kilobytes, M for Megabytes etc.)<br>
`VIDEOQUALITY` - Determines which resolution should be downloaded for videos with the value specifically being the video height. Value is a positive whole number.<br>
`THUMBNAIL`, `SUBTITLES`, `METADATA` - Enables downloading the specific feature. Value is a number that is either 1 or 0 (1 being enabled). <br>
`CHAPTERS` - Divides the download into multiple files depending on the amount of chapters (if available). <br>
## Video Processing
`REMUX` - Determines if a downloaded MP4 should be remuxed instead of being entirely re-encoded. Value is a number that is either 1 or 0 (1 being enabled). <br>
`POSTPROCESSING` - Enables post-processing for MP4 files. Affected by `PPARGS`. Value is a number that is either 1 or 0 (1 being enabled). It is recommended to read [the yt-dlp README](https://github.com/yt-dlp/yt-dlp#post-processing-options) before modifying this and PPARGS. <br>
`PPARGS` - FFMPEG post-processing arguments (It is recommended to read [the FFMPEG docs](https://trac.ffmpeg.org/wiki/Encode/) before messing with this.<br>
`DEBUG` - Enables verbose logging. Helpful if an error occurs! Value is a number that is either 1 or 0 (1 being enabled). <br>
## Audio Processing
`AUDIOQUALITY` - Affects the quality of audio downloaded. This only affects FFMPEG conversion from m4a to any other audio format and does not affect video audio. Accepts a number between 0 and 10 (inclusive). The best is 0 and the worst is 10. The default (5) is 128K.<br>
# License
**ytdlp-handler** is released under the _LGPLv3 license_. Please refer to the `LICENSE` file for more information 
