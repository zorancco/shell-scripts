#!/bin/bash

workingdir="`pwd`"

filesstring=$(git diff --name-only --diff-filter=U)

IFS=$'\n' read -rd '' -a files <<< "$filesstring"

for element in "${files[@]}"
do
        echo ''
        echo "-------> Resolving: $element <--------"
        echo "type r to revert or press any other key to skip:"
        read ACTION
        if [[ "r" = $ACTION ]]; then
                path="$workingdir/$element"
                #echo "git reset HEAD $path"
                git reset HEAD $path
                git checkout -- $path
                echo ""
                echo "Conflict resolved using mine for $element"
        else 
               echo "$element was skipped. Run git mergetool to resolve manually"
        fi
done

