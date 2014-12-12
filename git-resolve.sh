#!/bin/bash

workingdir="`pwd`"

#filesstring=$(git ls-files -o --exclude-standard) #untracked files
filesstring=$(git diff --name-only --diff-filter=U)

IFS=$'\n' read -rd '' -a files <<< "$filesstring"

for element in "${files[@]}"
do
	echo ''
	echo "-------> Resolving: $element <--------"
	echo "type c to keep the change, type r to revert, i to ignore the file completely or press any other key to skip:"
	path="$workingdir/$element"
	read ACTION
	if [[ "r" = $ACTION ]]; then
            git reset HEAD $path
		    git checkout -- $path
		echo "Conflict resolved using mine for $element"
	elif [[ "i" = $ACTION ]]; then
		echo "Conflict resolved using ignore for $element"
	    git update-index --assume-unchanged $path
	elif [[ "c" = $ACTION ]]; then
		git checkout --theirs $path
		git add $path
	    #git reset -- $path
	    #git checkout MERGE_HEAD -- $path
		echo "Conflict resolved using theirs for $element"
	else
        echo "$element was skipped. Run git mergetool to resolve manually"
	fi
done
