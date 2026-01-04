.PHONY: help validate build render generate clean

help:
	@echo "Notebook Library Makefile"
	@echo ""
	@echo "Commands:"
	@echo "  make validate       - Validate all packs"
	@echo "  make validate-exec  - Validate and execute all packs"
	@echo "  make build          - Build release zips"
	@echo "  make render        - Render previews for all packs"
	@echo "  make generate      - Generate library.json"
	@echo "  make clean          - Clean dist directory"
	@echo "  make create-pack    - Create a new pack (interactive)"

validate:
	@python3 tools/validate_pack.py --all

validate-exec:
	@python3 tools/validate_pack.py --all --execute

build:
	@python3 tools/build_release.py

render:
	@python3 tools/render_previews.py --all

generate:
	@python3 tools/generate_library_json.py

clean:
	@rm -rf dist/*.zip

create-pack:
	@python3 tools/create_pack.py
