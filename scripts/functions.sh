#!/bin/sh
. scripts/config.sh

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

    printf '%d\n' "$(( $1 + 1 ))" > "$ROOT/.step-$PKG" \
    || rm -f "$ROOT/.step-$PKG"

    return "$ret"
}

build(){
    cd "$BUILD/$1" && chateau make "$BUILD/$1.tar.xz" && rm -rf "$BUILD/$1" \
    && rm -f "$ROOT/.step-$PKG"
}
