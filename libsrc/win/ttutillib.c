// ================================================================================
// Notice : Copyright (C) 2017, Devuna
//          Distributed under the MIT License (https://opensource.org/licenses/MIT)
//
//    This file is part of Devuna-CoolTips (https://github.com/Devuna/Devuna-CoolTips)
//
//    Devuna-CoolTips is free software: you can redistribute it and/or modify
//    it under the terms of the MIT License as published by
//    the Open Source Initiative.
//
//    Devuna-CoolTips is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    MIT License for more details.
//
//    You should have received a copy of the MIT License
//    along with Devuna-CoolTips.  If not, see <https://opensource.org/licenses/MIT>.
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
