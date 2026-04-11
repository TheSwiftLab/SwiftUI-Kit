#!/bin/bash

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "❌ 버전을 입력하세요."
  echo "예: ./release.sh 1.0.0"
  exit 1
fi

echo "🚀 Release version: $VERSION"

# 최신 코드 가져오기
git pull origin main

# 태그 생성
# 현재 커밋을 4.7.0 버전 태그로 표시하고 메시지를 "release: 4.7.0" 로 남긴다
git tag -a "$VERSION" -m "release: $VERSION"

# 태그 push
git push origin "$VERSION"

# GitHub Release 생성
gh release create "$VERSION" \
  --title "$VERSION" \
  --notes "Release $VERSION"

echo "✅ Release $VERSION 완료"