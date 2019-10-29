# Docker file for creating kali-linux with some useful tools for bugbounty hunting
FROM kalilinux/kali-linux-docker

# Install the Core
RUN apt-get update && apt-get install -y
RUN apt-get -yqq update && \
    apt-get -yqq dist-upgrade && \
    apt-get clean && \
    apt-get install -y software-properties-common kali-linux-top10 --fix-missing

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y git wget curl git zip ccze byobu zsh golang \
  ufw python-pip python3-pip nikto dotdotpwn jsql nmap sqlmap sqlninja \
  sublist3r thc-ipv6 hydra dirb amass wafw00f python-dnspython php7.0 libapache2-mod-php

RUN go get -u github.com/tomnomnom/gron && \
    go get -u github.com/tomnomnom/httprobe && \
    go get -u github.com/tomnomnom/meg && \
    go get -u github.com/tomnomnom/unfurl && \
    go get github.com/tomnomnom/waybackurls && \
    go get -u github.com/tomnomnom/qsreplace && \
    go get github.com/ffuf/ffuf && \
    go get -u github.com/tomnomnom/assetfinder && \
    go get github.com/ffuf/ffuf

# Git Recon
RUN mkdir /root/tools
RUN git clone https://github.com/libcrack/gitrecon /root/tools/gitrecon
RUN git clone https://github.com/dxa4481/truffleHog /root/tools/trufflehog
RUN go get github.com/michenriksen/gitrob

# Creating Alias for tools
RUN echo 'alias ffuf="/root/go/bin/ffuf"' >> ~/.bashrc
RUN echo 'alias gitrob="/root/go/bin/gitrob"' >> ~/.bashrc
RUN echo 'alias gron="/root/go/bin/gron"' >> ~/.bashrc
RUN echo 'alias httprobe="/root/go/bin/httprobe"' >> ~/.bashrc
RUN echo 'alias unfurl="/root/go/bin/unfurl"' >> ~/.bashrc
RUN echo 'alias waybackurls="/root/go/bin/waybackurls"' >> ~/.bashrc
RUN echo 'alias qsreplace="/root/go/bin/qsreplace"' >> ~/.bashrc
RUN echo 'alias ffuf="/root/go/bin/ffuf"' >> ~/.bashrc
RUN echo 'alias assetfinder="/root/go/bin/assetfinder"' >> ~/.bashrc


#FinalRecon
RUN git clone https://github.com/thewhiteh4t/FinalRecon.git /root/tools/FinalRecon
RUN pip3 install -r /root/tools/FinalRecon/requirements.txt
RUN echo 'alias finalrecon="python3 /root/tools/FinalRecon/finalrecon.py --full $1"' >> ~/.bashrc

# Arjun
RUN git clone https://github.com/s0md3v/Arjun.git /root/tools/Arjun
RUN echo 'alias arjun="python3 /root/tools/Arjun/arjun.py $1"' >> ~/.bashrc

#knock
RUN git clone https://github.com/guelfoweb/knock.git /root/tools/knock
WORKDIR /root/tools/knock
RUN python setup.py install


# knock
RUN git clone -f https://github.com/guelfoweb/knock.git /root/tools/knock
WORKDIR /root/tools/knock
RUN python setup.py install

#template-generator
RUN git clone https://github.com/fransr/template-generator.git /root/tools/template-generator
WORKDIR /root/tools/template-generator
EXPOSE 9999
CMD ["php", "-S", "0.0.0.0:9999", "-t", "/root/tools/template-generator"]

# Pull Wordlists
#RUN git clone https://github.com/danielmiessler/SecLists /usr/share/wordlists/seclists
#RUN git clone https://github.com/danielmiessler/RobotsDisallowed /usr/share/wordlists/robotsdisallowed
#RUN cd /usr/share/wordlists/seclists/Passwords/Leaked-Databases && tar xvzf rockyou.txt.tar.gz

RUN echo "All Set!! Go hack the planet!"

#  Set working directory
WORKDIR /root

# docker build -t bounty/bounty .
# docker run --rm -it -v $(pwd):/data/ bounty/bounty
