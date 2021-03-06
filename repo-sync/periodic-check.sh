#! /bin/bash -eux

# Periodic job to keep the local mirror updated. This script takes snapshot
# of any arbitrary directory, if the update job actually says there ARE
# updates to be downloaded for one particular repository and one particular
# distribution. For example, you can say that for in.archive.ubuntu.com
# repository, for Precise, if there are any updates, take a snapshot.
# Currently, you cannot specify more than one repository, or distribution to
# take snapshot against.
#
# This script writes status to STDOUT.

MIRRORCONF=/etc/apt/mirror.list

DIST=precise
RELEASE=/home/repo/repo/mirror/jiocloud.rustedhalo.com/ubuntu/dists/$DIST/Release

SNAPSRC=/home/repo/repo
SNAPDEST=/home/repo/repo-snapshots

OLDMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

echo "---------------------------------------------"

sudo apt-mirror $MIRRORCONF

NEWMD5=`cat $RELEASE | grep main/binary-amd64/Packages$ | head -1 | cut -d' ' -f2`

echo "Old and new MD5: $OLDMD5 $NEWMD5"
echo "Time: `date`"

if [ "$OLDMD5" = "$NEWMD5" ]; then
    echo "No new packages found"
else
    /home/rushi/scripts/snapshot.sh $SNAPSRC $SNAPDEST
    echo "New packages found."
fi

