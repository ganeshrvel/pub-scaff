#!/bin/zsh

dartdoc ./lib
pub publish --dry-run
