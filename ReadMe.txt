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
o set up NVIDIA drivers for the Lenovo IdeaPad Gaming 3 on Arch Linux, follow these steps:

Update your system: Open a terminal and run the following commands to update your system's packages:
Copy
sudo pacman -Syu
```

Identify your NVIDIA GPU: Run the following command to identify the exact model of your NVIDIA GPU:
Copy
lspci -k | grep -A 2 -i "VGA"
```

Install the necessary packages: Install the required packages for NVIDIA driver support by running the following command:
Copy
sudo pacman -S nvidia nvidia-utils
```

Generate the initial RAM disk: Run the following command to generate an initial RAM disk with the NVIDIA driver:
Copy
sudo mkinitcpio -P
```

Enable the NVIDIA kernel module: Edit the /etc/mkinitcpio.conf file using a text editor such as nano or vim:
Copy
sudo nano /etc/mkinitcpio.conf
```

Find the line that begins with `MODULES=` and add `nvidia` to the list of modules. It should look like this:
MODULES=(nvidia)
awk
Copy

Save the file and exit the text editor.

Regenerate the initial RAM disk: Run the following command to regenerate the initial RAM disk with the updated configuration:
Copy
sudo mkinitcpio -P
```

Enable the NVIDIA persistence daemon: Run the following command to enable and start the NVIDIA persistence daemon:
Copy
sudo systemctl enable --now nvidia-persistenced
```

Configure Xorg: If you are using Xorg as your display server, create a new Xorg configuration file by running the following command:
Copy
sudo nvidia-xconfig
```
https://wiki.denshi.org/hypha/client/nvidia

Reboot your system: After completing the above steps, reboot your system to load the NVIDIA driver:
Copy
sudo reboot
nvtop to monitor
https://wiki.denshi.org/hypha/client/nvidia
if souned disapeared after boot
gpasswd -a username audio

for souned drivers 
On an educated guess, install sof-firmware and alsa-ucm-conf https://wiki.archlinux.org/index.php/Ad … A_Firmware

for touch pad 
/etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "touchpad catchall"
    Driver "libinput"
    Option "Tapping" "on"
EndSection
for bightness
brillo
