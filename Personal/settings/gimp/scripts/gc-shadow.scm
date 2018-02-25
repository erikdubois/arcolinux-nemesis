; GC Shadow V1.2 (07-2013) - (c) Copyright 2013 GPLv3
;
; Created by GnuTux
;
; Special thanks to Graechan and SaulGoode for their contributions
;
; ===========================
; Improved Drop Shadow Script
; ===========================
; Added Glow, Inner Shadow, Inner Glow and Feathering
; Specify separate x & y blue radius 
; Added the ability to specify shadow name (or pass from another script)
; Label shadow layers and using selected (or passed) layer name + shadow type 
; Added the ability to keep drop shadow on top at all times
; Fully compatible wih GIMP 2.6.x or GIMP 2.8.x (with layer group support)
;
;
; Image Resizing Logic borrowed from GIMP Drop Shadow Script
;         by Spencer Kimball and Peter Mattis
;
; 
; Comments directed to http://gimpchat.com or http://gimpscripts.com
;
; Official Support Thread: http://gimpchat.com/viewtopic.php?f=9&t=7357 
;
; License: GPLv3
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;    GNU General Public License for more details.
;
;    To view a copy of the GNU General Public License
;    visit: http://www.gnu.org/licenses/gpl.html
;
; ------------
;| Change Log |
; ------------ 
; RC V0.1 - Initial Release Candidate  
; RC V0.2 - Fix Gaussian limits, Merge visible layers, Clear script's selections on exit
; RC V0.3 - Resize shadow layer to compensate for shadow offset, blur & feather
;           Allow resize option, Correct shadow X & Y minimum limits
; RC V0.4 - Fix merge visible layers bug that was introduced in RC v0.03
; RC V0.5 - Improve layer positioning logic & correct artifact bug when resizing layers 
;           Add option to merge selected layer with shadow layer
; RC V0.6 - Added support for GIMP 2.8 layer groups, Name layers with selected shadow options
; RC V0.7 - If shadow name is blank (default) then use selected layer name
;           Add toggle to keep shadow layer above selected layer 
;           Simplify shadow merge logic 
;           Always add alpha channel
;           Dump merge visible layers option
;           Rework image sizing using logic from original GIMP Drop Shadow Script 
;=============================================================================================
; V1.0    - Official Release
;           Correct small bug with resizing when glow is selected 
;           When resizing the image, execute layer to image size on selected layer
; V1.1    - Added Support for Gradient Shadows
; V1.2    - Corrected bug to properly handle linked layers   
;
;
;
; Define GC Shadow Procedure
;
;
(define (script-fu-gc-shadow 
                             img                   ; Image in which to apply procedure 
                             in-layer              ; Layer used to create shadowto 
                             shadow-name           ; Shadow Name
                             shadow-color          ; Shadow Color
                             shadow-gradient       ; Shadow Gradient Type 
                             shadow-opacity        ; Shadow Opacity
                             shadow-feather        ; Feather Shadow Amount
                             shadow-blur-radiusx   ; Blur Radius 
                             shadow-blur-radiusy   ; Blur Radius
                             shadow-blur-method    ; Shadow Blur Method 
                             shadow-offsetx        ; Shadow Offset X
                             shadow-offsety        ; Shadow Offset Y
                             inner-shadow-toggle   ; Inner Shadow Toggle
                             glow-toggle           ; Glow Toggle
                             merge-shadow-layer    ; Merge Shadow layer Toggle
                             shadow-above-toggle   ; Knockout Shadow & Move Above Image
                             allow-resize          ; Resize toggle
)
  (let* (                        ; Variable Declaration Section
                                 ; ----------------------------
           (shadow-layer -1)     ; Shadow layer
           (saved-selection -1)  ; Save Selection Variable
           (shadow-height -1)    ; Shadow Height
           (shadow-width -1)     ; SHadow Width
           (radiusx-value -1)    ; Variable to hold radiusx for resize
           (radiusy-value -1)    ; Variable to hold radiusy for resize
           (selection-empty -1)  ; Incoming Selection Flag
           (inlayer-pos -1)      ; Postion in tree of incoming layer
           (selection-bounds -1) ; Bounds of incoming or alpha to selection
           (select-offset-x -1)  ; Selection offset x
           (select-offset-y -1)  ; Selection offset y
           (select-width  -1)    ; Selction width
           (select-height -1)    ; Seletion height
           (shadow-offset-x -1)  ; Shadow offset x
           (shadow-offset-y -1)  ; Sahdow offset y
           (image-width -1)      ; Incoming image width
           (image-height -1)     ; Incoming image height
           (new-image-width -1)  ; Resized image width
           (new-image-height -1) ; Resized image height
           (image-offset-x -1)   ; Image offset x 
           (image-offset-y -1)   ; Image offset y
           (simage-height 0)     ; Image Height
           (simage-width 0)      ; Image Width
           (linked-status FALSE) ; Hold the linked status of incloming layer
        )

;
; Save current GIMP context
;
    (gimp-context-push)               ; Push context onto stack
    (gimp-image-undo-group-start img) ; Begin undo group

;
; Define GIMP 2.8.x procedures that do not exists in GIMP 2.6.x
;
 (if (not (defined? 'gimp-image-get-item-position))         ; Check for get-item-posiiton
    (begin
        (define (gimp-image-get-item-position image layer)  ; Define it, if it doesn't exist
            (gimp-image-get-layer-position image layer)     ; Call get-layer-postion for GIMP 2.6.x
        )
    )
 );endif

 (if (not (defined? 'gimp-image-insert-layer))                   ; Check for image-insert-layer
    (begin
       (define (gimp-image-insert-layer image layer ignored pos) ; Define it, if it doesn't exist
           (gimp-image-add-layer image layer pos)                ; Call image-add-layer for GIMP 2.6.x 
       )
    )
  );endif

 (if (not (defined? 'gimp-item-set-linked))                   ; Check for item-set-linked
    (begin
       (define (gimp-item-set-linked layer state)             ; Define it, if it doesn't exist
           (gimp-layer-set-linked layer state)                ; Call layer-set-linked for GIMP 2.6.x 
       )
    )
  );endif

 (if (not (defined? 'gimp-item-get-linked))                   ; Check for item-get-linked
    (begin
       (define (gimp-item-get-linked layer)                   ; Define it, if it doesn't exist
           (gimp-layer-get-linked layer)                      ; Call layer-get-linked for GIMP 2.6.x 
       )
    )
  );endif

 (if (not (defined? 'gimp-item-get-parent))        ; Check for item-get-parent
    (begin
       (define (gimp-item-get-parent layer)        ; Define it, if it doesn't exist
        (cons #f #f)                               ; Return a pair
       )
    )
  );endif

 (set! linked-status (car (gimp-item-get-linked in-layer)))     ; Linked status of incoming layer
 (set! selection-empty (car (gimp-selection-is-empty img)))     ; Incoming selection flag
 (gimp-layer-add-alpha in-layer)                                ; Add alpha channel to incoming layer

    (if (= selection-empty TRUE)                  ; Check for a selection 
        (begin
          (gimp-selection-layer-alpha in-layer)   ; Select alpha to logo If there isn't one
        )
     ) ;endif
;
; Resize incoming image, if necessary 
;
         (set! selection-bounds (gimp-selection-bounds img)) ; Image selection bounds 
         (set! select-offset-x (cadr selection-bounds))      ; Selection offset x
         (set! select-offset-y (caddr selection-bounds))     ; Selection offset y

         (set! select-width (- (cadr (cddr selection-bounds)) select-offset-x))   ; Selection width
         (set! select-height (- (caddr (cddr selection-bounds)) select-offset-y)) ; Selection height

         (set! image-width (car (gimp-image-width img)))   ; Image width              
         (set! image-height (car (gimp-image-height img))) ; Image heght

         (set! shadow-width (+ select-width (* 2 shadow-blur-radiusx)))   ; Shadow width (2x blur radius x)
         (set! shadow-height (+ select-height (* 2 shadow-blur-radiusy))) ; Shadow height (2x blur radius y) 

         (if (= glow-toggle TRUE)         ; Check for glow layer toggle
           (begin
             (set! shadow-offsetx 0)      ; Zero Shadow x offset      
             (set! shadow-offsety 0)      ; Zero Shadow y offset
           )
         ) ;endif

         (set! shadow-offset-x (- select-offset-x shadow-blur-radiusx)) ; Shadow offset-x minus blur radius x 
         (set! shadow-offset-y (- select-offset-y shadow-blur-radiusy)) ; Saadow offset-y minux blur radius y
;
; Check resize toggle
;
(if (= allow-resize TRUE) 
    (begin
               (set! new-image-width image-width)    ; Resized image width
               (set! new-image-height image-height)  ; Resized image height
               (set! image-offset-x 0)               ; Image offset x
               (set! image-offset-y 0)               ; Image offset y 

          (if (< (+ shadow-offset-x shadow-offsetx) 0) ; Check shadow offset x
              (begin
                (set! image-offset-x (- 0 (+ shadow-offset-x shadow-offsetx))) ; Calc image offset x
                (set! shadow-offset-x (- 0 shadow-offsetx))                    ; Calc shadow offset x 
                (set! new-image-width (+ new-image-width image-offset-x))      ; Calc new image width
               )
          );endif

          (if (< (+ shadow-offset-y shadow-offsety) 0) ; Check shadow offset y
              (begin
                (set! image-offset-y (- 0 (+ shadow-offset-y shadow-offsety))) ; Calc image offset y 
                (set! shadow-offset-y (- 0 shadow-offsety))                    ; Calc shadow offset y 
                (set! new-image-height (+ new-image-height image-offset-y))    ; Calc new image height
              )
          );endif

          (if (> (+ (+ shadow-width shadow-offset-x) shadow-offsetx) new-image-width)      ; Check against new imagw width
                (set! new-image-width (+ (+ shadow-width shadow-offset-x) shadow-offsetx)) ; Calc new image width 
          )

          (if (> (+ (+ shadow-height shadow-offset-y) shadow-offsety) new-image-height)    ; Check against new image height 
              (set! new-image-height (+ (+ shadow-height shadow-offset-y) shadow-offsety)) ; Calc new image height 
          )
;
; Resize the image
;
      (gimp-image-resize img new-image-width new-image-height image-offset-x image-offset-y)
      (gimp-layer-resize-to-image-size in-layer) ; Ensure new layer size equals image size
    )
) ;endif resize toggle

;
; Create Shadow Layer
;
  (set! shadow-layer (car (gimp-layer-new-from-drawable in-layer img))) ; New Shadow Layer

;
; Position shadow layer in tree
;
    (cond ((or (= inner-shadow-toggle TRUE) (= glow-toggle TRUE) (= shadow-above-toggle TRUE))
            (set! inlayer-pos (car (gimp-image-get-item-position img in-layer)))  ;Position above selected layer
          )
          (else
            (set! inlayer-pos (+ (car (gimp-image-get-item-position img in-layer)) 1)) ;Position below selected layer
          )
    ) ;end cond

    (gimp-image-insert-layer img shadow-layer (car (gimp-item-get-parent in-layer)) inlayer-pos) ; Insert shadow layer

     (if (string=? shadow-name "")                               ; Check for null shadow name
        (begin
         (set! shadow-name (car (gimp-layer-get-name in-layer))) ; Set to incoming layer name
        )
     ) ; endif

     (if (= inner-shadow-toggle TRUE)                            ; Check for Inner Shadow
        (begin
        (set! shadow-name (string-append shadow-name " Inner"))  ; Add Inner to name
        )
     ) ; endif

    (cond ((= glow-toggle TRUE)
                (set! shadow-name (string-append shadow-name " Glow")) ; Add Glow to name
          )
          (else
                (set! shadow-name (string-append shadow-name " Shadow")) ; Add shadow to name
          )
    ) ;end cond

     (gimp-selection-feather img shadow-feather)              ; Feather the selection

     (if (= inner-shadow-toggle TRUE)                         ; Check for Inner Shadow
        (begin
          (gimp-selection-invert img)                         ; Invert selection
        )
     ) ; endif

     (set! saved-selection (car (gimp-selection-save img)))   ; Save selection
     (gimp-selection-none img)                                ; Clear selection
     (gimp-edit-clear shadow-layer)                           ; Cleal the layer
     (gimp-selection-load saved-selection)                    ; Restore Selection

;
; Shadow Layer Fill
;
    (if (and (> shadow-gradient 0)(< shadow-gradient 4))      ; Check for gradient fill
        (begin 

          (if (= shadow-gradient 1)                      ; Vertical gradient fill
            (begin
               (set! simage-height (car (gimp-drawable-height shadow-layer)))
            )
          ) ; endif
          (if (= shadow-gradient 2)                      ; Horizontal gradient fill
            (begin
               (set! simage-width (car (gimp-drawable-width shadow-layer)))
            )
          ) ; endif
          (if (= shadow-gradient 3)                      ; Diagonal gradient fill
            (begin
               (set! simage-height (car (gimp-drawable-height shadow-layer)))
               (set! simage-width (car (gimp-drawable-width shadow-layer)))
            )
          ) ; endif

             (gimp-edit-blend          ; Blend (Gradient)
                        shadow-layer   ; Drawable - (The affected drawable)
                        CUSTOM         ; Int32 - Blend Type (FG-BG-RGB-MODE (0))
                        NORMAL         ; Int32 - Paint Mode (NORMAL-MODE (0)) 
                        LINEAR         ; Int32 - Gradient Type (LINEAR (0))
                        100            ; Float - Opacity (0 - 100)
                        0              ; Float - Offset ( >= 0) 
                        0              ; Int32 - Repeat (NONE (0))
                        FALSE          ; Int32 - Reverse (TRUE or FALSE)
                        TRUE           ; Int32 - Supersample (TRUE or FALSE)
                        3              ; Int32 - Supersampling Recursion  Dept (1 - 9)
                        0.20           ; Float - Supersampling threshold (0 <= 4)
                        TRUE           ; Int32 - Dither (TRUE or FALSE)
                        0              ; Int32 - X Blend Starting Point
                        0              ; Int32 - Y Blend Starting Point
                        simage-width   ; Int32 - X Blend Ending Point  
                        simage-height  ; Int32 - Y Blend Ending Point
             ) ; End Blend

;             (gimp-layer-set-name shadow-layer "Gradient Fill")            ; Name layer
        )
     ) ;endif

   (if (= shadow-gradient 0)                                    ; Color fill
     (begin
       (gimp-context-set-foreground shadow-color)               ; Set logo color
       (gimp-edit-bucket-fill shadow-layer 0 0 100 0 0 0 0)     ; Fill with color
     )
   )

     (gimp-selection-none img)                                ; Clear selection
;
; Determine Blur Method (Defaults are reversed)
;
    (cond ((= shadow-blur-method 0)
             (set! shadow-blur-method 1)  ; Set blur method to RLE
          )
          (else
             (set! shadow-blur-method 0)  ; Set blur method to IIR
          )
    ) ;end cond

     (plug-in-gauss                    ; Gaussien blur the shadow (radius blur)
                1                      ; Non-interactive 
                img                    ; Image to apply blur 
                shadow-layer           ; Layer to apply blur
                shadow-blur-radiusx    ; Blur Radius x  
                shadow-blur-radiusy    ; Blue Radius y 
                shadow-blur-method)    ; Method (IIR=0 RLE=1)

     (gimp-selection-load saved-selection)                    ; Restore Selection
     (gimp-image-remove-channel img saved-selection)          ; Remove Selection Mask

     (if (= linked-status TRUE)                      ; Incoming layer linked? 
         (begin
           (gimp-item-set-linked shadow-layer FALSE) ; Remove link from Shadow layer 
         )
     )

     (gimp-layer-translate shadow-layer shadow-offsetx shadow-offsety)  ; Translate x/y offsets
     (gimp-layer-set-opacity shadow-layer shadow-opacity)               ; Set Opacity

;
; Check to see if we need to clear the shadow layer
;
    (if (or (= inner-shadow-toggle TRUE) (= glow-toggle TRUE) (= shadow-above-toggle TRUE))    ; Check for Inner Shadow or Glow
        (begin
            (gimp-edit-clear shadow-layer)                  ; Clear Shadow layer outside selection
        )
     ) ; endif

    (if (= selection-empty TRUE)              ; Check for incoming selection 
        (begin
           (gimp-selection-none img)          ; Clear selection if empty when procedure was called
        )
     ) ; endif

    (gimp-image-set-active-layer img in-layer)         ; Make in-layer active
    (gimp-layer-set-name shadow-layer shadow-name)     ; Name shadow layer
    (gimp-layer-resize-to-image-size shadow-layer)     ; Resize Shadow layer to image size
;
; Merge new shadow layer with selected layer maintaining original selected layer name
;
(if (= merge-shadow-layer TRUE)                        ; Check for merge shadow layer flag
   (begin
      (cond ((< (car (gimp-image-get-item-position img shadow-layer)) (car (gimp-image-get-item-position img in-layer))) ; Check layer Position 
               (gimp-image-merge-down img shadow-layer 0) ; Merge down shadow 
            )
            (else
              (set! shadow-name (car (gimp-layer-get-name in-layer)))  ; Set to incoming layer name
              (gimp-layer-set-name in-layer "temp-layer")              ; Temp Name
              (gimp-layer-set-name shadow-layer shadow-name)           ; Name shadow layer
              (gimp-image-merge-down img in-layer 0)                   ; Merge down selected
           )
     ) ;end cond

    (if (= linked-status TRUE)                      ; Incoming layer linked? 
        (begin
           (gimp-item-set-linked (car (gimp-image-get-active-layer img)) TRUE) ; Restore link after merge
        )
    )

   )
) ; endif

;
; Restore GIMP context
;
    (gimp-image-undo-group-end img)                ; End undo group
    (gimp-displays-flush)                          ; Flush display
    (gimp-context-pop)                             ; Pop context off stack

  ); End let
) ; Return From GC Shadow Procedure 

;
; Register GC Shadow Procedure in PDB
;
(script-fu-register "script-fu-gc-shadow"
                    _"_GC Shadow.."
                    _"Create Enhanced Shadow Procedure"
                    "GnuTux - http://gimpchat.com"
                    "GnuTux - GPLv3"
                    "05-2013"
                    "RGB*, GRAY*"
                    SF-IMAGE      "Image"                   0
                    SF-DRAWABLE   "Drawable"                0
                    SF-STRING     _"Shadow Name"            ""
                    SF-COLOR      _"Shadow Color"           '(0 0 0)
                    SF-OPTION     _"Shadow Gradient"        '("None" "Active Gradient Vertical" "Active Gradient Horizonal" "Active Gradient Diagonal")
                    SF-ADJUSTMENT _"Shadow Opacity"         '(50 0 100 1 1 0 0)
                    SF-ADJUSTMENT _"Shadow Feather"         '(0 0 20 1 1 0 0)
                    SF-ADJUSTMENT _"Blur Radius X"          '(20 1 120 1 1 0 0)
                    SF-ADJUSTMENT _"Blur Radius Y"          '(20 1 120 1 1 0 0)
                    SF-OPTION     _"Blur Method"            '("RLE Method" "IIR Method")
                    SF-ADJUSTMENT _"Offset X"               '(10 -200 200 1 1 0 0)
                    SF-ADJUSTMENT _"Offset Y"               '(10 -200 200 1 1 0 0)
                    SF-TOGGLE     _"Inner Shadow"           FALSE
                    SF-TOGGLE     _"Glow"                   FALSE
                    SF-TOGGLE     _"Merge Shadow Layer"     FALSE
                    SF-TOGGLE     _"Keep Shadow Above Selected Layer" TRUE
                    SF-TOGGLE     _"Allow Resize"                     TRUE
) ; End Register
;
; Menu Location
;
(script-fu-menu-register "script-fu-gc-shadow"
                         "<Image>/Filters/Light and Shadow")
