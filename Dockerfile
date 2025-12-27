FROM --platform=linux/amd64 iih2o/dreams-come:true

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Install ONLY what is needed to expose it
RUN apt update && apt install -y \
    tigervnc-standalone-server \
    novnc websockify \
    xterm dbus-x11 \
 && apt clean && rm -rf /var/lib/apt/lists/*

# VNC password (same as your example)
RUN mkdir -p /root/.vnc \
 && echo "headless" | vncpasswd -f > /root/.vnc/passwd \
 && chmod 600 /root/.vnc/passwd

# VNC startup (generic, works for most desktops)
RUN echo '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4 &' \
 > /root/.vnc/xstartup \
 && chmod +x /root/.vnc/xstartup

EXPOSE 6080

CMD bash -c "\
    vncserver :1 -geometry 1280x800 -SecurityTypes VncAuth && \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901 \
"
