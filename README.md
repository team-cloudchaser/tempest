# tempest

⛈ Scripts and examples to get you onboard with EPs.

## Scripts
Installation scripts provided by tempest supports POSIX-compliant systems only. You can override the version you want to install via the `INSTALL_VER` environment variable.

Use the following command to begin setting up your EP. Remember to specify the software you want to install.

```sh
bash <(curl -Ls https://github.com/team-cloudchaser/tempest/raw/main/install/<software>.sh)
```

### Software
Only the programs listed below are supported.

* `hysteria`
* `singbox`
* `xray`

### Supported distros
If you spot support problems, do not hesitate to open up an issue!

* AlmaLinux 9.0+
* Alpine Linux 3.18.0+ (`bash` required)
* Debian 12.0+
* openSUSE Leap 15.5+
* Rocky Linux 9.0+
* Termux

## Targets
To get included into this repo, the software itself must be open-source, and does not endorse closed-source counterparts.

As such, programs like **Clash** will never appear in the examples.

### Server
|               | Linux |
| ------------- | ----- |
| `xray`        | ✓     |
| `sing-box`    | ✓     |
| `hysteria`    | !     |
| `ping-tunnel` | !     |
| `tuic`        | !     |
| `iodine`      | !     |

### Client
#### CLI
|               | Linux | Android | Windows | macOS | iOS |
| ------------- | ----- | ------- | ------- | ----- | --- |
| `xray`        | !     | !       | !       | !     |     |
| `sing-box`    | !     | !       | !       | !     |     |
| `hysteria`    | !     | !       | !       | !     |     |
| `clash.meta`  | !     | !       | !       |       |     |
| `ping-tunnel` | !     |         | !       |       |     |
| `tuic`        | !     |         |         |       |     |
| `iodine`      | !     |         |         |       |     |

#### GUI
- [ ] NekoBox: Windows, Linux, Android
- [ ] Sing Box: Android, iOS
- [ ] v2rayN: Windows
- [ ] v2rayNG: Android
- [ ] Wings X: iOS