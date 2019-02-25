#!/bin/bash

set -eu

version=1.6.9
name=asciidocfx
url=https://github.com/$name/AsciidocFX/releases/download/v$version/$name-$version.zip

filters=""
patterns=( node_modules )

if [[ -f "$PWD/.gitignore" ]]; then
  patterns=( $(cat $PWD/.gitignore) )
fi

for expr in "${patterns[@]}"; do
  if [[ "$expr" =~ "." ]]; then
    filters+="! -iregex '.*\\$(echo $expr | sed 's/\*\./.*\\./g').*' "
  else
    filters+="! -iregex '.*/$(echo $expr | sed 's/\*\./.*\\./g')/.*' "
  fi
done

all_docs=( $(eval find $PWD -type f "\( -iname '*.adoc' ! -iregex '.*.git.*' $filters\)" | sort -n) )

if [[ "${1:-}" != "--fx" ]]; then
  if [[ -z "$(which asciidoctor)" ]]; then
    echo "Missing asciidoctor, try \`sudo gem install asciidoctor\`"
    exit 1
  fi

  for doc in "${all_docs[@]}"; do
    dest="$PWD/$(echo $name/docs$(dirname $doc | sed "s|$PWD||g")/$(basename $doc '.adoc') | sed 's/\.\///g').html"

    if [ "$dest" -ot "$doc" ]; then
      asciidoctor -t -D $(dirname $dest) $doc
    fi
  done

  if [[ "${1:-}" = "--live" ]]; then
    if [[ -z "$(which live-server)" ]]; then
      echo "Missing live-server, try \`npm install -g live-server\`"
      exit 1
    fi

    port="${PORT:-3001}"

    if [[ ! -z "${2:-}" ]]; then
      port="$2"
    fi

    live-server "$PWD/$name/docs" --port=$port --no-browser
  fi

  if [[ "${1:-}" = "--watch" ]]; then
    if [[ -z "$(which nodemon)" ]]; then
      echo "Missing nodemon, try \`npm install -g nodemon\`"
      exit 1
    fi

    nodemon -e adoc -i "$PWD/$name" -x "$0"
  fi
else
  if [[ ! -d "$name/bin" ]]; then
    echo "Downloading AsciidocFX..."

    curl -sL $url -o $PWD/$name.zip
    unzip -q $PWD/$name.zip -d $PWD/$name
    chmod +x $PWD/$name/bin/$name
    rm $PWD/$name.zip
  fi

  java_dir="${JAVA_HOME:-}"

  if [[ -z "$JAVA_HOME" ]] || [[ ! -d "$JAVA_HOME" ]]; then
    java_dir=`/usr/libexec/java_home`
  fi

  JAVA_HOME="$java_dir" "$PWD/$name/bin/$name" "${all_docs[@]}"
fi
