# 📉 MTU & MSS Fragmentation Fixer

![Platform](https://img.shields.io/badge/Platform-MikroTik%20RouterOS-red)
![Issue](https://img.shields.io/badge/Issue-Path%20MTU%20Discovery-orange)
![Fix](https://img.shields.io/badge/Fix-Change%20MSS-green)

## 🆘 The Problem
"Facebook works, but my Banking website keeps loading forever."
This is a classic symptom of **MTU (Maximum Transmission Unit)** fragmentation issues.
- When a data packet is larger than the smallest link in the network path (e.g., a PPPoE tunnel), it gets dropped if the `Don't Fragment` (DF) bit is set.
- HTTPS and VPNs are most affected because encryption headers add overhead.

## 🛠️ The Solution
We cannot change the MTU of the entire internet. Instead, we force our router to modify the **MSS (Maximum Segment Size)** of TCP packets during the "Handshake" phase.
This script creates a dynamic "Mangle" rule that automatically clamps the packet size to fit through the tunnel.

## ⚙️ Technical Logic
- **Standard Ethernet MTU:** 1500 bytes.
- **PPPoE Overhead:** 8 bytes (Max MTU = 1492).
- **The Fix:** We tell the client PC: *"Hey, don't send packets bigger than 1452 bytes!"* (Change MSS).

## 🚀 Installation Guide

### Step 1: Apply the Fix
Upload `mtu_fix.rsc` to your MikroTik and import it:
```bash
/import mtu_fix.rsc

Step 2: Verification
Try opening the banking website or VPN connection that was failing. It should load instantly.

Step 3: Check Counters
Go to IP > Firewall > Mangle and watch the counters increment on the change-mss rules. This confirms it is actively fixing packets.

Author: Sheikh Alamin Santo
Network Reliability Engineer (NRE)
