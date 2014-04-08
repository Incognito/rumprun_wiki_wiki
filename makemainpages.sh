#!/bin/sh

# NOTE!  Do not include categories with manual top level, e.g. Platforms!
CATEGORIES="Builds Info Howto Performance Repo"

DESC_Builds="Pages about automated builds:"
DESC_Info="Pages containing general information:"
DESC_Howto="Pages with howtos and tutorials:"
DESC_Performance="Pages about performance and optimizing performance:"
DESC_Repo="Pages for repositories:"

#
# BEGIN Script
#

die ()
{

	echo ERROR: $* 1>&2
	exit 1
}

[ -f ./makemainpages.sh -a -f _Sidebar.md ] || die Run in wiki directory

for cat in ${CATEGORIES}; do
	eval desc=\${DESC_${cat}}
	[ -z "${desc}" ] && { echo ${cat} is missing DESC; exit 1; }

	echo ${desc} > ${cat}.md
	echo >> ${cat}.md
	pages=$(echo ${cat}:*)
	for page in ${pages}; do
		txt=$(echo ${page} | sed "s/${cat}:-*//;s/-/ /g;s/\.md$//;")
		echo "- [[${txt}|${page%%.md}]]" >> ${cat}.md
	done
done
