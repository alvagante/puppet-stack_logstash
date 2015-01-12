#!/bin/bash
basedire='modules/public/stack_logstash/bin'
if [ ! -f $basedire/params_refactor.sed ] ; then
    echo "Cant find $basedire/params_refactor.sed"
    echo "Run this script from your project repo base directory:"
    echo "${basedire}/params_refactor.sh"
    exit 1
fi

SETCOLOR_NORMAL="echo -en \\033[0;39m"
SETCOLOR_BOLD="echo -en \\033[0;34m"

echo_title () {
 echo
 $SETCOLOR_BOLD ; echo $1 ; $SETCOLOR_NORMAL
}

echo_title "CHANGING HIERA FILES"

for file in $( find hiera -type f | grep -v ".git" | cut -d ":" -f 1 ) ; do
    # Detect OS
    if [ -f /System/Library/Accessibility/AccessibilityDefinitions.plist ] ; then
      sed -i "" -f $basedire/params_refactor.sed $file && echo "Processed: $file"
    else
      sed -i -f $basedire/params_refactor.sed $file && echo "Processed: $file"
    fi
done


echo_title "CHANGING TEMPLATES IN LOCAL SITE MODULE"
for file in $( find modules/local/site/templates -type f | grep -v ".git" | cut -d ":" -f 1 ) ; do
    # Detect OS
    if [ -f /System/Library/Accessibility/AccessibilityDefinitions.plist ] ; then
      sed -i "" -f $basedire/params_refactor.sed $file && echo "Processed: $file"
    else
      sed -i -f $basedire/params_refactor.sed $file && echo "Processed: $file"
    fi
done



echo_title "WELL DONE"
echo "Now use git diff to show the changes made and puppet agent -t --noop on clients to test them"
echo "Good luck!"

