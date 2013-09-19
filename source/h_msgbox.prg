/*
 * $Id: h_msgbox.prg,v 1.15 2013-09-19 20:35:36 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG message boxes functions
 *
 * Copyright 2005-2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

 "Harbour GUI framework for Win32"
  Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
  Copyright 2001 Antonio Linares <alinares@fivetech.com>
 www - http://www.harbour-project.org

 "Harbour Project"
 Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#include 'oohg.ch'
#include 'i_windefs.ch'

static _OOHG_MsgDefaultMessage := ''
static _OOHG_MsgDefaultTitle := ''
static _OOHG_MsgDefaultMode := Nil
// Nil = MB_SYSTEMMODAL, other values MB_APPLMODAL and MB_TASKMODAL


*-----------------------------------------------------------------------------*
Function SetMsgDefaultMessage( cMessage )
*-----------------------------------------------------------------------------*
   IF valtype( cMessage ) == "C"
      _OOHG_MsgDefaultMessage := cMessage
   ENDIF
Return _OOHG_MsgDefaultMessage


*-----------------------------------------------------------------------------*
Function SetMsgDefaultTitle( cTitle )
*-----------------------------------------------------------------------------*
   IF valtype( cTitle ) == "C"
      _OOHG_MsgDefaultTitle := cTitle
   ENDIF
Return _OOHG_MsgDefaultTitle


*-----------------------------------------------------------------------------*
Function SetMsgDefaultMode( nMode )
*-----------------------------------------------------------------------------*
   IF valtype( nMode ) == "N"
      _OOHG_MsgDefaultMode := nMode
   ENDIF
Return _OOHG_MsgDefaultMode


*-----------------------------------------------------------------------------*
Function MsgYesNo( Message, Title, lRevertDefault, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   IF HB_IsLogical( lRevertDefault ) .AND. lRevertDefault
      t := c_msgyesno_id( Message, Title, Mode )
   ELSE
      t := c_msgyesno( Message, Title, Mode )
   ENDIF

Return ( t == 6 )


*-----------------------------------------------------------------------------*
Function MsgYesNoCancel( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgyesnocancel( Message, Title, Mode )

Return iif( t == 6, 1, iif( t == 7, 2, 0 ) )


*-----------------------------------------------------------------------------*
Function MsgRetryCancel( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgretrycancel( Message, Title, Mode )

Return ( t == 4 )


*-----------------------------------------------------------------------------*
Function MsgOkCancel( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgokcancel( Message, Title, Mode )

Return ( t == 1 )


*-----------------------------------------------------------------------------*
Function MsgInfo( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msginfo( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgStop( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msgstop( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgExclamation( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode to _OOHG_MsgDefaultMode

   c_msgexclamation( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgExclamationYesNo( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode to _OOHG_MsgDefaultMode

   t := c_msgexclamationyesno( Message, Title, Mode )

Return ( t == 6 )


*-----------------------------------------------------------------------------*
Function MsgBox( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msgbox( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgInfoExt( cInfo, cTitulo, nSecs )
*-----------------------------------------------------------------------------*
* (c) LuchoMiranda@telefonica.Net
* modified by Ciro Vargas Clemow for ooHG
*-----------------------------------------------------------------------------*
Local nWidth, nHeight

   DEFAULT cInfo TO _OOHG_MsgDefaultMessage
   DEFAULT cTitulo TO _OOHG_MsgDefaultTitle
   DEFAULT nSecs TO 0

   cInfo   := STRTRAN(STRTRAN(cInfo, CHR(13), CHR(13)+CHR(10)), CHR(13)+CHR(10)+CHR(10), CHR(13)+CHR(10))
   nWidth  := MAX(MAXLINE(cInfo), LEN(cTitulo)) * 12
   nHeight := MLCOUNT(cInfo) * 20

   DefineWindow( "_Win_1", , 0, 0, nWidth, 115 + nHeight, .F., .F., .F., .F., .T., , , , , , , {204, 216, 124}, , .F., .T., , , , , , , , , , , , , , , , , .F., , , , .F., , , .F., .F., , .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., , .F., , , , , , , , , , ) ;

   _DefineAnyKey(, "ESCAPE", {|| _OOHG_ThisForm:release()} )
   _DefineAnyKey(, "RETURN", {|| _OOHG_ThisForm:release()} )

   IF nSecs = 1 .OR. nSecs > 1
      _OOHG_SelectSubClass( TTimer(), ): Define( "_timer__x", , nSecs*1000, {|| _OOHG_ThisForm:Release() }, .F. )
   ENDIF

   _OOHG_SelectSubClass( TLabel(), ):Define( "Label_1", , 000, 12, cTitulo, nWidth, 40, "Times NEW Roman", 18, .F., .F., .F., .F., .F., .T., , {0, 0, 0}, , , , .F., .F., .F., .F., .F., .F., .T., .F., .F., .F., )
   _OOHG_SelectSubClass( TLabel(), ):Define( "Label_2", , 0-5, 46, "", nWidth+10, 20 + nHeight, "Arial", 13, .T., .T., .T., .F., .F., .F., {248, 244, 199}, {250, 50, 100}, , , , .F., .F., .F., .F., .F., .F., .T., .F., .F., .F., )
   _OOHG_SelectSubClass( TLabel(), ):Define( "Label_3", , 000, 56, cInfo, nWidth, 00 + nHeight, "Times NEW Roman", 14, .F., .F., .F., .F., .F., .T., {177, 156, 037}, {000, 00, 000}, , , , .F., .F., .F., .F., .F., .F., .T., .F., .F., .F., )

   _OOHG_SelectSubClass( TButton(), ): Define( "Button_1", , (nWidth/2)-40, GetExistingFormObject( "_Win_1" ):Height-40, , {|| _OOHG_ThisForm:Release()}, 60, 25, "Arial", 10, , , , .F., .F., , .F., .F., .F., .F., .F., .F., .F., .F., , , "MINIGUI_EDIT_OK", .F., .F., .F., )

   GetExistingControlObject( "button_1", "_Win_1" ):setfocus ()

   _EndWindow ()
   DoMethod ( "_Win_1", "Center" )
   _ActivateWindow( {"_Win_1"}, .F. )

Return Nil


*-----------------------------------------------------------------------------*
Function AutoMsgInfoExt( uInfo, cTitulo, nSecs )
*-----------------------------------------------------------------------------*

   MsgInfoExt( autoType( uInfo ), cTitulo, Nsecs )

Return nil


*-----------------------------------------------------------------------------*
Function autoMsgBox( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode

   uMessage :=  autoType( uMessage )
   c_msgbox( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoMsgExclamation( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode
 
   uMessage := autoType( uMessage )
   c_msgexclamation( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoMsgStop( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode

   uMessage := autoType( uMessage )
   c_msgstop( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoMsgInfo( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode

   uMessage := autoType( uMessage )
   c_msginfo( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoType( Message )
*-----------------------------------------------------------------------------*
Local cMessage, ctype, l, i

   ctype := valtype( Message )

   do case
      case ctype $ "CNLDM"
         cMessage :=  transform( Message, "@" )+"  "         //// cvc
      case cType = "O"
         cMessage :=  Message:ClassName()+ " :Object: "       //// cvc
      case ctype = "A"
         l:=len( Message )
         cMessage:=""
         for i:=1 to l
             cMessage = cMessage +  if ( i=l, autoType( Message [ i ] )+chr(13)+chr(10), autoType( Message[ i ] ) )    /// cvc
         next i
      case ctype = "B"
         cMessage := "{|| Codeblock }   "
      case cType = "H"
         cMessage := ":Hash:   "
      case cType = "P"
   #IFDEF __XHARBOUR__
        cMessage :=  Ltrim( Hb_ValToStr( Message )) + " HexToNum()=> " + LTrim( Str( HexToNum( SubStr( Hb_ValToStr( Message ), 3 ) ) ) )  /// cvc
   #ELSE
        cMessage :=  Ltrim( Hb_ValToStr( Message )) + " Hb_HexToNum()=> " + LTrim( Str( Hb_HexToNum( SubStr( Hb_ValToStr( Message ), 3 ) ) ) )    ///cvc
   #ENDIF
      otherwise
         cMessage :="<NIL>   "
   endcase

Return cMessage
