#!/usr/bin/env bash

# Usage: layout ros <buildenv_dir>
#
# <buildenv_dir> is a directory with .envrc and build commands (e.g.
# colcon) wrappers. The default value used by ros-direnv-setup is
# `.buildenv`.
layout_ros() {
    local buildenv_dir
    buildenv_dir=$1
    # Source build environment, i.e., ROS underlay.
    source_env "$buildenv_dir"

    # Source local_setup if it exists
    watch_file install/local_setup.bash
    if [[ -f ./install/local_setup.bash ]]; then
        log_status "ros-direnv: sourcing install/local_setup.bash"
        source install/local_setup.bash
    fi

    # Override build tools such as colcon to use the environment
    # without local_setup.bash.
    #
    # NOTE: This must happen after sourcing ROS underlay so that our
    # colcon wrapper script is found before the colcon from the
    # underlay.
    export ROS_BUILDENV_DIR=$(expand_path "$buildenv_dir")
    PATH_add "$ROS_BUILDENV_DIR"
}
