# Piantor WeAct Firmware (QMK + Vial)

This is a custom firmware build for the [Beekeeb Piantor keyboard](https://beekeeb.com/piantor/), with support for the WeAct RP2040 board and built on top of QMK Firmware with Vial support.

This is just an updated configuration based on the [original Piantor firmware by beekeeb](https://github.com/beekeeb/vial-qmk-piantor), this is not the official firmware.

You can download the prebuilt firmware for the WeAct and with the mouse emulation disabled on the [releases page](https://github.com/CodeMyst/piantor-firmware/releases).

It is possible to use this firmware with a Raspberry PI Pico by changing the `USB_VBUS_PIN` in `keyboards/beekeeb/piantor_weact/config.h` - just comment/uncomment the last two lines.

**Additional note**: This config also disables mouse emulation since some games detected that as a game controller and I had some ghost inputs. If you need mouse emulation enabled it by setting `mousekey: true` in `keyboards/beekeeb/piantor_weact/keyboard.json`.

## Cloning

This repo contains a the `vial-qmk` as a submodule. So when cloning the repo make sure to clone submodules with:

```
git clone --recurse-submodules https://github.com/CodeMyst/piantor-firmware
```

## Setup

To setup the project before building you have to do a few steps first:

1. Install Python 3.10 (needed until [vial-qmk#1011](https://github.com/vial-kb/vial-qmk/issues/1011) is fixed)
2. Install the QMK CLI: `curl -fsSL https://install.qmk.fm | sh`
3. Setup the QMK CLI: `cd vial-qmk && qmk setup` (just press enter for defaults)
4. Run the setup script to copy the config to the Vial QMK submodule: `./setup.sh`

## Building

To build the firmware just run `make` (from the root of the repo):

```sh
make -C vial-qmk beekeeb:piantor_weact:vial
```

If everything passed properly the firmware should end up in `vial-qmk/.build/beekeeb_piantor_weact_vial.uf2`.

## Flashing

To flash the firmware to the Piantor enter the bootloader by either holding BOOTSEL while plugging in the keyboard or holding BOOTSEL and pressing NRST at the same time (while the keyboard is plugged in of course). Then drag the `.uf2` file to the mounted directory on your computer.

You only need to do this for the left half.

Now the keyboard should properly work and you can use Vial to configure it.

## Licensing & Attribution

This project is based on multiple open-source components:

### Vial

- https://github.com/vial-kb/vial-qmk
- Licensed under GNU General Public License v2.0 (GPL-2.0)

### Beekeeb Piantor firmware

Original keyboard firmware and hardware definitions:

- https://github.com/beekeeb/vial-qmk-piantor
- Copyright Beekeeb contributors
- Licensed under GNU General Public License v2.0 (GPL-2.0)
