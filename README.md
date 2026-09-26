# My NixOS Configuration

My personal NixOS setup, running the **Niri** scrollable-tiling Wayland compositor with the **Noctalia v5** shell.

> Note: the Niri + Noctalia configuration was inspired by CachyOS's setup.

## NixOS (`configuration.nix`)

- **Bootloader:** `systemd-boot`, with generation limit set so old boot entries don't pile up and block garbage collection.
- **Desktop:** X11 stack enabled alongside GNOME as a fallback session; `greetd` + `tuigreet` as the display manager, launching **Niri** by default.
- **Audio:** PipeWire (replacing PulseAudio), with ALSA/32-bit support.
- **Shell:** `fish` as the default user shell.
- **Services:** printing (CUPS), Flatpak, `nix-ld`/`envfs` for running non-NixOS binaries (e.g. AppImages) out of the box.
- **Packages:** Brave (browser), OnlyOffice, VLC, Ghostty (terminal), Nautilus, `nwg-displays`/`nwg-look`, Bibata/Capitaine cursors, Papirus icons, and **Noctalia v5** (pulled from `unstable`).
- **Nix store:** flakes/nix-command enabled, weekly automatic garbage collection, store auto-optimisation.

## Niri (`config.kdl`)

- **Input:** IT/US keyboard layouts (toggle with `Mod+Space`), tap-to-click + natural scroll on touchpad, numlock on by default.
- **Look:** Bibata cursor theme, 16px gaps, rounded window corners, soft drop shadows, colored focus ring.
- **Noctalia integration:** auto-started at login; dedicated binds for the app launcher, control center, settings panel and window switcher; volume/brightness keys routed through Noctalia.
- **App launchers:** `Mod+Return` / `Mod+Shift+T` → Ghostty, `Mod+B` → Brave, `Mod+E` → Nautilus.
- **Window/workspace management:** full Vim-style (`H/J/K/L`) and arrow-key navigation, moving windows/columns across monitors and workspaces, numbered workspace jumps (`Mod+1..9`), floating/tabbed toggles, resizing, screenshots, and system exit binds.
