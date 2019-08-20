Platform=unknown

echo .......................
echo Checking which platform
echo 
if grep -q "jetson-nano" /proc/device-tree/model;
then
echo I run on Nano pre 4.2.1
echo .......................
Platform=nano
fi

if grep -q "Raspberry" /proc/device-tree/model;
then
echo I run on Raspberry Pi
echo .....................
Platform=rpi
fi

if grep -q "jetson-nano" /proc/device-tree/model;
then
echo I run on Nano 4.2.1 +
echo .....................
Platform=nano
fi

