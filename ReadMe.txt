for fonts (){

find . -name '*.zip' -exec sh -c 'unzip -d "${1%.*}" "$1"' _ {} \;

chmod 644 NotoSansArabic-hinted/*

sudo cp -r Arimo Cousine Tinos NotoSansArabic-hinted /usr/share/fonts/truetype/

mkdir ~/.config/fontconfig

cp fonts-conf/fonts.conf ~/.config/fontconfig

sudo fc-cache -fv

------
   <alias>
   <family>sans-serif</family>
   <prefer>
    <family>Arimo اسم الخط الانجليزي موجود في الملف فمش مهم انقله </family>
    <family>اسم الخط العربي الي انت عاوزه</family>
   </prefer>
  </alias>

  



Regards
Mohammed Besar


https://bit.ly/35TxicB
https://bit.ly/35P6fPt
https://bit.ly/3xQHi2d
https://bit.ly/3qmvO42
}
for background () {
past setbg.sh in dwm/ 
}
