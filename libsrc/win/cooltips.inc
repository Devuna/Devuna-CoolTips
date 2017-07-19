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
!*********************************************************************************
! Source module name:  cooltips.inc
! Release Version:     ToolTipClass Version 2017.02.02
!
!Version 2017.02.02
!Rebuild for Clarion 10.0.12463
!
!Version 2015.03.05
!Rebuild for Clarion 10
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
!fixed font memory leak
!
!Version 2005.09.20
!added ability to specify font, title, icon for individual tips
!
!Version 2005.09.11
!added SetBalloonTips method to allow changing tip type at runtime
!********************************************************************************

    OMIT('_EndOfInclude_',_DevunaEquatesPresent_)
! Create Window
CW_USEDEFAULT           EQUATE(080000000h)

DEFAULT_PITCH           EQUATE(0)
LOGPIXELSY              EQUATE(90)          ! Logical pixels/inch in Y
HKEY_CURRENT_USER       EQUATE(080000001h)
KEY_QUERY_VALUE         EQUATE(00001h)
    !_EndOfInclude_

    OMIT('_EndOfInclude_',_ToolTipClassPresent_)
_ToolTipClassPresent_   EQUATE(1)

    INCLUDE('svapi.inc'),ONCE

WORD                    EQUATE(USHORT)
DWORD                   EQUATE(ULONG)
HANDLE                  EQUATE(UNSIGNED)
UINT                    EQUATE(UNSIGNED)
HWND                    EQUATE(HANDLE)
HINSTANCE               EQUATE(HANDLE)
HGLOBAL                 EQUATE(HANDLE)
WPARAM                  EQUATE(UINT)
LPARAM                  EQUATE(LONG)
COLORREF                EQUATE(DWORD)

tagINITCOMMONCONTROLSEX GROUP,TYPE
dwSize                    DWORD            ! size of this structure
dwICC                     DWORD            ! flags indicating which classes to be initialized
                        END

ICC_LISTVIEW_CLASSES    EQUATE(000000001h) ! listview, header
ICC_TREEVIEW_CLASSES    EQUATE(000000002h) ! treeview, tooltips
ICC_BAR_CLASSES         EQUATE(000000004h) ! toolbar, statusbar, trackbar, tooltips
ICC_TAB_CLASSES         EQUATE(000000008h) ! tab, tooltips
ICC_UPDOWN_CLASS        EQUATE(000000010h) ! updown
ICC_PROGRESS_CLASS      EQUATE(000000020h) ! progress
ICC_HOTKEY_CLASS        EQUATE(000000040h) ! hotkey
ICC_ANIMATE_CLASS       EQUATE(000000080h) ! animate
ICC_WIN95_CLASSES       EQUATE(0000000FFh)
ICC_DATE_CLASSES        EQUATE(000000100h) ! month picker, date picker, time picker, updown
ICC_USEREX_CLASSES      EQUATE(000000200h) ! comboex
ICC_COOL_CLASSES        EQUATE(000000400h) ! rebar (coolbar) control
ICC_INTERNET_CLASSES    EQUATE(000000800h)
ICC_PAGESCROLLER_CLASS  EQUATE(000001000h) ! page scroller
ICC_NATIVEFNTCTL_CLASS  EQUATE(000002000h) ! native font control

tagPOINT                GROUP,TYPE
X                         SIGNED
Y                         SIGNED
                        END

tagRECT                 GROUP,TYPE
left                      SIGNED
top                       SIGNED
right                     SIGNED
bottom                    SIGNED
                        END

tagTOOLINFO             GROUP,TYPE
cbSize                    UINT
uFlags                    UINT
hWindow                   HWND
uId                       UINT
rect                      LIKE(tagRECT)
hinst                     HINSTANCE
lpszText                  ULONG
lParam                    LPARAM
                        END

tagTTHITTESTINFO        GROUP,TYPE
hwndControl               HWND
pt                        LIKE(tagPOINT)
ti                        LIKE(tagTOOLINFO)
                        END

LPSTR_TEXTCALLBACK      EQUATE(-1)

!ToolTip Icons (Set with TTM_SETTITLE)
TTI_NONE                EQUATE(0)
TTI_INFO                EQUATE(1)
TTI_WARNING             EQUATE(2)
TTI_ERROR               EQUATE(3)

TTDT_AUTOMATIC          EQUATE(0)
TTDT_RESHOW             EQUATE(1)
TTDT_AUTOPOP            EQUATE(2)
TTDT_INITIAL            EQUATE(3)

TTM_ACTIVATE            EQUATE(WM_USER + 1)
TTM_SETDELAYTIME        EQUATE(WM_USER + 3)
TTM_ADDTOOL             EQUATE(WM_USER + 4)
TTM_DELTOOL             EQUATE(WM_USER + 5)
TTM_NEWTOOLRECT         EQUATE(WM_USER + 6)
TTM_RELAYEVENT          EQUATE(WM_USER + 7)
TTM_GETTOOLINFO         EQUATE(WM_USER + 8)
TTM_SETTOOLINFO         EQUATE(WM_USER + 9)
TTM_HITTESTA            EQUATE(WM_USER +10)
TTM_GETTEXTA            EQUATE(WM_USER +11)
TTM_UPDATETIPTEXT       EQUATE(WM_USER +12)
TTM_GETTOOLCOUNT        EQUATE(WM_USER +13)
TTM_ENUMTOOLS           EQUATE(WM_USER +14)
TTM_GETCURRENTTOOL      EQUATE(WM_USER + 15)
TTM_WINDOWFROMPOINT     EQUATE(WM_USER + 16)
TTM_TRACKACTIVATE       EQUATE(WM_USER + 17)  !wParam = TRUE/FALSE start end  lparam = LPTOOLINFO
TTM_TRACKPOSITION       EQUATE(WM_USER + 18)  !lParam = dwPos
TTM_SETTIPBKCOLOR       EQUATE(WM_USER + 19)
TTM_SETTIPTEXTCOLOR     EQUATE(WM_USER + 20)
TTM_GETDELAYTIME        EQUATE(WM_USER + 21)
TTM_GETTIPBKCOLOR       EQUATE(WM_USER + 22)
TTM_GETTIPTEXTCOLOR     EQUATE(WM_USER + 23)
TTM_SETMAXTIPWIDTH      EQUATE(WM_USER + 24)
TTM_GETMAXTIPWIDTH      EQUATE(WM_USER + 25)
TTM_SETMARGIN           EQUATE(WM_USER + 26)  !lParam = lprc
TTM_GETMARGIN           EQUATE(WM_USER + 27)  !lParam = lprc
TTM_POP                 EQUATE(WM_USER + 28)
TTM_UPDATE              EQUATE(WM_USER + 29)
TTM_GETBUBBLESIZE       EQUATE(WM_USER + 30)
TTM_ADJUSTRECT          EQUATE(WM_USER + 31)
TTM_SETTITLE            EQUATE(WM_USER + 32)  !wParam = TTI_*, lParam = char* szTitle

TTM_POPUP               EQUATE(WM_USER + 34)
TTM_GETTITLE            EQUATE(WM_USER + 35)  !wParam = 0, lParam = TTGETTITLE*
TTM_GETCURRENTTOOLW     EQUATE(WM_USER + 59)

TTN_FIRST               EQUATE(-520)          !tooltips
TTN_LAST                EQUATE(-549)
TTN_GETDISPINFO         EQUATE(TTN_FIRST - 0)
TTN_SHOW                EQUATE(TTN_FIRST - 1)
TTN_POP                 EQUATE(TTN_FIRST - 2)
TTN_NEEDTEXT            EQUATE(TTN_GETDISPINFO)

!unicode
TTN_GETDISPINFOW        EQUATE(TTN_FIRST - 10)
TTN_NEEDTEXTW           EQUATE(TTN_GETDISPINFOW)

TTF_IDISHWND            EQUATE(00001h)
! Use this to center around trackpoint in trackmode
! -OR- to center around tool in normal mode.
! Use TTF_ABSOLUTE to place the tip exactly at the track coords when
! in tracking mode.  TTF_ABSOLUTE can be used in conjunction with TTF_CENTERTIP
! to center the tip absolutely about the track point.
TTF_CENTERTIP           EQUATE(00002h)
TTF_RTLREADING          EQUATE(00004h)
TTF_SUBCLASS            EQUATE(00010h)
TTF_TRACK               EQUATE(00020h)
TTF_ABSOLUTE            EQUATE(00080h)
TTF_TRANSPARENT         EQUATE(00100h)
TTF_DI_SETITEM          EQUATE(08000h)     ! valid only on the TTN_NEEDTEXT callback

TTS_ALWAYSTIP           EQUATE(001h)
TTS_NOPREFIX            EQUATE(002h)
TTS_NOANIMATE           EQUATE(010h)
TTS_NOFADE              EQUATE(020h)
TTS_BALLOON             EQUATE(040h)

TOOLTIPS_CLASS          EQUATE('tooltips_class32')

tagDLLVERSIONINFO       GROUP,TYPE
cbSize                    DWORD
dwMajorVersion            DWORD
dwMinorVersion            DWORD
dwBuildNumber             DWORD
dwPlatformID              DWORD
                        END

tagMSG                  GROUP,TYPE
hwnd                      HWND
message                   UINT
wParam                    WPARAM
lParam                    LPARAM
time                      DWORD
pt                        LIKE(tagPOINT)
                        END

tagNMHDR                GROUP,TYPE
hwndFrom                  LONG
idfrom                    LONG
code                      LONG
                        END

tagNMTTDISPINFO         GROUP,TYPE
hdr                       LIKE(tagNMHDR)
lpszText                  ULONG
szText                    CSTRING(80)
hinst                     HINSTANCE
uFlags                    UINT
lParam                    LPARAM
                        END

tagCONTROLQUEUE         QUEUE,TYPE
hwndControl               ULONG
pfnControlProc            ULONG
hMem                      HGLOBAL
hMemTitle                 HGLOBAL
nIcon                     LONG
hFont                     LONG
                        END

!window properties used in Get/SetProp
propWindowProc          CSTRING('WindowProc')
propToolTipClass        CSTRING('ToolTipClass')
propToolTipText         CSTRING('ToolTipText')
propToolTipTitle        CSTRING('ToolTipTitle')
propToolTipIcon         CSTRING('ToolTipIcon')
propToolTipFont         CSTRING('ToolTipFont')

!========================================================================================
!========================================================================================
ToolTipClass    CLASS,TYPE,MODULE('COOLTIPS.CLW'),LINK('COOLTIPS.CLW') !,_ABCLinkMode_),DLL(_ABCDllMode_)

!Private properties
hwndParent          HWND,PRIVATE
Q                   &tagCONTROLQUEUE,PRIVATE
nDLLVersion         REAL,PRIVATE
hwndTT              HWND,PRIVATE
pfnWindowProc       ULONG,PRIVATE
hDefaultFont        LONG,PRIVATE
bDefaultSize        BYTE,PRIVATE
bEnabled            BYTE,PRIVATE

!Public properties

!Methods
Init                PROCEDURE(UNSIGNED hwndParent,BOOL bBalloonTips=0),BOOL,PROC
Kill                PROCEDURE()
AddTip              PROCEDURE(HWND hwndControl,STRING sTip,BOOL bMultiline=0),BOOL,PROC
AddTip              PROCEDURE(HWND hwndControl,STRING sTip,BOOL bMultiline=0,STRING sTitle,LONG nIcon,STRING sFontName,BYTE nFontSize),BOOL,PROC
!
Activate            PROCEDURE(BOOL fActivate),BOOL,PROC
SetDelayTime        PROCEDURE(DWORD dwDuration, LONG iTime),BOOL,PROC
AddTool             PROCEDURE(*tagTOOLINFO ti),BOOL,PROC
DelTool             PROCEDURE(HWND hwndControl),BOOL,PROC
NewToolRect         PROCEDURE(HWND hwndControl, *tagRECT rect),BOOL,PROC
RelayEvent          PROCEDURE(*tagMSG msg),BOOL,PROC
GetToolInfo         PROCEDURE(HWND hwndControl, *tagTOOLINFO ti),BOOL,PROC
SetToolInfo         PROCEDURE(*tagTOOLINFO ti),BOOL,PROC
HitTest             PROCEDURE(HWND hwndControl, *tagPOINT pt, *tagTOOLINFO ti),BOOL,PROC
GetText             PROCEDURE(HWND hwndControl, *CSTRING szText),BOOL,PROC
UpdateTipText       PROCEDURE(HWND hwndControl, STRING sTip, BOOL bMultiLine=0),BOOL,PROC
GetToolCount        PROCEDURE(),LONG
EnumTools           PROCEDURE(UINT iTool, *tagTOOLINFO ti),BOOL,PROC
GetCurrentTool      PROCEDURE(*tagTOOLINFO ti),BOOL,PROC
!Requires comctl32 version 4.70
TrackActivate       PROCEDURE(HWND hwndControl, BOOL bActivate),BOOL,PROC
TrackPosition       PROCEDURE(SIGNED xPos, SIGNED yPos),BOOL,PROC
SetTipBkColor       PROCEDURE(COLORREF clr),BOOL,PROC
SetTipTextColor     PROCEDURE(COLORREF clr),BOOL,PROC
GetDelayTime        PROCEDURE(DWORD dwDuration),LONG
GetTipBkColor       PROCEDURE(),COLORREF
GetTipTextColor     PROCEDURE(),COLORREF
SetMaxTipWidth      PROCEDURE(LONG iWidth),LONG,PROC
GetMaxTipWidth      PROCEDURE(),LONG
SetMargin           PROCEDURE(*tagRECT rc),BOOL,PROC
GetMargin           PROCEDURE(*tagRECT rc),BOOL,PROC
Pop                 PROCEDURE(),BOOL,PROC
!Requires comctl32 version 4.71
Update              PROCEDURE(),BOOL,PROC
!Requires comctl32 version 5.80
GetBubbleSize       PROCEDURE(HWND hwndControl, *WORD wWidth, *WORD wHeight),BOOL,PROC
AdjustRect          PROCEDURE(BOOL fLarger, *tagRECT rc),BOOL,PROC
SetTitle            PROCEDURE(*CSTRING szTitle, WORD wIcon),BOOL,PROC
SetTitle            PROCEDURE(STRING sTitle, WORD wIcon),BOOL,PROC

!enhanced functionality
SetBalloonTips      PROCEDURE(BOOL fBalloonTips),BOOL,PROC
UpdateTitle         PROCEDURE(HWND hwndControl,<*CSTRING NewTitle>, <WORD wIcon>),BOOL,PROC
GetEnabled          PROCEDURE(),BOOL
SetEnabled          PROCEDURE(BOOL fEnableTips),BOOL,PROC

!Private Utility Functions
GetDllVersion       PROCEDURE(*CSTRING lpszDllName),PRIVATE
MakeLong            PROCEDURE(SIGNED a,SIGNED b),ULONG,PRIVATE
                END
!   _EndOfInclude_

