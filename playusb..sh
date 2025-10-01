#!/bin/bash
# playusb.sh - Autoplay audio från USB via Scarlett 2i2
LOGFILE="/home/tekniker/playusb.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "=== Startar playusb.sh $(date) ==="

USBPATH="/mnt/usb"

# Vänta tills USB är monterad (max 30 sekunder)
for i in {1..30}; do
    if mountpoint -q "$USBPATH"; then
        echo "USB monterad!"
        break
    fi
    sleep 1
done

if ! mountpoint -q "$USBPATH"; then
    echo "Fel: USB monterades inte efter 30 sekunder"
    exit 1
fi

# Kontrollera att katalogen innehåller ljudfiler
AUDIO_FILES=$(find "$USBPATH" -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.flac" -o -iname "*.ogg" \))
if [ -z "$AUDIO_FILES" ]; then
    echo "Ingen musik hittades i $USBPATH"
    exit 1
fi

echo "Spelar upp filer från: $USBPATH"

# Hitta Scarlett 2i2 automatiskt
CARDNUM=$(aplay -l | grep -i "Scarlett 2i2" | head -n1 | awk '{print $2}' | tr -d ':')
if [ -z "$CARDNUM" ]; then
    echo "Fel: Scarlett 2i2 hittades inte!"
    exit 1
fi

echo "Använder ljudkort: $CARDNUM (Scarlett 2i2)"

# Spela alla ljudfiler i loop via Scarlett, robust mot mellanslag i filnamn
echo "$AUDIO_FILES" | xargs -d '\n' cvlc -I dummy --quiet --loop --no-video --aout=alsa --alsa-audio-device=hw:$CARDNUM,0
