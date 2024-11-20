#!/bin/bash

export USER=${USER:-$(id -un)}
export HOME=${HOME:-$(eval echo ~$USER)}
export TERM=${TERM:-linux}
