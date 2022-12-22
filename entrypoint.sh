#!/usr/bin/env bash
set -e

INPUT_USERNAME="${INPUT_USERNAME:-$1}"
echo "::debug::Credly username: ${INPUT_USERNAME}"

INPUT_DATAFILE="${INPUT_DATAFILE:-$2}"
INPUT_DATAFILE="${INPUT_DATAFILE:-CredlyBadges.json}"
INPUT_DATAFILE="${GITHUB_WORKSPACE}/${INPUT_DATAFILE}"
echo "::debug::Storage location for badge json file: $INPUT_DATAFILE"
mkdir -p "$(dirname "$INPUT_DATAFILE")"
rm -f "$INPUT_DATAFILE"

INPUT_IMAGEDIR="${INPUT_IMAGEDIR:-$3}"
INPUT_IMAGEDIR="${INPUT_IMAGEDIR:-CredlyBadges}"
INPUT_IMAGEDIR="${GITHUB_WORKSPACE}/${INPUT_IMAGEDIR}"
echo "::debug::Storage location for badge image files: $INPUT_IMAGEDIR"
mkdir -p "$INPUT_IMAGEDIR"

URL="https://www.credly.com/users/${INPUT_USERNAME}/badges.json"
echo "::debug::Credly json url: $URL"

echo "::notice::Downloading infos from Credly"
curl --silent "$URL" | jq --sort-keys '.data|=sort_by(.issued_at)' > "$INPUT_DATAFILE"

BADGED_FOUND=$(jq '.data[] | .id' "$INPUT_DATAFILE" | wc -l )
echo "::notice::Found $BADGED_FOUND badges on Credly"

if [ "${INPUT_SKIP_IMAGE_DOWNLOADING}" == "1" ]; then
    echo "::notice::Skipping image downloading as configured"
    exit 0
fi

for url in $(jq --raw-output '.data[] | .badge_template.image_url' "$INPUT_DATAFILE"); do
    GUID="$(echo "$url" | cut -d'/' -f5)"
    EXT="$(echo "$url" | rev | cut -d'.' -f1 | rev)"
    FULL_LOCAL_PATH="${INPUT_IMAGEDIR}/${GUID}.${EXT}"

    if [ -f "$FULL_LOCAL_PATH" ]; then
        echo "::notice::Badge image for id ${GUID} already present - skipping download"
    else
        echo "::notice::Downloading bage image for id ${GUID}"
        curl --silent "$url" > "$FULL_LOCAL_PATH"
    fi
done
