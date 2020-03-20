#!/bin/bash

#SalesForce Partial Deployment script
#Created by: Algis Kukenas
#Version: 1.2
#Updates:
#  - For story mode, multi VersionOne items are now supported
#  - Updated help text and comments
#Documentation: https://legalzoom.atlassian.net/wiki/spaces/DEVOPS/pages/131634869/SalesForce_Build

case "$1" in
  ""|"-h")
    echo -e "Usage: sf_partial_deployment_creation.sh [mode] \"[value|value1,value2,...]\" [git branch] [jenkins build number]"
    echo "modes:"
    echo "-s : story mode; pass one or more V1 items (enclosed in quotes), git branch, and Jenkins build number (optional)"
    echo "-c : commit mode: pass number of commits to go back, git branch, and Jenkins build number (optional)"
    exit 0
    ;;
  "-s")
    mode="story"
    if [ -n "$2" ]
      then
        v1_stories=$2
        if [[ -z $(echo "$v1_stories" | grep -i "[B|D|TK][-]\?[0-9]") ]]
          then
            echo "$v1_stories does not contain a valid V1 item. Exiting."
            exit 1
        fi
        echo "V1 items $v1_stories will be used"
        v1_items=$(echo $v1_stories|sed 's/[ ,]\+/_/g')
        git_file="git_files_${v1_items}.txt"
      else
        echo "No V1 story was passed. Exiting"
        exit 1
    fi
    if [ -n "$3" ]
      then
        git_branch=$3
        echo "git_branch: $git_branch"
        echo "going to do an explicit git checkout $git_branch"
        git checkout $git_branch
      else
        echo "No git branch was passed. Exiting"
        exit 1
    fi
    if [ -n "$4" ]
      then
        build_number=$4
        echo "build_number: $build_number"
    fi
    ;;
  "-c")
    mode="commit"
    if [ -n "$2" ]
      then
        commits_back=$2
        echo "The script will go back $commits_back commits for its starting point."
        git_start=$(git rev-parse --short HEAD~${commits_back})
        git_end=$(git rev-parse --short HEAD)
        #creating text file name that will contain added and modified files
        git_file="git_files_${git_start}_${git_end}.txt"
      else
        echo "No value was passed for the number of commits to go back. Exiting"
        exit 1
    fi
    if [ -n "$3" ]
      then
        git_branch=$3
        echo "git_branch: $git_branch"
      else
        echo "No git branch was passed. Exiting"
        exit 1
    fi
    if [ -n "$4" ]
      then
        build_number=$4
        echo "build_number: $build_number"
    fi
    ;;
  *)
    echo "A valid mode was not used. Exiting."
    exit 1
    ;;
esac

echo "Listing of files added or modified" > $git_file
echo "----------------------------------" >> $git_file

if [ "$mode" = "commit" ]
  then
    #grabbing file list from git based off of two commits
    git log --oneline --name-status --diff-filter=d ${git_start}..${git_end} >> $git_file
elif  [ "$mode" = "story" ]
  then

    #grabbing file list from git based off of V1 items in git commit notes
    #(IFS=" ,";for v1_story in $v1_stories; do \
    #  IFS=$' \t\n'; \
    #  echo "v1_story: $v1_story"; \
    #  echo "Git commits associated with $v1_story:" ;\
    #  git log --pretty=oneline|grep -i ${v1_story} |awk '{print $1}' ;\
    #  for j in `git log --pretty=oneline|grep -i ${v1_story} |awk '{print $1}'`; do git show --pretty=oneline --name-status "${j}"; done >> $git_file;
    #  echo "Finished writing to $git_file" for $v1_story; \
    #  echo "Going to determine the latest commit ID for ${v1_story}"; \
    #  latest_commit=$(sed -n '3p' $git_file | awk '{print $1}') ; \
    #  echo "the latest commit ID is $latest_commit. Going to checkout $latest_commit"; \
    #  git checkout $latest_commit; \
    #done)
    
      echo "v1_stories: $v1_stories"
      echo "Git commits associated with $v1_stories:"
      v1_search=$(echo $v1_stories | sed 's/[ ,]/|/g') 
      git_log=$(git log --pretty=oneline|grep -iE ${v1_search} |awk '{print $1}')

      if [ -z "$git_log" ]
      then
        echo "Can not determine git commits associated with $v1_stories. Exiting."
        exit 1
      else
        (IFS=$' \t\n'; for i in $git_log; do echo $i; done)
        echo
      fi

      for j in `(IFS=$' \t\n'; for i in $git_log; do echo $i; done)`; do git show --pretty=oneline --name-status "${j}"; done >> $git_file
      echo "Finished writing to $git_file for ${v1_stories}"
      echo "Going to determine the latest commit ID for ${v1_stories}"
      latest_commit=$(sed -n '3p' $git_file | awk '{print $1}')

      if [ -z "$latest_commit" ]
      then
        echo "Can not determine latest commit. Exiting."
        exit 1
      fi

      echo "The latest commit ID is $latest_commit. Going to checkout affected files from $latest_commit"
      for i in $(for j in `git log --pretty=oneline|grep -iE ${v1_search} |awk '{print $1}'`; do git show --pretty="" --name-only "${j}"; done|grep -v ".git"|sort|uniq)
      do
        echo "Checking out $i from commit ID $latest_commit"
        git checkout $latest_commit $i
      done
else
  echo "There is no mode value. Exiting"
  exit 1
fi

echo "Checking git_file $git_file"
if [[ $(grep "src/" $git_file | awk '{print $2}' | grep -viE "\-meta.xml|.js|package.xml|.txt|\.sh|Jenkinsfile|.gitignore|.css|.svg|.auradoc|.design" | wc -l) -eq 0 ]]
then
  echo "There aren't any SalesForce components to deploy. Exiting with exit code 1"
  exit 1
fi

#going to filer out any files that are not in src/; also excluding any js, shell scripts, text files, package.xml, and Jenkinsfile
for i in $(grep "src/" $git_file | awk '{print $2}' | grep -viE "\-meta.xml|.js|package.xml|.txt|\.sh|Jenkinsfile|.gitignore|.css|.svg|.auradoc|.design" | sort | uniq)
do

  #for troubleshooting
  #echo "=================================================="
  #echo $i
  #end of troubleshooting

  #need to xmllint xml file in order for sed to work
  if [ -e  ${i}-meta.xml ]
  then
    name=$(xmllint ${i}-meta.xml | sed -e '$!d' -e 's|</||' -e 's/>//')
  else
    name=$(xmllint ${i} | sed -e '$!d' -e 's|</||' -e 's/>//')
  fi  

  member=$(echo $i|awk -F/ '{print $NF}'|awk -F. '{print $1}')
  echo $name $member

  #for troubleshooting
  #echo "=================================================="
  #name=""
  #member=""
  #end of troubleshooting

done | sort | uniq > ./project_xml_raw_data.txt

echo '<?xml version="1.0" encoding="UTF-8"?>' > package.xml
echo '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' >> package.xml

for i in $(awk '{print $1}' ./project_xml_raw_data.txt | sort | uniq)
do
  echo '  <types>' >> package.xml
  grep ${i} project_xml_raw_data.txt | awk '{print "    <members>"$2"</members>"}' >> package.xml
  echo "    <name>${i}</name>" >> package.xml
  echo '  </types>' >> package.xml
done

echo '  <version>40.0</version>' >> package.xml
echo '</Package>' >> package.xml

if [ -d artifact ]
then
  echo "artifact directory exists. Deleting it."
  rm -fr ./artifact
  echo "Creating artifact directory."
  mkdir ./artifact
else
  echo "artifact directory does not exists. Creating it."
  mkdir ./artifact
fi

cp $git_file ./artifact
cp project_xml_raw_data.txt ./artifact
for i in $(grep "src/" ${git_file} |awk '{print $2}' | sort | uniq)
do
  cp --parents $i ./artifact
  if [ -e  ${i}-meta.xml ]
  then
    cp --parents ${i}-meta.xml ./artifact
  fi
done
cp package.xml ./artifact/src

cd ./artifact


if [ "$mode" = "commit" ]
  then
    if [ -n "$build_number" ]
      then build_number=_${build_number}
    fi
    zip_file="sf_${git_branch}_$(date +%Y%m%d)${build_number}_${git_start}_${git_end}.zip"
elif [ "$mode" = "story" ]
  then 
    if [ -n "$build_number" ]
      then build_number=_${build_number}
    fi
    zip_file="sf_${git_branch}_$(date +%Y%m%d)${build_number}_${v1_items}.zip"
else
  echo "There is no mode value. Exiting"
  exit 1
fi

zip -r ../${zip_file} .

cd ..

echo "Modifing ./lib/build.properties to include $zip_file" 
sed -i "s/.*sf.zipFile.*/sf.zipFile = ${zip_file}/" ./lib/build.properties

exit 0
