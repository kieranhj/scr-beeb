.PHONY:default
default:
	$(error Specify target)

.PHONY:extract_pngs
extract_pngs:
	mkdir -p tmp
	python ./ssd_extract.py -o tmp ../scr-beeb.ssd
	python ./extract_pngs.py
