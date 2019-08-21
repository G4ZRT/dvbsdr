Platform=unknown

echo ..................................
echo Checking which platform you are on
echo 
if grep -q "jetson-nano" /proc/device-tree/model;
then
echo I run on Nano pre 4.2.1
echo .......................
Platform=nano
fi

if grep -q "Jetson" /proc/device-tree/model;
then
echo I run on Nano 4.2.1 +
echo .....................
Platform=nano
fi

