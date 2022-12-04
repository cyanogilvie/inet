package require jitc

namespace eval ::inet {
	namespace export *
	namespace ensemble create -prefixes no

	set cdef {
		options		{-Wall -gdwarf-5}
		filter		{jitc::re2c -W --case-ranges}
		code {
			Tcl_Obj*	lit_ipv4				= NULL;
			Tcl_Obj*	lit_ipv4_net			= NULL;
			Tcl_Obj*	lit_ipv6				= NULL;
			Tcl_Obj*	lit_ipv6_net			= NULL;
			Tcl_Obj*	lit_invalid				= NULL;

			INIT {
				replace_tclobj(&lit_ipv4,				Tcl_NewStringObj("ipv4",				-1));
				replace_tclobj(&lit_ipv4_net,			Tcl_NewStringObj("ipv4_net",			-1));
				replace_tclobj(&lit_ipv6,				Tcl_NewStringObj("ipv6",				-1));
				replace_tclobj(&lit_ipv6_net,			Tcl_NewStringObj("ipv6_net",			-1));
				replace_tclobj(&lit_invalid,			Tcl_NewStringObj("invalid",				-1));
				return TCL_OK;
			}

			RELEASE {
				replace_tclobj(&lit_ipv4,				NULL);
				replace_tclobj(&lit_ipv4_net,			NULL);
				replace_tclobj(&lit_ipv6,				NULL);
				replace_tclobj(&lit_ipv6_net,			NULL);
				replace_tclobj(&lit_invalid,			NULL);
			}

			OBJCMD(type){
				CHECK_ARGS(1, "addr");
				const char*	str = Tcl_GetString(objv[1]);
				const char*	YYCURSOR = str;
				const char*	YYMARKER;

				/*!re2c
					re2c:yyfill:enable = 0;
					re2c:define:YYCTYPE = "char";

					end			= [\x00];
					alpha       = [a-zA-Z];
					digit       = [0-9];
					hexdigit    = [0-9a-fA-F];
					dec_octet
						= digit
						| [\x31-\x39] digit
						| "1" digit{2}
						| "2" [\x30-\x34] digit
						| "25" [\x30-\x35];
					prefix
						= [12]? digit
						| "3" [012];
					prefix6
						= digit
						| [1-9] digit
						| "1" [01] digit
						| "12" [0-8];
					ipv4address = dec_octet "." dec_octet "." dec_octet "." dec_octet;
					h16         = hexdigit{1,4};
					ls32        = h16 ":" h16 | ipv4address;
					ipv6address
						=                            (h16 ":"){6} ls32
						|                       "::" (h16 ":"){5} ls32
						| (               h16)? "::" (h16 ":"){4} ls32
						| ((h16 ":"){0,1} h16)? "::" (h16 ":"){3} ls32
						| ((h16 ":"){0,2} h16)? "::" (h16 ":"){2} ls32
						| ((h16 ":"){0,3} h16)? "::"  h16 ":"     ls32
						| ((h16 ":"){0,4} h16)? "::"              ls32
						| ((h16 ":"){0,5} h16)? "::"              h16
						| ((h16 ":"){0,6} h16)? "::";

					ipv4address end				{ Tcl_SetObjResult(interp, lit_ipv4);				return TCL_OK; }
					ipv4address "/" prefix end	{ Tcl_SetObjResult(interp, lit_ipv4_net);			return TCL_OK; }
					ipv6address end 			{ Tcl_SetObjResult(interp, lit_ipv6);				return TCL_OK; }
					ipv6address "/" prefix6 end	{ Tcl_SetObjResult(interp, lit_ipv6_net);			return TCL_OK; }
					*							{ Tcl_SetObjResult(interp, lit_invalid);			return TCL_OK; }
				*/

				Tcl_SetObjResult(interp, Tcl_NewStringObj("Fell out of re2c block", -1));
				return TCL_ERROR;
			}
		}
	}

	interp alias {} [namespace current]::type {} jitc::capply $cdef type
}
