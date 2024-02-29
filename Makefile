build: clean
	fatpack pack ./scripts/rt-choose-workspace > ./dist/rofintmux
	chmod u+x ./dist/rofintmux

run: build
	./dist/rofintmux

clean:
	rm -f ./dist/rofintmux
