.PHONY: sphinx-build
sphinx-build:
	@## make docs ouput=OUTPUT_DIR

	cd docs; make dirhtml
	if [ $(output) ]; then \
		mkdir -p $(output); \
		tar -c docs/build/dirhtml -C docs/build/dirhtml "./" | tar xfp - -C $(output); \
	fi
