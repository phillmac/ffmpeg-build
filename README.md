# ffmpeg-build
Build ffmpeg and retain sources

# Build instructions

```
ubuntu_version=18.04
ffmpeg_version=tags/n4.0.1

docker build \
    -t phillmac/ffmpeg-build:${ubuntu_version}-${ffmpeg_version////_} \
    --build-arg FFMPEG_VERSION=${ffmpeg_version} \
    --target ffmpeg_builder \
    git://github.com/phillmac/ffmpeg-build#${ubuntu_version}
```
