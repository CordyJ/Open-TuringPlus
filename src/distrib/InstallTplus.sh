#!/bin/sh
echo Installing Turing+ 6.2 ...

# install include files
/bin/mkdir -p /usr/local/include/tplus

echo ""
echo /bin/rm -rf /usr/local/include/tplus/* 
/bin/rm -rf /usr/local/include/tplus/* 

echo ""
echo /bin/cp -r usr/local/include/tplus/* /usr/local/include/tplus
/bin/cp -r usr/local/include/tplus/* /usr/local/include/tplus

# install lib files
mkdir -p /usr/local/lib/tplus

echo ""
echo /bin/rm -rf /usr/local/lib/tplus/* 
/bin/rm -rf /usr/local/lib/tplus/* 

echo ""
echo /bin/cp -r usr/local/lib/tplus/* /usr/local/lib/tplus
/bin/cp -r usr/local/lib/tplus/* /usr/local/lib/tplus

echo ""
echo ranlib /usr/local/lib/tplus/*.a
ranlib /usr/local/lib/tplus/*.a

# install bin files
mkdir -p /usr/local/bin

echo ""
echo /bin/rm -f /usr/local/bin/tpc /usr/local/bin/tssl
/bin/rm -f /usr/local/bin/tpc /usr/local/bin/tssl

echo ""
echo /bin/cp usr/local/bin/* /usr/local/bin
/bin/cp usr/local/bin/* /usr/local/bin

# Enable the Turing+ commands in MacOS
if [ `uname -s` = Darwin ]; then
    echo ""
    echo "Enabling Turing+ commands in MacOS"
    spctl --remove --label "Tplus" >& /dev/null
    spctl --add --label "Tplus" /usr/local/bin/tpc /usr/local/bin/tssl
    spctl --add --label "Tplus" /usr/local/lib/tplus/as /usr/local/lib/tplus/cc /usr/local/lib/tplus/ld 
    spctl --add --label "Tplus" /usr/local/lib/tplus/*.x
    spctl --enable --label "Tplus"
fi

echo ""
echo Done.
