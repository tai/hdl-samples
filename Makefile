USE = iv

APP = $(foreach top,$(wildcard */top.v),$(subst /top.v,,$(top)))
GEN = $(MAKE) -C build -f ../Makefile.$(USE) -$(MAKEFLAGS)

help:
	@echo "Type: make <target> APP=... TOP=... BOARD=... USE=..."
	@echo "Example:"
	@echo "  $$ make clean"
	@echo "  $$ make test"
	@echo "  $$ make test APP=blink"
	@echo "  $$ make all APP=blink TOP=top BOARD=s3esk USE=ise"

%:
	mkdir -p build
	set -e; for i in $(APP); do $(GEN) APP=$$i $@; done

clean:
	$(RM) *.old *.bak *~
	$(RM) -r build

gitclean:
	git ls-files -o | xargs rm -f
	find * -depth -type d -print | xargs rmdir --ignore-fail-on-non-empty
