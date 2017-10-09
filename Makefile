# Update the specified dependencies
install:
	@command -v ruby >/dev/null 2>&1 || { echo >&2 "I require ruby but it's not installed. Aborting."; exit 1; }
	@command -v bundle >/dev/null 2>&1 || gem install bundler;
	bundle check || bundle install

# Run all the tests
test: bundler
	bundle exec rake spec

# Build a new package file
build:
	bundle exec gem build dovico-client.gemspec

# Publish a package on https://rubygems.org/gems/dovico
publish:
	bundle exec gem push $(PACKAGE_FILE)

# Private - ensure gems are up-to-date
bundler:
	bundle check>/dev/null || bundle install


.PHONY: install test build publish bundler
