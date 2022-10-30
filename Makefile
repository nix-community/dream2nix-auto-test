branches = $(shell curl https://raw.githubusercontent.com/nix-community/dream2nix-auto-test/main/indexes.json | jq .[].name -r)
jsons = $(addsuffix /translation-errors.json,${branches})
icons = $(addsuffix .svg,${branches})

.PHONY: $(jsons) $(icons) all pretty
all: $(jsons) $(icons)

.ONESHELL:
${icons}: %.svg: %
	export evalId=$$(curl 'https://hercules-ci.com/api/v1/site/github/account/nix-community/project/dream2nix-auto-test/jobs?limit=1&ref=refs/heads/$<' | jq .items[0].id -r)
	export build=$$(curl "https://hercules-ci.com/api/v1/jobs/$${evalId}/evaluation" | jq '.attributes|map(.|select(.path[0]=="checks")|(select(.value.Ok.status != "BuildSuccess")))|length')
	export translation=$$(cat $</translation-errors.json | jq 'length')
	export failure=$$(( build + translation))
	export total=$$(cat indexes.json | jq -r 'map(.|select(.name =="$<"))[].number')
	export color="rgb($$(( 2 * 256 * $$failure / $$total)),$$(( 256 - 2 * 256 * $$failure / $$total)),64)"
	export name="$<"
	envsubst < template.svg > $<.svg

pretty:
	js-beautify -r -t -w 100 templates/* index.html

${jsons}: %/translation-errors.json: %
	git worktree add $<-temp $<
	cp -r $<-temp/translation-errors* $<
	git worktree remove $<-temp
