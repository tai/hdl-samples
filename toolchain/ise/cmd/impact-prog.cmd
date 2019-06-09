setmode -bs
setcable -p usb21
identify -inferir
assignFile -p 1 -file top.bit
program -p 1
exit
