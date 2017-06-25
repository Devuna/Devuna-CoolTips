// ================================================================================
// Notice : Copyright (C) 2017, Devuna
//          Distributed under LGPLv3 (http://www.gnu.org/licenses/lgpl.html)
//
//    This file is part of Devuna-CoolTips (https://github.com/Devuna/Devuna-CoolTips)
//
//    Devuna-CoolTips is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Devuna-CoolTips is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Devuna-CoolTips.  If not, see <http://www.gnu.org/licenses/>.
// ================================================================================
//
// ********************************************************************************
// Source module name:  utillib.c
// Release Version:     Devuna WinAPI utility library
// ********************************************************************************

typedef unsigned char byte;
typedef void far *    PDVI;

byte pascal CallDllGetVersion(byte (pascal *fpDllGetVersion)(PDVI), PDVI dvi);

byte pascal CallDllGetVersion(byte (pascal *fpDllGetVersion)(PDVI), PDVI dvi)
{
  return((*fpDllGetVersion)(dvi));
}
