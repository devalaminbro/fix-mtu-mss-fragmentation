```rsc
# ============================================================
# Emergency Script 4: Fix MTU/MSS Fragmentation
# Author: Sheikh Alamin Santo
# Use Case: Fixes "Can't access specific websites" & VPN drops
# ============================================================

/ip firewall mangle

# --- 1. Fix for PPPoE & VPN Clients (Dynamic) ---
# This rule automatically detects the Interface MTU and adjusts the packet size.
# It applies to "Forward" chain (Traffic passing through the router).

add action=change-mss chain=forward new-mss=clamp-to-pmtu passthrough=yes \
    protocol=tcp tcp-flags=syn comment="Auto-Clamp MSS for VPN/PPPoE"

# --- 2. Hardcoded Fix (If Auto fails) ---
# Sometimes "clamp-to-pmtu" isn't enough. We manually set it to 1440 or 1360.
# Use this if you are using L2TP/IPsec which has high overhead.

add action=change-mss chain=forward new-mss=1440 passthrough=yes \
    protocol=tcp tcp-flags=syn tcp-mss=!0-1440 comment="Force MSS to 1440 (Safe Mode)"

# --- 3. Fix for IPv6 (If used) ---
# IPv6 headers are larger, so fragmentation issues are common.
/ipv6 firewall mangle
add action=change-mss chain=forward new-mss=clamp-to-pmtu passthrough=yes \
    protocol=tcp tcp-flags=syn comment="IPv6 Auto-Clamp MSS"

:log info "MTU/MSS Fix Applied. Browsing issues should be resolved."
