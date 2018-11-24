DEVICE:=fenix3_hr
COMPILEFLAGS:=
DOFLAGS:=

wait:=&
outfile:=bin/StatsGlance.prg

.PHONY: release compile test execute check-env

release: COMPILEFLAGS+= --release
release: outfile:=$(subst .prg,-release.prg,$(outfile))
release: $(outfile)

compile: $(outfile)

check-env:
ifndef KEY
	$(error KEY is undefined)
endif

$(outfile): check-env
	monkeyc \
		--warn \
		--output $(outfile) \
		--jungles monkey.jungle \
		--private-key "$(KEY)" \
		$(COMPILEFLAGS)

test: COMPILEFLAGS+= --unit-test
test: DOFLAGS+=-t
test: wait:=
test: outfile:=$(subst .prg,-test.prg,$(outfile))
test: execute

execute: $(outfile)
	monkeydo $(outfile) $(DEVICE) $(DOFLAGS) $(wait)
