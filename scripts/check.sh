#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "$0")/.."

lake build
lake env lean -DwarningAsError=true FirstProof.lean
lake env lean -DwarningAsError=true HandsOn/Solutions.lean
lake env lean HandsOn/Practice.lean
lake env lean StartHere.lean
