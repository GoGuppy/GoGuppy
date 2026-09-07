# Disables fast startup so shutdown is a real shutdown.
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" HiberbootEnabled 0
