# Check running on Nano
source ./detect_platform.sh
echo .......................
echo Checking which platform
echo 

if grep -q "jetson-nano" /proc/device-tree/model;
then
echo I run on Nano pre 4.2.1
echo .......................
Platform=nano
fi

if grep -q "jetson-nano" /proc/device-tree/model;
then
echo I run on Nano 4.2.1 +
echo .....................
Platform=nano
fi

if  [ "$Platform" = "nano" ] ; then

while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

else
echo "You are not running on a Jetson Nano."
echo "Exiting install."
exit

fi

# Install environment for DVB with LimeSDR
mkdir build
mkdir bin
cd build

# ------ Install LimeSuite ---------

#Install debian packages for LimeSuite
echo ".................................."
echo "Installing packages for LimeSuite."
echo ".................................."
sudo apt-get update
sudo apt-get install -y git g++ cmake libsqlite3-dev libi2c-dev libusb-1.0-0-dev netcat

#Get FPGA mapping firmware
echo "................................."
echo "Installing FPGA mapping firmware."
echo "................................."
wget -q https://github.com/natsfr/LimeSDR_DVBSGateware/releases/download/v0.3/LimeSDR-Mini_lms7_trx_HW_1.2_auto.rpd -O LimeSDR-Mini_lms7_trx_HW_1.2_auto.rpd

#Install latest LimeSuite
echo "............................"
echo "Installing latest LimeSuite."
echo "............................"
git clone --depth=1 https://github.com/myriadrf/LimeSuite
cd LimeSuite
mkdir dirbuild
cd dirbuild
cmake ../p
make
sudo make install
sudo ldconfig
cd ../udev-rules/
chmod +x install.sh
sudo ./install.sh
cd ../../

echo "................................"
echo "Installing Lime firmware update."
echo "..............................."
#Update Lime firmware 
echo " "
while true; do
    read -p "Is your Lime plugged in and ready for firmware update?" yn
    case $yn in
        [Yy]* ) sudo LimeUtil --update; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done


#--------- Install LimeSDRTools --------------
echo "........................"
echo "Installing LimeSDRTools."
echo "........................"
# Install debian packages

git clone https://github.com/F5OEO/limesdr_toolbox
cd limesdr_toolbox

# Install sub project dvb modulation
sudo apt-get install -y libfftw3-dev
git clone https://github.com/F5OEO/libdvbmod
cd libdvbmod/libdvbmod
make
cd ../DvbTsToIQ/
make
cp dvb2iq ../../../../bin/
cd ../../

#Make 
make 
cp limesdr_send ../../bin/
make dvb
cp limesdr_dvb ../../bin/
cd ../

echo ".................."
echo "Installing ffmpeg."
echo ".................."
if  [ "$Platform" = "nano" ] ; then
sudo apt-get install buffer ffmpeg
sudo apt-get install libhackrf-dev libavutil-dev libavdevice-dev libswresample-dev libswscale-dev libavformat-dev libavcodec-dev
fi

#------- Install Leandvb -----------------
echo "..................."
echo "Installing Leandvb."
echo "..................."
git clone https://github.com/pabr/leansdr
cd leansdr/src/apps
git checkout work
make
make embedded
cp leandvb ../../../../bin/
cd ../../../

#install Excellent Analog TV project from fsphil : hacktv
echo ".................................."
echo "Installing hacktv."
echo ".................................."
git clone https://github.com/F5OEO/hacktv
cd hacktv
sudo apt-get install libhackrf-dev
make
cp hacktv ../../bin/
cd ..

# End of install
cd ../scripts
echo ".............................................."
echo "Installation finished, going to script folder. "
echo ".............................................."




