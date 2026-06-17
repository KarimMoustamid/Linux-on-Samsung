#!/data/data/com.termux/files/usr/bin/bash

export XDG_DATA_DIRS=/data/data/com.termux/files/usr/share:${XDG_DATA_DIRS}
export XDG_CONFIG_DIRS=/data/data/com.termux/files/usr/etc/xdg:${XDG_CONFIG_DIRS}

# Detect installed desktop environments
DESKTOPS=()
declare -A EXEC_CMDS
declare -A KILL_CMDS

if command -v startxfce4 >/dev/null 2>&1; then
    DESKTOPS+=("XFCE4")
    EXEC_CMDS["XFCE4"]="exec startxfce4"
    KILL_CMDS["XFCE4"]="pkill -9 xfce4-session; pkill -9 plank"
fi

if command -v startlxqt >/dev/null 2>&1; then
    DESKTOPS+=("LXQt")
    EXEC_CMDS["LXQt"]="exec startlxqt"
    KILL_CMDS["LXQt"]="pkill -9 lxqt-session"
fi

if command -v mate-session >/dev/null 2>&1; then
    DESKTOPS+=("MATE")
    EXEC_CMDS["MATE"]="exec mate-session"
    KILL_CMDS["MATE"]="pkill -9 mate-session; pkill -9 plank"
fi

if command -v startplasma-x11 >/dev/null 2>&1; then
    DESKTOPS+=("KDE Plasma")
    EXEC_CMDS["KDE Plasma"]="(sleep 5 && pkill -9 plasmashell && plasmashell) > /dev/null 2>&1 & exec startplasma-x11"
    KILL_CMDS["KDE Plasma"]="pkill -9 startplasma-x11; pkill -9 kwin_x11; pkill -9 plasmashell"
fi

if [ ${#DESKTOPS[@]} -eq 0 ]; then
    echo "❌ No desktop environments found! Run setup-hacklab.sh first."
    exit 1
fi

SELECTED_DE=""

if [ ${#DESKTOPS[@]} -eq 1 ]; then
    SELECTED_DE="${DESKTOPS[0]}"
else
    echo "📺 Multiple Desktop Environments detected!"
    echo "   Which desktop do you want to start today?"
    echo ""
    for i in "${!DESKTOPS[@]}"; do
        echo "  $((i+1))) ${DESKTOPS[$i]}"
    done
    echo ""
    while true; do
        read -p "Enter number (1-${#DESKTOPS[@]}): " DE_INPUT
        if [[ "$DE_INPUT" =~ ^[0-9]+$ ]] && [ "$DE_INPUT" -ge 1 ] && [ "$DE_INPUT" -le "${#DESKTOPS[@]}" ]; then
            SELECTED_DE="${DESKTOPS[$((DE_INPUT-1))]}"
            break
        else
            echo "Invalid input."
        fi
    done
fi

echo ""
echo "🚀 Starting Samsung Mobile HackLab (${SELECTED_DE})..."
echo ""

# Load GPU config
source ~/.config/hacklab-gpu.sh 2>/dev/null

# Kill any existing sessions
echo "🔄 Cleaning up old sessions..."
pkill -9 -f "termux.x11" 2>/dev/null
eval "${KILL_CMDS["${SELECTED_DE}"]}" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

# === AUDIO SETUP ===
unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Starting audio server..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

# === START X11 ===
echo "📺 Starting X11 display server..."
termux-x11 :0 -ac &
sleep 3
export DISPLAY=:0

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📱 Open the Termux-X11 app to see desktop!"
echo "  🔊 Audio is enabled!"
echo "  🎮 GPU acceleration is active!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

eval "${EXEC_CMDS["${SELECTED_DE}"]}"
