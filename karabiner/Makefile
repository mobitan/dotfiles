all:
	scripts/update-json.sh
	cp docs/json/*.json ../.config/karabiner/assets/complex_modifications/

rebuild:
	touch src/json/*
	$(MAKE) all
	scripts/apply-lint.sh

server:
	ruby -rwebrick -e 'WEBrick::HTTPServer.new(:DocumentRoot => "./docs", :Port => 8000).start'
