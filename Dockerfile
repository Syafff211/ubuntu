FROM --platform=linux/amd64 kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update & basic tools
RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
    kali-desktop-xfce \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    xterm \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    openssl && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Install Firefox (sudah tersedia di repo Kali)
RUN apt update && apt install -y firefox-esr && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Setup VNC
RUN mkdir -p /root/.vnc && \
    echo "#!/bin/bash\nstartxfce4 &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    touch /root/.Xauthority

EXPOSE 5901
EXPOSE 6080

CMD bash -c "\
vncserver -localhost no -SecurityTypes None -geometry 1024x768 :1 && \
openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem && \
websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 && \
tail -f /dev/null"
