#!/usr/bin/env bash

set -u

firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
bundle_id="org.mozilla.firefox"

target_workspace="$(aerospace list-workspaces --focused)"
before_file="$(mktemp)"

cleanup() {
    rm -f "$before_file"
}
trap cleanup EXIT

list_firefox_windows() {
    aerospace list-windows \
        --monitor all \
        --app-bundle-id "$bundle_id" \
        --format '%{window-id}' |
        sort -n
}

list_firefox_windows >"$before_file"

"$firefox" -browser >/dev/null 2>&1 &

for _ in {1..100}; do
    new_window_id="$(
        comm -13 "$before_file" <(list_firefox_windows) |
            head -n 1
    )"

    if [[ -n "$new_window_id" ]]; then
        aerospace move-node-to-workspace \
            --window-id "$new_window_id" \
            -- "$target_workspace"

        aerospace workspace -- "$target_workspace"
        aerospace focus --window-id "$new_window_id"
        exit 0
    fi

    sleep 0.03
done

aerospace workspace -- "$target_workspace"
exit 1
