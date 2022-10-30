branches = $(shell curl https://raw.githubusercontent.com/nix-community/dream2nix-auto-test/main/indexes.json | jq .[].name -r)
jsons = $(addsuffix /translation-errors.json,${branches})

.PHONY: $(jsons)
all: $(jsons)

${jsons}: %/translation-errors.json: %
	git worktree add $<-temp $<
	cp -r $<-temp/translation-errors* $<
	git worktree remove $<-temp
