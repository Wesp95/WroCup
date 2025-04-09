#!/bin/bash

case "$1" in
    B) sh ./scripts/build.sh;;
    C) sh ./scripts/clean.sh $2;;
    E) sh ./scripts/expo_data.sh $2;;
    I) sh ./scripts/input.sh $2;;
    U) sh ./scripts/upload.sh ;;
    P) sh ./scripts/expo_data.sh $2
       sh ./scripts/input.sh $2
       sh ./scripts/upload.sh ;;
    *)
        echo "Usage: $0  B for build
                    C for clean
                    E for export
                    I for input
                    U for upload
                    P for push all"
        exit 1
        ;;
esac