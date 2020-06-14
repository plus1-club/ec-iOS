#!/bin/sh

#  ecelectric.sh
#  ecelectric
#
#  Created by Sergey Lavrov on 13.06.2020.
#  Copyright © 2020 +1. All rights reserved.

#git=$(sh /etc/profile; which git)
#number_of_commits=$("$git" rev-list HEAD --count)
#git_release_version=$("$git" describe --tags --always --abbrev=0)
#
#target_plist="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
#dsym_plist="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"
#
#for plist in "$target_plist" "$dsym_plist"; do
#  if [ -f "$plist" ]; then
#    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $number_of_commits" "$plist"
#    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_release_version#*v}" "$plist"
#  fi
#done

git_tag=$(git describe --tags --always --abbrev=0)
git_version=$(git rev-list HEAD --count)

#info_plist="${INFOPLIST_FILE}"
#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${git_tag}'" "${info_plist}"
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${git_version}'" "${info_plist}"

#dsym_plist="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist"
#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${git_tag}'" "${dsym_plist}"
#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${git_version}'" "${dsym_plist}"

if [ "${Build}" = "" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${git_version}" "$INFOPLIST_FILE"
else
  Build=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
  Build=$(echo "scale=0; $Build + ${git_version}" | bc)
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $Build" "$INFOPLIST_FILE"
fi
if [ "${Version}" = "" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_tag}" "$INFOPLIST_FILE"
else
  Version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
  Version=$(echo "scale=2; $Version + ${git_tag}" | bc)
  if [ "${CONFIGURATION}" = "Release" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $Version" "$INFOPLIST_FILE"
  fi
fi

sourceFilePath="$PROJECT_DIR/$PROJECT_NAME/Base.lproj/LaunchScreen.storyboard"
sed -i .bak -e "/userLabel=\"APP_VERSION\"/s/text=\"[^\"]*\"/text=\"version $git_tag.$git_version\"/" "$sourceFilePath"

