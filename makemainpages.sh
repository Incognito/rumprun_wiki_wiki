#!/bin/sh

# NOTE!  Do not include categories with manual top level, e.g. Platforms!
CATEGORIES="Builds Info Howto Performance Repo Tutorial"

DESC_Builds='Automated builds and binary packages:'
DESC_Howto='Documentation for specific issues:'
DESC_Info='General information:'
DESC_Performance='Performance and optimizing performance:'
DESC_Repo='Main pages for repositories:'
DESC_Tutorial='Detailed tutorials aimed at starting from zero and
working towards mastering a subject:'

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

	if [ "${cat}" = "Repo" ]; then
		dashsub=''
	else
		dashsub='s/-/ /g'
	fi

	echo ${desc} > ${cat}.md
	echo >> ${cat}.md
	pages=$(echo ${cat}:*)
	for page in ${pages}; do
		sed 1q ${page} | grep -q RUMPWIKI_NOINDEX && continue
		txt=$(echo ${page} | sed "s/${cat}:-*//;${dashsub};s/\.md$//;")
		echo "- [[${txt}|${page%%.md}]]" >> ${cat}.md
	done
done
