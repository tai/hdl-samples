UCF = $(TOP)/$(TARGET)/$(BOARD).ucf
TCL = $(wildcard $(TOP)/board/$(BOARD)/config/*.tcl)

XMAKE = xilinx xtclsh $(TOP)/toolchain/ise/ise-make
IMPACT = xilinx impact

LD_PRELOAD = /opt/xilinx/usb-driver/lin64/libusb-driver.so 
export LD_PRELOAD

all: top.bit

prog: top.bit
	$(IMPACT) -batch $(TOP)/toolchain/ise/cmd/impact-prog.cmd

top.bit: $(SRCS) $(UCF) $(TCL)
	$(XMAKE) build -t top -p $(TARGET) $(SRCS) $(UCF) $(TCL)
