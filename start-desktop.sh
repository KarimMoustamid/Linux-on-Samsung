#!/data/data/com.termux/files/usr/bin/bash
# Safe desktop launcher — does NOT kill existing X11 or pulseaudio
# Use this instead of start-hacklab.sh

export DISPLAY=:0

# Source GPU config
if [ -f ~/.config/hacklab-gpu.sh ]; then
    source ~/.config/hacklab-gpu.sh
fi

# Start audio if not running
if ! pidof pulseaudio > /dev/null 2>&1; then
    echo "🔊 Starting audio..."
    pulseaudio --start --exit-idle-time=-1
    sleep 1
    pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 > /dev/null 2>&1
    export PULSE_SERVER=127.0.0.1
fi

# Start X11 server if not running
if ! pidof termux-x11 > /dev/null 2>&1; then
    echo "📺 Starting X11 server..."
    termux-x11 :0 -ac &
    sleep 3
fi

# Start XFCE4 desktop
if pidof xfce4-session > /dev/null 2>&1; then
    echo "✅ Desktop already running"
else
    echo "🚀 Launching XFCE4 desktop..."
    startxfce4 &
    echo "   Open Termux-X11 app to see the desktop"
fi
