su
useradd philosan
cd /home/philosan
git clone https://github.com/philopaterwaheed/arch-dwm.git
cd arch-dwm
cp .* /home/philosan
cd dwm 
make clean install
cd ..
cd st
make clean install
