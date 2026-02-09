#!/usr/bin/env bash

log()   { echo -e "${GREEN}[tux]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[warn]${RESET} $1"; }
error() { echo -e "${RED}[error]${RESET} $1"; exit 1; }

