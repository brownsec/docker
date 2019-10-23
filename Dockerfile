# Docker file for creating kali-linux with some useful tools for bugbounty hunting
FROM kalilinux/kali-linux-docker

# Install the Core
RUN apt-get update && apt-get install -y
RUN apt-get -yqq update && \
    apt-get -yqq dist-upgrade && \
    apt-get clean && \
    apt-get install -y software-properties-common kali-linux-top10 --fix-missing

RUN apt-get install -y git wget curl git zip ccze byobu zsh golang \
  ufw python-pip python3-pip nikto dotdotpwn jsql nmap sqlmap sqlninja \
  sublist3r thc-ipv6 hydra dirb amass wafw00f python-dnspython

RUN go get -u github.com/tomnomnom/gron && \
    go get -u github.com/tomnomnom/httprobe && \
    go get -u github.com/tomnomnom/meg && \
    go get -u github.com/tomnomnom/unfurl && \
    go get github.com/tomnomnom/waybackurls && \
    go get -u github.com/tomnomnom/qsreplace && \
    go get github.com/ffuf/ffuf && \
    go get -u github.com/tomnomnom/assetfinder \
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


# Pull Wordlists
#RUN git clone https://github.com/danielmiessler/SecLists /usr/share/wordlists/seclists
#RUN git clone https://github.com/danielmiessler/RobotsDisallowed /usr/share/wordlists/robotsdisallowed
#RUN cd /usr/share/wordlists/seclists/Passwords/Leaked-Databases && tar xvzf rockyou.txt.tar.gz

RUN echo "All Set!! Go hack the planet!"

# set to bash so you can set keys before running aquatone.
ENTRYPOINT ["/bin/bash"]

#  Set working directory
WORKDIR /root

# docker build -t bounty/bounty .
# docker run --rm -it -v $(pwd):/data/ bounty/bounty
