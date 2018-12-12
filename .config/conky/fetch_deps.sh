#!/bin/bash

type luarocks >/dev/null 2>&1 || { echo >&2 "No luarocks found. Please install luarocks"; exit 1; }

luarocks install json-lua
