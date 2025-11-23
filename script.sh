# Write the clean script to the Magisk service folder

cat <<'EOF' > /data/adb/service.d/lite_mode.sh
#!/system/bin/sh
# Wait for boot to finish
sleep 20

# --- PART 1: CPU FREQUENCY CAPS ---
# Cluster 0 (Little Cores) -> Cap at ~1.5GHz
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
    echo 1516800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

# Cluster 1 (Big Cores) -> Cap at ~1.1GHz
if [ -d /sys/devices/system/cpu/cpu6/cpufreq ]; then
    echo 1113600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
fi

# --- PART 2: SCHEDUTIL TUNING (FIXED) ---
# Tunables must be applied to policy0 (Little) and policy6 (Big) individually

# Apply to Little Cluster (Policy 0)
if [ -d /sys/devices/system/cpu/cpufreq/policy0/schedutil ]; then
    echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
    echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
fi

# Apply to Big Cluster (Policy 6)
if [ -d /sys/devices/system/cpu/cpufreq/policy6/schedutil ]; then
    echo 20000 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/up_rate_limit_us
    echo 20000 > /sys/devices/system/cpu/cpufreq/policy6/schedutil/down_rate_limit_us
fi

# --- PART 3: GPU CAPS ---
if [ -e /sys/class/kgsl/kgsl-3d0/max_gpuclk ]; then
    echo 333500000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk
    echo 1 > /sys/class/kgsl/kgsl-3d0/idle_timer
fi

# --- PART 4: STORAGE OPTIMIZATION ---
# Validating path for sda (UFS)
if [ -e /sys/block/sda/queue/scheduler ]; then
    echo "noop" > /sys/block/sda/queue/scheduler
fi

# --- PART 5: SYSTEM CLEANUP ---
echo 6000 > /proc/sys/vm/dirty_writeback_centisecs
echo 10 > /proc/sys/vm/swappiness

# Kill logging using property triggers (Cleanest method)
stop logd
setprop ctl.stop logd

echo "Redmi Note 10 Lite Mode Applied"
EOF

# 2. Set Permissions
chmod 755 /data/adb/service.d/lite_mode.sh

# 3. Run it once immediately to test
sh /data/adb/service.d/lite_mode.sh