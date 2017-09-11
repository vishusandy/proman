Dictionary()
{
   CLSID_Dictionary := "{EE09B103-97E0-11CF-978F-00A02463E06F}"
    IID_IDictionary := "{42C642C1-97E1-11CF-978F-00A02463E06F}"
   Return CreateObject(CLSID_Dictionary, IID_IDictionary)
}

GetItem(pdic, sKey)   ; Added Exists check, to avoid creating an unwanted new one.
{
   pKey := SysAllocString(sKey)
   VarSetCapacity(var1, 8 * 2, 0)
   EncodeInteger(&var1 + 0, 8)
   EncodeInteger(&var1 + 8, pKey)

   DllCall(VTable(pdic, 12), "Uint", pdic, "Uint", &var1, "intP", bExist)

   If bExist
   {
      VarSetCapacity(var2, 8 * 2, 0)
      DllCall(VTable(pdic, 9), "Uint", pdic, "Uint", &var1, "Uint", &var2)
      pItm := DecodeInteger(&var2 + 8)
      Unicode2Ansi(pItm, sItm)
      SysFreeString(pItm)
   }

   SysFreeString(pKey)

   Return sItm
}

Add(pdic, sKey, sItm)   ; If already existing one, will produce error, i.e., no update.
{
   pKey := SysAllocString(sKey)
   VarSetCapacity(var1, 8 * 2, 0)
   EncodeInteger(&var1 + 0, 8)
   EncodeInteger(&var1 + 8, pKey)

   pItm := SysAllocString(sItm)
   VarSetCapacity(var2, 8 * 2, 0)
   EncodeInteger(&var2 + 0, 8)
   EncodeInteger(&var2 + 8, pItm)

   DllCall(VTable(pdic, 10), "Uint", pdic, "Uint", &var1, "Uint", &var2)

   SysFreeString(pKey)
   SysFreeString(pItm)
}


HashVal(pdic, sKey)
{
   pKey := SysAllocString(sKey)
   VarSetCapacity(var1, 8 * 2, 0)
   EncodeInteger(&var1 + 0, 8)
   EncodeInteger(&var1 + 8, pKey)

   DllCall(VTable(pdic, 12), "Uint", pdic, "Uint", &var1, "intP", bExist)

   If bExist
   {
      VarSetCapacity(var2, 8 * 2, 0)
      DllCall(VTable(pdic, 21), "Uint", pdic, "Uint", &var1, "Uint", &var2)
      nHashVal := DecodeInteger(&var2 + 8)
   }

   SysFreeString(pKey)

   Return nHashVal
}

#Include CoHelper.ahk
