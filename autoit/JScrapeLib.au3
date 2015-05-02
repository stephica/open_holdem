
; ============================================================================
; 							 JScrape Library v1.3
;   							19th July 2009
; 						 	 Copyright 2009, JLab
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; ============================================================================

; Variable declarations - your script may need to include these 

;	; The char bank - a list of ASCII representations of characters in a specific font
;	; The maximum number of characters in the char bank
;	Global $Char_maxChars = 64
;	; The maximum size of the characters in the charbank
;	Global $Char_maxWidth = 16
;	Global $Char_maxHeight = 16
;
;	; The name of the set of characters currently in the bank
;	Global $Char_set_name
;	; The character represented by each char in the set, and its size
;	Global $Char_bank_chr[$Char_maxChars + 1]
;	Global $Char_bank_width[$Char_maxChars + 1]
;	Global $Char_bank_height[$Char_maxChars + 1]
;	; The charbank itself, [set][char][n] a string like "  x xxx " on the nth row of the character
;	Global $Char_bank[$Char_maxChars + 1][$Char_maxHeight + 1]
;	; The number of characters currently in the character bank
;	Global $Char_bank_number
;
;	; The list of scraped characters, with lines separated by "|"
;	Global $Char_scrape_string
;	; The number of scraped characters in the string 
;	Global $Char_scrape_count
;	; When scraping, remember the position of the line, so that a new line can be noticed
;	Global $Char_scrape_currentLinePosition
;	Global $Char_scrape_lastLinePosition
;   ; When scraping, also remember the position of the last character (specifically, the x coordinate
;   ;    of the right-most pixel), and the minimum width of the space between words, so that the
;   ;    script can detect space
;	Global $Char_scrape_lastColumn
;   Global $Char_scrape_spaceWidth
;	; Up to three colours which determine the font colours to search for
;	Global $Char_scrape_colour[3 + 1]

; Image searching utilities

Func Util_FindImage($checksum, $pixelColour, $image_width, $image_height, $region_topx, $region_topy, $region_bottomx, $region_bottomy)

	; Finds the first location in a search region where an image can be found
	; 		The image has the checksum $checksum and its top-left pixel has the colour $pixelColour
	;		The image has width $image_width and height $image_height
	;		The search region's top-left corner pixel has x coordinate $region_topx, y coordinate $region_topy
	;			and the bottom-right corner has x coordinate $region_bottomx, y coordinate $region_bottomy
	; Returns an array with the coordinates of the top-left pixel of the first location found,
	;		such that $returnArray[1] = x coordinate, $returnArray[2] = y coordinate
	; If no match location matching the image is found, returns "fail"
	
	Local $x, $startY, $nextLineFlag, $pixel, $result
	Local $returnArray[3]
	
	; Uncomment one of these lines to be sure of using absolute or relative coordinates
;	Opt("PixelCoordMode", 0) 		; Use coordinates relative to the active window
;	Opt("PixelCoordMode", 1) 		; Use coordinates relative to the desktop
;	Opt("PixelCoordMode", 2) 		; Use coordinates relative to the active window's client area
	
	; Check the region for pixels matching the colour, that could possibly be the top-left corner of the image
	
	; Search one column at a time
	For $x = $region_topx to $region_bottomx
		$startY = $region_topy
		$nextLineFlag = 0
		Do
			$pixel = PixelSearch($x, $startY, $x, ($region_bottomy - $image_height), $pixelColour)
			If Not @error Then 
				
				; Compare the checksum at this location
				$result = PixelChecksum($pixel[0], $pixel[1], ($pixel[0] + $image_width), ($pixel[1] + $image_height))
				If $result = $checksum Then 
					; We have found a match!
					$returnArray[0] = "success"
					$returnArray[1] = $pixel[0]
					$returnArray[2] = $pixel[1]
					Return $returnArray
				Else
					; Search the rest of this line
					If $startY = $region_bottomy - $image_height Then 
						$nextLineFlag = 1
					; Search the next line
					Else
						$startY = $pixel[1] + 1
					EndIf
				EndIf
			Else
				; Search the next line
				$nextLineFlag = 1
			EndIf
		Until $nextLineFlag = 1
	Next

	; If no matches were found, return "fail"
	$returnArray[0] = "fail"
	Return $returnArray
	
EndFunc

Func Util_PixelSearch($topx, $topy, $bottomx, $bottomy)

	; A replacement for PixelSearch() that finds pixels of up to three different colours
	; Look for one of the up to three pixel colours in the specified region, $Pixel_number contains the number
	;	of target colours (should be 1, 2 or 3)
	; First look for colour 1, then colour 2, then colour 3. Return the result of PixelSearch() after the first
	; 	successful search (don't search for colour 2, if colour 1 is present)
	; If region contains none of the colours, returns "fail"

	Local $result

	If $Char_scrape_colour[2] = -1 Then
		$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Char_scrape_colour[1])
		If @error Then
			Return "fail"
		Else
			Return $result
		EndIf

	ElseIf $Char_scrape_colour[3] = -1 Then
		$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Char_scrape_colour[1])
		If @error Then
			$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Char_scrape_colour[2])
			If @error Then
				Return "fail"
			Else
				Return $result
			EndIf
		Else
			Return $result
		EndIf

	ElseIf $Char_scrape_colour[3] <> -1 Then 
		$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Char_scrape_colour[1])
		If @error Then
			$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Char_scrape_colour[2])
			If @error Then
				$result = PixelSearch($topx, $topy, $bottomx, $bottomy, $Char_scrape_colour[3])
				If @error Then
					Return "fail"
				Else
					Return $result
				EndIf
			Else
				Return $result
			EndIf
		Else
			Return $result
		EndIf

	EndIf

EndFunc

; Text scrape utilities

; The scraping algorithm goes can be called from one of two functions
;
;	Util_ScrapeText					Called to search a region for characters matching the character bank
;									Copies any recognised characters into the string $Char_scrape_string
;									Returns the number of scraped characters (also stored in $Char_scrape_count)
;   Util_ScrapeText_DetectSpaces	As above, but also detects spaces between words - spaces are defined as gaps
;									   between characters that are at least $spaceWidth pixels wide (minimum 2 pixels)
;
; Both these functions then proceed as follows
;
;	Util_ScrapeText_SearchStage1	If necessary, lower the top and raise the bottom of the search region to remove any 
;									characters touching the top and bottom, which may be partially outside the captured image
;	Util_ScrapeText_SearchStage2	Separate the search region into horizontal bands, each line of which contains at least one of 
;									the target pixel colours
;
;		(for each horizontal band)
; 	Util_ScrapeText_SearchStage3	If necessary, move the left- and right-hand boundaries of the band inwards to remove
;									characters touching the boundaries, which may be partially outside the captured image
;	Util_ScrapeText_SearchStage4	Separate the band into vertical strips, which should contain one character (or a few
;									touching ones)
;
;		(for each vertical strip)
;	Util_ScrapeText_SearchStage5	If necessary, narrow the strip to contain only the top and bottom of a character
; 	Util_ScrapeText_SearchStage6	If the character is too big, reduce its size
;
; 	    (for each character)
; 	Util_ScrapeText_ScrapeChar		Scrapes the character and appends it to $Char_scrape_string

Func Util_ScrapeText($topx, $topy, $bottomx, $bottomy, $colour1, $colour2 = -1, $colour3 = -1)

	; Store the font colours so they don't have to be passed from function to function
	$Char_scrape_colour[1] = $colour1
	$Char_scrape_colour[2] = $colour2
	$Char_scrape_colour[3] = $colour3
	
	; Reset the scraped string variables
	$Char_scrape_string = ""
	$Char_scrape_count = 0
	$Char_scrape_currentLinePosition = 0
	$Char_scrape_lastLinePosition = 0

    ; Don't detect spaces between words
	$Char_scrape_lastColumn = -1
	$Char_scrape_spaceWidth = -1

	; Scrape the text, storing it in the scraped string
	Util_ScrapeText_SearchStage1($topx, $topy, $bottomx, $bottomy)
	
	; Return the number of scraped characters
	Return $Char_scrape_count
	
EndFunc

Func Util_ScrapeText_DetectSpaces($spaceWidth, $topx, $topy, $bottomx, $bottomy, $colour1, $colour2 = -1, $colour3 = -1)

	; Store the font colours so they don't have to be passed from function to function
	$Char_scrape_colour[1] = $colour1
	$Char_scrape_colour[2] = $colour2
	$Char_scrape_colour[3] = $colour3
	
	; Reset the scraped string variables
	$Char_scrape_string = ""
	$Char_scrape_count = 0
	$Char_scrape_currentLinePosition = 0
	$Char_scrape_lastLinePosition = 0

    ; Detect spaces between words, as long as $spaceWidth is an integer, 2 or above
	$Char_scrape_lastColumn = -1
	If StringIsInt($spaceWidth) AND $spaceWidth >= 2 Then 
		$Char_scrape_spaceWidth = $spaceWidth
	Else
		$Char_scrape_spaceWidth = -1
	EndIf
		
	; Scrape the text, storing it in the scraped string
	Util_ScrapeText_SearchStage1($topx, $topy, $bottomx, $bottomy)
	
	; Return the number of scraped characters
	Return $Char_scrape_count
	
EndFunc

Func Util_ScrapeText_SearchStage1($topx, $topy, $bottomx, $bottomy)

	; Narrow the search region hoping to remove any partially-visible characters at the top and bottom of the search region

	Local $line, $matchLine, $count, $result, $newTopY
	Local $newBottomY

	; Lower the top horizontal line until a line without the target pixel is found, but don't lower it
	; at all if a line can't be found within the maximum character height, or within the search region
	$line = $topy - 1
	$matchLine = ""
	$count = 0
	Do

		$line = $line + 1
		$count = $count + 1
		If $count > $Char_maxHeight Or $line > $bottomy Then
			; Give up, use the old top horizontal line
			$matchLine = $topy
		Else
			$result = Util_PixelSearch($topx, $line, $bottomx, $line)
			If $result = "fail" Then
				; No pixels of the right colour found on this line
				$matchLine = $line
			Else
				; Target pixel was found, ignore this line
			EndIf
		EndIf
	Until $matchLine > 0

	$newTopY = $matchLine

	; Raise the bottom horizontal line
	$line = $bottomy + 1
	$matchLine = ""
	$count = 0
	Do

		$line = $line - 1
		$count = $count + 1
		If $count > $Char_maxHeight Or $line < $topy Then
			; Give up
			$matchLine = $bottomy
		Else
			$result = Util_PixelSearch($topx, $line, $bottomx, $line)
			If $result = "fail" Then
				$matchLine = $line
			EndIf
		EndIf
	Until $matchLine > 0

	$newBottomY = $matchLine

	; Make the changes to the search region
	$topy = $newTopY
	$bottomy = $newBottomY

	; Now search the narrowed region
	Util_ScrapeText_SearchStage2($topx, $topy, $bottomx, $bottomy)

	Return "success"

EndFunc  

Func Util_ScrapeText_SearchStage2($topx, $topy, $bottomx, $bottomy) 

	; Search the region, horizontal strip after horizontal strip

	Local $startLine, $endLine, $line, $result, $matchLine
	Local $finishedFlag = 0

	$startLine = $topy - 1
	$endLine = $topy - 1
	Do
		
		; Find the start line, starting one below the last endline
		$line = $endLine
		$matchLine = ""
		Do
			$line = $line + 1
			$result = Util_PixelSearch($topx, $line, $bottomx, $line)
			If $result = "fail" Then
				; No pixels of the right colour found on this line
			Else
				; Target pixel was found, make this the start line
				$matchLine = $line
			EndIf
			; Check if this is the end of the search region
			If $line >= $bottomy Then
				$finishedFlag = 1
			EndIf
			; Continue until a match is found, or the end of the search region is reached
		Until $finishedFlag = 1 Or $matchLine <> ""

		If $finishedFlag = 0 And $matchLine <> "" Then

			; Set the start line
			$startLine = $matchLine

			; Find the end line, the last line containing the pixel colour, starting one below the start line
			$line = $startLine
			$matchLine = ""
			Do
				$line = $line + 1
				$result = Util_PixelSearch($topx, $line, $bottomx, $line)
				If $result = "fail" Then
					; Target pixel wasn't found in this line, make it the end line plus one
					$matchLine = $line
				ElseIf $line >= $bottomy Then
					; We have reached the end of the search region, end the search
					$finishedFlag = 1
				EndIf
				; Continue until a line without the pixel is found, or the end of the search region is reached
			Until $finishedFlag = 1 Or $matchLine <> ""

			If $matchLine <> "" Then
				; Set the end line to be one above the match line
				$endLine = $matchLine - 1
			ElseIf $finishedFlag = 1 Then
				; Set the end line to be the bottom of the search region
				$endLine = $bottomy
			EndIf

			; If a start line and end line was found, search the region enclosed by them
			If $endLine <> "" Then
				Util_ScrapeText_SearchStage3($topx, $startLine, $bottomx, $endLine)
			EndIf
		EndIf

		; Repeat the loop until the end of the search region has been reached
	Until $finishedFlag = 1

	Return "success"

EndFunc   

Func Util_ScrapeText_SearchStage3($topx, $topy, $bottomx, $bottomy)

	; Narrow the search region hoping to remove any partially-visible characters at the left and right of the search region

	Local $column, $matchColumn, $count, $result, $newTopX
	Local $newBottomX

	; Move the leftmost vertical column to the right
	$column = $topx - 1
	$matchColumn = ""
	$count = 0
	Do

		$column = $column + 1
		$count = $count + 1
		If $count > $Char_maxWidth Or $column > $bottomx Then
			; Don't narrow the search region from the left side
			$matchColumn = $topx
		Else
			$result = Util_PixelSearch($column, $topy, $column, $bottomy)
			If $result = "fail" Then
				$matchColumn = $column
			EndIf
		EndIf
	Until $matchColumn > 0

	$newTopX = $matchColumn

	; Move the rightmost vertical column to the left
	$column = $bottomx + 1
	$matchColumn = ""
	$count = 0
	Do

		$column = $column - 1
		$count = $count + 1
		If $count > $Char_maxWidth Or $column < $topy Then
			; Don't narrow the search region from the right side
			$matchColumn = $bottomx
		Else
			$result = Util_PixelSearch($column, $topy, $column, $bottomy)
			If $result = "fail" Then
				$matchColumn = $column
			EndIf
		EndIf
	Until $matchColumn > 0

	$newBottomX = $matchColumn

	; Make the changes to the search region
	$topx = $newTopX
	$bottomx = $newBottomX

	; Now search the narrowed region
	Util_ScrapeText_SearchStage4($topx, $topy, $bottomx, $bottomy)

	Return "success"

EndFunc  

Func Util_ScrapeText_SearchStage4($topx, $topy, $bottomx, $bottomy) 

	; Search the region, vertical strip after vertical strip

	Local $startColumn, $endColumn, $column, $result, $matchColumn
	Local $finishedFlag = 0

	$startColumn = $topx - 1
	$endColumn = $topx - 1
	Do

		; Find the start column, starting one to the right of the last end column
		$column = $endColumn
		$matchColumn = ""
		Do
			$column = $column + 1
			$result = Util_PixelSearch($column, $topy, $column, $bottomy)
			If $result = "fail" Then
				; Target pixel wasn't found in this column, move on to the next one
			Else
				; Target pixel was found, make this the start column
				$matchColumn = $column
			EndIf
			; Check if this is the end of the search region
			If $column >= $bottomx Then
				$finishedFlag = 1
			EndIf
			; Continue until a match is found, or the end of the search region is reached
		Until $finishedFlag = 1 Or $matchColumn <> ""

		If $finishedFlag = 0 And $matchColumn <> "" Then

			; Set the start column
			$startColumn = $matchColumn

			; Find the end column, the last column containing the target pixel colour, starting one to the right
			; of the start column
			$column = $startColumn
			$matchColumn = ""
			Do
				$column = $column + 1
				$result = Util_PixelSearch($column, $topy, $column, $bottomy)
				If $result = "fail" Then
					; Target pixel wasn't found in this column, make this the end column plus one
					$matchColumn = $column
				ElseIf $column >= $bottomx Then
					; We have reached the end of the search region, end the search
					$finishedFlag = 1
				EndIf
				; Continue until a column without the pixel is found, or the end of the search region is reached
			Until $finishedFlag = 1 Or $matchColumn <> ""

			If $matchColumn <> "" Then
				; Set the end column to be one to the left of the match column
				$endColumn = $matchColumn - 1
			ElseIf $finishedFlag = 1 Then
				; Set the end column to be the right boundary of the search region
				$endColumn = $bottomx
			EndIf

			; If a start column and end column were found, search the region enclosed by them
			If $endColumn <> "" Then
				Util_ScrapeText_SearchStage5($startColumn, $topy, $endColumn, $bottomy)
			EndIf
		EndIf

		; Repeat the loop until the end of the search region has been reached
	Until $finishedFlag = 1

	Return "success"

EndFunc   

Func Util_ScrapeText_SearchStage5($topx, $topy, $bottomx, $bottomy) 

	; Narrow the search region to contain only the top and bottom of the character

	Local $startLevel, $endLevel, $level, $result
	Local $finishedFlag = 0

	; Remember the top of the search region - Util_ScrapeText_ScrapeChar needs it to recognise when 
	; the scraped char is on a new line
	$Char_scrape_currentLinePosition = $topy
	
	; Find the start level, starting one above the top of the region
	$level = $topy - 1
	Do

		$level = $level + 1
		$result = Util_PixelSearch($topx, $level, $bottomx, $level)
		If $result = "fail" Then
			; No pixels of the right colour found on this level
		Else
			; Target pixel was found, make this the start level
			$startLevel = $level
		EndIf
		; If the bottom of the search region is reached, forget about scraping characters in this region
		If $level >= $bottomy Then
			$finishedFlag = 1
		EndIf
		; Continue until a match is found, or the end of the search region is reached
	Until $finishedFlag = 1 Or $startLevel <> ""

	If $finishedFlag = 0 Then

		$level = $bottomy + 1
		Do
			$level = $level - 1
			$result = Util_PixelSearch($topx, $level, $bottomx, $level)
			If $result = "fail" Then
				; No pixels of the right colour found on this level
			Else
				; Target pixel was found, make this the end level
				$endLevel = $level
			EndIf
			; If the start level is reached, mark it as the endline
			If $level <= $startLevel Then
				$endLevel = $startLevel
			EndIf
			; Continue until a match is found, or the end of the search region is reached
		Until $endLevel <> ""

		; Check that the search region isn't bigger than the maximum character size
		Util_ScrapeText_SearchStage6($topx, $startLevel, $bottomx, $endLevel)
	EndIf

	Return "success"

EndFunc   

Func Util_ScrapeText_SearchStage6($topx, $topy, $bottomx, $bottomy)

	; The search region should now contain a single character. If the region is bigger than the maximum allowed
	; character size, reduce the size of the region by raising the bottom line and moving the right line to the left

	; Raise the bottom line, if necessary
	If ($bottomy - $topy + 1) > $Char_maxHeight Then
		$bottomy = $topy + $Char_maxHeight - 1
		Beep(2000, 100)
	EndIf
	; Move the right line to the left, if necessary
	If ($bottomx - $topx + 1) > $Char_maxWidth Then
		$bottomx = $topx + $Char_maxWidth - 1
		Beep(2000, 100)
	EndIf

	; Scrape the character contained in the region enclosed by the start and end levels
	Util_ScrapeText_ScrapeChar($topx, $topy, $bottomx, $bottomy)

	Return "success"

EndFunc   

Func Util_ScrapeText_ScrapeChar($topx, $topy, $bottomx, $bottomy) 

	; Scrape the character occupying the region bounded by the function arguments, but if it is bigger
	;    than the maximum size, ignore the excess pixels
	; Then look for a match in the character bank, and if one is found, add the character to the scraped string
	
	Local $region_countX, $region_countY, $char_countX, $char_countY, $pixel
	Local $scrapedChar[$Char_maxHeight + 1], $scrapedChar_width, $scrapedChar_height
	Local $bankCount, $bankMatch, $m, $c
	
	; Scrape the char
	$region_countY = $topy - 1 ; Count the region pixels from top to bottom
	$char_countY = 0 ; Count the char pixels from top to bottom
	Do
		$region_countY = $region_countY + 1
		$char_countY = $char_countY + 1
		If $char_countY <= $Char_maxHeight Then
				$region_countX = $topx - 1 ; Count the region pixels from left to right
			$char_countX = 0 ; Count the char pixels from left to right
			Do
			$region_countX = $region_countX + 1
				$char_countX = $char_countY + 1
				If $char_countX <= $Char_maxWidth Then
					$pixel = PixelGetColor($region_countX, $region_countY)
					If $pixel = $Char_scrape_colour[1] Or $pixel = $Char_scrape_colour[2] Or $pixel = $Char_scrape_colour[3] Then
						$scrapedChar[$char_countY] = $scrapedChar[$char_countY] & "x"
					Else
						$scrapedChar[$char_countY] = $scrapedChar[$char_countY] & " "
					EndIf
				EndIf
			Until $region_countX = $bottomx
		EndIf
	Until $region_countY = $bottomy
	
	; Remember the height and width of the scraped character
	$scrapedChar_width = $bottomx - $topx + 1
	$scrapedChar_height = $bottomy - $topy + 1

	; Now look for a match in the character bank
	$bankCount = 0
	$bankMatch = 0
	Do
		$bankCount = $bankCount + 1
		; Only compare characters of the right width and height
		If $scrapedChar_width = $Char_bank_width[$bankCount] AND $scrapedChar_height = $Char_bank_height[$bankCount] Then 
			; Compare each line in turn, and record any discrepancy
			$m = 0
			$c = 0
			Do
				$c = $c + 1
				If $Char_bank[$bankCount][$c] <> $scrapedChar[$c] Then 
					$m = $c
				EndIf
			Until $m > 0 OR $c = $scrapedChar_height
			
			If $m = 0 Then 
				; The scraped char matches this charbank char
				$bankMatch = $bankCount 
			EndIf
		EndIf
	Until $bankMatch > 0 OR $bankCount = $Char_bank_number

	; If a match was found, add it to the scraped character array
	If $bankMatch > 0 Then 
		
		; If this is the first line, remember its position (and forget about the 
		;   right-most column of the previous scraped character, on the previous line)
		If $Char_scrape_lastLinePosition = 0 Then 
			$Char_scrape_lastLinePosition = $Char_scrape_currentLinePosition
			$Char_scrape_lastColumn = -1
		; If the character is on a new line, add the delimiter "|" to the string (and 
		;   forget about the right-most column of the previous scraped character, on the 
		;   previous line)
		ElseIf $Char_scrape_lastLinePosition <> $Char_scrape_currentLinePosition Then 
			$Char_scrape_string = $Char_scrape_string & "|"
			$Char_scrape_lastLinePosition = $Char_scrape_currentLinePosition
			$Char_scrape_lastColumn = -1			
		; If space detection is on...
		ElseIf $Char_scrape_spaceWidth <> -1 Then 
			; If this isn't the first character in the line, check for spaces between words
			If $Char_scrape_lastColumn <> -1 AND ($Char_scrape_lastColumn + $Char_scrape_spaceWidth) < $topx Then 
				; The space between this character and the previous is one is big enough to be a 
				;   space between words, so add a space to the string
				$Char_scrape_string = $Char_scrape_string & " "
			EndIf
			; Remember the right-most column of this character, in case it's the end of a word
			$Char_scrape_lastColumn = $bottomx
		EndIf
		
		; Add the character to the string, and remember how many characters have been scraped
		$Char_scrape_string = $Char_scrape_string & $Char_bank_chr[$bankMatch]
		$Char_scrape_count = $Char_scrape_count + 1
		
		Return "success"	

	Else
		 
		Return "fail"
		 
	EndIf

EndFunc  

; JScrape output utilities 

Func Util_EmptyCharBank()
	
	; Empty the charbank so that <Casino>_LoadCharBank_<Name>() can fill it
	
	Local $a, $b
	
	$Char_set_name = ""
	For $a = 1 to $Char_maxChars
		$Char_bank_chr[$a] = ""
		For $b = 1 to $Char_maxHeight
			$Char_bank[$a][$b] = ""
		Next
	Next
	
	Return "success"
	
EndFunc
