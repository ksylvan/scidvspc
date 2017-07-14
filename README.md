# scidvspc docker image

To run this image, share the X11 socket or use any
of the other methods to run X11 Apps in Docker.

For example, you can run the image like this:

```
docker run -it -u 1000:1000 --rm -e HOME \
  -e DISPLAY=unix:0 -e XAUTHORITY=/tmp/xauth \
  -v $XAUTHORITY:/tmp/xauth -v $HOME:$HOME \
  -v /tmp/.X11-unix:/tmp/.X11-unix kayvan/scidvspc
```
The image includes the latest scidvspc and
stockfish (at `/usr/games/stockfish`)

Mapping `$HOME` into the container will make
the `~/.scidvspc/` directory and configuration
persist.

# Reference
- http://scidvspc.sourceforge.net/
- https://stockfishchess.org/
