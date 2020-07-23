# This Scripts Automates Installation (Building) of HAProxy CE with LUA support on Linux systems with x64 Architecture. It can be run as a remote script or locally while passing 'two' arguments as follows:

This Script supports and is tested on the BASH Shell on RHEL/CentOS 7.x,8.x only!

1.) 1st Argument: HAProxy Sorce Code Download URL. ## example: https://www.haproxy.org/download/2.1/src/haproxy-2.1.4.tar.gz

2.) 2nd Argument: LUA Source Code Download URL. ##example: https://www.lua.org/ftp/lua-5.3.5.tar.gz

## Important: It is extremely necessary that the 1st Argument is the HAProxy URL and the Second the LUA URL and not vice versa as I have not had time to implement dynamic URLs for both the argument though it can be done. If you want to contribute you may issue a pull request.

### **Usage:**

**Locally:**

chmod +x script.sh

./script.sh {arg1} {arg2}

Example: ./script.sh https://www.haproxy.org/download/2.1/src/haproxy-2.1.4.tar.gz https://www.lua.org/ftp/lua-5.3.5.tar.gz

**Remotely:**

curl -L -s https://ronnietalks.com/shell-scripts/haproxy/script.sh | bash -s -- arg1 arg2

Example: curl -L -s https://ronnietalks.com/shell-scripts/haproxy/script.sh | bash -s -- https://www.haproxy.org/download/2.1/src/haproxy-2.1.7.tar.gz https://www.lua.org/ftp/lua-5.3.5.tar.gz


[![Demo HAProxy Script](https://s7.gifyu.com/images/New-video.gif)](https://gifyu.com/image/nQzx)

### **FAQs:**
**Q: What is the need for it?**
A: Unfortunately as of writing, for the CE of HAProxy there is no official Repository for any Linux Distro out there. This means that if you install using via the in-built repo, you're bound to **not-have** the latest version.

**Q: But I saw *Banana/Potato* repo online, why can't I just use that for my Distribution?.**
A: You definitely can! I like to be fully aware of what is going on with my machine that is all :)

**Q: I do not need the latest version. I'm fine with the version available in my OS repo.**
A: Latest versions do not only mean new features. But also security enhacements, big fixed, overall improvements and performace upgrades. If you still do not care about any of this, then this please use the version available in your repo.

**Q: What if something goes wrong? Who will support me? Can I sue you to messing up my PROD?.**
A: I cannot help you if using my script gets you into trouble. I also cannot help you directly with anything other than what is hosted on Github. You are responsible for using this script in your own environement! Hence, it is always advisable to go through any script you find online first before executing it! Hope that helps! :)

