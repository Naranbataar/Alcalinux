#!/bin/sh
set -e

not_built(){
    [ ! -f "$BUILD/$PKG.tar.xz" ]
}

inside(){
    url="$1"; file="${url##*/}"; dir="${file%.tar*}"
    
    cd "$DOWNLOADS"
    if [ ! -d "$dir" ]; then
        rm -f "$ROOT/.step-$PKG"
        if curl -L "$url" > "$file" && tar -xf "$file"; then
            cd "$dir"
        else
            return 1
        fi
    else
        cd "$dir"
    fi

    unset url file dir
}

step(){
    [ "$(cat "$ROOT/.step-$PKG" 2>/dev/null || printf '1\n')" -gt "$1" ]
    ret="$?"

    if [ ! "$ret" -eq 0 ]; then
        printf '%d\n' "$1" > "$ROOT/.step-$PKG"
        printf '=== %s: step %d ===\n' "$PKG" "$1" >&2
    fi
    return "$ret"
}

build(){
    cd "$BUILD/$PKG" && chateau make "$BUILD/$PKG.tar.xz" \
    && rm -rf "$BUILD/$PKG" && rm -f "$ROOT/.step-$PKG"
}
