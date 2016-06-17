TEST_COMMAND ?= py.test --verbose --debug --pdb tests

.PHONY: test-test
test-test:
	@# テストを実行します。

	@TEST_COMMAND
