/*
	Title: Encrypt Email
	
	Function: CryptEmail
	
	Encodes an email address into a string of alternating hexadecimal and decimal
	HTML entities which make it harder for spam bots to parse your web pages.
	
	Parameters:
		a - email address, the protocol prefix may be omitted (mailto:)
		t - anchor text, if this is blank or equal to the email address it will
				default to the encrypted version of the email address without the protocol prefix
	
	Returns:
		A valid XHTML anchor with the encoded email address and text.
	
	About: License
		- Version 2.1 by Titan <http://www.autohotkey.net/~Titan/#cryptemail>.
		- Licenced under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/>.

*/

CryptEmail(a, t = "") {
	f = %A_FormatInteger%
	p = mailto:
	If !InStr(a, p)
		a = %p%%a%
	Loop, Parse, a
	{
		SetFormat, Integer, % A_Index & 1 ? "Hex" : "Dec"
		c .= "&#" . Asc(A_LoopField) . ";"
	}
	SetFormat, Integer, %f%
	StringReplace, c, c, 0x, x, All
	If t in ,%a%
		StringTrimLeft, t, c, 41
	Return, "<a href=""" . c . """>" . t . "</a>"
}
