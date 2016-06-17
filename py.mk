# Need PACKAGE_NAME
VERSION_FILE ?= src/$(PACKAGE_NAME)/__init__.py
BUILD_LOG ?= .build.log


.PHONY: py-version
py-version:
	@# versionを表示します。

	@rm -f $(BUILD_LOG)
	@python setup.py build 2> $(BUILD_LOG) 1> /dev/null
	@if [ -s $(BUILD_LOG) ]; then cat $(BUILD_LOG); exit 1; fi
	@grep "^Version" `gfind -name PKG-INFO` | cut -d " " -f 2


.PHONY: py-bump
py-bump:
	@## version=VERSION
	@#
	@# versionをbumpします。

	@if [ "$(version)" == "" ]; then echo "You must specify the version.\nex) make bump version=VERSION"; exit 1; fi
	@sed -i -e "s/$(shell make version)/$(version)/" $(VERSION_FILE)


.PHONY: py-release-production
py-release-production:
	python setup.py sdist bdist_wheel upload


.PHONY: py-release-test
py-release-test:
	python setup.py sdist bdist_wheel upload -r https://testpypi.python.org/pypi
