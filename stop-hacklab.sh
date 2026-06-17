#!/data/data/com.termux/files/usr/bin/bash
echo "🛑 Stopping Samsung Mobile HackLab..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 xfce4-session 2>/dev/null
pkill -9 plank 2>/dev/null
pkill -9 lxqt-session 2>/dev/null
pkill -9 mate-session 2>/dev/null
pkill -9 startplasma-x11 2>/dev/null
pkill -9 kwin_x11 2>/dev/null
pkill -9 plasmashell 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
echo "✓ Desktop stopped."
