!region Notices
! ================================================================================
! Notice : Copyright (C) 2017, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
!
!    This file is part of Devuna-CoolTips (https://github.com/Devuna/Devuna-CoolTips)
!
!    Devuna-CoolTips is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-CoolTips is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-CoolTips.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================
!endregion Notices
! ********************************************************************************
! Source module name:  cooltips.clw
! Release Version:     ToolTipClass Version 2015.03.05
!
!Version 2017.02.02
!rebuild for Clarion 10.0.12463
!fixed access violation bug which would cause program to crash
!
!Version 2015.03.05
!rebuild for Clarion 10
!
!Version 2014.11.30
!fixed SubClassFunc to call default window proc when pfnWindowProc is null
!
!Version 2014.10.24
!reworked code to handle tooltip icon when setting tooltip text
!
!Version 2014.03.01
!first Devuna release
!updated help file
!updated copyright information
!
!Version 2013.01.12
!reworked so that the control queue does not need to be accessed in the window procs
!this was causing intermittent crashes in clarion 8.9661
!updated copyright dates
!
!Version 2008.09.14
!added TTF_TRANSPARENT flag to ti structure to prevent double tips
!
!Version 2005.10.09
!compatible with clarion version 6.2.9048
!added old style AddTip method to avoid compile errors for converted applications
!
!Version 2005.09.21
!fixed font memeory leak
!
!Version 2005.09.20
!added ability to specify font, title, icon for individual tips
!
!Version 2005.09.11
!added SetBalloonTips method to allow changing tip type at runtime
!********************************************************************************
   MEMBER

   INCLUDE('COOLTIPS.INC'),ONCE

   MAP
      SubClassFunc(HWND hWndMsg,LONG wMsg,LONG wParam,LONG lParam),LONG,PASCAL
      WinSubClassFunc(HWND hWndMsg,LONG wMsg,LONG wParam,LONG lParam),LONG,PASCAL
      GetDefaultTipFont(HWND hWndTT, *LONG hDefaultFont, *BYTE PointSize)
      GetPointSize(LONG FontSize),BYTE
      MODULE('WIN32API')
         kcr_CallWindowProc(ULONG,HWND,UINT,WPARAM,LPARAM),LONG,PASCAL,NAME('CallWindowProcA')
         kcr_CreateFont(SIGNED,SIGNED,SIGNED,SIGNED,SIGNED,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,DWORD,*CSTRING),HANDLE,PASCAL,RAW,NAME('CreateFontA')
         kcr_CreateWindowEx(ULONG,*CSTRING,ULONG,ULONG,SHORT,SHORT,SHORT,SHORT,UNSIGNED,UNSIGNED,UNSIGNED,ULONG),HWND,PASCAL,RAW,NAME('CreateWindowExA')
         kcr_DefWindowProc(HWND,UINT,WPARAM,LPARAM),LONG,PASCAL,NAME('DefWindowProcA')
         kcr_DeleteObject(HANDLE),BOOL,PASCAL,PROC,NAME('DeleteObject')
         kcr_DestroyWindow(HWND),LONG,PASCAL,PROC,NAME('DestroyWIndow')
         kcr_FreeLibrary(HINSTANCE),BOOL,PASCAL,PROC,NAME('FreeLibrary')
         kcr_GetClassName(UNSIGNED hWnd, *CSTRING ClassName, LONG nClassName),LONG,PASCAL,RAW,PROC,NAME('GetClassNameA')
         kcr_GetClientRect(HWND hWnd, *tagRECT lpRect),BOOL,RAW,PASCAL,PROC,NAME('GetClientRect')
         kcr_GetDC(UNSIGNED),UNSIGNED,PASCAL,NAME('GetDC')
         kcr_GetDeviceCaps(UNSIGNED, SIGNED),SIGNED,PASCAL,NAME('GetDeviceCaps')
         kcr_GetProcAddress(UNSIGNED,*CSTRING),ULONG,PASCAL,RAW,NAME('GetProcAddress')
         kcr_GetProp(HWND hwnd, *CSTRING szPropertyName),HANDLE,RAW,PASCAL,NAME('GetPropA')
         kcr_GetWindowLong(HWND,SHORT),LONG,RAW,PASCAL,NAME('GetWindowLongA')
         kcr_GetWindowRect(HWND hWnd, *tagRECT lpRect),BOOL,RAW,PASCAL,PROC,NAME('GetWindowRect')
         kcr_GlobalAlloc(UNSIGNED,ULONG),HGLOBAL,PASCAL,NAME('GlobalAlloc')
         kcr_GlobalFree(HGLOBAL),HGLOBAL,PASCAL,PROC,NAME('GlobalFree')
         kcr_GlobalHandle(UNSIGNED),HGLOBAL,PASCAL,NAME('GlobalHandle')
         kcr_GlobalLock(HGLOBAL),ULONG,PASCAL,PROC,NAME('GlobalLock')
         kcr_GlobalUnlock(HGLOBAL),BOOL,PASCAL,PROC,NAME('GlobalUnlock')
         kcr_LoadLibrary(*CSTRING),HINSTANCE,PASCAL,RAW,NAME('LoadLibraryA')
         kcr_MulDiv(SIGNED,SIGNED,SIGNED),SIGNED,PASCAL,NAME('MulDiv')
         kcr_RegCloseKey(UNSIGNED),LONG,RAW,PASCAL,NAME('RegCloseKey'),PROC
         kcr_RegOpenKeyEx(UNSIGNED,*CSTRING,ULONG,ULONG,*ULONG),LONG,RAW,PASCAL,NAME('RegOpenKeyExA'),PROC
         kcr_RegQueryValueEx(UNSIGNED,*CSTRING,ULONG,*ULONG,ULONG,*ULONG),LONG,RAW,PASCAL,NAME('RegQueryValueExA'),PROC
         kcr_ReleaseDC(UNSIGNED, UNSIGNED),SIGNED,PASCAL,PROC,NAME('ReleaseDC')
         kcr_ScreenToClient(HWND hWnd, *tagPOINT lpPoint),PASCAL,RAW,NAME('ScreenToClient')
         kcr_SendMessage(LONG,LONG,LONG,LONG),LONG,PASCAL,PROC,NAME('SendMessageA')
         kcr_SetProp(HWND hwnd, *CSTRING szPropertyName, HANDLE hData),BOOL,RAW,PASCAL,PROC,NAME('SetPropA')
         kcr_SetWindowLong(HWND,SHORT,LONG),LONG,RAW,PASCAL,NAME('SetWindowLongA'),PROC
         kcr_SetWindowPos(UNSIGNED,UNSIGNED,SIGNED,SIGNED,SIGNED,SIGNED,SHORT),RAW,PASCAL,NAME('SetWindowPos')
         kcr_WideCharToMultiByte(UNSIGNED,DWORD,*STRING,SIGNED,*CSTRING,SIGNED,LONG,LONG),SIGNED,PASCAL,RAW,PROC,NAME('WideCharToMultiByte')
      END
      MODULE('COMDLG32')
         kcr_InitCommonControlsEx(*tagINITCOMMONCONTROLSEX),BOOL,PASCAL,RAW,PROC,NAME('InitCommonControlsEx')
      END
      MODULE('UTILLIB')
         kcr_CallDllGetVersion(ULONG, *tagDLLVERSIONINFO dvi),BYTE,RAW,PASCAL,PROC,NAME('CallDllGetVersion')
      END
      MODULE('CLIB')
         kcr_MemCpy(ULONG,ULONG,UNSIGNED),NAME('_memcpy')
         kcr_MemSet(ULONG,ULONG,UNSIGNED),NAME('_memset')
         kcr_StrCpy(ULONG,ULONG),NAME('_strcpy')
         kcr_StrnCpy(ULONG,ULONG,UNSIGNED),NAME('_strncpy')
         kcr_ltoa(LONG,*CSTRING,SIGNED),ULONG,RAW,NAME('_ltoa'),PROC
      END
   END

 COMPILE('End_Compile',_debuger_)
 INCLUDE('debuger.inc'),ONCE
dbx debuger
 !End_Compile

!========================================================================================
!========================================================================================
ToolTipClass.Init PROCEDURE(hwndParent,bBalloonTips)

iccex                GROUP(tagINITCOMMONCONTROLSEX),PRE(iccex)
                     END
bUseBalloonTips      BYTE
WorkCSTRING          CSTRING(40)
lDllVersion          LONG
comctl32             CSTRING('comctl32.dll')
szFont               CSTRING(33)

   CODE
      COMPILE('End_Compile',_debuger_)
      dbx.mg_init('cooltips')
      !End_Compile

      !Initialize Private Properties
      SELF.hwndParent = hwndParent
      SELF.Q &= NEW(tagCONTROLQUEUE)    !ControlQ
      ASSERT(NOT SELF.Q &= NULL,'Tooltip Control Queue is NULL')
      SELF.GetDllVersion(comctl32)

      !Check Style Flag
      bUseBalloonTips = bBalloonTips
      IF bUseBalloonTips
         !Check version for balloon support
         IF SELF.nDLLVersion >= 5.80
            bUseBalloonTips = TRUE
         ELSE
            bUseBalloonTips = FALSE
         END
      END

      !Initialize Common Controls
      iccex.dwICC = ICC_WIN95_CLASSES
      iccex.dwSize = size(iccex)
      IF ~kcr_InitCommonControlsEx(iccex)
?        MESSAGE('InitCommonControlsEx Failed','CoolTips Error')
         RETURN(FALSE)
      END

      WorkCSTRING = TOOLTIPS_CLASS
      !Create a ToolTip Window
      SELF.hwndTT = kcr_CreateWindowEx(WS_EX_TOPMOST,       |
               WorkCSTRING,                             |
               0,                                       |
               WS_POPUP + TTS_NOPREFIX + TTS_ALWAYSTIP + (TTS_BALLOON * bUseBalloonTips), |
               CW_USEDEFAULT,                           |
               CW_USEDEFAULT,                           |
               CW_USEDEFAULT,                           |
               CW_USEDEFAULT,                           |
               hwndParent,                              |
               0,                                       |
               SYSTEM{PROP:AppInstance},                |
               0)

      IF SELF.hwndTT
         kcr_SetWindowPos(SELF.hwndTT,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE + SWP_NOSIZE + SWP_NOACTIVATE)
         GetDefaultTipFont(SELF.hwndTT, SELF.hDefaultFont, SELF.bDefaultSize)

         !SetWindowLong(hwndParent,GWL_USERDATA,ADDRESS(SELF))
         kcr_SetProp(hwndParent,propToolTipClass,ADDRESS(SELF))

         SELF.pfnWindowProc = kcr_GetWindowLong(hwndParent,GWL_WNDPROC)
         kcr_SetProp(hwndParent,propWindowProc,SELF.pfnWindowProc)

         kcr_SetWindowLong(hwndParent,GWL_WNDPROC,ADDRESS(WinSubClassFunc))

         SELF.bEnabled = TRUE

         COMPILE('End_Compile',_debuger_)
         dbx.debugout('hwndTT ' & SELF.hwndTT)
         !End_Compile

      END

      SELF.SetMaxTipWidth(200)
      RETURN(SELF.hwndTT)

!========================================================================================
!========================================================================================
ToolTipClass.Kill PROCEDURE()
I     LONG
J     LONG

   CODE
      J = RECORDS(SELF.Q)
      LOOP I = 1 TO J
        GET(SELF.Q,I)

        IF SELF.Q.hMem
           kcr_GlobalFree(SELF.Q.hMem)
        END

        IF SELF.Q.hMemTitle
           kcr_GlobalFree(SELF.Q.hMemTitle)
        END

        !Clean up font objects
        IF SELF.Q.hFont
           kcr_DeleteObject(SELF.Q.hFont)
        END
      END

      IF SELF.hDefaultFont
         kcr_DeleteObject(SELF.hDefaultFont)
      END

      !Destroy the window
      IF SELF.hwndTT
         kcr_SetWindowLong(SELF.hwndParent,GWL_WNDPROC,SELF.pfnWindowProc)
         kcr_DestroyWindow(SELF.hwndTT)
         SELF.hwndTT = 0
      END

      !Free up the queue
      FREE(SELF.Q)
      DISPOSE(SELF.Q)
      SELF.Q &= NULL

      COMPILE('End_Compile',_debuger_)
      dbx.kill()
      !End_Compile

      RETURN

!========================================================================================
!========================================================================================
ToolTipClass.AddTip  PROCEDURE(HWND hwndControl,STRING sTip,BOOL bMultiline=0)  !,BOOL,PROC
   CODE
      RETURN(SELF.AddTip(hwndControl,sTip,bMultiline,'',0,'',0))

!========================================================================================
!========================================================================================
ToolTipClass.AddTip  PROCEDURE(HWND hwndControl,STRING sTip,BOOL bMultiline,STRING sTitle,LONG nIcon,STRING sFontName,BYTE nFontSize)   !,BOOL,PROC
ti                      LIKE(tagTOOLINFO)
sTipText                CSTRING(1024)
sTitleText              CSTRING(100)
hMem                    HANDLE
pMem                    ULONG
hDC                     HDC
nHeight                 LONG
!tt_font                 HANDLE
szFont                  CSTRING(256)

   CODE
      IF SELF.hwndTT
         !Subclass the control window
         SELF.Q.hwndControl = hwndControl

         SELF.Q.pfnControlProc = kcr_GetWindowLong(hwndControl,GWL_WNDPROC)
         !!SELF.Q.pfnControlProc = hwndControl{PROP:WndProc}
         ASSERT(SELF.Q.pfnControlProc <> ADDRESS(SubClassFunc))
         kcr_SetProp(hwndControl,propWindowProc,SELF.Q.pfnControlProc)

         kcr_SetProp(hwndControl,propToolTipClass,ADDRESS(SELF))

         kcr_SetWindowLong(hwndControl,GWL_WNDPROC,ADDRESS(SubClassFunc))
         !!hwndControl{PROP:WndProc} = ADDRESS(SubClassFunc)

         ! Initialize members of the TOOLINFO structure
         kcr_memset(ADDRESS(ti),00h,SIZE(ti))
         ti.cbSize = SIZE(ti)
         ti.uFlags = TTF_IDISHWND + TTF_TRANSPARENT               ! + TTF_SUBCLASS
         ti.hWindow = SELF.hwndParent
         ti.hinst = SYSTEM{PROP:AppInstance}
         ti.uId = SELF.Q.hwndControl

         IF bMultiLine
            SELF.Q.hMem = kcr_globalAlloc(GHND,LEN(sTip)+1)           !Allocate global memory
            pMem = kcr_globalLock(SELF.Q.hMem)                        !get pointer
            kcr_strncpy(pMem,ADDRESS(sTip),LEN(sTip))                 !copy tip to global memory
            kcr_memset(pMem+LEN(sTip),00h,1)                          !Null Terminate
            kcr_GlobalUnlock(SELF.Q.hMem)
            ti.lpszText = LPSTR_TEXTCALLBACK
            ti.lparam   = SELF.Q.hMem
            kcr_SetProp(hwndControl,propToolTipText,SELF.Q.hMem)
         ELSE
            SELF.Q.hMem = 0
            sTipText = sTip
            ti.lpszText = ADDRESS(sTipText)
            ti.lparam   = SELF.Q.hMem
         END

         SELF.Q.nIcon = nIcon

         sTitleText = CLIP(sTitle)
         IF sTitleText <> ''
            SELF.Q.hMemTitle = kcr_globalAlloc(GHND,LEN(sTitleText)+1)     !Allocate global memory
            pMem = kcr_globalLock(SELF.Q.hMemTitle)                        !get pointer
            kcr_strncpy(pMem,ADDRESS(sTitleText),LEN(sTitleText))          !copy tip to global memory
            kcr_memset(pMem+LEN(sTitleText),00h,1)                         !Null Terminate
            kcr_GlobalUnlock(SELF.Q.hMemTitle)
            kcr_SetProp(hwndControl,propToolTipTitle,SELF.Q.hMemTitle)
            kcr_SetProp(hwndControl,propToolTipIcon,SELF.Q.nIcon)
         ELSE
            kcr_SetProp(hwndControl,propToolTipTitle,0)
            kcr_SetProp(hwndControl,propToolTipIcon,0)
         END

         SELF.Q.hFont = 0
         szFont = CLIP(sFontName)
         IF szFont <> ''
            hDC = kcr_GetDC(SELF.hwndTT)
            IF INRANGE(nFontSize,6,24)
               nHeight = -kcr_MulDiv(nFontSize,kcr_GetDeviceCaps(hDC,LOGPIXELSY),72)
            ELSE
               nHeight = -kcr_MulDiv(SELF.bDefaultSize,kcr_GetDeviceCaps(hDC,LOGPIXELSY),72)
            END
            kcr_ReleaseDC(SELF.hwndTT,hDC)
            SELF.Q.hFont = kcr_CreateFont(nHeight,0,0,0,FW_NORMAL,0,0,0,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,BOR(DEFAULT_PITCH,FF_DONTCARE),szFont)
         ELSE
            SELF.Q.hFont = SELF.hDefaultFont
         END
         kcr_SetProp(hwndControl,propToolTipFont,SELF.Q.hFont)

         ! Add element to Control Queue
         ADD(SELF.Q,+SELF.Q.hwndControl)

         RETURN(SELF.AddTool(ti))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.Activate            PROCEDURE(BOOL fActivate)
!Activates or deactivates a tooltip control.
!
!TTM_ACTIVATE
!    wParam = (WPARAM) (BOOL) fActivate;
!    lParam = 0;
!
!Parameters:
!fActivate
!   Activation flag. If this parameter is TRUE, the tooltip control is activated. If it
!   is FALSE, the tooltip control is deactivated.
!========================================================================================
ToolTipClass.Activate            PROCEDURE(BOOL fActivate)
   CODE
      IF SELF.hwndTT
         ! Send TTM_ACTIVATE message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_ACTIVATE, fActivate, 0)
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.SetDelayTime        PROCEDURE(DWORD dwDuration, LONG iTime)
!Sets the initial, pop-up, and reshow durations for a tooltip control.
!
!TTM_SETDELAYTIME
!    wParam = (WPARAM)(DWORD) dwDuration;
!    lParam = (LPARAM)(INT) MAKELONG(iTime,0);
!
!Parameters:
!dwDuration
!   Flag that specifies the duration value to set. This parameter can be one of the
!   following values:
!       TTDT_AUTOPOP    Set the length of time a tooltip window remains visible if the
!                       pointer is stationary within a tool's bounding rectangle. To
!                       return the autopop delay time to its default value, set iTime to -1.
!       TTDT_INITIAL    Set the length of time a pointer must remain stationary within a
!                       tool's bounding rectangle before the tooltip window appears. To
!                       return the initial delay time to its default value, set iTime to -1.
!       TTDT_RESHOW     Set the length of time it takes for subsequent tooltip windows to
!                       appear as the pointer moves from one tool to another. To return
!                       the reshow delay time to its default value, set iTime to -1.
!       TTDT_AUTOMATIC  Set all three delay times to default proportions. The autopop time
!                       will be ten times the initial time and the reshow time will be one
!                       fifth the initial time. If this flag is set, use a positive value
!                       of iTime to specify the initial time, in milliseconds. Set iTime to
!                       a negative value to return all three delay times to their default
!                       values.
!
!iTime
!   Delay time, in milliseconds.
!
!Remarks:
!The default delay times are based on the double-click time. For the default double-click
!time of 500 ms, the initial, autopop, and reshow delay times are 500ms, 5000ms, and 100ms
!respectively.
!========================================================================================
ToolTipClass.SetDelayTime        PROCEDURE(DWORD dwDuration, LONG iTime)
   CODE
      IF SELF.hwndTT
         ! Send TTM_SETDELAYTIME message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_SETDELAYTIME, dwDuration, iTime)
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.AddTool             PROCEDURE(*tagTOOLINFO ti)
!Registers a tool with a tooltip control.
!
!TTM_ADDTOOL
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!lpti
!   Address of a TOOLINFO structure containing information that the tooltip control needs
!   to display text for the tool. The cbSize member of this structure must be filled in
!   before sending this message.
!
!Return Values:
!Returns TRUE if successful, or FALSE otherwise.
!========================================================================================
ToolTipClass.AddTool PROCEDURE(*tagTOOLINFO ti)
   CODE
      IF SELF.hwndTT
         ! Send TTM_ADDTOOL message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_ADDTOOL, 0, ADDRESS(ti)))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.DelTool             PROCEDURE(HWND hwndControl)
!Removes a tool from a tooltip control.
!
!TTM_DELTOOL
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!lpti
!   Address of a TOOLINFO structure. The hwnd and uId members identify the tool to remove,
!   and the cbSize member must specify the size of the structure. All other members are
!   ignored.
!========================================================================================
ToolTipClass.DelTool PROCEDURE(HWND hwndControl)

ti    LIKE(tagTOOLINFO)

   CODE
      IF SELF.hwndTT
         ! Clean up memory and remove q entry
         SELF.Q.hwndControl = hwndControl
         GET(SELF.Q,+SELF.Q.hwndControl)
         IF ~ERRORCODE()

            !SetWindowLong(SELF.Q.hwndControl,GWL_USERDATA,0)
            kcr_SetProp(SELF.Q.hwndControl,propToolTipClass,0)
            kcr_SetWindowLong(SELF.Q.hwndControl,GWL_WNDPROC,SELF.Q.pfnControlProc)

            IF SELF.Q.hMem
               kcr_GlobalFree(SELF.Q.hMem)
            END

            IF SELF.Q.hMemTitle
               kcr_GlobalFree(SELF.Q.hMemTitle)
            END

           !Clean up font objects
           IF SELF.Q.hFont
              kcr_DeleteObject(SELF.Q.hFont)
           END
            DELETE(SELF.Q)

            ! Initialize members of the TOOLINFO structure
            kcr_memset(ADDRESS(ti),00h,SIZE(ti))
            ti.cbSize = SIZE(ti)
            ti.hWindow = SELF.hwndParent
            ti.uId = hwndControl

            ! Send TTM_DELTOOL message to tooltip window
            kcr_SendMessage(SELF.hwndTT, TTM_DELTOOL, 0, ADDRESS(ti))
            RETURN(TRUE)
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.NewToolRect         PROCEDURE(HWND hwndControl, *tagRECT rect)
!Sets a new bounding rectangle for a tool.
!
!TTM_NEWTOOLRECT
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!lpti
!   Address of a TOOLINFO structure. The hwnd and uId members identify a tool, and the
!   rect member specifies the new bounding rectangle. The cbSize member of this structure
!   must be filled in before sending this message.
!========================================================================================
ToolTipClass.NewToolRect         PROCEDURE(HWND hwndControl, *tagRECT rect)

ti      LIKE(tagTOOLINFO)

   CODE
      IF SELF.hwndTT
         ! Initialize members of the TOOLINFO structure
         kcr_memset(ADDRESS(ti),00h,SIZE(ti))
         ti.cbSize = SIZE(ti)
         ti.hWindow = SELF.hwndParent
         ti.uId = hwndControl
         ti.rect = rect

         ! Send TTM_NEWTOOLRECT message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_NEWTOOLRECT, 0, ADDRESS(ti))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.RelayEvent          PROCEDURE(*tagMSG msg)
!Passes a mouse message to a tooltip control for processing.
!
!TTM_RELAYEVENT
!    wParam = 0;
!    lParam = (LPARAM) (LPMSG) lpmsg;
!
!Parameters:
!lpmsg
!   Address of an MSG structure that contains the message to relay.
!
!Remarks:
!A tooltip control processes only the following messages passed to it by the
!TTM_RELAYEVENT message:
!
!   WM_LBUTTONDOWN
!   WM_LBUTTONUP
!   WM_MBUTTONDOWN
!   WM_MBUTTONUP
!   WM_MOUSEMOVE
!   WM_RBUTTONDOWN
!   WM_RBUTTONUP
!========================================================================================
ToolTipClass.RelayEvent          PROCEDURE(*tagMSG pMsg)
   CODE
      IF SELF.hwndTT
         ! Send TTM_RELAYEVENT message to tooltip window
         kcr_SendMessage(SELF.hwndTT,TTM_RELAYEVENT,0,ADDRESS(pMsg))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetToolInfo         PROCEDURE(HWND hwndControl, *tagTOOLINFO ti)
!Retrieves the information that a tooltip control maintains about a tool.
!
!TTM_GETTOOLINFO
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!lpti
!   Address of a TOOLINFO structure. When sending the message, the hwnd and uId members
!   identify a tool, and the cbSize member must specify the size of the structure. If the
!   tooltip control includes the tool, the structure receives information about the tool.
!
!Return Values:
!Returns TRUE if successful, or FALSE otherwise.
!========================================================================================
ToolTipClass.GetToolInfo         PROCEDURE(HWND hwndControl, *tagTOOLINFO ti)
   CODE
      IF SELF.hwndTT
         kcr_memset(ADDRESS(ti),00h,SIZE(ti))
         ti.cbSize = SIZE(ti)
         ti.hWindow = SELF.hwndParent
         ti.uId = hwndControl
         ! Send TTM_GETTOOLINFO message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETTOOLINFO, 0, ADDRESS(ti)))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.SetToolInfo         PROCEDURE(*tagTOOLINFO ti)
!Sets the information that a tooltip control maintains for a tool.
!
!TTM_SETTOOLINFO
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!lpti
!   Address of a TOOLINFO structure that specifies the information to set. The cbSize member
!   of this structure must be filled in before sending this message.
!
!Remarks:
!Some internal properties of a tool are established when the tool is created, and are not
!recomputed when a TTM_SETTOOLINFO message is sent. If you simply assign values to a
!TOOLINFO structure and pass it to the tooltip control with a TTM_SETTOOLINFO message,
!these properties may be lost. Instead, your application should first request the tool's
!current TOOLINFO structure by sending the tooltip control a TTM_GETTOOLINFO message. Then,
!Modify the members of this structure as needed and pass it back to the tooltip control with
!TTM_SETTOOLINFO.
!========================================================================================
ToolTipClass.SetToolInfo         PROCEDURE(*tagTOOLINFO ti)
   CODE
      IF SELF.hwndTT
         ti.cbSize = SIZE(ti)
         ! Send TTM_SGETTOOLINFO message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_SETTOOLINFO, 0, ADDRESS(ti))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.HitTest             PROCEDURE(HWND hwndControl, *tagPOINT pt, *tagTOOLINFO ti)
!Tests a point to determine whether it is within the bounding rectangle of the specified tool
!and, if it is, retrieves information about the tool.
!
!TTM_HITTEST
!    wParam = 0;
!    lParam = (LPARAM) (LPHITTESTINFO) lphti;
!
!Parameters:
!lphti
!   Address of a TTHITTESTINFO structure. When sending the message, the hwnd member must
!   specify the handle to a tool and the pt member must specify the coordinates of a point.
!   If the return value is TRUE, the ti member (a TOOLINFO structure) receives information
!   about the tool that occupies the point. The cbSize member of the ti structure must be
!   filled in before sending this message.
!
!Return Values:
!Returns TRUE if the tool occupies the specified point, or FALSE otherwise.
!========================================================================================
ToolTipClass.HitTest             PROCEDURE(HWND hwndControl, *tagPOINT pt, *tagTOOLINFO ti)

hti     LIKE(tagTTHITTESTINFO)

   CODE
      IF SELF.hwndTT
         hti.hwndControl = hwndControl
         hti.pt = pt
         hti.ti.cbSize = SIZE(hti.ti)
         IF kcr_SendMessage(SELF.hwndTT, TTM_HITTESTA, 0, ADDRESS(hti))
            ti = hti.ti
            RETURN(TRUE)
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetText             PROCEDURE(HWND hwndControl, *CSTRING szText)
!Retrieves the information a tooltip control maintains about a tool.
!
!TTM_GETTEXT
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters
!lpti
!   Address of a TOOLINFO structure.
!   The cbSize member of this structure must be filled in before sending this message.
!   Set the hwnd and uId members to identify the tool for which to retrieve information.
!   Set the lpszText member to point to a buffer that receives the text. There currently
!   is no way to specify the size of the buffer or to determine the required buffer size.
!========================================================================================
ToolTipClass.GetText             PROCEDURE(HWND hwndControl, *CSTRING szText)

ti      LIKE(tagTOOLINFO)

   CODE
      IF SELF.hwndTT
         kcr_memset(ADDRESS(ti),00h,SIZE(ti))
         ti.cbSize = SIZE(ti)
         ti.hWindow = SELF.hwndParent
         ti.uId = hwndControl
         ti.lpszText = ADDRESS(szText)
         ! Send TTM_GETTEXT message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_GETTEXTA, 0, ADDRESS(ti))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.UpdateTipText       PROCEDURE(HWND hwndControl, STRING sTip, BOOL bMultiLine=0)
!Sets the tooltip text for a tool.
!
!TTM_UPDATETIPTEXT
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!lpti
!   Address of a TOOLINFO structure. The hinst and lpszText members must specify the
!   instance handle and the address of the text. The hwnd and uId members identify the
!   tool to update. The cbSize member of this structure must be filled in before sending
!   this message.
!========================================================================================
ToolTipClass.UpdateTipText       PROCEDURE(HWND hwndControl, STRING sTip, BOOL bMultiLine=0)

ti          LIKE(tagTOOLINFO)
sTipText    CSTRING(1024)
pMem        LONG

   CODE
      IF SELF.hwndTT
         SELF.Q.hwndControl = hwndControl
         GET(SELF.Q,+SELF.Q.hwndControl)
         IF ~ERRORCODE()
            ! Free existing global memory
            IF SELF.Q.hMem
               kcr_GlobalFree(SELF.Q.hMem)
            END

            ! Initialize members of the TOOLINFO structure
            kcr_memset(ADDRESS(ti),00h,SIZE(ti))
            ti.cbSize = SIZE(ti)
            ti.hWindow = SELF.hwndParent
            ti.hinst = SYSTEM{PROP:AppInstance}
            ti.uId = hwndControl
            IF bMultiLine
               SELF.Q.hMem = kcr_globalAlloc(GHND,LEN(sTip)+1)           !Allocate global memory
               pMem = kcr_globalLock(SELF.Q.hMem)                        !get pointer
               kcr_strncpy(pMem,ADDRESS(sTip),LEN(sTip))                 !copy tip to global memory
               kcr_memset(pMem+LEN(sTip),00h,1)                          !Null Terminate
               kcr_GlobalUnlock(SELF.Q.hMem)
               ti.lpszText = LPSTR_TEXTCALLBACK
               ti.lparam   = SELF.Q.hMem
            ELSE
               SELF.Q.hMem = 0
               sTipText = sTip
               ti.lpszText = ADDRESS(sTipText)
               ti.lparam   = SELF.Q.hMem
            END

            ! Update the control queue
            PUT(SELF.Q,+SELF.Q.hwndControl)

            ! Send TTM_UPDATETIPTEXT message to tooltip window
            kcr_SendMessage(SELF.hwndTT, TTM_UPDATETIPTEXT, 0, ADDRESS(ti))
            RETURN(TRUE)
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetToolCount        PROCEDURE()
!Retrieves a count of the tools maintained by a tooltip control.
!
!TTM_GETTOOLCOUNT
!    wParam = 0;
!    lParam = 0;
!
!Return Values:
!Returns a count of tools.
!========================================================================================
ToolTipClass.GetToolCount        PROCEDURE()
   CODE
      IF SELF.hwndTT
         ! Send TTM_GETTOOLCOUNT message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETTOOLCOUNT, 0, 0))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.EnumTools           PROCEDURE(UINT iTool, *tagTOOLINFO ti)
!Retrieves the information that a tooltip control maintains about the current tool
!that is, the tool for which the tooltip is currently displaying text.
!
!TTM_ENUMTOOLS
!    wParam = (WPARAM) (UINT) iTool;
!    lParam = (LPARAM) (LPTOOLINFO) lpti;
!
!Parameters:
!iTool
!   Zero-based index of the tool for which to retrieve information.
!lpti
!   Address of a TOOLINFO structure that receives information about the tool.
!   Before sending this message, the cbSize member must specify the size of the structure.
!
!Return Values:
!Returns TRUE if any tools are enumerated, or FALSE otherwise.
!========================================================================================
ToolTipClass.EnumTools           PROCEDURE(UINT iTool, *tagTOOLINFO ti)
   CODE
      IF SELF.hwndTT
         ! Initialize members of the TOOLINFO structure
         kcr_memset(ADDRESS(ti),00h,SIZE(ti))
         ti.cbSize = SIZE(ti)
         ! Send TTM_ENUMTOOLS message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_ENUMTOOLS, iTool, ADDRESS(ti)))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetCurrentTool      PROCEDURE(*tagTOOLINFO ti)
!Retrieves the information for the current tool in a tooltip control.
!
!TTM_GETCURRENTTOOL
!    wParam = 0;
!    lParam = (LPARAM)(LPTOOLINFO) lpti;
!
!Parameters
!lpti
!   Address of a TOOLINFO structure that receives information about the current tool.
!   If this value is NULL, the return value indicates the existence of the current tool
!   without actually retrieving the tool information. If this value is not NULL, the
!   cbSize member of the TOOLINFO structure must be filled in before sending this message.
!
!Return Values:
!Returns nonzero if successful, or zero otherwise. If lpti is NULL, returns nonzero if a
!current tool exists, or zero otherwise.
!========================================================================================
ToolTipClass.GetCurrentTool      PROCEDURE(*tagTOOLINFO ti)
   CODE
      IF SELF.hwndTT
         ! Initialize members of the TOOLINFO structure
         kcr_memset(ADDRESS(ti),00h,SIZE(ti))
         ti.cbSize = SIZE(ti)
         ! Send TTM_GETCURRENTTOOL message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETCURRENTTOOL, 0, ADDRESS(ti)))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.TrackActivate       PROCEDURE(HWND hwndControl, BOOL bActivate)
!Activates or deactivates a tracking tooltip.
!
!TTM_TRACKACTIVATE
!    wParam = (WPARAM)(BOOL) bActivate;
!    lParam = (LPARAM)(LPTOOLINFO) lpti;
!
!Parameters
!bActivate
!   Value specifying whether tracking is being activated or deactivated.
!   This value can be one of the following:
!       TRUE Activate tracking.
!       FALSE Deactivate tracking.
!
!lpti
!   Address of a TOOLINFO structure that identifies the tool to which this message applies.
!   The hwnd and uId members identify the tool, and the cbSize member specifies the size
!   of the structure. All other members are ignored.
!========================================================================================
ToolTipClass.TrackActivate       PROCEDURE(HWND hwndControl, BOOL bActivate)

ti      LIKE(tagTOOLINFO)

   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Initialize members of the TOOLINFO structure
         IF SELF.GetToolInfo(hwndControl, ti)
            ! Send TTM_TRACKACTIVATE message to tooltip window
            kcr_SendMessage(SELF.hwndTT, TTM_TRACKACTIVATE, bActivate, ADDRESS(ti))
            RETURN(TRUE)
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.TrackPosition       PROCEDURE(SIGNED xPos, SIGNED yPos)
!Parameters:
!xPos and yPos
!   The x- and y-coordinates of the point at which the tracking tooltip will be displayed,
!   in screen coordinates.
!
!Return Values:
!The return value for this message is not used.
!
!Remarks:
!The tooltip control chooses where to display the tooltip window based on the coordinates
!you provide with this message. This causes the tooltip window to appear beside the tool
!to which it corresponds. To have tooltip windows displayed at specific coordinates,
!include the TTF_ABSOLUTE flag in the uFlags member of the TOOLINFO structure when adding
!the tool.
!========================================================================================
ToolTipClass.TrackPosition       PROCEDURE(SIGNED xPos, SIGNED yPos)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_TRACKPOSITION message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_TRACKPOSITION, 0, SELF.MakeLong(xPos,yPos))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.SetTipBkColor       PROCEDURE(COLORREF clr)
!Sets the background color in a tooltip window.
!
!TTM_SETTIPBKCOLOR
!    wParam = (WPARAM)(COLORREF) clr;
!    lParam = 0;
!
!Parameters:
!clr
!   New background color.
!========================================================================================
ToolTipClass.SetTipBkColor       PROCEDURE(COLORREF clr)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_SETTIPBKCOLOR message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_SETTIPBKCOLOR, clr, 0)
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.SetTipTextColor     PROCEDURE(COLORREF clr)
!Sets the text color in a tooltip window.
!
!TTM_SETTIPTEXTCOLOR
!    wParam = (WPARAM)(COLORREF) clr;
!    lParam = 0;
!
!Parameters:
!clr
!   New text color.
!========================================================================================
ToolTipClass.SetTipTextColor     PROCEDURE(COLORREF clr)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_SETTIPTEXTCOLOR message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_SETTIPTEXTCOLOR, clr, 0)
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetDelayTime        PROCEDURE(DWORD dwDuration)
!Retrieves the initial, pop-up, and reshow durations currently set for a tooltip control.
!
!TTM_GETDELAYTIME
!    wParam = (DWORD) dwDuration;
!    lParam = 0;
!
!Parameters:
!dwDuration
!   Flag that specifies which duration value will be retrieved. This parameter can have one of
!   the following values:
!
!   TTDT_AUTOPOP    Retrieve the length of time the tooltip window remains visible if the
!                   pointer is stationary within a tool's bounding rectangle.
!   TTDT_INITIAL    Retrieve the length of time the pointer must remain stationary within a
!                   tool's bounding rectangle before the tooltip window appears.
!   TTDT_RESHOW     Retrieve the length of time it takes for subsequent tooltip windows to
!                   appear as the pointer moves from one tool to another.
!
!Return Values:
!Returns an INT value with the specified duration in milliseconds.
!========================================================================================
ToolTipClass.GetDelayTime        PROCEDURE(DWORD dwDuration)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_GETDELAYTIME message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETDELAYTIME, dwDuration, 0))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetTipBkColor       PROCEDURE()
!Retrieves the background color in a tooltip window.
!
!TTM_GETTIPBKCOLOR
!    wParam = 0;
!    lParam = 0;
!
!Return Values:
!Returns a COLORREF value that represents the background color.
!========================================================================================
ToolTipClass.GetTipBkColor       PROCEDURE()
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_GETTIPBKCOLOR message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETTIPBKCOLOR, 0, 0))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetTipTextColor     PROCEDURE()
!Retrieves the text color in a tooltip window.
!
!TTM_GETTIPTEXTCOLOR
!    wParam = 0;
!    lParam = 0;
!
!Return Values:
!Returns a COLORREF value that represents the text color.
!========================================================================================
ToolTipClass.GetTipTextColor     PROCEDURE()
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_GETTIPTEXTCOLOR message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETTIPTEXTCOLOR, 0, 0))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.SetMaxTipWidth      PROCEDURE(LONG iWidth)
!Sets the maximum width for a tooltip window.
!
!TTM_SETMAXTIPWIDTH
!    wParam = 0;
!    lParam = (LPARAM)(INT) iWidth;
!
!Parameters:
!iWidth
!   Maximum tooltip window width to be set.
!
!Return Values:
!Returns an INT value that represents the previous maximum tooltip width.
!
!Remarks:
!The maximum tooltip width value does not indicate a tooltip window's actual width.
!Rather, if a tooltip string exceeds the maximum width, the control breaks the text into
!multiple lines, using spaces to determine line breaks. If the text cannot be segmented
!into multiple lines, it will be displayed on a single line. The length of this line may
!exceed the maximum tooltip width.
!========================================================================================
ToolTipClass.SetMaxTipWidth      PROCEDURE(LONG iWidth)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_SETMAXTIPWIDTH message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_SETMAXTIPWIDTH, 0, iWidth))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetMaxTipWidth      PROCEDURE()
!Retrieves the maximum width for a tooltip window.
!
!TTM_GETMAXTIPWIDTH
!    wParam = 0;
!    lParam = 0;
!
!Return Values:
!Returns an INT value that represents the maximum tooltip width, in pixels. If no maximum
!width was set previously, the message returns -1.
!
!Remarks:
!The maximum tooltip width value does not indicate a tooltip window's actual width.
!Rather, if a tooltip string exceeds the maximum width, the control breaks the text into
!multiple lines, using spaces to determine line breaks. If the text cannot be segmented
!into multiple lines, it will be displayed on a single line. The length of this line may
!exceed the maximum tooltip width.
!========================================================================================
ToolTipClass.GetMaxTipWidth      PROCEDURE()
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_GETMAXTIPWIDTH message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_GETMAXTIPWIDTH, 0, 0))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.SetMargin           PROCEDURE(*tagRECT rc)
!Sets the top, left, bottom, and right margins for a tooltip window. A margin is the
!distance, in pixels, between the tooltip window border and the text contained within
!the tooltip window.
!
!TTM_SETMARGIN
!    wParam = 0;
!    lParam = (LPARAM)(LPRECT) lprc;
!
!Parameters:
!lprc
!   Address of a RECT structure that contains the margin information to be set.
!   The members of the RECT structure do not define a bounding rectangle.
!   For the purpose of this message, the structure members are interpreted as follows:
!       top     Distance between top border and top of tooltip text, in pixels.
!       left    Distance between left border and left end of tooltip text, in pixels.
!       bottom  Distance between bottom border and bottom of tooltip text, in pixels.
!       right   Distance between right border and right end of tooltip text, in pixels.
!========================================================================================
ToolTipClass.SetMargin           PROCEDURE(*tagRECT rc)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_SETMARGIN message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_SETMARGIN, 0, ADDRESS(rc))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.GetMargin           PROCEDURE(*tagRECT rc)
!Retrieves the top, left, bottom, and right margins set for a tooltip window. A margin is the distance, in pixels, between the tooltip window border and the text contained within the tooltip window.
!
!TTM_GETMARGIN
!    wParam = 0;
!    lParam = (LPARAM)(LPRECT) lprc;
!
!Parameters:
!lprc
!   Address of a RECT structure that will receive the margin information.
!   The members of the RECT structure do not define a bounding rectangle.
!   For the purpose of this message, the structure members are interpreted as follows:
!       top     Distance between top border and top of tooltip text, in pixels.
!       left    Distance between left border and left end of tooltip text, in pixels.
!       bottom  Distance between bottom border and bottom of tooltip text, in pixels.
!       right   Distance between right border and right end of tooltip text, in pixels.
!
!Remarks:
!All four margins default to zero when you create the tooltip control.
!========================================================================================
ToolTipClass.GetMargin           PROCEDURE(*tagRECT rc)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_GETMARGIN message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_GETMARGIN, 0, ADDRESS(rc))
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.Pop                 PROCEDURE()
!Removes a displayed tooltip window from view.
!
!TTM_POP
!    wParam = 0;
!    lParam = 0;
!========================================================================================
ToolTipClass.Pop                 PROCEDURE()
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.70
         ! Send TTM_POP message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_POP, 0, 0)
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!ToolTipClass.Update              PROCEDURE()
!Forces the current tool to be redrawn.
!
!TTM_UPDATE
!    wParam = 0;
!    lParam = 0;
!========================================================================================
ToolTipClass.Update              PROCEDURE()
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 4.71
         ! Send TTM_UPDATE message to tooltip window
         kcr_SendMessage(SELF.hwndTT, TTM_UPDATE, 0, 0)
         RETURN(TRUE)
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!GetBubbleSize  PROCEDURE(HWND hwndControl, *WORD wWidth, *WORD wHeight)
!Returns the width and height of a tooltip control.
!
!TTM_GETBUBBLESIZE
!    wParam = 0;
!    lParam = (LPARAM) (LPTOOLINFO) pTtm;
!
!Parameters:
!pTtm
!   Pointer to the tooltip's TOOLINFO structure.
!
!Return Values:
!Returns the width of the tooltip in the low word and the height in the high word if
!successful. Otherwise, it returns FALSE.
!
!Remarks
!If the TTF_TRACK and TTF_ABSOLUTE flags are set in the uFlags member of the tooltip's
!TOOLINFO structure, this message can be used to help position the tooltip accurately.
!========================================================================================
ToolTipClass.GetBubbleSize   PROCEDURE(HWND hwndControl, *WORD wWidth, *WORD wHeight)

lPackedSize LONG
ti          LIKE(tagTOOLINFO)

   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 5.80
         IF SELF.GetToolInfo(hwndControl, ti)
            ! Send TTM_GETBUBBLESIZE message to tooltip window
            lPackedSize = kcr_SendMessage(SELF.hwndTT, TTM_GETBUBBLESIZE, 0, ADDRESS(ti))
            IF lPackedSize
               wWidth  = BAND(lPackedSize,0FFFFh)
               wHeight = BSHIFT(BAND(lPackedSize,0FFFF0000h),-16)
               RETURN(TRUE)
            ELSE
               RETURN(FALSE)
            END
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!AdjustRect          PROCEDURE(BOOL fLarger, *tagRECT rc)
!Calculates a tooltip control's text display rectangle from its window rectangle, or the
!tooltip window rectangle needed to display a specified text display rectangle.
!
!TTM_ADJUSTRECT
!    wParam = (WPARAM) (BOOL) fLarger;
!    lParam = (LPARAM) (LPRECT) prc;
!
!Parameters:
!fLarger
!   Value that specifies which operation to perform. If TRUE, prc is used to specify a
!   text-display rectangle and it receives the corresponding window rectangle.
!   If FALSE, prc is used to specify a window rectangle and it receives the corresponding
!   text display rectangle.
!
!prc
!   RECT structure to hold either a tooltip window rectangle or a text display rectangle.
!
!Return Values:
!Returns a non-zero value if the rectangle is successfully adjusted, and returns zero if
!an error occurs.
!========================================================================================
ToolTipClass.AdjustRect          PROCEDURE(BOOL fLarger, *tagRECT rc)
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 5.80
         ! Send TTM_ADJUSTRECT message to tooltip window
         RETURN(kcr_SendMessage(SELF.hwndTT, TTM_ADJUSTRECT, fLarger, ADDRESS(rc)))
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!========================================================================================
!SetTitle            PROCEDURE(*CSTRING szTitle, WORD wIcon)
!Adds a standard icon and title string to a tooltip.
!
!TTM_SETTITLE
!wParam = icon;
!lParam = (LPCTSTR) pszTitle;
!
!Parameters
!icon
!   Set wParam to one of the following values to specify the icon to be displayed.
!       0 No icon.
!       1 Info icon.
!       2 Warning icon
!       3 Error Icon
!
!pszTitle
!   A pointer to the title string. You must assign a value to pszTitle.
!
!Return Values:
!Returns TRUE if successful, FALSE if not
!========================================================================================
ToolTipClass.SetTitle      PROCEDURE(*CSTRING szTitle, WORD wIcon)
bstrTitle   BSTRING
   CODE
      IF SELF.hwndTT AND SELF.nDLLVersion >= 5.80
         IF ~ERRORCODE()
            ! Send TTM_SETTITLE message to tooltip window
            RETURN(kcr_SendMessage(SELF.hwndTT, TTM_SETTITLE, wIcon, ADDRESS(szTitle)))
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!========================================================================================
ToolTipClass.SetTitle            PROCEDURE(STRING sTitle, WORD wIcon)

szTitle     CSTRING(64)

   CODE
      szTitle = sTitle
      RETURN(SELF.SetTitle(szTitle,wIcon))

!========================================================================================
!========================================================================================
ToolTipClass.SetBalloonTips PROCEDURE(BOOL fBalloonTips)
style   LONG

   CODE
      style = kcr_GetWindowLong(SELF.hwndTT,GWL_STYLE)
      IF fBalloonTips
         style = WS_POPUP + TTS_NOPREFIX + TTS_ALWAYSTIP + TTS_BALLOON
      ELSE
         style = WS_BORDER + WS_POPUP + TTS_NOPREFIX + TTS_ALWAYSTIP
      END
      kcr_SetWindowLong(SELF.hwndTT,GWL_STYLE,style)
      RETURN(TRUE)

!========================================================================================
!========================================================================================
ToolTipClass.UpdateTitle         PROCEDURE(HWND hwndControl,<*CSTRING NewTitle>,<WORD wIcon>)
pMem                 ULONG

   CODE
      IF SELF.hwndTT
         SELF.Q.hwndControl = hwndControl
         GET(SELF.Q,+SELF.Q.hwndControl)
         IF ~ERRORCODE()
            IF NOT OMITTED(3)
               ! Free existing global memory
               IF SELF.Q.hMemTitle
                  kcr_GlobalFree(SELF.Q.hMemTitle)
               END

               SELF.Q.hMemTitle = kcr_globalAlloc(GHND,LEN(NewTitle)+1)     !Allocate global memory
               pMem = kcr_globalLock(SELF.Q.hMemTitle)                      !get pointer
               kcr_strncpy(pMem,ADDRESS(NewTitle),LEN(NewTitle))            !copy tip to global memory
               kcr_memset(pMem+LEN(NewTitle),00h,1)                         !Null Terminate
               kcr_GlobalUnlock(SELF.Q.hMemTitle)
               kcr_SetProp(hwndControl,propToolTipTitle,SELF.Q.hMemTitle)
            END
            IF NOT OMITTED(4)
               SELF.Q.nIcon = wIcon
               kcr_SetProp(hwndControl,propToolTipIcon,SELF.Q.nIcon)
            END
            ! Update the control queue
            PUT(SELF.Q,+SELF.Q.hwndControl)

            RETURN(TRUE)
         ELSE
            RETURN(FALSE)
         END
      ELSE
         RETURN(FALSE)
      END

!========================================================================================
!========================================================================================
ToolTipClass.GetEnabled PROCEDURE()

   CODE
      RETURN(SELF.bEnabled)

!========================================================================================
!========================================================================================
ToolTipClass.SetEnabled PROCEDURE(BOOL fEnableTips)
oldValue    BYTE

   CODE
      oldValue = SELF.bEnabled
      SELF.bEnabled = fEnableTips
      RETURN(oldValue)

!========================================================================================
!========================================================================================
ToolTipClass.GetDllVersion   PROCEDURE(lpszDllName)

hinstDll        HINSTANCE
dwVersion       DWORD(0)
pDllGetVersion  ULONG
dvi             GROUP(tagDLLVERSIONINFO),PRE()
                END
hr              UNSIGNED
DllGetVersion   CSTRING('DllGetVersion')

   CODE
      hinstDll = kcr_LoadLibrary(lpszDllName)

      IF hinstDll
         pDllGetVersion = kcr_GetProcAddress(hinstDll, DllGetVersion)
         !Because some DLLs may not implement this function, you
         ! must test for it explicitly. Depending on the particular
         ! DLL, the lack of a DllGetVersion function may
         ! be a useful indicator of the version.
         IF pDllGetVersion
            kcr_memset(ADDRESS(dvi), 00h, SIZE(dvi))
            dvi.cbSize = SIZE(dvi)

            IF ~kcr_CallDllGetVersion(pDllGetVersion,dvi)
               SELF.nDLLVersion = (dvi.dwMajorVersion & '.' & dvi.dwMinorVersion)
?           ELSE
?              MESSAGE('CallDllGetVersion Failed','CoolTips Error')
            END
            kcr_FreeLibrary(hinstDll)
?        ELSE
?           MESSAGE('GetProcAddress Failed','CoolTips Error')
         END
?     ELSE
?        MESSAGE('LoadLibrary Failed','CoolTips Error')
      END
      RETURN

!========================================================================================
!========================================================================================
ToolTipClass.MakeLong PROCEDURE(a,b)
   CODE
      RETURN(BOR(a, BSHIFT(b,16)))

!========================================================================================
!========================================================================================
SubClassFunc   PROCEDURE(HWND hWndMsg,LONG wMsg,LONG wParam,LONG lParam)
_msg              LIKE(tagMSG)
tt                &ToolTipClass
hDC               HANDLE
nHeight           LONG
tt_font           HANDLE
hFont             LONG
szTitle           CSTRING(100)
hMem              HANDLE
pMem              ULONG
pfnWindowProc     LONG
hIcon             HANDLE

   CODE
      pfnWindowProc = kcr_GetProp(hWndMsg,propWindowProc)
      ASSERT(pfnWindowProc <> 0,'pfnWindowProc is null')
      IF pfnWindowProc = 0
         RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
      ELSE
         tt &= (kcr_GetProp(hWndMsg,propToolTipClass))
         IF tt &= NULL
            RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
         ELSIF tt.hwndTT = 0
            RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
         ELSIF tt.GetEnabled() = FALSE
            RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
         ELSE
            CASE wMsg
              OF WM_LBUTTONDOWN    |
            OROF WM_LBUTTONUP      |
            OROF WM_MBUTTONDOWN    |
            OROF WM_MBUTTONUP      |
            OROF WM_MOUSEMOVE      |
            OROF WM_RBUTTONDOWN    |
            OROF WM_RBUTTONUP
               _msg.lParam = lParam
               _msg.wParam = wParam
               _msg.message = wMsg
               _msg.hwnd = hWndMsg
               kcr_SendMessage(tt.hwndTT,TTM_RELAYEVENT,0,ADDRESS(_msg))
            END

            IF wMsg > TTM_GETCURRENTTOOLW
               RETURN(kcr_CallWindowProc(pfnWindowProc,hWndMsg,wMsg,wParam,lParam))
            ELSE
               hMem = kcr_GetProp(hWndMsg,propToolTipTitle)
               IF hMem
                  pMem = kcr_GlobalLock(hMem)
                  kcr_strcpy(ADDRESS(szTitle),pMem)
                  kcr_GlobalUnlock(hMem)
                  hIcon = kcr_GetProp(hWndMsg,propToolTipIcon)
                  IF hIcon
                     tt.SetTitle(szTitle,hIcon)
                  ELSE
                     tt.SetTitle(szTitle,TTI_NONE)
                  END
               ELSE
                  tt.SetTitle('',0)
               END
               kcr_SendMessage(tt.hwndTT,WM_SETFONT,kcr_GetProp(hWndMsg,propToolTipFont),0)
               RETURN(kcr_CallWindowProc(pfnWindowProc,hWndMsg,wMsg,wParam,lParam))
            END
         END
      END

!========================================================================================
!========================================================================================
WinSubClassFunc   PROCEDURE(HWND hWndMsg,LONG wMsg,LONG wParam,LONG lParam)
ttd                  LIKE(tagNMTTDISPINFO)
_nmhdr               LIKE(tagNMHDR),OVER(ttd)
szToolTip            CSTRING(1024)
ti                   LIKE(tagTOOLINFO)
pMem                 ULONG
tt                   &ToolTipClass
hFont                HFONT

   CODE
      tt &= (kcr_GetProp(hWndMsg,propToolTipClass))
      IF tt &= NULL
         RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
      ELSIF tt.hwndTT = 0
         RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
      ELSIF tt.pfnWindowProc = 0
         RETURN(kcr_DefWindowProc(hWndMsg,wMsg,wParam,lParam))
      ELSE
         CASE wMsg
           OF WM_NOTIFY
              kcr_memcpy(ADDRESS(_nmhdr),lParam,SIZE(_nmhdr))
              CASE _nmhdr.code
                OF TTN_POP
                   COMPILE('End_Compile',_debuger_)
                   dbx.debugout('ttn_pop ' & wParam)
                   !End_Compile
                   tt.SetTitle('',0)
                   hFont = kcr_GetProp(tt.hwndTT,propToolTipFont)
                   IF hFont AND hFont <> tt.hDefaultFont
                      kcr_DeleteObject(hFont)
                   END
                   kcr_SetProp(tt.hwndTT,propToolTipFont,tt.hDefaultFont)
                   kcr_SendMessage(tt.hwndTT,WM_SETFONT,tt.hDefaultFont,0)
                OF TTN_SHOW
                   COMPILE('End_Compile',_debuger_)
                   dbx.debugout('ttn_show idTT     ' & wParam)
                   !End_Compile
                OF TTN_GETDISPINFO
                   IF lParam
                      kcr_memcpy(ADDRESS(ttd),lParam,SIZE(ttd))
                      ti.cbSize = SIZE(ti)
                      kcr_SendMessage(ttd.hdr.hwndFrom, TTM_GETCURRENTTOOL, 0, ADDRESS(ti))
                      pMem = kcr_GlobalLock(ti.lparam)
                      !ASSERT(pMem,'pMem is null')
                      IF pMem
                         kcr_strcpy(ADDRESS(szToolTip),pMem)
                      END
                      kcr_GlobalUnlock(ti.lparam)
                      ttd.lpszText = ADDRESS(szToolTip)
                      kcr_memcpy(lParam,ADDRESS(ttd),SIZE(ttd))
                   END
                   COMPILE('End_Compile',_debuger_)
                   dbx.debugout('ttn_getdispinfo ' & wParam)
                   !End_Compile
                   RETURN(0)
              END
         END
         ASSERT(tt.pfnWindowProc,'tt.pfnWindowProc is null')
         RETURN(kcr_CallWindowProc(tt.pfnWindowProc,hWndMsg,wMsg,wParam,lParam))
      END

!========================================================================================
!========================================================================================
GetDefaultTipFont   PROCEDURE(HWND hWndTT, *LONG hDefaultFont, *BYTE bDefaultSize)
szSubKey            CSTRING('Control Panel\Desktop\WindowMetrics')
szValueName         CSTRING('StatusFont')
phkResult           ULONG
binValue            GROUP
FontSize               LONG
                       STRING(24)
wsFontName             STRING(64)
                    END
dwData              ULONG
dwType              ULONG
szFontName          CSTRING(33)
cc                  ULONG
hDC                 HANDLE
nHeight             LONG

   CODE
      CLEAR(binValue,-1)
      cc = kcr_RegOpenKeyEx(HKEY_CURRENT_USER,szSubKey,0,KEY_QUERY_VALUE,phkResult)
      IF ~cc
         dwData = SIZE(binValue)
         dwType = REG_BINARY
         cc = kcr_RegQueryValueEx(phkResult,szValueName,0,dwType,ADDRESS(binValue),dwData)
         IF ~cc
            cc = kcr_WideCharToMultiByte(CP_ACP,0,binValue.wsFontName,-1,szFontName,SIZE(szFontName),0,0)
         END
         kcr_RegCloseKey(phkResult)
      END
      IF szFontName = ''
         szFontName = 'Tahoma'
      END
      bDefaultSize = (GetPointSize(binValue.FontSize))
      hDC = kcr_GetDC(hWndTT)
      nHeight = -kcr_MulDiv(bDefaultSize,kcr_GetDeviceCaps(hDC,LOGPIXELSY),72)
      kcr_ReleaseDC(hWndTT,hDC)
      hDefaultFont = kcr_CreateFont(nHeight,0,0,0,FW_NORMAL,0,0,0,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,BOR(DEFAULT_PITCH,FF_DONTCARE),szFontName)
      RETURN

!========================================================================================
!========================================================================================
GetPointSize    PROCEDURE(LONG FontSize)    !,BYTE

PointSize_06 EQUATE(0FFFFFFF8h)
PointSize_07 EQUATE(0FFFFFFF7h)
PointSize_08 EQUATE(0FFFFFFF5h)
PointSize_09 EQUATE(0FFFFFFF4h)
PointSize_10 EQUATE(0FFFFFFF3h)
PointSize_11 EQUATE(0FFFFFFF1h)
PointSize_12 EQUATE(0FFFFFFF0h)
PointSize_13 EQUATE(0FFFFFFEFh)
PointSize_14 EQUATE(0FFFFFFEDh)
PointSize_15 EQUATE(0FFFFFFECh)
PointSize_16 EQUATE(0FFFFFFEBh)
PointSize_17 EQUATE(0FFFFFFE9h)
PointSize_18 EQUATE(0FFFFFFE8h)
PointSize_19 EQUATE(0FFFFFFE7h)
PointSize_20 EQUATE(0FFFFFFE5h)
PointSize_21 EQUATE(0FFFFFFE4h)
PointSize_22 EQUATE(0FFFFFFE3h)
PointSize_23 EQUATE(0FFFFFFE1h)
PointSize_24 EQUATE(0FFFFFFD5h)

PointSize    BYTE

   CODE
      CASE FontSize
      OF PointSize_06
         PointSize = 6
      OF PointSize_07
         PointSize = 7
      OF PointSize_08
         PointSize = 8
      OF PointSize_09
         PointSize = 9
      OF PointSize_10
         PointSize = 10
      OF PointSize_11
         PointSize = 11
      OF PointSize_12
         PointSize = 12
      OF PointSize_13
         PointSize = 13
      OF PointSize_14
         PointSize = 14
      OF PointSize_15
         PointSize = 15
      OF PointSize_16
         PointSize = 16
      OF PointSize_17
         PointSize = 17
      OF PointSize_18
         PointSize = 18
      OF PointSize_19
         PointSize = 19
      OF PointSize_20
         PointSize = 20
      OF PointSize_21
         PointSize = 21
      OF PointSize_22
         PointSize = 22
      OF PointSize_23
         PointSize = 23
      OF PointSize_24
         PointSize = 24
      END
      RETURN PointSize
