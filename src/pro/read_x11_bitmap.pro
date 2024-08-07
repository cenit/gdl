;+
;
; NAME: READ_X11_BITMAP
;
; PURPOSE: Reads an X11 BITMAP file (.xbm)
;
; CATEGORY: Images (IO)
;
; CALLING SEQUENCE:
; 
;      READ_X11_BITMAP, filename, bitmap , [X, Y ]
;
; KEYWORD PARAMETERS: 
;
;      /EXPAND_TO_BYTES: returns in 'bitmap' an array of bytes, 0b for bit
;      not set, 255b for bit set.
;
; OUTPUTS:
; 
;      byte array 'bitmap'
;
; OPTIONAL OUTPUTS:
; 
;      X: size of returned array in 1st dimension
;      Y: size of returned array in 2nd dimension
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;         Requires ImageMagick (that means that GDL must have been
;         compiled with ImageMagick)
;
; PROCEDURE:
;         Use ImageMagick to read the data as requested
;
; EXAMPLE: 
;         read_x11_bitmap,'/tmp/toto.xpm',bitmap
;         b=widget_button(base,value=bitmap,/bitmap)
;
; MODIFICATION HISTORY:
;    Written by: Gilles Duvert : 2016-05-20, as a derivative work from READ_JPEG
;-
; LICENCE:
; Copyright (C) 2016
; This program is free software; you can redistribute it and/or modify  
; it under the terms of the GNU General Public License as published by  
; the Free Software Foundation; either version 2 of the License, or     
; (at your option) any later version.                                   
;
;-
;
PRO READ_X11_BITMAP, filename, bitmap , X, Y , expand_to_bytes=expand_to_bytes
;

compile_opt hidden, idl2

ON_ERROR, 2

;
; this line allows to compile also in IDL ...
FORWARD_FUNCTION MAGICK_EXISTS, MAGICK_PING, MAGICK_READ
;
if KEYWORD_SET(help) then begin
    print, 'pro READ_X11_BITMAP, filename, bitmap [, X, Y ,], /EXPAND_TO_BYTES'
    return
endif
;
; Do we have access to ImageMagick functionnalities ??
;
if (MAGICK_EXISTS() EQ 0) then begin
    MESSAGE, /continue, "GDL was compiled without ImageMagick support."
    MESSAGE, "You must have ImageMagick support to use this functionaly."
endif
;
; AC 2011-Aug-18: this test will be wrong when UNIT will be available
if (N_PARAMS() NE 2 AND N_PARAMS() NE 4) then MESSAGE, "Incorrect number of arguments."
;
if (N_ELEMENTS(filename) GT 1) then MESSAGE, "Only one file at once !"
if (STRLEN(filename) EQ 0) then MESSAGE, "Null filename not allowed."
if ((FILE_INFO(filename)).exists EQ 0) then MESSAGE, "Error opening file. File: "+filename
if (FILE_TEST(filename, /regular) EQ 0) then MESSAGE, "Not a regular File: "+filename
;
; testing whether the format is as expected
;
if ( ~MAGICK_PING(filename, 'XBM') ) then  MESSAGE, "Not a XBM file."

READ_ANYGRAPHICSFILEWITHMAGICK, filename, bitmap, colortable ; returns an 'expanded bitmap 0 or 1'
sz = size(bitmap)
 x=sz[1]
 y=sz[2]

; compact bitmap (normal case)
if ~keyword_set(expand_to_bytes) then bitmap=cvttobm(bitmap) else bitmap*=255b

end 
