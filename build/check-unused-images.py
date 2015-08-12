#!/usr/bin/python

import os,sys,re

# Find which images are actually used
used = set([])

# Find from DocBook files
# Note that this uses grep and does not know about outcommented code
pin = os.popen("grep imagedata chapter-*.xml", "r")
imagedatalines = pin.readlines()
pin.close
for imagedataline in imagedatalines:
    imagedataline = imagedataline.strip()
    m = re.search(r'fileref="(.+)"', imagedataline)
    if m:
        used.add(m.group(1))
    else:
        print "Did not match:", imagedataline
        sys.exit(1)

# Find from DocBook files
# Note that this uses grep and does not know about outcommented code
pin = os.popen("grep 'xlink:href=\"[^#]' original-drawings/*/*.svg", "r")
imagedatalines = pin.readlines()
pin.close
for imagedataline in imagedatalines:
    imagedataline = imagedataline.strip()
    m = re.search(r'href=".*(img/.+)"', imagedataline)
    if m:
        used.add(m.group(1))
    else:
        print "Did not match:", imagedataline

# Find the existing image files
existing = set([])
pin = os.popen("find img -type f", "r")
imagedatalines = pin.readlines()
pin.close
for imagedataline in imagedatalines:
    imagedataline = imagedataline.strip()
    existing.add(imagedataline)

print "Unused:"
unused = list(existing - used)
unused.sort()
for img in unused:
    print img,
print

print "Missing:"
missing = list(used - existing)
missing.sort()
for img in missing:
    print img,
print
