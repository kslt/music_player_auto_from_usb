# music_player_auto_from_usb

1. Skapa .sh filen (finns en mall)
2. Gör filen körbar
3. Skapa playusb.service filen (finns en mall)
4. Ladda om daemon
5. Aktivera tjänsten
6. Starta tjänsten
7. Kolla statusen på tjänsten så allt ser okej ut (ska komma ljud ur högtalaren också om en USB sticka med filer är inkopplad)

Gör .sh filen körbar: 
chmod +x /home/tekniker/playusb.sh

Aktivera tjänsten: 
sudo systemctl daemon-reload
sudo systemctl enable playusb.service
sudo systemctl start playusb.service
sudo systemctl status playusb.service

Logg:
journalctl -u playusb.service -f

Status för tjänsten (och kort logg):
systemctl status playusb.service

Loggfil:
cat /home/tekniker/playusb.log