# This Scripts Automates Installation (Building) of HAProxy CE with LUA support on Linux systems with x64 Architecture. It can be run as a remote script or locally while passing 'two' arguments as follows:

This Script supports and is tested on the BASH Shell only!

1.) 1st Argument: HAProxy Sorce Code Download URL. ## example: https://www.haproxy.org/download/2.1/src/haproxy-2.1.4.tar.gz

2.) 2nd Argument: LUA Source Code Download URL. ##example: https://www.lua.org/ftp/lua-5.3.5.tar.gz

## Important: It is extremely necessary that the 1st Argument is the HAProxy URL and the Second the LUA URL and not vice versa as I have not had time to implement dynamic URLs for both the argument though it can be done. If you want to contribute you may issue a pull request.

### **Usage:**

**Locally:**

chmod +x script.sh

./script.sh {arg1} {arg2}

Example: ./script.sh https://www.haproxy.org/download/2.1/src/haproxy-2.1.4.tar.gz https://www.lua.org/ftp/lua-5.3.5.tar.gz

**Remotely:**

curl -s https://ronnietalks.com/shell-scripts/haproxy/script.sh | bash -s -- arg1 arg2

Example: curl -s https://ronnietalks.com/shell-scripts/haproxy/script.sh | bash -s -- https://www.haproxy.org/download/2.1/src/haproxy-2.1.4.tar.gz https://www.lua.org/ftp/lua-5.3.5.tar.gz
