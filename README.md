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
The scripts will attempt registering respective services when it detects a service manager, being systemd, OpenRC or else. In future versions of these scripts, it would be possible to override this behaviour by setting `NOSERVICE` to any non-false values.

If you spot problems with installation, do not hesitate to open an issue in the repo!

* AlmaLinux 9.0+ (uses systemd)
* Alpine Linux 3.18.0+ (Bash required, uses OpenRC)
* Debian 12.0+ (uses systemd)
* openSUSE Leap 15.5+ (uses systemd)
* Rocky Linux 9.0+ (uses systemd)
* Termux

### Regarding domain sockets
Because Linux will not clean non-abstract domain sockets up if kills happen, the `systemd` service files themselves have been spiced to conduct automatic cleanup under `/run/<software>/%i`, with `%i` defaulting to `config`. Thus, to prevent processes listening on DSes from accidental bootlooping, please use these namespaced paths to listen to sockets.

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