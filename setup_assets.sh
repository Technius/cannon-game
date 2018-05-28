#!/bin/bash
export ASSETS_DIR=assets
export DOWNLOAD_DIR=assets_download
mkdir -p $ASSETS_DIR $DOWNLOAD_DIR

download_archive() {
    if [ ! -f $DOWNLOAD_DIR/$2 ]; then
        echo "Downloading $1 and saving to $DOWNLOAD_DIR/$2"
        curl -L $1 -o $DOWNLOAD_DIR/$2
        mkdir -p $DOWNLOAD_DIR/$3
        unzip $DOWNLOAD_DIR/$2 -d $DOWNLOAD_DIR/$3
    fi
}

download_file () {
    if [ ! -f $ASSETS_DIR/$2 ]; then
        echo "Downloading $1 and saving to $ASSETS_DIR/$2"
        curl -L $1 -o $ASSETS_DIR/$2
    fi
}

unzip_file () {
    mkdir -p "$DOWNLOAD_DIR/$2"
    unzip "$DOWNLOAD_DIR/$1" -d "$DOWNLOAD_DIR/$2"
}

copy_ar_file() {
    mkdir -p "$ASSETS_DIR/$1"
    cp "$DOWNLOAD_DIR/$1/$2" "$ASSETS_DIR/$1/${3-$2}"
}

copy_ar_dir() {
    mkdir -p "$ASSETS_DIR/$1"
    rsync -r "$DOWNLOAD_DIR/$1/" "$ASSETS_DIR/$1/"
}

download_archive https://opengameart.org/sites/default/files/UIpack.zip UIpack.zip kenney_ui_pack
copy_ar_dir kenney_ui_pack/PNG

download_archive https://opengameart.org/sites/default/files/kenney_physicsAssets_v2.zip kenney_physics_assets.zip kenney_physics_assets
copy_ar_dir kenney_physics_assets/PNG/Backgrounds
copy_ar_dir kenney_physics_assets/Spritesheet

download_file https://github.com/google/fonts/raw/master/ofl/lato/Lato-Medium.ttf Lato-Medium.ttf

if [ ! -f $ASSETS_DIR/one.ogg ]; then
    download_file https://opengameart.org/sites/default/files/one_0.mp3 one.mp3
    ffmpeg -i $ASSETS_DIR/one.mp3 $ASSETS_DIR/one.ogg
    rm $ASSETS_DIR/one.mp3
fi

download_file https://opengameart.org/sites/default/files/TRAPS_0.png TRAPS.png

download_file https://opengameart.org/sites/default/files/dannorder-lab%20rat%20labyrinth-cc0.png lab_rat_labyrinth.png
