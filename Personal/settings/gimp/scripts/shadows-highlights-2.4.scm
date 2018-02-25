(define (script-fu-shadows-highlights image drawable shadows highlights)

; create a highlights layer
(let ((highlights-layer (car (gimp-layer-copy drawable 1))))
(gimp-drawable-set-name highlights-layer "fix highlights (adjust opacity)")
(gimp-image-add-layer image highlights-layer -1)

;process shadows/highlights layer
(gimp-desaturate highlights-layer)
(gimp-invert highlights-layer)
(gimp-layer-set-mode highlights-layer 5)
(plug-in-gauss-iir2 1 image highlights-layer 25 25)

;copy highlights layer to create shadows layer
(define shadows-layer (car (gimp-layer-copy highlights-layer 1)))
(gimp-drawable-set-name shadows-layer "fix shadows (adjust opacity)")
(gimp-image-add-layer image shadows-layer -1)

;process highlights layer
(plug-in-colortoalpha 1 image highlights-layer '(255 255 255))
(gimp-layer-set-opacity highlights-layer highlights)

;process shadows layer
(plug-in-colortoalpha 1 image shadows-layer '(0 0 0))
(gimp-layer-set-opacity shadows-layer shadows)

;update image window
(gimp-displays-flush)))

(script-fu-register "script-fu-shadows-highlights"
                   _"<Image>/Filters/Light and Shadow/Shadows & Highlights"
                    "Removes shadows and highlights from a photograph - adapted from http://mailgate.supereva.com/comp/comp.graphics.apps.gimp/msg06394.html"
                    "Dennis Bond - thanks to Jozef Trawinski"
                    "Dennis Bond - thanks to Jozef Trawinski"
                    "October 24, 2007"
                    "RGB* GRAY*"
                    SF-IMAGE "Image" 0
                    SF-DRAWABLE "Drawable" 0
                    SF-ADJUSTMENT "Shadows"    '(50 0  100   1   1   0   0)
                    SF-ADJUSTMENT "Highlights" '(0  0  100   1   1   0   0))
