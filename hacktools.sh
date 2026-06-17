#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear
    echo ""
    echo "╔═══════════════════════════════════════════════╗"
    echo "║   🔧 Samsung Mobile HackLab - Quick Tools     ║"
    echo "╠═══════════════════════════════════════════════╣"
    echo "║                                               ║"
    echo "║   1) 💀 Metasploit  - Exploit Framework       ║"
    echo "║   2) 🖥️  Start Desktop                        ║"
    echo "║   3) 🎮 Check GPU Status                      ║"
    echo "║   0) ❌ Exit                                  ║"
    echo "║                                               ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    read -p "  Select option: " choice
    
    case $choice in
        1) 
            ~/msfconsole
            ;;
        2) 
            bash ~/start-hacklab.sh
            ;;
        3)
            echo ""
            echo "  === GPU Information ==="
            glxinfo 2>/dev/null | grep -i "renderer\|vendor\|version" || echo "  glxinfo not available (install mesa-utils)"
            echo ""
            vulkaninfo 2>/dev/null | head -20 || echo "  vulkaninfo not available"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        0) 
            echo ""
            echo "  👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "  Invalid option."
            sleep 1
            ;;
    esac
done
