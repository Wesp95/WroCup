#!/bin/bash

case "$1" in
#destroy project and remove all files
    A) aws s3 rm s3://wroclawcup2025 --recursive
        terraform destroy -auto-approve
        rm wro.plan 2>/dev/null
        rm *.csv 2>/dev/null
        rm *.txt 2>/dev/null
        rm ./html/backup/* 2>/dev/null
        rm ./csfiles/* 2>/dev/null;;
#clean up files, left working webpage
    F) rm wro.plan 2>/dev/null
        rm *.csv 2>/dev/null
        rm *.txt 2>/dev/null
        rm ./html/backup/* 2>/dev/null
        rm ./csfiles/* 2>/dev/null;;
   *)
        echo "Usage: $0 A for clear ALL
                    F for clear files"
                   exit 1
        ;;
esac

