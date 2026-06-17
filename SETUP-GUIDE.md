# Samsung Tablet Linux Setup Guide

**Device**: Samsung Galaxy Tab S10+ (SM-X930) · **Android 16** · **Snapdragon/Adreno GPU**
**Created**: 2025-06-16

---

## 📖 Table of Contents

1. [Quick Start](#quick-start)
2. [What's Installed](#whats-installed)
3. [Using the Desktop](#using-the-desktop)
4. [VS Code](#vs-code)
5. [Metasploit](#metasploit)
6. [Wine & Windows Apps](#wine--windows-apps)
7. [Python & Flask](#python--flask)
8. [Stopping the Desktop](#stopping-the-desktop)
9. [Critical: Stop Termux from Being Killed](#critical-stop-termux-from-being-killed)
10. [Troubleshooting](#troubleshooting)
11. [Useful Commands](#useful-commands)

---

## Quick Start

```bash
# 1. Open Termux-X11 app (split-screen or floating, never background)

# 2. In this Termux terminal:
export DISPLAY=:0
source ~/.config/hacklab-gpu.sh
startxfce4

# 3. The XFCE4 desktop appears in the Termux-X11 app
```

---

## What's Installed

| Category | Software | How to Run |
|---|---|---|
| **Desktop** | XFCE4 (Lightweight) | `startxfce4` |
| **Browser** | Firefox | `firefox` or desktop shortcut |
| **Code Editor** | VS Code (code-oss) | `code-oss --no-sandbox` |
| **Media** | VLC | `vlc` or desktop shortcut |
| **Terminal** | xfce4-terminal | From desktop menu |
| **Security** | Metasploit Framework v6.4 | `~/msfconsole` |
| **Windows Apps** | Wine / Hangover | `wine app.exe` |
| **Python** | Python 3 + Flask | `python app.py` |
| **Git** | Git | `git` |

### Desktop Shortcuts (in `~/Desktop/`)
- Firefox, VS Code, VLC, Terminal
- Metasploit, Windows Explorer, Wine Config

---

## Using the Desktop

### Launch (recommended — no kill)
```bash
export DISPLAY=:0
source ~/.config/hacklab-gpu.sh
startxfce4
```

### Launch (original script — kills & restarts X11)
```bash
./start-hacklab.sh
```
⚠️ This kills any existing termux-x11 process first. Only use if the desktop is frozen.

### Stop the desktop
```bash
pkill xfce4-session
```
Or: `./stop-hacklab.sh`

### Quick tools menu
```bash
./hacktools.sh
```
Shows: Metasploit, Start Desktop, GPU Status.

---

## VS Code

```bash
# Inside the desktop's terminal:
code-oss --no-sandbox

# Or from Termux terminal (desktop must be running):
DISPLAY=:0 code-oss --no-sandbox
```

Or double-click the **VS Code** shortcut on the desktop.

**Note**: `code-oss` uses the `electron26` runtime. It requires `--no-sandbox` on Termux.

---

## Metasploit

```bash
# From Termux terminal (doesn't need desktop):
~/msfconsole

# Or from desktop terminal:
msfconsole
```

The framework was installed from GitHub and lives at `~/metasploit-framework/`.  
250 Ruby gems are bundled and ready.

---

## Wine & Windows Apps

```bash
# Run a Windows app:
wine /path/to/app.exe

# Configure Wine:
wine winecfg

# Windows File Manager:
wine winefile
```

Desktop shortcuts for Wine Config and Windows Explorer are in `~/Desktop/`.

---

## Python & Flask

```bash
cd ~/demo_python
python app.py
```

Open `http://localhost:5000` in Firefox (inside the desktop) to see the demo.

---

## Stopping the Desktop

```bash
# Method 1: Smooth stop (just kills XFCE, keeps X11 alive)
pkill xfce4-session

# Method 2: Hard stop (kills everything)
./stop-hacklab.sh
```

---

## Critical: Stop Termux from Being Killed

**Android 16 aggressively kills background apps.** This is the #1 issue with this setup. Do ALL of the following:

### 1. Battery → Unrestricted (CRITICAL)
```
Settings → Apps → Termux → Battery → "Unrestricted"
Settings → Apps → Termux-X11 → Battery → "Unrestricted"
```
If you skip this, Android kills Termux within minutes of backgrounding.

### 2. Lock in Recent Apps
- Open Recents view
- Tap the **app icon** at the top of each app card → **"Keep open"** / Lock

### 3. Disable "Pause app activity if unused"
```
Settings → Developer options → Pause execution for cached apps → OFF
```
If you don't see Developer options, enable it:
```
Settings → About tablet → Software information → Tap "Build number" 7 times
```

### 4. Keep Termux-X11 visible
Run Termux-X11 in **split-screen** or **floating window** mode.  
If it goes fully background, Android 16 may kill it.

### 5. Use wake lock (optional)
```bash
termux-wake-lock
```
Keeps Termux alive but shows a notification. You can hide the notification:
- Long-press the "wake lock held" notification → Turn off notifications

### 6. Turn off Auto-optimize
```
Device care → Memory → Auto-optimize → OFF
```

---

## Troubleshooting

### XFCE4 won't start / "Cannot open display"
```bash
# Check if X11 is running:
ps aux | grep termux-x11

# If not running, open Termux-X11 app first, then:
termux-x11 :0 -ac &
sleep 2
export DISPLAY=:0
startxfce4
```

### Termux-X11 keeps crashing
- **Battery → Unrestricted** for Termux-X11 (see above)
- Keep it in split-screen, not background
- Check if GPU drivers loaded: `source ~/.config/hacklab-gpu.sh`

### VS Code won't open
```bash
code-oss --no-sandbox --disable-gpu
```
If it still fails, check electron runtime:
```bash
ls -la /data/data/com.termux/files/usr/lib/code-oss/code-oss
```
Should be a symlink to `/data/data/com.termux/files/usr/lib/electron26/electron`.

### Metasploit: "command not found"
```bash
~/msfconsole
# Or from the framework directory:
cd ~/metasploit-framework && bundle exec ruby msfconsole
```

### Firefox: "cannot open display"
Make sure the desktop is running (`startxfce4`) and DISPLAY=:0 is set.

### "Failed to get system bus" / "DPMS missing" warnings
These are cosmetic. Termux doesn't have D-Bus system bus. They don't affect functionality.

### PulseAudio not working in desktop
```bash
pulseaudio --kill
pulseaudio --start --exit-idle-time=-1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
export PULSE_SERVER=127.0.0.1
```

### Package install fails with "electron-for-code-oss" error
A dummy `electron-for-code-oss` package was created to satisfy apt. If it causes issues:
```bash
dpkg --remove --force-depends code-oss
```

### Out of memory / slow
```bash
free -m
# Shows RAM + swap. If low:
pkill firefox    # Firefox is heavy
pkill vlc        # VLC uses lots of RAM
```

### Hermes Agent (if used)
```bash
hermes config set model <model-name>
hermes config set provider <provider>
```

---

## Useful Commands

```bash
# System info
free -m                # RAM + swap usage
df -h                  # Storage
ps aux | wc -l         # Process count
getprop ro.product.model  # Device model

# GPU check
source ~/.config/hacklab-gpu.sh
glxinfo | grep -i "renderer\|vendor\|version"
vulkaninfo | head -20

# Check running desktop
ps aux | grep xfce

# Check all installed tools
pkg list-installed | grep -E "xfce|code-oss|firefox|vlc|python|ruby"

# Wake lock
termux-wake-lock       # Prevent sleep
termux-wake-unlock     # Allow sleep

# Audio
pulseaudio --start --exit-idle-time=-1
pactl list sinks short  # List audio outputs
```
