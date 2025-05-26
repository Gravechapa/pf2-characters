#!/bin/bash
cd "$(dirname -- "${0}")"

VERSION=$1
MSG=$2

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Wrong version format"
  exit 0
fi

if [ -z "$MSG" ]; then
    echo "Empty commit msg."
    exit 1
fi


sed -i "/\"version\":/c\  \"version\": \"${VERSION}\"," ./module.json
sed -i "/\"download\":/c\  \"download\": \"https://github.com/Gravechapa/pf2-characters/releases/download/v${VERSION}/module.zip\"," ./module.json

git diff module.json

while true
do
    read -r -p 'Do you want to continue? ' choice
    case "$choice" in
      n|N) break;;
      y|Y) 
        git add ./module.json
        git commit -m "${MSG}"
        git tag "v${VERSION}"
        git push
        git push origin "v${VERSION}"
        break;;
      *) echo 'Response not valid';;
    esac
done

exit 0
