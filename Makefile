# Usage:
#   이 Makefile은 scripts/release.sh 쉘 스크립트를 활용해 릴리즈 명령을 실행합니다.
#
#   make help
#       사용 가능한 명령을 출력합니다.
#
#   make release 1.0.0
#       main 브랜치를 pull한 뒤 1.0.0 태그와 GitHub Release를 생성합니다.
#
#   make retag-release 1.0.0
#       1.0.0 태그를 현재 HEAD로 강제 이동하고 origin에 force push합니다.

.DEFAULT_GOAL := all

VERSION := $(word 2,$(MAKECMDGOALS))

.PHONY: all help release retag-release

all: help

help:
	@echo "사용법:"
	@echo "  make release <version>        새 릴리즈 태그와 GitHub Release 생성"
	@echo "  make retag-release <version>  기존 태그를 현재 HEAD로 이동 후 force push"

release:
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ 버전을 입력하세요."; \
		echo "예: make release 1.0.0"; \
		exit 1; \
	fi
	bash scripts/release.sh "$(VERSION)"

retag-release:
	@if [ -z "$(VERSION)" ]; then \
		echo "❌ 버전을 입력하세요."; \
		echo "예: make retag-release 1.0.0"; \
		exit 1; \
	fi
	@echo "⚠️ $(VERSION) 태그를 현재 HEAD로 이동합니다."
	git tag -fa "$(VERSION)" -m "release: $(VERSION)"
	git push origin "$(VERSION)" --force

%:
	@:
