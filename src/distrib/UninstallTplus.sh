#!/bin/sh
echo Uninstalling Turing+ ...

# uninstall include files
/bin/rm -rf /usr/local/include/tplus

# uninstall lib files
/bin/rm -rf /usr/local/lib/tplus

# uninstall bin files
/bin/rm -f /usr/local/bin/tpc /usr/local/bin/tssl

echo Done.
