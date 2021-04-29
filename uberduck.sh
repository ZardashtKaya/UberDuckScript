#!/bin/bash
file=$1
voice=$2
lines=$(cat $file | wc -l)
for i in $(seq 0 $lines)

do line="$(awk "NR==$i" $file)"; curl -O 'https://api.uberduck.ai/speak' \
    --data-raw '{"speech":"'"$line"'","voice":"'$voice'"}' \
    --compressed;
    mkdir -p $(echo $file | cut -d "." -f1)_$voice;
    cat speak | base64 -D > $(echo $file | cut -d "." -f1)_$voice/$i.wav;
done

for i in $(ls $(echo $file | cut -d "." -f1)_$voice | grep ".wav" | sort -n)
do ffmpeg -i $(echo $file | cut -d "." -f1)_$voice/$i $(echo $file | cut -d "." -f1)_$voice/$i.mp3
done

for i in $(ls $(echo $file | cut -d "." -f1)_$voice | grep ".mp3" | sort -n)
do
    cat $(echo $file | cut -d "." -f1)_$voice/$i >> $(echo $file | cut -d "." -f1)_$voice/full.mp3;
done
ffmpeg -i $(echo $file | cut -d "." -f1)_$voice/full.mp3 -i $(echo $file | cut -d "." -f1)_$voice/full.mp3 -map 1 -c copy -map_metadata:s:a 0:s:a $(echo $file | cut -d "." -f1)_$voice/final.mp3;
ffmpeg -i $(echo $file | cut -d "." -f1)_$voice/final.mp3 -af volume=1 -vsync 2 $(echo $file | cut -d "." -f1)_$voice/fulll.mp3;
rm $(echo $file | cut -d "." -f1)_$voice/final.mp3;
rm $(echo $file | cut -d "." -f1)_$voice/full.mp3;
mv $(echo $file | cut -d "." -f1)_$voice/fulll.mp3 $(echo $file | cut -d "." -f1)_$voice/final.mp3;
rm $(echo $file | cut -d "." -f1)_$voice/*.wav.mp3;
rm speak





