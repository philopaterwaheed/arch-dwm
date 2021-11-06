

find . -name '*.zip' -exec sh -c 'unzip -d "${1%.*}" "$1"' _ {} \;

chmod 644 NotoSansArabic-hinted/*

sudo cp -r Arimo Cousine Tinos NotoSansArabic-hinted /usr/share/fonts/truetype/

mkdir ~/.config/fontconfig

cp fonts-conf/fonts.conf ~/.config/fontconfig

sudo fc-cache -fv

------

Regards
Mohammed Besar

https://www.youtube.com/c/mmbesar
https://mastodon.online/mbesar
https://twitter.com/MMBesar
https://www.facebook.com/Mohammed.Besar.Page
https://www.instagram.com/mmbesar
