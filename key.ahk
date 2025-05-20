#SingleInstance,force
#Persistent
;variables
global key := "" ; XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX-XXXXXX
global CurrentSessionID
global hwid := "" ; if need
global name := "" ; your program name
global ownerid := "" ; your owner id

; creating web request
DataReq := ComObjCreate("Msxml2.XMLHTTP")

;_Initialize(name, ownerid) ; gettings session id
sleep, 5000 ; avg cooldown to get sessionid. can be changed by animation of something else.
;_License(key, CurrentSessionID, name, ownerid, hwid := "")

_Initialize(name, ownerid) ; CALL IT TO GET SESSION Id
{
	GLOBAL DataReq
	DataReq.onreadystatechange := Func("_InitializeReady") ;async method (ONLY FOR XMLHTTP)
	DataReq.Open("GET","https://keyauth.win/api/1.1/?type=init&ver=1.0&name=" name "&ownerid=" ownerid,true) ;request (initialize for sessionid)
	DataReq.send()
}

_InitializeReady() { ; DO NOT MESS WITH
	GLOBAL DataReq
	if (DataReq.readyState != 4)
        return
    if (DataReq.status == 200)
	{
		Loop, parse, % DataReq.ResponseText(), `, ;parsing JSON
		{
			If InStr(A_LoopField, "sessionid")
			{
				CurrentSessionID := StrReplace(StrSplit(A_LoopField, ":").2, """") ;change to your global var
			}
		}
	}
}

_License(key, sessionid, name, ownerid, hwid := ""){
	GLOBAL DataReq
	DataReq.onreadystatechange := Func("_LicenseReady") ;async method (ONLY FOR XMLHTTP)
	DataReq.Open("GET","https://keyauth.win/api/1.1/?type=license&key=" key "&hwid=" hwid "&sessionid=" sessionid "&name=" name "&ownerid=" ownerid,true) ;request
	DataReq.send()
}

_LicenseReady(){
	GLOBAL DataReq
	if (DataReq.readyState != 4)
        return
	if (DataReq.status == 200)
    {
		MsgBox % DataReq.ResponseText()
	}
}
