# Set up the basics
# Leverage Kali Base Image
FROM kalilinux/kali-linux-docker
# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.name='Kali Linux' \
      org.label-schema.description='Official Kali Linux docker image' \
      org.label-schema.usage='https://www.kali.org/news/official-kali-linux-docker-images/' \
      org.label-schema.url='https://www.kali.org/' \
      org.label-schema.vendor='Offensive Security' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd='docker run --rm kalilinux/kali-linux-docker' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti kalilinux/kali-linux-docker' \
      org.label-schema.docker.debug='docker logs $CONTAINER' \
      io.github.offensive-security.docker.dockerfile="Dockerfile" \
      io.github.offensive-security.license="GPLv3" \
      MAINTAINER="Steev Klimaszewski <steev@kali.org>"
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN set -x \
    && apt-get -yqq update \
    && apt-get -yqq dist-upgrade \
    && apt-get clean

# Install the Core
RUN apt-get update && apt-get install -y \
  sudo git wget curl git zip ccze byobu zsh golang \
  ufw python-pip nikto dotdotpwn jsql nmap sqlmap sqlninja thc-ipv6 hydra dirb amass

# Make Directory Structure
RUN mkdir /usr/share/wordlists && mkdir -p /usr/share/tools/scripts/

# Pull Wordlists
RUN git clone https://github.com/danielmiessler/SecLists /usr/share/wordlists/seclists
RUN git clone https://github.com/danielmiessler/RobotsDisallowed /usr/share/wordlists/robotsdisallowed
RUN cd /usr/share/wordlists/seclists/Passwords/Leaked-Databases && tar xvzf rockyou.txt.tar.gz

# Set up DNS Tooling
### Building Aquatone
FROM ruby
WORKDIR /

# Prepare
RUN apt-get update && apt-get upgrade -y

# Install normal Packages needed
RUN apt-get update && apt-get install -y -u \
  apt-utils unzip nodejs wget curl jruby nano screen htop openssl git

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs

# Installing the packages needed to run Nightmare
RUN apt-get update && apt-get install -y \
  xvfb \
  x11-xkb-utils \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  x11-apps \
  clang \
  libdbus-1-dev \
  libgtk2.0-dev \
  libnotify-dev \
  libgconf2-dev \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libxtst-dev \
  libxss1 \
  libnss3-dev \
  gcc-multilib \
  g++-multilib

# Use aq domain.com to automated all options of aquatone.
RUN wget "https://gist.githubusercontent.com/random-robbie/beae1991e9ad139c6168c385d8a31f7d/raw/" -O /bin/aq
RUN chmod 777 /bin/aq

#install aquatone
RUN gem install aquatone

# Clone down other DNS tooling
RUN mkdir -p /usr/share/tools/DNS
RUN git clone https://github.com/lorenzog/dns-parallel-prober /usr/share/tools/DNS/dnsq
RUN git clone https://github.com/aboul3la/Sublist3r /usr/share/tools/DNS/sublist3r
RUN git clone https://github.com/guelfoweb/knock /usr/share/tools/DNS/knock
RUN git clone https://github.com/anshumanbh/brutesubs /usr/share/tools/DNS/brutesubs
RUN git clone https://github.com/jhaddix/domain /usr/share/tools/DNS/domain
RUN apt-get update && apt-get install -y fierce || true

# CMS Tooling
RUN mkdir -p /usr/share/tools/CMS
RUN git clone https://github.com/droope/droopescan /usr/share/tools/CMS/droopscan
RUN apt-get update && apt-get install -y wpscan || true
RUN git clone https://github.com/Dionach/CMSmap /usr/share/tools/CMS/cmsmap

# Detect WAF
RUN git clone https://github.com/EnableSecurity/wafw00f /opt/wafw00f && \
    git clone https://github.com/techgaun/github-dorks /opt/github-dorks && \
    git clone https://github.com/maurosoria/dirsearch /opt/dirsearch && \
    git clone https://github.com/s0md3v/Arjun.git /opt/arjun

# Directory Busting
RUN mkdir -p /usr/share/tools/DirBusting
RUN apt-get update && apt-get install -y dirb || true
RUN git clone https://github.com/OJ/gobuster /usr/share/tools/DirBusting/gobuster
RUN git clone https://github.com/henshin/filebuster /usr/share/tools/DirBusting/filebuster

# Git Recon
RUN mkdir /usr/share/tools/gitint
RUN git clone https://github.com/libcrack/gitrecon /usr/share/tools/gitint/gitrecon
RUN git clone https://github.com/dxa4481/truffleHog /usr/share/tools/gitint/trufflehog
RUN git clone https://github.com/michenriksen/gitrob /usr/share/tools/gitint/gitrob


# OSINT Tooling
RUN mkdir -p /usr/share/tools/OSINT
RUN apt-get update && apt-get install -y recon-ng || true
RUN git clone https://github.com/smicallef/spiderfoot /usr/share/tools/OSINT/spiderfoot
RUN git clone https://github.com/ZephrFish/GoogD0rker /usr/share/tools/OSINT/googd0rk
RUN git clone https://github.com/GerbenJavado/LinkFinder /usr/share/tools/OSINT/linkfinder

# HTTP Analysis
RUN mkdir /usr/share/tools/HTTPAnal
RUN git clone https://github.com/ChrisTruncer/EyeWitness /usr/share/tools/HTTPAnal/eyewitness
RUN git clone https://github.com/robertdavidgraham/masscan /usr/share/tools/HTTPAnal/masscan

RUN apt-get install golang -y
RUN go get -u github.com/tomnomnom/gf
RUN echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc \
	&& mkdir /root/.gf
#COPY gf-examples/*.json /root/.gf/

RUN go get -u github.com/tomnomnom/gron && \
    go get -u github.com/tomnomnom/httprobe && \
    go get -u github.com/tomnomnom/meg && \
    go get -u github.com/tomnomnom/unfurl && \
    go get github.com/tomnomnom/waybackurls && \
    go get -u github.com/tomnomnom/qsreplace && \
    go get github.com/ffuf/ffuf && \
    go get -u github.com/tomnomnom/assetfinder

RUN echo "That's all folks! You're good to go hack the planet!"

# set to bash so you can set keys before running aquatone.
ENTRYPOINT ["/bin/bash"]

#  Set working directory
WORKDIR /root

# docker build -t bounty/bounty .
# docker run -it -v /tmp/test:/tmp/test bounty/bounty
