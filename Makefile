default: clean
	sbt "runMain randlut.RandomLUTPipeDriver"
	dc_shell -f syn.tcl

clean: syn_clean
	rm -rf ./test_run_dir/*
	rm -f ./*.v
	rm -f ./*.json
	rm -f ./*.fir
	rm -f ./build/*

syn_clean:
	rm -rf out/ work/
	mkdir out
	mkdir work
