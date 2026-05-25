# RasPi
Collection of things for use on Raspberry Pi

## get_status.sh and get_status_basic.sh
Scripts to pull information from running Pi.
The basic version does not include information for PiHole or Unbound.
Both versions will pull the following:

* System Information
  * Hostname
  * Model
  * OS
  * Kernel
  * Architecture
  * Uptime
* Temperature
* Memory Usage (free -h)
* Disk Usage
* Network info
  * Local IP & Gateway
* DNS Test
  * Provides a (much) shortened 'dig' reply to 'google.com'
    * Provides google.com resolved IP & DNS server address (useful for ensuring Unbound is working)
* CPU Load info
* Top 6 processes
  
Non-Basic will pull additionally:
* PiHole status via 'pihole status'
* Unbound status via 'service unbound status'
