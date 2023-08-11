#!/usr/bin/env bash

layout_ros() {
    # Source build environment, i.e., ROS underlay.
    source_env ./.buildenv/

    # Source local_setup if it exists
    if [[ -f ./install/local_setup.bash ]]; then
        log_status "ros-direnv: sourcing install/local_setup.bash"
        source install/local_setup.bash
        watch_file install/local_setup.bash
    fi

    # Override build tools such as colcon to use the environment
    # without local_setup.bash.
    #
    # NOTE: This must happen after sourcing ROS underlay so that our
    # colcon wrapper script is found before the colcon from the
    # underlay.
    export ROS_BUILDENV_DIR=$PWD/.buildenv
    PATH_add "$ROS_BUILDENV_DIR"
}
