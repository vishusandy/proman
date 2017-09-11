;http://www.autohotkey.com/forum/topic4934.html

#NoEnv

SetFormat Integer, H
CRC32(x)
{
   L := StrLen(x)>>1          ; length in bytes
   StringTrimLeft L, L, 2     ; remove leading 0x
   L = 0000000%L%
   StringRight L, L, 8        ; 8 hex digits
   x = %x%%L%                 ; standard pad
   R =  0xFFFFFFFF            ; initial register value
   Loop Parse, x
   {
      y := "0x" A_LoopField   ; one hex digit at a time
      Loop 4
      {
         R := (R << 1) ^ ( (y << (A_Index+28)) & 0x100000000)
         IfGreater R,0xFFFFFFFF
            R := R ^ 0x104C11DB7
      }
   }
   Return ~R                  ; ones complement is the CRC
}