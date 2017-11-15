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

Mapping `$HOME` into the container will make
the `~/.scidvspc/` directory and configuration files
persist.

## MacOS: Using this image instead of the native Mac App

On MacOS, if you wish to run this image instead of the native
`SCID vs Mac` port, you need to install `XQuartz` and `socat`.
With `brew` installed, simply do this:

```
brew cask install xquartz
brew install socat
```

Then you can place this bash snippet in your `~/.bash_profile`:

```sh
__my_ip=$(ifconfig|grep 'inet '|grep -v '127.0.0.1'| \
            head -1|awk '{print $2}')
__scid_home_dir=~/docker/scid_home # pick a place for the .scidvspc dir
scid() {
  killall -0 quartz-wm > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "ERROR: Quartz is not running. Start Quartz and try again."
  else
    socat TCP-LISTEN:6001,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    SOCAT_SCID_PID=$!
    docker run --rm -e HOME=$__scid_home_dir \
      -e XAUTHORITY=/tmp/xauth -v ~/.Xauthority:/tmp/xauth \
      -e DISPLAY=$__my_ip:1 --net host -v $HOME:$HOME kayvan/scidvspc
    kill $SOCAT_SCID_PID
  fi
}
```

Now, `scid` should launch the `scidvspc` GUI. The `.scidvspc` directory
will end up wherever you set `__scid_home_dir` and will not conflict with
the native MacOS application.

## Chess Engines

In addition to the engines included with the `scidvspc` sources,
this image includes the latest stockfish (at `/usr/games/stockfish`)

Also included is an `ssh` client. This makes it possible
to run the image and add any other `uci` chess engine running
on the host to the Engine list available in `scidvspc`.

On your Docker host, set up your `~/.ssh/authorized_keys` to
include its own ssh key.

Now, in the Tools->Analysis Engines menu, you can add
any command by putting in the following info:

```
Command: /usr/bin/ssh
Parameters: youruser@172.17.0.1 whatever command
```

This even includes running another container. For example,
you can run tagged versions of the `kayvan/stockfish` image:

```
Command: /usr/bin/ssh
Parameters: kayvan@172.17.0.1 docker run --rm -i kayvan/stockfish:151117
```

# Reference
- http://scidvspc.sourceforge.net/
- https://stockfishchess.org/
- https://hub.docker.com/r/kayvan/stockfish/
