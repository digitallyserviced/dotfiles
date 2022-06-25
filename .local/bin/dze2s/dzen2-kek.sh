#!/bin/bash
conky -c ./.conkyrc-time | dzen2 -fn "TerminusTTF:pixelsize=8:antialias=yes" -w '3000' -bg '#232323' -x '169'  -h '21' -ta 'r'
