FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    xfce4-session \
    xfce4-panel \
    xfce4-terminal \
    xfwm4 \
    dbus-x11 \
    tigervnc-standalone-server \
    novnc \
    websockify \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Fix tigervnc config path
RUN mkdir -p /root/.config/tigervnc && chmod -R 700 /root/.config

# Setup VNC password (WAJIB!)
RUN mkdir -p /root/.vnc && \
    echo "railway123" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Setup xstartup
RUN echo -e "#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4 &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 8080

CMD bash -c "\
vncserver -localhost no -geometry 1024x768 :1 && \
websockify --web=/usr/share/novnc/ $PORT localhost:5901"
