#!/usr/bin/env bash
set -euo pipefail

WORKFLOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$(cd "$WORKFLOW_DIR/../output" && pwd)"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <workflow-name>"
    echo
    echo "Available workflows:"
    find "$WORKFLOW_DIR" -maxdepth 1 -type f -name '*.json' \
        -printf '%f\n' | sort
    exit 1
fi

WORKFLOW="$1"

[[ "$WORKFLOW" == *.json ]] || WORKFLOW="${WORKFLOW}.json"

JSON="$WORKFLOW_DIR/$WORKFLOW"

if [[ ! -f "$JSON" ]]; then
    echo "ERROR: Workflow not found:"
    echo "  $JSON"
    exit 1
fi

NAME="${WORKFLOW%.json}"
PREVIEW="$WORKFLOW_DIR/$NAME.png"

echo "Workflow:"
echo "  $WORKFLOW"
echo
echo "Generate your preview image in ComfyUI."
echo "Then press ENTER here..."
read -r

LATEST=$(find "$OUTPUT_DIR" -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
    -printf '%T@ %p\n' 2>/dev/null |
    sort -nr |
    head -n 1 |
    cut -d' ' -f2-)

if [[ -z "$LATEST" ]]; then
    echo "ERROR: No generated image found."
    exit 1
fi

cp "$LATEST" "$PREVIEW"

echo
echo "Preview created:"
echo "  $PREVIEW"
echo
echo "Source:"
echo "  $LATEST"
