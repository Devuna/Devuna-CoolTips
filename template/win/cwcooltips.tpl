#! ================================================================================================
#!                                   Devuna - CoolTips Templates
#! ================================================================================================
#! Author:  Randy Rogers (KCR) <rrogers@devuna.com>
#! Notice:  Copyright (C) 2017, Devuna
#!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
#! ================================================================================================
#!    This file is part of Devuna-CoolTips (https://github.com/Devuna/Devuna-CoolTips)
#!
#!    Devuna-CoolTips is free software: you can redistribute it and/or modify
#!    it under the terms of the MIT License as published by
#!    the Open Source Initiative.
#!
#!    Devuna-CoolTips is distributed in the hope that it will be useful,
#!    but WITHOUT ANY WARRANTY; without even the implied warranty of
#!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#!    MIT License for more details.
#!
#!    You should have received a copy of the MIT License
#!    along with Devuna-CoolTips.  If not, see <https://opensource.org/licenses/MIT>.
#! ================================================================================================
#!
#! ---------------------------------------------------------
#TEMPLATE(KCR_LegacyCoolTips,'Devuna Legacy CoolTips Templates')
#HELP('COOLTIPS.HLP')
#!
#! ---------------------------------------------------------
#! Modified By Bjarne Havnen
#!
#!----------------------------------------------------------------------------------------------
#! Modified By Devuna 2005.09.11
#! to support LANSRAD TipLink Template ( www.lansrad.com )
#!
#! Put conditional code in INIT to allow TipLink to set tip type during initialization
#! If tipLink is not present, the conditional code is ignored.
#!----------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------
#! Modified By Devuna 2005.09.20
#! Added template support for Titles and Font
#!----------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------
#! Modified By Devuna 2005.12.13
#! ignore tips on tabs since they are owner drawn
#!----------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------
#! Modified By Devuna 2014.10.24
#! removed erroneous blank lines reported by Diego Borojovich from Softvelocity
#!----------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------
#! Modified By Devuna 2015.03.05
#! rebuild for Clarion 10
#!----------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------
#! Modified By Devuna 2017.02.02
#! rebuild for Clarion 10.0.12463
#!----------------------------------------------------------------------------------------------
#!
#EXTENSION(KCR_GlobalCoolTips,'Devuna Global Cooltip Extension'),Application(KCR_CoolTip(KCR_LegacyCoolTips))
#BOXED('Default MakeHead Prompts'),AT(0,0),WHERE(%False),HIDE
  #INSERT(%MakeHeadHiddenPrompts)
#ENDBOXED
#PREPARE
  #INSERT (%MakeHead,'KCR_CoolTip (Devuna)','CoolTip Extension','2017.02.02')
#ENDPREPARE
#BOXED('Devuna')
 #INSERT (%Head)
 #DISPLAY('This just adds CoolTip to all procedures')
 #DISPLAY('This is not neccessary')
 #DISPLAY('You may select each and every one procedure too')
#ENDBOXED
#!
#!
#EXTENSION(KCR_CoolTip,'Devuna CoolTip Extension'),PROCEDURE,HLP('~KCR_TOOLTIPS')
#!----------------------------------------------------------
#BOXED('Default MakeHead Prompts'),AT(0,0),WHERE(%False),HIDE
  #INSERT(%MakeHeadHiddenPrompts)
#ENDBOXED
#PREPARE
  #INSERT (%MakeHead,'KCR_CoolTip (Devuna)','CoolTip Extension','2017.02.02')
#ENDPREPARE
#BOXED('Devuna')
  #INSERT (%Head)
  #DISPLAY ('This template adds custom tooltips to the Window'),AT(10)
  #DISPLAY ('')
  #PROMPT('Don''t apply at all',Check),%DontApply,At(10)
  #PROMPT('Use Balloon Tips',CHECK),%UseBalloonTips,DEFAULT(%TRUE),AT(10)
#!Modified By Bjarne Havnen
  #PROMPT('Replace regular tip',Check),%ApplyAsRegularTip,DEFAULT(%TRUE),AT(10)
  #DISPLAY ('')
  #ENABLE(NOT %ApplyAsRegularTip)
    #BUTTON('Selected Controls...'),MULTI(%ToolTipControls,%ToolTipControl & ' - ' & %ToolTipTextOption),AT(,,178,)
      #PROMPT('Control:',CONTROL),%ToolTipControl,REQ,AT(65,,115)
      #PROMPT('Multi-Line Tip',CHECK),%MultiLineTip,DEFAULT(%TRUE),AT(10)
      #PROMPT('ToolTip Text',OPTION),%ToolTipTextOption,DEFAULT('Use Tip Text'),AT(10,,180,65)
      #PROMPT('Use Tip Text',RADIO),AT(15)
      #PROMPT('Use Local Data Variable',RADIO),AT(15)
      #PROMPT('Use Global Data Variable',RADIO),AT(15)
      #PROMPT('Specify Text',RADIO),AT(15)
      #BOXED,AT(,75),WHERE(%ToolTipTextOption = 'Use Local Data Variable')
        #PROMPT('Local Variable:',FROM(%LocalData)),%TTLocalVariable,REQ,AT(75,,105),PROMPTAT(15)
      #ENDBOXED
      #BOXED,AT(,75),WHERE(%ToolTipTextOption = 'Use Global Data Variable')
        #PROMPT('Global Variable:',FROM(%GlobalData)),%TTGlobalVariable,REQ,AT(75,,105),PROMPTAT(15)
      #ENDBOXED
      #BOXED,AT(,75),WHERE(%ToolTipTextOption = 'Specify Text')
        #PROMPT('Enter Tip Text:',@S64),%TTText,AT(75,,105),PROMPTAT(15)
      #ENDBOXED
        #BOXED('Title Options'),AT(10,94,180),WHERE(%UseBalloonTips)
        #PROMPT('Title Text',@S64),%TTTitleText,AT(60,,115)
        #ENABLE(%TTTitleText)
          #PROMPT('Icon',OPTION),%TTIcon,AT(10,,165,58),DEFAULT('None')
          #PROMPT('None',RADIO),AT(15)
          #PROMPT('Info',RADIO),AT(15)
          #PROMPT('Warning',RADIO),AT(15)
          #PROMPT('Error',RADIO),AT(15)
        #ENDENABLE
      #ENDBOXED
      #BOXED('HIDDEN'),WHERE(%False),HIDE,AT(0,0,0,0)
        #PROMPT('FontName:',@s255),%TTFontName,DEFAULT('')
        #PROMPT('FontSize:',@s255),%TTFontSize,DEFAULT(0)
        #PROMPT('FontColor:',@s255),%TTFontColor,DEFAULT('')
        #PROMPT('FontStyle:',@s255),%TTFontStyle,DEFAULT(400)
        #PROMPT('FontCharSet:',@s255),%TTFontCharSet,DEFAULT(1)
      #ENDBOXED
      #BOXED('Font Options'),AT(10,,180)
        #BUTTON('Select Font...'),WHENACCEPTED(%TTFontDialog('Select Font',%TTFontName,%TTFontSize,%TTFontColor,%TTFontStyle,%TTFontCharSet,2)),AT(,,165)
        #ENDBUTTON
        #BOXED,WHERE(%TTFontName<>'')
          #DISPLAY('Font Name: ' & %TTFontName)
        #ENDBOXED
        #BOXED,WHERE(%TTFontSize<>0)
          #DISPLAY('Font Size: ' & %TTFontSize)
        #ENDBOXED
      #ENDBOXED
      #BOXED,HIDE
        #PROMPT('Can Recieve Input Focus',CHECK),%ControlGetsFocus,DEFAULT(%TRUE)
        #PROMPT('ToolTipFeq',CONTROL),%ToolTipFeq
      #ENDBOXED
    #ENDBUTTON
  #ENDENABLE
#ENDBOXED
#!
#!
#AT(%DataSection),WHERE(NOT %DontApply)
tt                  ToolTipClass
hwndTT              HWND
#ENDAT
#!
#!
#!Modified By Bjarne Havnen
#AT(%CustomGlobalDeclarations),WHERE(NOT %DontApply)
  #IF(%Target32)
    #PROJECT('TTUTILLIB.C')
  #ELSE
    #ERROR('Error: ToolTipClass requires 32-bit application')
  #ENDIF
#ENDAT
#!
#!
#ATSTART
  #DECLARE(%nIcon)
  #DECLARE(%LastField)
  #SET(%LastField,0)
  #FOR(%Control)
     #SET(%LastField,%LastField+1)
  #ENDFOR
  #FOR(%ToolTipControls)
    #FIX(%Control,%ToolTipControl)
    #CASE(%ControlType)
    #OF('BOX')
    #OROF('ELLIPSE')
    #OROF('IMAGE')
    #OROF('LINE')
    #OROF('PANEL')
    #OROF('PROMPT')
    #OROF('PROGRESS')
    #OROF('STRING')
      #SET(%ControlGetsFocus,%FALSE)
    #ELSE
      #SET(%ToolTipFeq,%Control)
    #ENDCASE
  #ENDFOR
  #!
  #!Support for Charles Edmonds TipLink Template
  #DECLARE(%TipLink)
  #SET(%TipLink,0)
  #FOR(%ApplicationTemplate),WHERE(%ApplicationTemplate='TipLink(TipLink)')
    #SET(%TipLink,1)
  #ENDFOR
#ENDAT
#!
#!
#!Modified By Bjarne Havnen
#AT(%AfterGlobalIncludes),PRIORITY(4000),WHERE(NOT %DontApply)
   INCLUDE('COOLTIPS.INC'),ONCE
#ENDAT
#!
#!
#!Modified By Devuna 2005.09.11
#AT(%DataSection),WHERE(NOT %DontApply)
tt_ctrl  LONG
#ENDAT
#!
#!
#!Modified By Bjarne Havnen
#!AT(%WindowManagerMethodCodeSection,'Open','()'),PRIORITY(5000),WHERE(NOT %DontApply)
#AT(%AfterWindowOpening),WHERE(NOT %DontApply)
  #FOR(%ToolTipControls)
    #IF(NOT %ControlGetsFocus)      #!Control cannot recieve focus so create a region
      #SET(%LastField,%LastField+1)
      #SET(%ToolTipFeq,%LastField)
CREATE(%ToolTipFeq,CREATE:Region)  #<! Create a region around non-focus control
      #FIX(%Control,%ToolTipControl)
%ToolTipFeq{PROP:XPOS} = %Control{PROP:XPOS}
%ToolTipFeq{PROP:YPOS} = %Control{PROP:YPOS}
%ToolTipFeq{PROP:WIDTH} = CHOOSE(%Control{PROP:WIDTH}=0,1,%Control{PROP:WIDTH})
%ToolTipFeq{PROP:HEIGHT} = CHOOSE(%Control{PROP:HEIGHT}=0,1,%Control{PROP:HEIGHT})
%ToolTipFeq{PROP:HIDE} = FALSE
    #ENDIF
  #ENDFOR
#!-----------------------------------------------------------------------------------------
#! Modified by Devuna to support LANSRAD to support TipLink 2005.09.11
#!-----------------------------------------------------------------------------------------
#IF(%TipLink=0)
hwndTT = tt.init(%Window{PROP:HANDLE},%UseBalloonTips)  #<!ToolTipClass Initialization
#ELSE
IF GLO:TipType = 0    !Tooltips Off
   hwndTT = tt.init(%Window{PROP:HANDLE},%UseBalloonTips)  #<!ToolTipClass Initialization
   tt.Activate(0)
ELSE
   CASE GLO:TipType
     OF 1    !Normal
        hwndTT = tt.init(%Window{PROP:HANDLE},0)  #<!ToolTipClass Initialization
     OF 2    !Balloon
        hwndTT = tt.init(%Window{PROP:HANDLE},1)  #<!ToolTipClass Initialization
   END
END
#ENDIF
#!-----------------------------------------------------------------------------------------
IF hwndTT
  #!Modified By Bjarne Havnen
  #IF (%ApplyAsRegularTip)
  !this code is placed to enable instantly tooltip on all controls
  !Loop I#=FirstField() To LastField()
  !Modified By Devuna to use PROP:NextField
  !to handle toolbar button tips
  tt_ctrl = 0
  LOOP
     tt_ctrl = %window{PROP:NextField,tt_ctrl}
     IF tt_ctrl = 0
        BREAK
     ELSIF tt_ctrl{PROP:Type} = CREATE:Tab
        CYCLE   !Tooltip not supported on tabs (owner drawn)
     ELSE
        IF tt_ctrl{PROP:TIP}
           IF INSTRING('<13,10>',tt_ctrl{PROP:TIP},1,1)
              tt.addtip(tt_ctrl{PROP:HANDLE},tt_ctrl{PROP:TIP},1,'',0,'',0)
           ELSE
              tt.addtip(tt_ctrl{PROP:HANDLE},tt_ctrl{PROP:TIP},0,'',0,'',0)
           END!if
           tt_ctrl{PROP:TIP}=''
        END !if
     END
  END
  #ELSE
    #FOR(%ToolTipControls)
      #CASE(%TTIcon)
      #OF('None')
        #SET(%nIcon,0)
      #OF('Info')
        #SET(%nIcon,1)
      #OF('Warning')
        #SET(%nIcon,2)
      #OF('Error')
        #SET(%nIcon,3)
      #ENDCASE
      #!
      #CASE(%ToolTipTextOption)
      #OF('Use Tip Text')
        #IF(%ControlGetsFocus)      #!Control can recieve focus
   tt.addtip(%ToolTipFeq{PROP:HANDLE},%ToolTipFeq{PROP:TIP},%MultiLineTip,'%TTTitleText',%nIcon,'%TTFontName',%TTFontSize)
        #ELSE                       #!Control cannot recieve focus so use text, not tip
   tt.addtip(%ToolTipFeq{PROP:HANDLE},%ToolTipControl{PROP:TEXT},%MultiLineTip,'%TTTitleText',%nIcon,'%TTFontName',%TTFontSize)
        #ENDIF
      #OF('Use Local Data Variable')
   tt.addtip(%ToolTipFeq{PROP:HANDLE},%TTLocalVariable,%MultiLineTip,'%TTTitleText',%nIcon,'%TTFontName',%TTFontSize)
      #OF('Use Global Data Variable')
   tt.addtip(%ToolTipFeq{PROP:HANDLE},%TTGlobalVariable,%MultiLineTip,'%TTTitleText',%nIcon,'%TTFontName',%TTFontSize)
      #OF('Specify Text')
   tt.addtip(%ToolTipFeq{PROP:HANDLE},'%TTText',%MultiLineTip,'%TTTitleText',%nIcon,'%TTFontName',%TTFontSize)
      #ENDCASE
      #FIX(%Control,%ToolTipControl)
      #IF(EXTRACT(%ControlStatement,'TIP',0))
   %ToolTipFeq{PROP:TIP} = '' #<! Clear tip property to avoid two tips
      #ENDIF
    #ENDFOR
  #ENDIF
END
#!-----------------------------------------------------------------------------------------
#ENDAT
#!
#!
#!Modified By Bjarne Havnen
#!AT(%WindowManagerMethodCodeSection,'Kill','(),BYTE'),PRIORITY(2500),DESCRIPTION('ToolTip Cleanup'),WHERE(NOT %DontApply)
#AT(%EndOfProcedure,'End of Procedure'),DESCRIPTION('ToolTip Cleanup'),WHERE(NOT %DontApply)
tt.Kill()   #<!ToolTipClass Cleanup
hwndTT = 0  #<!ToolTipClass Cleanup
#ENDAT
#!
#!
#!
#!
#GROUP(%TTFontDialog,%pFontTitle ,*%pFontTypeface ,*%pFontSize,*%pFontColor,*%pFontStyle,*%pCharSet,%pFontAdded),AUTO
#DECLARE(%lFontTypeface)
#DECLARE(%lFontSize)
#DECLARE(%lFontColor)
#DECLARE(%lFontStyle)
#DECLARE(%lCharSet)
#SET(%lFontTypeface,%pFontTypeface)
#SET(%lFontSize,%pFontSize)
#SET(%lFontColor,%pFontColor)
#SET(%lFontStyle,%pFontStyle)
#SET(%lCharSet,%pCharSet)
#DECLARE(%ReturnValue)
   #SET(%ReturnValue, FONTDIALOG(%pFontTitle,%lFontTypeface,%lFontSize,%lFontColor,%lFontStyle,%lCharSet,%pFontAdded))
   #IF(%ReturnValue)
      #SET(%pFontTypeface,%lFontTypeface)
      #SET(%pFontSize,%lFontSize)
      #SET(%pFontColor,%lFontColor)
      #SET(%pFontStyle,%lFontStyle)
      #SET(%pCharSet,%lCharSet)
   #ENDIF
#!
#!
#!
#!
#!-----------------------------------------------------------------------------------------------------------
#!The following template code is derived from "The Clarion Handy Tools" created by Gus Creces.
#!Used with permission.  Look for "The Clarion Handy Tools" at www.cwhandy.com
#!-----------------------------------------------------------------------------------------------------------
#SYSTEM
 #TAB('Devuna CoolTip Templates')
  #INSERT  (%SysHead)
  #BOXED   ('About Devuna CoolTips Templates'),AT(5)
    #DISPLAY (''),AT(15)
    #DISPLAY ('This template 1s free software:                                       '),AT(15)
    #DISPLAY ('You can redistribute it and/or modify it under the terms of the GNU   '),AT(15)
    #DISPLAY ('General Public License as published by the Free Software Foundation,  '),AT(15)
    #DISPLAY (''),AT(15)
    #DISPLAY ('This template is distributed in the hope that they will be useful     '),AT(15)
    #DISPLAY ('but WITHOUT ANY WARRANTY; without even the implied warranty           '),AT(15)
    #DISPLAY ('of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'),AT(15)
    #DISPLAY (''),AT(15)
    #DISPLAY ('See the MIT License for more details.'),AT(15)
    #DISPLAY ('http://www.gnu.org/licenses/'),AT(15)
    #DISPLAY ('Copyright 2017 Devuna'),AT(15)
  #ENDBOXED
 #ENDTAB
#!-----------------------------------------------------------------------------------------------------------
#GROUP (%MakeHeadHiddenPrompts)
  #PROMPT('',@S50),%TplName
  #PROMPT('',@S100),%TplDescription
  #PROMPT('',@S10),%TplVersion
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%MakeHead,%xTplName,%xTplDescription,%xTplVersion)
  #SET (%TplName,%xTplName)
  #SET (%TplDescription,%xTplDescription)
  #SET (%TplVersion,%xTplVersion)
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%Head)
  #IMAGE   ('CoolTips.ico'), AT(,,175,26)
  #DISPLAY (%TplName),AT(40,4)
  #DISPLAY ('Version ' & %TplVersion),AT(40,12)
  #DISPLAY ('(C)1994-2017 Devuna'),AT(40,20)
  #DISPLAY ('')
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP   (%SysHead)
  #IMAGE   ('CoolTips.ico'), AT(,,175,26)
  #DISPLAY ('CoolTips.tpl'),AT(40,4)
  #DISPLAY ('Devuna CoolTips Clarion Templates'),AT(40,12)
  #DISPLAY ('for Clarion Template Applications'),AT(40,20)
  #DISPLAY ('')
#!
#!-----------------------------------------------------------------------------------------------------------
#GROUP(%EmbedStart)
#?!-----------------------------------------------------------------------------------------------------------
#?! CoolTips.tpl   (C)1994-2017 Devuna
#?! Template: (%TplName - %TplDescription)
#IF (%EmbedID)
#?! Embed:    (%EmbedID) (%EmbedDescription) (%EmbedParameters)
#ENDIF
#?!-----------------------------------------------------------------------------------------------------------
#!
#!----------------------------------------------------------------------------------------------------------
#GROUP(%EmbedEnd)
#?!-----------------------------------------------------------------------------------------------------------
#!End of derived work.  Thanks Gus!
#!-----------------------------------------------------------------------------------------------------------
