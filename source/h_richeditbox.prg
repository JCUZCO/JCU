/*
 * $Id: h_richeditbox.prg,v 1.3 2005-08-25 05:57:42 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG rich edit functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TEditRich FROM TEdit
   DATA Type      INIT "RICHEDIT" READONLY

   METHOD Define
   METHOD BkColor     SETGET
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, maxlenght, gotfocus, change, lostfocus, ;
               readonly, break, HelpId, invisible, notabstop, bold, italic, ;
               underline, strikeout, field, backcolor, lRtl ) CLASS TEditRich
*-----------------------------------------------------------------------------*
Local ContainerHandle
Local ControlHandle

   DEFAULT w         TO 120
   DEFAULT h         TO 240
   DEFAULT value     TO ""
   DEFAULT change    TO ""
   DEFAULT lostfocus TO ""
   DEFAULT gotfocus  TO ""
   DEFAULT Maxlenght TO 64738
   DEFAULT invisible TO FALSE
   DEFAULT notabstop TO FALSE

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , BackColor, .T., lRtl )

   If ValType( Field ) $ 'CM' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

	if valtype(x) == "U" .or. valtype(y) == "U"

      If _OOHG_SplitLastControl == 'TOOLBAR'
			Break := .T.
		EndIf

      _OOHG_SplitLastControl   := 'RICHEDIT'

         ControlHandle := InitRichEditBox ( ::Parent:ReBarHandle, 0, x, y, w, h, '', 0 , maxlenght , readonly, invisible, notabstop, ::lRtl )

         AddSplitBoxItem ( Controlhandle , ::Parent:ReBarHandle, w , break , , , , _OOHG_ActiveSplitBoxInverted )
         Containerhandle := ::Parent:ReBarHandle

	Else

      ControlHandle := InitRichEditBox ( ::Parent:hWnd, 0, x, y, w, h, '', 0 , maxlenght , readonly, invisible, notabstop, ::lRtl )

	endif

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::Value := value

   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change

	if valtype ( Field ) != 'U'
      aAdd ( ::Parent:BrowseList, Self )
	EndIf

   if valtype ( ::aBkColor ) == 'A'
      SendMessage ( ::hWnd, EM_SETBKGNDCOLOR  , 0 , RGB ( ::aBkColor[1] , ::aBkColor[2] , ::aBkColor[3] ) )
	EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD BkColor( uValue ) CLASS TEditRich
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "A"
      ::Super:BkColor := uValue
      IF ::hWnd > 0
         SendMessage ( ::hWnd, EM_SETBKGNDCOLOR , 0 , RGB( ::aBkColor[1] , ::aBkColor[2] , ::aBkColor[3] ) )
         RedrawWindow( ::hWnd )
      ENDIF
   ENDIF
Return ::aBkColor