# Sunny Lite Mode: Aggressive Battery Saver

Sunny Lite Mode is a shell script designed for the **Xiaomi Redmi Note 10 (sunny/mojito)** running YAAP ROM. It applies extremely aggressive kernel tuning parameters via Magisk's `service.d` system to maximize screen-on time (SOT) at the cost of peak performance.

> [!WARNING]
> This script limits the "Big" CPU cores to 1.1GHz, which is lower than the "Little" cores. The device will be fully functional but significantly slower. This is intended for "Lite" usage (reading, messaging, music) or emergency battery situations.

## Features

### 1. CPU Frequency Capping
- **Little Cluster (Cores 0-5)**: Capped at 1.51 GHz (Standard usage)
- **Big Cluster (Cores 6-7)**: Capped at 1.11 GHz (Heavy throttling to prevent power drain)

### 2. Schedutil Governor Tuning
- Adjusted `up_rate_limit_us` and `down_rate_limit_us` to 20000
- **Effect**: The CPU takes longer to ramp up frequencies, ignoring short burst workloads and staying at lower frequencies longer

### 3. GPU Optimization
- **Max Frequency**: Locked to 333 MHz (Lowest step)
- **Idle Timer**: Forced to sleep immediately (1ms) after rendering frames

### 4. I/O & System Tweaks
- **Scheduler**: Forces `noop` on sda (UFS) for lower CPU overhead
- **VM Tweaks**: Reduced swappiness (10) and increased `dirty_writeback_centisecs` to reduce background disk writing
- **Logd**: Background logging services are killed to stop log-spam CPU cycles

## Compatibility

| Requirement | Details |
|-------------|---------|
| **Device** | Xiaomi Redmi Note 10 (Sunny/Mojito) |
| **ROM** | YAAP (Tested on YAAP-16-Banshee-sunny-20251104) |
| **Kernel** | Default kernel or NetErnels (Must support schedutil) |
| **Root** | Magisk or KernelSU required |

## Installation

### Method 1: Termux (Copy & Paste)

You can apply this script directly from your phone using a terminal emulator (Termux) with Root access.

1. Open **Termux**
2. Type `su` and grant root permissions
3. Copy the script content (or the file generation command) and paste it into the terminal
4. Reboot your device

### Method 2: Manual Installation

1. Download `lite_mode.sh` from this repository
2. Using a Root Explorer (like MT Manager or MixPlorer), copy the file to:
   ```
   /data/adb/service.d/
   ```
3. Set permissions to `755` (rwxr-xr-x):
   ```bash
   chmod 755 /data/adb/service.d/lite_mode.sh
   ```
4. Reboot

## How to Revert

If the device is too slow for your needs or you experience issues:

1. Open your Root File Manager
2. Navigate to `/data/adb/service.d/`
3. Delete `lite_mode.sh`
4. Reboot

**Alternatively, via Termux:**

```bash
su
rm /data/adb/service.d/lite_mode.sh
reboot
```

## Performance Impact

| Metric | Stock | Lite Mode |
|--------|-------|-----------|
| UI Fluidity | 60Hz Smooth | Minor stutters possible |
| App Opening | Fast | Slower (1-2s delay) |
| Gaming | Playable | Not Recommended |
| Battery Drain | Normal | Significantly Reduced |

## Contributing

Feel free to fork this repo and submit Pull Requests if you find better values for the schedutil rate limits or safe undervolting offsets!

## Disclaimer

I am not responsible for bricked devices, dead SD cards, thermonuclear war, or your alarm app failing because the CPU was sleeping too deeply. **Use at your own risk.**
