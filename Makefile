
all prog:
ifeq ($(TARGET),)
	@echo "Type: make TARGET=... BOARD=... TOOLCHAIN=..."
	@echo "Example:"
	@echo "  $ make TARGET=blink BOARD=s3e-sk TOOLCHAIN=ise"
else
	mkdir -p build
	$(MAKE) -C build -f ../Makefile.build -$(MAKEFLAGS) "$@"
endif

clean:
	rm -fr build

gitclean:
	git ls-files -o | xargs rm -f
	find * -depth -type d -print | xargs rmdir --ignore-fail-on-non-empty
