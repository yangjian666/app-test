TESTS             = $(shell find tests -type f -name test-*)

-COVERAGE_DIR    := out/test/
-RELEASE_DIR     := out/release/

-RELEASE_COPY    := lib config.yaml

-BIN_MOCHA       := ./node_modules/.bin/mocha
-BIN_ISTANBUL    := ./node_modules/.bin/istanbul
-BIN_COFFEE      := ./node_modules/.bin/coffee

-TESTS           := $(sort $(TESTS))

-COVERAGE_TESTS  := $(addprefix $(-COVERAGE_DIR),$(-TESTS))
-COVERAGE_TESTS  := $(-COVERAGE_TESTS:.coffee=.js)

-TESTS_ENV       := tests/env.js

-LOGS_DIR        := logs

-GIT_REV         := $(shell git show | head -n1 | cut -f 2 -d ' ')
-GIT_REV         := $(shell echo "print substr('$(-GIT_REV)', 0, 8);" | /usr/bin/env perl)

default: dev

-common-pre: clean -npm-install -logs

dev: -common-pre
	@$(-BIN_MOCHA) \
		--colors \
		--ignore-leaks  \
		--compilers coffee:coffee-script/register \
		--reporter spec \
		--growl \
		--require $(-TESTS_ENV) \
		$(-TESTS)

test: -common-pre
	@$(-BIN_MOCHA) \
		--no-colors \
		--ignore-leaks \
		--compilers coffee:coffee-script/register \
		--reporter tap \
		--require $(-TESTS_ENV) \
		$(-TESTS)

-pre-test-cov: -common-pre
	@echo 'copy files'
	@mkdir -p $(-COVERAGE_DIR)

	@rsync -av . $(-COVERAGE_DIR) --exclude out --exclude .git --exclude node_modules
	@rsync -av ./node_modules $(-COVERAGE_DIR)
	@$(-BIN_COFFEE) -cb out/test
	@find ./out/test -path ./out/test/node_modules -prune -o -name "*.coffee" -exec rm -rf {} \;

test-cov: -pre-test-cov
	@cd $(-COVERAGE_DIR) && \
	  $(-BIN_ISTANBUL) cover ./node_modules/.bin/_mocha -- -u bdd -R tap $(patsubst $(-COVERAGE_DIR)%, %, $(-COVERAGE_TESTS)) && \
	  $(-BIN_ISTANBUL) report html

-release-pre : -common-pre
	@echo 'copy files'
	@mkdir -p $(-RELEASE_DIR)

	@if [ `echo $$OSTYPE | grep -c 'darwin'` -eq 1 ]; then \
		cp -r $(-RELEASE_COPY) $(-RELEASE_DIR); \
	else \
		cp -rL $(-RELEASE_COPY) $(-RELEASE_DIR); \
	fi
	@echo $(-GIT_REV)
	# @echo "$(-RELEASE_DIR)etc/config.yaml"
	# @cat $(-RELEASE_DIR)etc/config.yaml | sed 's/@@rev@@/$(-GIT_REV)/g' > $(-RELEASE_DIR)etc/config.backup.yaml
	# @mv -f $(-RELEASE_DIR)etc/config.backup.yaml  $(-RELEASE_DIR)etc/config.yaml
	# @cp -f $(-RELEASE_DIR)config.yaml  $(-RELEASE_DIR)config.yaml 
	@cd $(-RELEASE_DIR)

	@cp package.json $(-RELEASE_DIR)

	@cd $(-RELEASE_DIR) && PYTHON=`which python2.6` npm --color=false --registry=http://registry.npm.alibaba-inc.com install --production


release: -release-pre
	@rm -fr $(-RELEASE_DIR)/tests
	@echo "all codes in \"$(-RELEASE_DIR)\""

.-PHONY: default

-npm-install:
	@npm --color=false --registry=http://registry.npm.alibaba-inc.com install

clean:
	@echo 'clean'
	@-rm -fr out
	@-rm -fr $(-LOGS_DIR)

-logs:
	@mkdir -p $(-LOGS_DIR)