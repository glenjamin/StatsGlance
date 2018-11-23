DEVICE=fenix3_hr

testflag=
outfile=bin/StatsGlance.prg

.PHONY: test execute check-env

default: $(outfile)

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
		$(testflag)

# would rather use --unit-test but that doesn't work on monkeydo
test: testflag=-t
test: execute

execute: $(outfile)
	monkeydo $(outfile) $(DEVICE) $(testflag)
