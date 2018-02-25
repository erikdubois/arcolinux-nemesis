; GIMP Layer Effects
; Copyright (c) 2008 Jonathan Stipe
; JonStipe@prodigy.net

; ---------------------------------------------------------------------

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define (get-blending-mode mode)
  (let* ((modenumbers #(0 1 3 15 4 5 16 17 18 19 20 21 6 7 8 9 10 11 12 13 14)))
    (vector-ref modenumbers mode)
  )
)

(define (math-round input)
  (floor (+ input 0.5))
)

(define (math-ceil input)
  (if (= input (floor input))
    input
    (+ (floor input) 1)
  )
)

(define (get-layer-pos img layer)
  (let* ((layerdata (gimp-image-get-layers img))
	 (numlayers (car layerdata))
	 (layerarray (cadr layerdata))
	 (i 0)
	 (pos -1)
	)
    (while (< i numlayers)
      (if (= layer (vector-ref layerarray i))
	(begin
	  (set! pos i)
	  (set! i numlayers)
	)
	(set! i (+ i 1))
      )
    )
    pos
  )
)

(define (add-under-layer img newlayer oldlayer)
  (gimp-image-add-layer img newlayer (+ (get-layer-pos img oldlayer) 1))
)

(define (add-over-layer img newlayer oldlayer)
  (gimp-image-add-layer img newlayer (get-layer-pos img oldlayer))
)

(define (draw-blurshape img drawable size initgrowth sel invert)
  (let* ((k initgrowth)
	 (currshade 0)
	 (i 0))
    (while (< i size)
      (if (> k 0)
	(gimp-selection-grow img k)
	(if (< k 0)
	  (gimp-selection-shrink img (abs k))
	)
      )
      (if (= invert 1)
	(set! currshade (math-round (* (/ (- size (+ i 1)) size) 255)))
	(set! currshade (math-round (* (/ (+ i 1) size) 255)))
      )
      (gimp-palette-set-foreground (list currshade currshade currshade))
      (if (= (car (gimp-selection-is-empty img)) 0)
	(gimp-edit-fill drawable 0)
      )
      (gimp-selection-load sel)
      (set! k (- k 1))
      (set! i (+ i 1))
    )
  )
)

(define (apply-contour drawable channel contour)
  (let* ((contourtypes #(0 0 0 0 0 0 0 0 0 1 1))
	 (contourlengths #(6 6 10 14 18 10 18 18 10 256 256))
	 (contours #(#(0 0 127 255 255 0)
#(0 255 127 0 255 255)
#(0 64 94 74 150 115 179 179 191 255)
#(0 0 5 125 6 125 48 148 79 179 107 217 130 255)
#(0 0 33 8 64 38 97 102 128 166 158 209 191 235 222 247 255 255)
#(0 0 28 71 87 166 194 240 255 255)
#(0 0 33 110 64 237 97 240 128 138 158 33 191 5 222 99 255 255)
#(0 0 33 74 64 219 97 186 128 0 158 176 191 201 222 3 255 255)
#(3 255 54 99 97 107 179 153 252 0)
#(0 5 9 13 16 19 22 25 27 29 30 32 33 34 35 36 38 39 40 41 43 44 46 47 48 49 50 51 52 53 54 55 55 56 56 57 57 58 58 59 59 59 60 60 60 61 61 61 61 62 62 62 62 62 63 63 63 63 63 63 64 64 64 64 64 71 75 78 81 84 86 89 91 93 95 96 98 99 101 102 103 104 105 107 107 108 110 111 112 113 114 115 116 117 118 119 119 120 121 121 122 123 123 123 124 124 124 125 125 125 125 125 125 125 126 126 126 126 126 126 126 125 125 125 125 125 125 125 125 130 134 137 141 145 148 151 153 156 158 160 162 163 165 166 167 168 170 171 171 172 173 174 175 176 177 178 178 179 180 181 181 182 183 183 184 184 185 185 186 186 187 187 188 188 189 189 189 189 190 190 190 190 191 191 191 191 191 191 191 191 191 191 193 194 196 197 198 200 201 203 204 205 207 208 209 211 212 213 214 215 217 218 219 220 220 221 222 222 223 223 224 224 224 224 224 223 223 222 222 221 221 220 219 218 217 216 215 214 213 212 211 210 209 208 206 205 204 203 202 200 199 198 197 196 194 194)
#(0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100 102 104 106 108 110 112 114 116 118 120 122 124 126 127 125 123 121 119 117 115 113 111 109 107 105 103 101 99 97 95 93 91 89 87 85 83 81 79 77 75 73 71 69 67 65 63 61 59 57 55 53 51 49 47 45 43 41 39 37 35 33 31 29 27 25 23 21 19 17 15 13 11 9 7 5 3 1 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67 69 71 73 75 77 79 81 83 85 87 89 91 93 95 97 99 101 103 105 107 109 111 113 115 117 119 121 123 125 127 128 126 124 122 120 118 116 114 112 110 108 106 104 102 100 98 96 94 92 90 88 86 84 82 80 78 76 74 72 70 68 66 64 62 60 58 56 54 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2))))
    (if (= (vector-ref contourtypes (- contour 1)) 0)
      (gimp-curves-spline drawable channel (vector-ref contourlengths (- contour 1)) (vector-ref contours (- contour 1)))
      (gimp-curves-explicit drawable channel (vector-ref contourlengths (- contour 1)) (vector-ref contours (- contour 1)))
    )
  )
)

(define (apply-noise img drawable srclayer noise)
  (let* ((drwwidth (car (gimp-drawable-width srclayer)))
	 (drwheight (car (gimp-drawable-height srclayer)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (drwoffsets (gimp-drawable-offsets srclayer))
	 (srcmask (car (gimp-layer-get-mask srclayer)))
	 (noiselayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-noise") 100 0)))
	 (blanklayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-noise") 100 0))))
    (add-over-layer img noiselayer srclayer)
    (add-over-layer img blanklayer noiselayer)
    (gimp-layer-set-offsets noiselayer (car drwoffsets) (cadr drwoffsets))
    (gimp-layer-set-offsets blanklayer (car drwoffsets) (cadr drwoffsets))
    (gimp-selection-all img)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill noiselayer 0)
    (gimp-edit-fill blanklayer 0)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-selection-load srcmask)
    (gimp-edit-fill blanklayer 0)
    (plug-in-hsv-noise 1 img noiselayer 1 0 0 255)
    (gimp-layer-set-mode blanklayer 5)
    (gimp-layer-set-opacity blanklayer noise)
    (set! noiselayer (car (gimp-image-merge-down img blanklayer 0)))
    (set! blanklayer (car (gimp-layer-create-mask noiselayer 5)))
    (gimp-channel-combine-masks srcmask blanklayer 2 0 0)
    (gimp-image-remove-layer img noiselayer)
  )
)

(define (script-fu-layerfx-drop-shadow img
				       drawable
				       color
				       opacity
				       contour
				       noise
				       mode
				       spread
				       size
				       offsetangle
				       offsetdist
				       knockout
				       merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (growamt (math-ceil (/ size 2)))
	 (steps (math-round (- size (* (/ spread 100) size))))
	 (lyrgrowamt (math-round (* growamt 1.2)))
	 (shadowlayer (car (gimp-layer-new img (+ drwwidth (* lyrgrowamt 2)) (+ drwheight (* lyrgrowamt 2)) (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-dropshadow") opacity (get-blending-mode mode))))
	 (shadowmask 0)
	 (alphaSel 0)
	 (ang (* (* (+ offsetangle 180) -1) (/ (* 4 (atan 1.0)) 180)))
	 (offsetX (math-round (* offsetdist (cos ang))))
	 (offsetY (math-round (* offsetdist (sin ang))))
	 (origmask 0)
	)
    (add-under-layer img shadowlayer drawable)
    (gimp-layer-set-offsets shadowlayer (- (+ (car drwoffsets) offsetX) lyrgrowamt) (- (+ (cadr drwoffsets) offsetY) lyrgrowamt))
    (gimp-selection-all img)
    (gimp-palette-set-foreground color)
    (gimp-edit-fill shadowlayer 0)
    (gimp-selection-none img)
    (set! shadowmask (car (gimp-layer-create-mask shadowlayer 1)))
    (gimp-layer-add-mask shadowlayer shadowmask)
    (gimp-selection-layer-alpha drawable)
    (if (> (car (gimp-layer-get-mask drawable)) -1)
      (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
    )
    (gimp-selection-translate img offsetX offsetY)
    (set! alphaSel (car (gimp-selection-save img)))
    (draw-blurshape img shadowmask steps growamt alphaSel 0)
    (gimp-selection-none img)
    (if (> contour 0)
      (begin
	(apply-contour shadowmask 0 contour)
	(gimp-selection-load alphaSel)
	(gimp-selection-grow img growamt)
	(gimp-selection-invert img)
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-edit-fill shadowmask 0)
	(gimp-selection-none img)
      )
    )
    (if (> noise 0)
      (apply-noise img drawable shadowlayer noise)
    )
    (if (= knockout 1)
      (begin
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-selection-layer-alpha drawable)
	(gimp-edit-fill shadowmask 0)
      )
    )
    (gimp-layer-remove-mask shadowlayer 0)
    (gimp-selection-none img)
    (if (= merge 1)
      (begin
	(set! origmask (car (gimp-layer-get-mask drawable)))
	(if (> origmask -1)
	  (gimp-layer-remove-mask drawable 0)
	)
	(set! shadowlayer (car (gimp-image-merge-down img drawable 0)))
	(gimp-drawable-set-name shadowlayer layername)
      )
    )
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaSel)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-inner-shadow img
					drawable
					color
					opacity
					contour
					noise
					mode
					source
					choke
					size
					offsetangle
					offsetdist
					merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (shadowlayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-innershadow") opacity (get-blending-mode mode))))
	 (shadowmask 0)
	 (alphaSel 0)
	 (growamt (math-ceil (/ size 2)))
	 (chokeamt (* (/ choke 100) size))
	 (steps (math-round (- size chokeamt)))
	 (ang (* (* (+ offsetangle 180) -1) (/ (* 4 (atan 1.0)) 180)))
	 (offsetX (math-round (* offsetdist (cos ang))))
	 (offsetY (math-round (* offsetdist (sin ang))))
	 (origmask 0)
	 (alphamask 0)
	)
    (add-over-layer img shadowlayer drawable)
    (gimp-layer-set-offsets shadowlayer (car drwoffsets) (cadr drwoffsets))
    (gimp-selection-all img)
    (gimp-palette-set-foreground color)
    (gimp-edit-fill shadowlayer 0)
    (gimp-selection-none img)
    (set! shadowmask (car (gimp-layer-create-mask shadowlayer 1)))
    (gimp-layer-add-mask shadowlayer shadowmask)
    (gimp-selection-layer-alpha drawable)
    (if (> (car (gimp-layer-get-mask drawable)) -1)
      (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
    )
    (gimp-selection-translate img offsetX offsetY)
    (set! alphaSel (car (gimp-selection-save img)))
    (if (= source 0)
      (begin
	(gimp-selection-all img)
	(gimp-palette-set-foreground '(255 255 255))
	(gimp-edit-fill shadowmask 0)
	(gimp-selection-load alphaSel)
	(draw-blurshape img shadowmask steps (- growamt chokeamt) alphaSel 1)
      )
      (draw-blurshape img shadowmask steps (- growamt chokeamt) alphaSel 0)
    )
    (gimp-selection-none img)
    (if (> contour 0)
      (apply-contour shadowmask 0 contour)
    )
    (if (= merge 0)
      (begin
	(gimp-selection-layer-alpha drawable)
	(gimp-selection-invert img)
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-edit-fill shadowmask 0)
      )
    )
    (if (> noise 0)
      (apply-noise img drawable shadowlayer noise)
    )
    (gimp-layer-remove-mask shadowlayer 0)
    (if (= merge 1)
      (if (= source 0)
	(begin
	  (set! origmask (car (gimp-layer-get-mask drawable)))
	  (if (> origmask -1)
	    (begin
	      (set! origmask (car (gimp-channel-copy origmask)))
	      (gimp-layer-remove-mask drawable 1)
	    )
	  )
	  (set! alphamask (car (gimp-layer-create-mask drawable 3)))
	  (set! shadowlayer (car (gimp-image-merge-down img shadowlayer 0)))
	  (gimp-drawable-set-name shadowlayer layername)
	  (gimp-layer-add-mask shadowlayer alphamask)
	  (gimp-layer-remove-mask shadowlayer 0)
	  (if (> origmask -1)
	    (gimp-layer-add-mask shadowlayer origmask)
	  )
	)
	(begin
	  (set! origmask (car (gimp-layer-get-mask drawable)))
	  (if (> origmask -1)
	    (begin
	      (set! origmask (car (gimp-channel-copy origmask)))
	      (gimp-layer-remove-mask drawable 1)
	    )
	  )
	  (set! shadowlayer (car (gimp-image-merge-down img shadowlayer 0)))
	  (gimp-drawable-set-name shadowlayer layername)
	  (if (> origmask -1)
	    (gimp-layer-add-mask shadowlayer origmask)
	  )
	)
      )
    )
    (gimp-selection-none img)
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaSel)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-outer-glow img
				      drawable
				      color
				      opacity
				      contour
				      noise
				      mode
				      spread
				      size
				      knockout
				      merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (lyrgrowamt (math-round (* size 1.2)))
	 (glowlayer (car (gimp-layer-new img (+ drwwidth (* lyrgrowamt 2)) (+ drwheight (* lyrgrowamt 2)) (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-outerglow") opacity (get-blending-mode mode))))
	 (glowmask 0)
	 (alphaSel 0)
	 (growamt (* (/ spread 100) size))
	 (steps (- size growamt))
	 (origmask 0)
	)
    (add-under-layer img glowlayer drawable)
    (gimp-layer-set-offsets glowlayer (- (car drwoffsets) lyrgrowamt) (- (cadr drwoffsets) lyrgrowamt))
    (gimp-selection-all img)
    (gimp-palette-set-foreground color)
    (gimp-edit-fill glowlayer 0)
    (gimp-selection-none img)
    (set! glowmask (car (gimp-layer-create-mask glowlayer 1)))
    (gimp-layer-add-mask glowlayer glowmask)
    (gimp-selection-layer-alpha drawable)
    (if (> (car (gimp-layer-get-mask drawable)) -1)
      (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
    )
    (set! alphaSel (car (gimp-selection-save img)))
    (draw-blurshape img glowmask steps size alphaSel 0)
    (gimp-selection-none img)
    (if (> contour 0)
      (begin
	(apply-contour glowmask 0 contour)
	(gimp-selection-load alphaSel)
	(gimp-selection-grow img size)
	(gimp-selection-invert img)
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-edit-fill glowmask 0)
	(gimp-selection-none img)
      )
    )
    (if (> noise 0)
      (apply-noise img drawable glowlayer noise)
    )
    (if (= knockout 1)
      (begin
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-selection-layer-alpha drawable)
	(gimp-edit-fill glowmask 0)
      )
    )
    (gimp-layer-remove-mask glowlayer 0)
    (gimp-selection-none img)
    (if (= merge 1)
      (begin
	(set! origmask (car (gimp-layer-get-mask drawable)))
	(if (> origmask -1)
	  (gimp-layer-remove-mask drawable 0)
	)
	(set! glowlayer (car (gimp-image-merge-down img drawable 0)))
	(gimp-drawable-set-name glowlayer layername)
      )
    )
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaSel)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-inner-glow img
				      drawable
				      color
				      opacity
				      contour
				      noise
				      mode
				      source
				      choke
				      size
				      merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (glowlayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-innerglow") opacity (get-blending-mode mode))))
	 (glowmask 0)
	 (alphaSel 0)
	 (shrinkamt (* (/ choke 100) size))
	 (steps (- size shrinkamt))
	 (i 0)
	 (currshade 0)
	 (origmask 0)
	 (alphamask 0)
	)
    (add-over-layer img glowlayer drawable)
    (gimp-layer-set-offsets glowlayer (car drwoffsets) (cadr drwoffsets))
    (gimp-selection-all img)
    (gimp-palette-set-foreground color)
    (gimp-edit-fill glowlayer 0)
    (gimp-selection-none img)
    (set! glowmask (car (gimp-layer-create-mask glowlayer 1)))
    (gimp-layer-add-mask glowlayer glowmask)
    (gimp-selection-layer-alpha drawable)
    (if (> (car (gimp-layer-get-mask drawable)) -1)
      (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
    )
    (set! alphaSel (car (gimp-selection-save img)))
    (if (= source 0)
      (begin
	(gimp-selection-all img)
	(gimp-palette-set-foreground '(255 255 255))
	(gimp-edit-fill glowmask 0)
	(gimp-selection-load alphaSel)
	(draw-blurshape img glowmask steps (- (* shrinkamt -1) 1) alphaSel 1)
      )
      (draw-blurshape img glowmask steps (* shrinkamt -1) alphaSel 0)
    )
    (gimp-selection-none img)
    (if (> contour 0)
      (apply-contour glowmask 0 contour)
    )
    (if (and (= source 0) (= merge 0))
      (begin
	(gimp-selection-load alphaSel)
	(gimp-selection-invert img)
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-edit-fill glowmask 0)
      )
    )
    (if (> noise 0)
      (apply-noise img drawable glowlayer noise)
    )
    (gimp-layer-remove-mask glowlayer 0)
    (if (= merge 1)
      (if (= source 0)
	(begin
	  (set! origmask (car (gimp-layer-get-mask drawable)))
	  (if (> origmask -1)
	    (begin
	      (set! origmask (car (gimp-channel-copy origmask)))
	      (gimp-layer-remove-mask drawable 1)
	    )
	  )
	  (set! alphamask (car (gimp-layer-create-mask drawable 3)))
	  (set! glowlayer (car (gimp-image-merge-down img glowlayer 0)))
	  (gimp-drawable-set-name glowlayer layername)
	  (gimp-layer-add-mask glowlayer alphamask)
	  (gimp-layer-remove-mask glowlayer 0)
	  (if (> origmask -1)
	    (gimp-layer-add-mask glowlayer origmask)
	  )
	)
	(begin
	  (set! origmask (car (gimp-layer-get-mask drawable)))
	  (if (> origmask -1)
	    (begin
	      (set! origmask (car (gimp-channel-copy origmask)))
	      (gimp-layer-remove-mask drawable 1)
	    )
	  )
	  (set! glowlayer (car (gimp-image-merge-down img glowlayer 0)))
	  (gimp-drawable-set-name glowlayer layername)
	  (if (> origmask -1)
	    (gimp-layer-add-mask glowlayer origmask)
	  )
	)
      )
    )
    (gimp-selection-none img)
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaSel)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-bevel-emboss img
					drawable
					style
					depth
					direction
					size
					soften
					angle
					altitude
					glosscontour
					highlightcolor
					highlightmode
					highlightopacity
					shadowcolor
					shadowmode
					shadowopacity
					surfacecontour
					invert
					merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (imgtype (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)))
	 (lyrgrowamt (math-round (* size 1.2)))
	 (bumpmaplayer 0)
	 (highlightlayer 0)
	 (highlightmask 0)
	 (shadowlayer 0)
	 (shadowmask 0)
	 (layersize 0)
	 (alphaSel 0)
	 (halfsizef 0)
	 (halfsizec 0)
	 (origmask 0)
	 (alphamask 0)
	)
    (cond
      ((= style 0)
	(begin
	  (set! layersize (list
	    (+ drwwidth (* lyrgrowamt 2))
	    (+ drwheight (* lyrgrowamt 2))
	    (- (car drwoffsets) lyrgrowamt)
	    (- (cadr drwoffsets) lyrgrowamt)
	  ))
	)
      )
      ((= style 1)
	(begin
	  (set! layersize (list
	    drwwidth
	    drwheight
	    (car drwoffsets)
	    (cadr drwoffsets)
	  ))
	)
      )
      ((= style 2)
	(begin
	  (set! layersize (list
	    (+ drwwidth lyrgrowamt)
	    (+ drwheight lyrgrowamt)
	    (- (car drwoffsets) (floor (/ lyrgrowamt 2)))
	    (- (cadr drwoffsets) (floor (/ lyrgrowamt 2)))
	  ))
	)
      )
      (
	(begin
	  (set! layersize (list
	    (+ drwwidth lyrgrowamt)
	    (+ drwheight lyrgrowamt)
	    (- (car drwoffsets) (floor (/ lyrgrowamt 2)))
	    (- (cadr drwoffsets) (floor (/ lyrgrowamt 2)))
	  ))
	)
      )
    )
    (set! bumpmaplayer (car (gimp-layer-new img (car layersize) (cadr layersize) imgtype (string-append layername "-bumpmap") 100 0)))
    (set! highlightlayer (car (gimp-layer-new img (car layersize) (cadr layersize) imgtype (string-append layername "-highlight") highlightopacity (get-blending-mode highlightmode))))
    (set! shadowlayer (car (gimp-layer-new img (car layersize) (cadr layersize) imgtype (string-append layername "-shadow") shadowopacity (get-blending-mode shadowmode))))
    (add-over-layer img bumpmaplayer drawable)
    (add-over-layer img shadowlayer bumpmaplayer)
    (add-over-layer img highlightlayer shadowlayer)
    (gimp-layer-set-offsets bumpmaplayer (caddr layersize) (cadddr layersize))
    (gimp-layer-set-offsets shadowlayer (caddr layersize) (cadddr layersize))
    (gimp-layer-set-offsets highlightlayer (caddr layersize) (cadddr layersize))
    (gimp-selection-all img)
    (gimp-palette-set-foreground highlightcolor)
    (gimp-edit-fill highlightlayer 0)
    (gimp-palette-set-foreground shadowcolor)
    (gimp-edit-fill shadowlayer 0)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill bumpmaplayer 0)
    (set! highlightmask (car (gimp-layer-create-mask highlightlayer 1)))
    (set! shadowmask (car (gimp-layer-create-mask shadowlayer 1)))
    (gimp-layer-add-mask highlightlayer highlightmask)
    (gimp-layer-add-mask shadowlayer shadowmask)
    (gimp-selection-layer-alpha drawable)
    (if (> (car (gimp-layer-get-mask drawable)) -1)
       (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
    )
    (set! alphaSel (car (gimp-selection-save img)))
    (cond
      ((= style 0)
	(draw-blurshape img bumpmaplayer size size alphaSel 0)
      )
      ((= style 1)
	(draw-blurshape img bumpmaplayer size 0 alphaSel 0)
      )
      ((= style 2)
	(begin
	  (set! halfsizec (math-ceil (/ size 2)))
	  (draw-blurshape img bumpmaplayer size halfsizec alphaSel 0)
	)
      )
      (
	(begin
	  (set! halfsizef (floor (/ size 2)))
	  (set! halfsizec (- size halfsizef))
	  (gimp-selection-all img)
	  (gimp-palette-set-foreground '(255 255 255))
	  (gimp-edit-fill bumpmaplayer 0)
	  (draw-blurshape img bumpmaplayer halfsizec halfsizec alphaSel 1)
	  (draw-blurshape img bumpmaplayer halfsizef 0 alphaSel 0)
	)
      )
    )
    (gimp-selection-all img)
    (gimp-palette-set-foreground '(127 127 127))
    (gimp-edit-fill highlightmask 0)
    (gimp-selection-none img)
    (if (> surfacecontour 0)
      (apply-contour bumpmaplayer 0 surfacecontour)
    )
    (if (< angle 0)
      (set! angle (+ angle 360))
    )
    (plug-in-bump-map 1 img highlightmask bumpmaplayer angle altitude depth 0 0 0 0 1 direction 0)
    (if (> glosscontour 0)
      (apply-contour highlightmask 0 glosscontour)
    )
    (if (> soften 0)
      (plug-in-gauss-rle 1 img highlightmask soften 1 1)
    )
    (if (> invert 0)
      (gimp-invert highlightmask)
    )
    (gimp-channel-combine-masks shadowmask highlightmask 2 0 0)
    (gimp-levels highlightmask 0 127 255 1.0 0 255)
    (gimp-levels shadowmask 0 0 127 1.0 255 0)
    (gimp-selection-load alphaSel)
    (if (= style 0)
      (gimp-selection-grow img size)
      (if (or (= style 2) (= style 3))
	(gimp-selection-grow img halfsizec)
      )
    )
    (gimp-selection-invert img)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill shadowmask 0)
    (gimp-selection-none img)
    (gimp-image-remove-layer img bumpmaplayer)
    (if (= merge 1)
      (if (= style 1)
	(begin
	  (set! origmask (car (gimp-layer-get-mask drawable)))
	  (if (> origmask -1)
	    (begin
	      (set! origmask (car (gimp-channel-copy origmask)))
	      (gimp-layer-remove-mask drawable 1)
	    )
	  )
	  (set! alphamask (car (gimp-layer-create-mask drawable 3)))
	  (set! shadowlayer (car (gimp-image-merge-down img shadowlayer 0)))
	  (set! highlightlayer (car (gimp-image-merge-down img highlightlayer 0)))
	  (gimp-drawable-set-name highlightlayer layername)
	  (gimp-layer-add-mask highlightlayer alphamask)
	  (gimp-layer-remove-mask highlightlayer 0)
	  (if (> origmask -1)
	    (gimp-layer-add-mask highlightlayer origmask)
	  )
	)
	(begin
	  (set! origmask (car (gimp-layer-get-mask drawable)))
	  (if (> origmask -1)
	    (gimp-layer-remove-mask drawable 0)
	  )
	  (set! shadowlayer (car (gimp-image-merge-down img shadowlayer 0)))
	  (set! highlightlayer (car (gimp-image-merge-down img highlightlayer 0)))
	  (gimp-drawable-set-name highlightlayer layername)
	)
      )
    )
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaSel)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-satin img
				 drawable
				 color
				 opacity
				 mode
				 offsetangle
				 offsetdist
				 size
				 contour
				 invert
				 merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (growamt (math-ceil (/ size 2)))
	 (lyrgrowamt (math-round (* growamt 1.2)))
	 (satinlayer (car (gimp-layer-new img (+ (car (gimp-drawable-width drawable)) (* lyrgrowamt 2)) (+ (car (gimp-drawable-height drawable)) (* lyrgrowamt 2)) (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-satin") 100 0)))
	 (satinmask 0)
	 (blacklayer 0)
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (ang (* (* (+ offsetangle 180) -1) (/ (* 4 (atan 1.0)) 180)))
	 (offsetX (math-round (* offsetdist (cos ang))))
	 (offsetY (math-round (* offsetdist (sin ang))))
	 (alphaSel 0)
	 (layeraoffsets 0)
	 (layerboffsets 0)
	 (dx 0)
	 (dy 0)
	 (origmask 0)
	 (alphamask 0)
	)
    (add-over-layer img satinlayer drawable)
    (gimp-layer-set-offsets satinlayer (- (car drwoffsets) lyrgrowamt) (- (cadr drwoffsets) lyrgrowamt))
    (gimp-selection-all img)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill satinlayer 0)
    (gimp-selection-none img)
    (gimp-selection-layer-alpha drawable)
    (if (> (car (gimp-layer-get-mask drawable)) -1)
       (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
    )
    (set! alphaSel (car (gimp-selection-save img)))
    (draw-blurshape img satinlayer size growamt alphaSel 0)
    (plug-in-autocrop-layer 1 img satinlayer)
    (set! satinmask (car (gimp-layer-copy satinlayer 0)))
    (add-over-layer img satinmask satinlayer)
    (gimp-layer-translate satinlayer offsetX offsetY)
    (gimp-layer-translate satinmask (* offsetX -1) (* offsetY -1))
    (set! layeraoffsets (gimp-drawable-offsets satinlayer))
    (set! layerboffsets (gimp-drawable-offsets satinmask))
    (set! dx (- (max (car layeraoffsets) (car layerboffsets)) (min (car layeraoffsets) (car layerboffsets))))
    (set! dy (- (max (cadr layeraoffsets) (cadr layerboffsets)) (min (cadr layeraoffsets) (cadr layerboffsets))))
    (set! blacklayer (car (gimp-layer-new img (+ (car (gimp-drawable-width satinlayer)) dx) (+ (car (gimp-drawable-height satinlayer)) dy) (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-satinblank") 100 0)))
    (add-under-layer img blacklayer satinlayer)
    (gimp-layer-set-offsets blacklayer (min (car layeraoffsets) (car layerboffsets)) (min (cadr layeraoffsets) (cadr layerboffsets)))
    (gimp-selection-all img)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill blacklayer 0)
    (gimp-selection-none img)
    (gimp-layer-set-mode satinmask 6)
    (set! satinlayer (car (gimp-image-merge-down img satinlayer 0)))
    (set! satinlayer (car (gimp-image-merge-down img satinmask 0)))
    (gimp-drawable-set-name satinlayer (string-append layername "-satin"))
    (if (> contour 0)
      (begin
	(apply-contour satinlayer 0 contour)
	(gimp-selection-load alphaSel)
	(gimp-selection-grow img size)
	(gimp-selection-invert img)
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-edit-fill satinlayer 0)
	(gimp-selection-none img)
      )
    )
    (if (= invert 1)
      (gimp-invert satinlayer)
    )
    (set! satinmask (car (gimp-layer-create-mask satinlayer 5)))
    (gimp-layer-add-mask satinlayer satinmask)
    (gimp-selection-all img)
    (gimp-palette-set-foreground color)
    (gimp-edit-fill satinlayer 0)
    (gimp-selection-none img)
    (gimp-layer-set-opacity satinlayer opacity)
    (gimp-layer-set-mode satinlayer (get-blending-mode mode))
    (gimp-layer-resize satinlayer (car (gimp-drawable-width drawable)) (car (gimp-drawable-height drawable)) (- (car (gimp-drawable-offsets satinlayer)) (car drwoffsets)) (- (cadr (gimp-drawable-offsets satinlayer)) (cadr drwoffsets)))
    (if (= merge 1)
      (begin
	(set! origmask (car (gimp-layer-get-mask drawable)))
	(if (> origmask -1)
	  (begin
	    (set! origmask (car (gimp-channel-copy origmask)))
	    (gimp-layer-remove-mask drawable 1)
	  )
	)
	(set! alphamask (car (gimp-layer-create-mask drawable 3)))
	(set! satinlayer (car (gimp-image-merge-down img satinlayer 0)))
	(gimp-drawable-set-name satinlayer layername)
	(gimp-layer-add-mask satinlayer alphamask)
	(gimp-layer-remove-mask satinlayer 0)
	(if (> origmask -1)
	  (gimp-layer-add-mask satinlayer origmask)
	)
      )
      (begin
	(gimp-selection-load alphaSel)
	(gimp-selection-invert img)
	(gimp-palette-set-foreground '(0 0 0))
	(gimp-edit-fill satinmask 0)
      )
    )
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaSel)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-stroke img
				  drawable
				  color
				  opacity
				  mode
				  size
				  position
				  merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (strokelayer 0)
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (alphaselection 0)
	 (outerselection 0)
	 (innerselection 0)
	 (origmask 0)
	 (alphamask 0)
	 (outerwidth 0)
	 (innerwidth 0)
	 (growamt 0)
	)
    (if (= position 0)
      (begin
	(set! strokelayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-stroke") opacity (get-blending-mode mode))))
	(add-over-layer img strokelayer drawable)
	(gimp-layer-set-offsets strokelayer (car drwoffsets) (cadr drwoffsets))
	(gimp-selection-all img)
	(gimp-edit-clear strokelayer)
	(gimp-selection-none img)
	(gimp-selection-layer-alpha drawable)
	(if (> (car (gimp-layer-get-mask drawable)) -1)
	  (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
	)
	(set! alphaselection (car (gimp-selection-save img)))
	(gimp-selection-shrink img size)
	(set! innerselection (car (gimp-selection-save img)))
	(if (= merge 1)
	  (begin
	    (set! origmask (car (gimp-layer-get-mask drawable)))
	    (if (> origmask -1)
	      (begin
		(set! origmask (car (gimp-channel-copy origmask)))
		(gimp-layer-remove-mask drawable 1)
	      )
	    )
	    (set! alphamask (car (gimp-layer-create-mask drawable 3)))
	    (gimp-selection-none img)
	    (gimp-threshold alphaselection 1 255)
	    (gimp-selection-load alphaselection)
	    (gimp-selection-combine innerselection 1)
	    (gimp-palette-set-foreground color)
	    (gimp-edit-fill strokelayer 0)
	    (set! strokelayer (car (gimp-image-merge-down img strokelayer 0)))
	    (gimp-drawable-set-name strokelayer layername)
	    (gimp-layer-add-mask strokelayer alphamask)
	    (gimp-layer-remove-mask strokelayer 0)
	    (if (> origmask -1)
	      (gimp-layer-add-mask strokelayer origmask)
	    )
	  )
	  (begin
	    (gimp-selection-load alphaselection)
	    (gimp-selection-combine innerselection 1)
	    (gimp-palette-set-foreground color)
	    (gimp-edit-fill strokelayer 0)
	  )
	)
      )
      (if (= position 100)
	(begin
	  (set! growamt (math-round (* size 1.2)))
	  (set! strokelayer (car (gimp-layer-new img (+ drwwidth (* growamt 2)) (+ drwheight (* growamt 2)) (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-stroke") opacity (get-blending-mode mode))))
	  (add-under-layer img strokelayer drawable)
	  (gimp-layer-set-offsets strokelayer (- (car drwoffsets) growamt) (- (cadr drwoffsets) growamt))
	  (gimp-selection-all img)
	  (gimp-edit-clear strokelayer)
	  (gimp-selection-none img)
	  (gimp-selection-layer-alpha drawable)
	  (if (> (car (gimp-layer-get-mask drawable)) -1)
	    (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
	  )
	  (set! alphaselection (car (gimp-selection-save img)))
	  (set! innerselection (car (gimp-selection-save img)))
	  (gimp-selection-none img)
	  (gimp-threshold innerselection 255 255)
	  (gimp-selection-load alphaselection)
	  (gimp-selection-grow img size)
	  (gimp-selection-combine innerselection 1)
	  (gimp-palette-set-foreground color)
	  (gimp-edit-fill strokelayer 0)
	  (if (= merge 1)
	    (begin
	      (set! origmask (car (gimp-layer-get-mask drawable)))
	      (if (> origmask -1)
		(gimp-layer-remove-mask drawable 0)
	      )
	      (set! strokelayer (car (gimp-image-merge-down img drawable 0)))
	      (gimp-drawable-set-name strokelayer layername)
	    )
	  )
	)
	(begin
	  (set! outerwidth (math-round (* (/ position 100) size)))
	  (set! innerwidth (- size outerwidth))
	  (set! growamt (math-round (* outerwidth 1.2)))
	  (set! strokelayer (car (gimp-layer-new img (+ drwwidth (* growamt 2)) (+ drwheight (* growamt 2)) (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-stroke") opacity (get-blending-mode mode))))
	  (add-over-layer img strokelayer drawable)
	  (gimp-layer-set-offsets strokelayer (- (car drwoffsets) growamt) (- (cadr drwoffsets) growamt))
	  (gimp-selection-all img)
	  (gimp-edit-clear strokelayer)
	  (gimp-selection-none img)
	  (gimp-selection-layer-alpha drawable)
	  (if (> (car (gimp-layer-get-mask drawable)) -1)
	    (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
	  )
	  (set! alphaselection (car (gimp-selection-save img)))
	  (gimp-selection-shrink img innerwidth)
	  (set! innerselection (car (gimp-selection-save img)))
	  (gimp-selection-load alphaselection)
	  (gimp-selection-grow img outerwidth)
	  (gimp-selection-combine innerselection 1)
	  (gimp-palette-set-foreground color)
	  (gimp-edit-fill strokelayer 0)
	  (if (= merge 1)
	    (begin
	      (set! origmask (car (gimp-layer-get-mask drawable)))
	      (if (> origmask -1)
		(gimp-layer-remove-mask drawable 0)
	      )
	      (set! strokelayer (car (gimp-image-merge-down img strokelayer 0)))
	      (gimp-drawable-set-name strokelayer layername)
	    )
	  )
	)
      )
    )
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img alphaselection)
    (gimp-image-remove-channel img innerselection)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-color-overlay img
					 drawable
					 color
					 opacity
					 mode
					 merge)
  (gimp-image-undo-group-start img)
  (let* ((origfgcolor (car (gimp-palette-get-foreground)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (colorlayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-color") opacity (get-blending-mode mode))))
	 (origmask 0)
	 (alphamask 0)
	)
    (add-over-layer img colorlayer drawable)
    (gimp-layer-set-offsets colorlayer (car drwoffsets) (cadr drwoffsets))
    (gimp-selection-all img)
    (gimp-palette-set-foreground color)
    (gimp-edit-fill colorlayer 0)
    (gimp-selection-none img)
    (if (= merge 1)
      (begin
	(set! origmask (car (gimp-layer-get-mask drawable)))
	(if (> origmask -1)
	  (begin
	    (set! origmask (car (gimp-channel-copy origmask)))
	    (gimp-layer-remove-mask drawable 1)
	  )
	)
	(set! alphamask (car (gimp-layer-create-mask drawable 3)))
	(set! colorlayer (car (gimp-image-merge-down img colorlayer 0)))
	(gimp-drawable-set-name colorlayer layername)
	(gimp-layer-add-mask colorlayer alphamask)
	(gimp-layer-remove-mask colorlayer 0)
	(if (> origmask -1)
	  (gimp-layer-add-mask colorlayer origmask)
	)
      )
      (begin
	(gimp-selection-layer-alpha drawable)
	(if (> (car (gimp-layer-get-mask drawable)) -1)
	  (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
	)
	(set! alphamask (car (gimp-layer-create-mask colorlayer 4)))
	(gimp-layer-add-mask colorlayer alphamask)
	(gimp-layer-remove-mask colorlayer 0)
      )
    )
    (gimp-palette-set-foreground origfgcolor)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-gradient-overlay img
					    drawable
					    grad
					    gradtype
					    repeattype
					    reverse
					    opacity
					    mode
					    cx
					    cy
					    gradangle
					    gradsize
					    merge)
  (gimp-image-undo-group-start img)
  (let* ((origgradient (car (gimp-context-get-gradient)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (gradientlayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-gradient") opacity (get-blending-mode mode))))
	 (origmask 0)
	 (alphamask 0)
	 (ang (* (* gradangle -1) (/ (* 4 (atan 1.0)) 180)))
	 (offsetX (math-round (* (/ gradsize 2) (cos ang))))
	 (offsetY (math-round (* (/ gradsize 2) (sin ang))))
	 (x1 (- (- cx offsetX) (car drwoffsets)))
	 (y1 (- (- cy offsetY) (cadr drwoffsets)))
	 (x2 (- (+ cx offsetX) (car drwoffsets)))
	 (y2 (- (+ cy offsetY) (cadr drwoffsets)))
	)
    (add-over-layer img gradientlayer drawable)
    (gimp-layer-set-offsets gradientlayer (car drwoffsets) (cadr drwoffsets))
    (gimp-selection-none img)
    (gimp-edit-clear gradientlayer)
    (gimp-context-set-gradient grad)
    (if (and (>= gradtype 6) (<= gradtype 8))
      (gimp-selection-layer-alpha drawable)
    )
    (gimp-edit-blend gradientlayer 3 0 gradtype 100 1 repeattype reverse 0 1 0 0 x1 y1 x2 y2)
    (gimp-selection-none img)
    (if (= merge 1)
      (begin
	(set! origmask (car (gimp-layer-get-mask drawable)))
	(if (> origmask -1)
	  (begin
	    (set! origmask (car (gimp-channel-copy origmask)))
	    (gimp-layer-remove-mask drawable 1)
	  )
	)
	(set! alphamask (car (gimp-layer-create-mask drawable 3)))
	(set! gradientlayer (car (gimp-image-merge-down img gradientlayer 0)))
	(gimp-drawable-set-name gradientlayer layername)
	(gimp-layer-add-mask gradientlayer alphamask)
	(gimp-layer-remove-mask gradientlayer 0)
	(if (> origmask -1)
	  (gimp-layer-add-mask gradientlayer origmask)
	)
      )
      (begin
	(gimp-selection-layer-alpha drawable)
	(if (> (car (gimp-layer-get-mask drawable)) -1)
	  (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
	)
	(set! alphamask (car (gimp-layer-create-mask gradientlayer 4)))
	(gimp-layer-add-mask gradientlayer alphamask)
	(gimp-layer-remove-mask gradientlayer 0)
      )
    )
    (gimp-context-set-gradient origgradient)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(define (script-fu-layerfx-pattern-overlay img
					   drawable
					   pattern
					   opacity
					   mode
					   merge)
  (gimp-image-undo-group-start img)
  (let* ((origpattern (car (gimp-context-get-pattern)))
	 (origselection (car (gimp-selection-save img)))
	 (drwwidth (car (gimp-drawable-width drawable)))
	 (drwheight (car (gimp-drawable-height drawable)))
	 (layername (car (gimp-drawable-get-name drawable)))
	 (drwoffsets (gimp-drawable-offsets drawable))
	 (patternlayer (car (gimp-layer-new img drwwidth drwheight (cond ((= (car (gimp-image-base-type img)) 0) 1) ((= (car (gimp-image-base-type img)) 1) 3)) (string-append layername "-pattern") opacity (get-blending-mode mode))))
	 (origmask 0)
	 (alphamask 0)
	)
    (add-over-layer img patternlayer drawable)
    (gimp-layer-set-offsets patternlayer (car drwoffsets) (cadr drwoffsets))
    (gimp-selection-all img)
    (gimp-context-set-pattern pattern)
    (gimp-edit-fill patternlayer 4)
    (gimp-selection-none img)
    (if (= merge 1)
      (begin
	(set! origmask (car (gimp-layer-get-mask drawable)))
	(if (> origmask -1)
	  (begin
	    (set! origmask (car (gimp-channel-copy origmask)))
	    (gimp-layer-remove-mask drawable 1)
	  )
	)
	(set! alphamask (car (gimp-layer-create-mask drawable 3)))
	(set! patternlayer (car (gimp-image-merge-down img patternlayer 0)))
	(gimp-drawable-set-name patternlayer layername)
	(gimp-layer-add-mask patternlayer alphamask)
	(gimp-layer-remove-mask patternlayer 0)
	(if (> origmask -1)
	  (gimp-layer-add-mask patternlayer origmask)
	)
      )
      (begin
	(gimp-selection-layer-alpha drawable)
	(if (> (car (gimp-layer-get-mask drawable)) -1)
	  (gimp-selection-combine (car (gimp-layer-get-mask drawable)) 3)
	)
	(set! alphamask (car (gimp-layer-create-mask patternlayer 4)))
	(gimp-layer-add-mask patternlayer alphamask)
	(gimp-layer-remove-mask patternlayer 0)
      )
    )
    (gimp-context-set-pattern origpattern)
    (gimp-selection-load origselection)
    (gimp-image-remove-channel img origselection)
    (gimp-displays-flush)
  )
  (gimp-image-undo-group-end img)
)

(script-fu-register "script-fu-layerfx-drop-shadow"
		    _"<Image>/Script-Fu/Layer Effects/_Drop Shadow..."
		    "Adds a drop shadow to a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"				0
		    SF-DRAWABLE		"Drawable"			0
		    SF-COLOR		_"Color"			'(0 0 0)
		    SF-ADJUSTMENT	"Opacity"			'(75 0 100 1 10 1 0)
		    SF-OPTION		"Contour"			'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-ADJUSTMENT	"Noise"				'(0 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"			'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Spread"			'(0 0 100 1 10 1 0)
		    SF-ADJUSTMENT	"Size"				'(5 0 250 1 10 1 1)
		    SF-ADJUSTMENT	"Offset Angle"			'(120 -180 180 1 10 1 0)
		    SF-ADJUSTMENT	"Offset Distance"		'(5 0 30000 1 10 1 1)
		    SF-TOGGLE		"Layer knocks out Drop Shadow"	FALSE
		    SF-TOGGLE		"Merge with layer"		FALSE)

(script-fu-register "script-fu-layerfx-inner-shadow"
		    _"<Image>/Script-Fu/Layer Effects/I_nner Shadow..."
		    "Adds an inner shadow to a layer"
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-COLOR		_"Color"		'(0 0 0)
		    SF-ADJUSTMENT	"Opacity"		'(75 0 100 1 10 1 0)
		    SF-OPTION		"Contour"		'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-ADJUSTMENT	"Noise"			'(0 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-OPTION		"Source"		'("Edge" "Center")
		    SF-ADJUSTMENT	"Choke"			'(0 0 100 1 10 1 0)
		    SF-ADJUSTMENT	"Size"			'(5 0 250 1 10 1 1)
		    SF-ADJUSTMENT	"Offset Angle"		'(120 -180 180 1 10 1 0)
		    SF-ADJUSTMENT	"Offset Distance"	'(5 0 30000 1 10 1 1)
		    SF-TOGGLE		"Merge with layer"	FALSE)

(script-fu-register "script-fu-layerfx-outer-glow"
		    _"<Image>/Script-Fu/Layer Effects/_Outer Glow..."
		    "Creates an outer glow effect around a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"				0
		    SF-DRAWABLE		"Drawable"			0
		    SF-COLOR		_"Color"			'(255 255 190)
		    SF-ADJUSTMENT	"Opacity"			'(75 0 100 1 10 1 0)
		    SF-OPTION		"Contour"			'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-ADJUSTMENT	"Noise"				'(0 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"			'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Spread"			'(0 0 100 1 10 1 0)
		    SF-ADJUSTMENT	"Size"				'(5 0 999 1 10 1 1)
		    SF-TOGGLE		"Layer knocks out Outer Glow"	FALSE
		    SF-TOGGLE		"Merge with layer"		FALSE)

(script-fu-register "script-fu-layerfx-inner-glow"
		    _"<Image>/Script-Fu/Layer Effects/_Inner Glow..."
		    "Creates an inner glow effect around a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-COLOR		_"Color"		'(255 255 190)
		    SF-ADJUSTMENT	"Opacity"		'(75 0 100 1 10 1 0)
		    SF-OPTION		"Contour"		'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-ADJUSTMENT	"Noise"			'(0 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-OPTION		"Source"		'("Edge" "Center")
		    SF-ADJUSTMENT	"Choke"			'(0 0 100 1 10 1 0)
		    SF-ADJUSTMENT	"Size"			'(5 0 999 1 10 1 1)
		    SF-TOGGLE		"Merge with layer"	FALSE)

(script-fu-register "script-fu-layerfx-bevel-emboss"
		    _"<Image>/Script-Fu/Layer Effects/_Bevel and Emboss..."
		    "Creates beveling and embossing effects over a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-OPTION		"Style"			'("Outer Bevel" "Inner Bevel" "Emboss" "Pillow Emboss")
		    SF-ADJUSTMENT	"Depth"			'(3 1 65 1 10 0 0)
		    SF-OPTION		"Direction"		'("Up" "Down")
		    SF-ADJUSTMENT	"Size"			'(5 0 250 1 10 0 0)
		    SF-ADJUSTMENT	"Soften"		'(0 0 16 1 2 0 0)
		    SF-ADJUSTMENT	"Angle"			'(120 -180 180 1 10 1 0)
		    SF-ADJUSTMENT	"Altitude"		'(30 0 90 1 10 1 0)
		    SF-OPTION		"Gloss Contour"		'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-COLOR		_"Highlight Color"	'(255 255 255)
		    SF-OPTION		"Highlight Mode"	'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Highlight Opacity"	'(75 0 100 1 10 1 0)
		    SF-COLOR		_"Shadow Color"		'(0 0 0)
		    SF-OPTION		"Shadow Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Shadow Opacity"	'(75 0 100 1 10 1 0)
		    SF-OPTION		"Surface Contour"	'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-TOGGLE		"Invert"		FALSE
		    SF-TOGGLE		"Merge with layer"	FALSE)

(script-fu-register "script-fu-layerfx-satin"
		    _"<Image>/Script-Fu/Layer Effects/_Satin..."
		    "Creates a satin effect over a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-COLOR		_"Color"		'(0 0 0)
		    SF-ADJUSTMENT	"Opacity"		'(75 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Offset Angle"		'(19 -180 180 1 10 1 0)
		    SF-ADJUSTMENT	"Offset Distance"	'(11 0 30000 1 10 1 1)
		    SF-ADJUSTMENT	"Size"			'(14 0 250 1 10 0 0)
		    SF-OPTION		"Contour"		'("Linear" "Cone" "Cone - Inverted" "Cove - Deep" "Cove-Shallow" "Gaussian" "Half Round" "Ring" "Ring - Double" "Rolling Slope - Descending" "Rounded Steps" "Sawtooth 1")
		    SF-TOGGLE		"Invert"		TRUE
		    SF-TOGGLE		"Merge with layer"	FALSE)

(script-fu-register "script-fu-layerfx-stroke"
		    _"<Image>/Script-Fu/Layer Effects/S_troke..."
		    "Creates a stroke around a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"					0
		    SF-DRAWABLE		"Drawable"				0
		    SF-COLOR		_"Color"				'(255 255 255)
		    SF-ADJUSTMENT	"Opacity"				'(100 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"				'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Size"					'(1 1 999 1 10 0 1)
		    SF-ADJUSTMENT	"Position (0 = inside, 100 = outside)"	'(50 0 100 1 10 1 0)
		    SF-TOGGLE		"Merge with layer"			FALSE)

(script-fu-register "script-fu-layerfx-color-overlay"
		    _"<Image>/Script-Fu/Layer Effects/_Color Overlay..."
		    "Overlays a color over a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-COLOR		_"Color"		'(255 255 255)
		    SF-ADJUSTMENT	"Opacity"		'(100 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-TOGGLE		"Merge with layer"	FALSE)

(script-fu-register "script-fu-layerfx-gradient-overlay"
		    _"<Image>/Script-Fu/Layer Effects/_Gradient Overlay..."
		    "Overlays a gradient over a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-GRADIENT		_"Gradient"		"Default"
		    SF-OPTION		"Gradient Type"		'("Linear" "Bi-linear" "Radial" "Square" "Conical (sym)" "Conical (asym)" "Shaped (angular)" "Shaped (spherical)" "Shaped (dimpled)" "Spiral (cw)" "Spiral (ccw)")
		    SF-OPTION		"Repeat"		'("None" "Sawtooth Wave" "Triangular Wave")
		    SF-TOGGLE		"Reverse"		FALSE
		    SF-ADJUSTMENT	"Opacity"		'(100 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-ADJUSTMENT	"Center X"		'(0 0 262144 1 10 0 1)
		    SF-ADJUSTMENT	"Center Y"		'(0 0 262144 1 10 0 1)
		    SF-ADJUSTMENT	"Gradient Angle"	'(90 -180 180 1 10 1 0)
		    SF-ADJUSTMENT	"Gradient Width"	'(10 0 262144 1 10 1 1)
		    SF-TOGGLE		"Merge with layer"	FALSE)

(script-fu-register "script-fu-layerfx-pattern-overlay"
		    _"<Image>/Script-Fu/Layer Effects/_Pattern Overlay..."
		    "Overlays a pattern over a layer."
		    "Jonathan Stipe <JonStipe@prodigy.net>"
		    "Jonathan Stipe"
		    "January 2008"
		    "RGBA, GRAYA"
		    SF-IMAGE		"Image"			0
		    SF-DRAWABLE		"Drawable"		0
		    SF-PATTERN		_"Pattern"		""
		    SF-ADJUSTMENT	"Opacity"		'(100 0 100 1 10 1 0)
		    SF-OPTION		"Blending Mode"		'("Normal" "Dissolve" "Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Hard Light" "Soft Light" "Grain Extract" "Grain Merge" "Difference" "Addition" "Subtract" "Darken Only" "Lighten Only" "Hue" "Saturation" "Color" "Value")
		    SF-TOGGLE		"Merge with layer"	FALSE)