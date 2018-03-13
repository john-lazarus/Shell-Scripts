Glanes is a CUI Monitoring Tool. It is not client-less and DOES need to be installed on every client. Hence the creation of this Script to ease the whole process of running the tool on WebServer Mode with the help of a Ligtweight python framework called the 'Bottle'. Official Website for Glances: https://nicolargo.github.io/glances/ All credit for the Software goes to it's author.

This Bash Script is intended to Run on Ubuntu Distros. I have been able to only test this with Ubunutu 16.04 but it should work just fine with any Ubuntu version based on SYSTEMD and the newer APT (not apt-get). The only reason of using the half-compatible APT in the script is because I like a good verbose output.

It is to be duly noted that the same Script can be modified to use YUM on RPM based Distros like RedHat & CentOS.

In some cases the *systemd unit* fails to start. In that case, it is advised to Reboot the System and manually restart the service via *systemd*

Feel free to add or take from this Script. Suggestions and Improvements are always welcome, Thanks!
