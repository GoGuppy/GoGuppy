(New-Object -ComObject Wscript.Shell).Popup("Your device needs a reboot. Please make sure everything is saved and reboot at your earliest convenience.", 900, "Reboot required", 0+48) > $null
exit 0
