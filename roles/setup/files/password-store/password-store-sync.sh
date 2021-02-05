#!/bin/bash

set -e

/usr/bin/pass pull --rebase
/usr/bin/pass push
