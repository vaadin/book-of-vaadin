================================================================================
Building Vaadin Documentation
================================================================================

PDF Version of the Manual

  You can build only the PDF version of the Manual with:

  $ ant manual-pdf

Pocket Book Format

  To build PDF manual with the pocket book format:

  $ ant manual-pdf -Dmanual.fo.style=-pocket

Building Tutorial

  $ ant tutorial

------------------------------------
Requirements for building the manual
------------------------------------

You need
  - XEP installed to /opt/RenderX/XEP
  - licence.xml file in the directory
  - OR in the build/lib/XEP directory

---------------------------------
Rebuilding title page stylesheets
---------------------------------

  There are currently two titlepage style definitions:

    - docbook/conf/custom-fo-titlepage.xml
    - docbook/conf/custom-fo-titlepage-pocket.xml

  These files are used for generating the actual
  XSL files, with the following command:
  
   $ cd docbook
   $ make

----------
Font Setup
----------

For building the book using the special Vaadin fonts, put
the font files as follows:

  lib/XEP/fonts/HelveticaRoundedLTStd-Bd.otf
  lib/XEP/fonts/HelveticaLTStd-Light.otf

Enable the special fonts with
   -Dmanual.fonts.custom=1

