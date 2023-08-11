# ros-direnv

Manage [ROS][] workspace environment via [direnv][].

Do you always forget to source `install/local_setup.bash`? This
project does it for you. It relies on [direnv][], which automatically
sets the environment based on the `.envrc` file in the current or
upper directory.

## Getting started

1. [Install direnv][] and [hook it into your shell][].
2. Clone/download this project to, say `~/ros-direnv`.
3. Go to your ROS 2 workspace and setup ros-direnv there:

       cd my-ros-workspace
       ~/ros-direnv/ros-direnv-setup

   This does the following:

   - Installs a [direnv library](./direnv-lib.sh) to
     `~/.config/direnv/lib/ros.sh`.
   - Creates `.envrc` file (if it doesn't exist) containing `layout
     ros`. Support for this layout is in our direnv library.
   - Creates `.buildenv` directory with another `.envrc` file and a
     `colcon` wrapper.

4. Configure your build environment in `./.buildenv/.envrc`. Typically
   sourcing the underlay is sufficient:

       source /opt/ros/rolling/setup.bash

5. Enable direnv in both directories:

       direnv allow .buildenv
       direnv allow .


[Install direnv]: https://direnv.net/docs/installation.html
[hook it into your shell]: https://direnv.net/docs/hook.html

## Problem to be solved

[direnv][] works well for most types of projects, but not for ROS. The
reason is that with ROS you need to use two different environments in
a single workspace:

- Environment for building the workspace. This is usually set by
  sourcing a setup file from a ROS underlay, e.g., `source
  /opt/ros/humble/setup.bash`.

- Environment for using the packages from the workspace (overlay).
  This requires sourcing the `local_setup.bash` on top of the underlay
  setup.

This is described in more detail in a [ROS tutorial][].

Manually switching between the two environments is error prone.

## Solution

The solution in this repository uses [direnv][] to automatically load
both underlay and overlay environments, but build commands such as
`colcon` are run only in the underlay environment.

## How it works?

[direnv][] loads the build (underlay) environment from
`.buildenv/.envrc` and the overlay environment from
`install/local_setup.bash` (if it exists). Further, it prepends
`.buildenv` to your PATH. The `.buildenv` directory contains wrappers
for commands that need to be run in the build environment. By default
only `colcon` wrapper is there, but you're free to add other wrappers.
The wrapper runs the wrapped command via `direnv exec` with the
environment from `.buildenv/.envrc`.

[direnv]: https://direnv.net/
[ROS]: https://www.ros.org/
[ROS tutorial]: https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html#source-the-overlay
