# ros-direnv

Manage [ROS][] workspace environment via [direnv][].

Do you always forget to source `install/local_setup.bash`? Do you hate
switching to another terminal for running `colcon`? This project does
it for you. It relies on [direnv][], which automatically sets the
environment based on the `.envrc` file in the current or upper
directory.

## Getting started

1. [Install direnv][] and [hook it into your shell][].
2. Clone/download this project to, say `~/ros-direnv` (or install it
   as shown below).
3. Go to your ROS 2 workspace and setup ros-direnv there:

       cd my-ros-workspace
       ~/ros-direnv/ros-direnv-setup

   This does the following:

   - Installs the [direnv library](./direnv-lib.sh) to
     `~/.config/direnv/lib/ros.sh`.
   - Creates `.envrc` file (if it doesn't exist) containing `layout
     ros .buildenv`. Support for this layout is contained in our
     direnv library.
   - Creates the `.buildenv` directory with another `.envrc` file and
     a `colcon` wrapper.

4. Configure your build environment in `./.buildenv/.envrc`. Typically
   sourcing the underlay is sufficient:

       source /opt/ros/rolling/setup.bash

5. Enable direnv in both directories:

       direnv allow .buildenv
       direnv allow .

Then, whenever you change the working directory to your workspace, ROS
environment is automatically sourced:

```console
$ cd my-ros-workspace
direnv: loading ~/my-ros-workspace/.envrc
direnv: loading ~/my-ros-workspace/.buildenv/.envrc
direnv: ros-direnv: sourcing install/local_setup.bash
```

When you run `colcon`, it is run only in the `.buildenv` environment,
without `install/local_setup.bash`:

```console
$ colcon build
ros-build-wrapper: loading ~/my-ros-workspace/.buildenv/.envrc
Summary: 0 packages finished [0.07s]
```

[Install direnv]: https://direnv.net/docs/installation.html
[hook it into your shell]: https://direnv.net/docs/hook.html

### Installation

Instead of heaving `ros-direnv` in some random directory, you can
install it to `/usr/local` by running:

    make install

If you prefer another location, specify it with the `PREFIX` variable,
e.g.:

    make install PREFIX=$HOME

You can also install `ros-direnv` as Nix flake:

    nix profile install github:wentasah/ros-direnv --no-write-lock-file

After installation, `ros-direnv-setup` command should be available in
your `PATH`.

## Problem we are solving

Using [direnv][] with most types of projects is easy, but not with
ROS. The reason is that with ROS you need to use two different
environments in a single workspace:

- Environment for building the workspace. This is usually set up by
  sourcing a setup file from a ROS underlay, e.g., `source
  /opt/ros/jazzy/setup.bash`.

- Environment for using the packages from the workspace (overlay).
  This requires sourcing the `local_setup.bash` on top of the underlay
  setup.

This is described in more detail in this [ROS tutorial][] and [colcon
documentation][].

The problem is that manually switching between the two environments is
error prone.

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
only `colcon` wrapper is there, but you're free to wrap other commands.
The wrapper runs the original command via `direnv exec` with the
environment from `.buildenv/.envrc`.

[direnv]: https://direnv.net/
[ROS]: https://www.ros.org/
[ROS tutorial]: https://docs.ros.org/en/jazzy/Tutorials/Beginner-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html#source-the-overlay
[colcon documentation]: https://colcon.readthedocs.io/en/released/user/what-is-a-workspace.html#install-artifacts
