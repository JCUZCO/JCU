/*
 * $Id: h_toolbar.prg,v 1.19 2007-05-14 02:24:45 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG toolbar functions
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
#include "hbclass.ch"
#include "i_windefs.ch"

STATIC _OOHG_ActiveToolBar := NIL    // Active toolbar

CLASS TToolBar FROM TControl
   DATA Type      INIT "TOOLBAR" READONLY

   METHOD Define
   METHOD Events_Size
   METHOD Events_Notify
   METHOD Events
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, caption, ProcedureName, ;
               fontname, fontsize, tooltip, flat, bottom, righttext, break, ;
               bold, italic, underline, strikeout, border, lRtl ) CLASS TToolBar
*-----------------------------------------------------------------------------*
Local ControlHandle, id, lSplitActive

	if valtype (caption) == 'U'
		caption := ""
	EndIf

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   _OOHG_ActiveToolBar := Self

	Id := _GetId()

   lSplitActive := ::SetSplitBoxInfo( Break, caption, ::nWidth,, .T. )
   ControlHandle := InitToolBar( ::ContainerhWnd, Caption, id, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, "", 0, flat, bottom, righttext, lSplitActive, border, ::lRtl )

   ::Register( ControlHandle, ControlName, , , ToolTip, Id )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::OnClick := ProcedureName

   ::ContainerhWndValue := ::hWnd

Return Self

*-----------------------------------------------------------------------------*
Function _EndToolBar()
*-----------------------------------------------------------------------------*
Local w, MinWidth, MinHeight
Local Self

   Self := _OOHG_ActiveToolBar

   MaxTextBtnToolBar( ::hWnd, ::Width, ::Height )

   If ::SetSplitBoxInfo()
      w := GetSizeToolBar( ::hWnd )
      MinWidth  := HiWord( w )
      MinHeight := LoWord( w )

      w := GetWindowWidth( ::hWnd )

      SetSplitBoxItem ( ::hWnd, ::Container:hWnd, w,,, MinWidth, MinHeight, ::Container:lInverted )

      ::SetSplitBoxInfo( .T. )  // Force break for next control...
	EndIf

   _OOHG_ActiveToolBar := nil

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TToolBar
*-----------------------------------------------------------------------------*

   SendMessage( ::hWnd, TB_AUTOSIZE , 0 , 0 )

RETURN ::Super:Events_Size()

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TToolBar
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local ws, x, aPos

   If nNotify == TBN_DROPDOWN
      ws := GetButtonPos( lParam )
      x  := Ascan( ::aControls, { |o| o:Id == ws } )
      IF x  > 0
         aPos:= {0,0,0,0}
         GetWindowRect( ::hWnd, aPos )
         ws := GetButtonBarRect( ::hWnd, ::aControls[ x ]:Position - 1 )
         ::aControls[ x ]:ContextMenu:Activate( aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2 , aPos[1]+LoWord(ws) )
      ENDIF
      Return nil

   ElseIf nNotify == TTN_NEEDTEXT

      ws := GetButtonPos( lParam )

      x  := Ascan ( ::aControls, { |o| o:Id == ws } )

      IF x  > 0

         If VALTYPE( ::aControls[ x ]:ToolTip ) $ "CM"

            ShowToolButtonTip ( lParam , ::aControls[ x ]:ToolTip )

         Endif

      ENDIF

      Return nil

/*
   If nNotify == TBN_ENDDRAG  // -702
      ws := GetButtonPos( lParam )
      x  := Ascan( ::aControls, { |o| o:Id == ws } )
      IF x > 0

         aPos:= {0,0,0,0}
         GetWindowRect( ::hWnd, aPos )
         ws := GetButtonBarRect( ::hWnd, ::aControls[ x ]:Position - 1 )
         // TrackPopupMenu ( ::aControls[ x ]:ContextMenu:hWnd , aPos[1]+LoWord(ws) ,aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2 , ::hWnd )
         ::aControls[ x ]:ContextMenu:Activate( aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2 , aPos[1]+LoWord(ws) )
      ENDIF
      Return nil
*/

   ElseIf nNotify == TBN_GETINFOTIP
      ws := _ToolBarGetInfoTip( lParam )
      x  := Ascan ( ::aControls, { |o| o:Id == ws } )
      IF x > 0
         If VALTYPE( ::aControls[ x ]:ToolTip ) $ "CM"
            _ToolBarSetInfoTip( lParam, ::aControls[ x ]:ToolTip )
         Endif
      ENDIF

   EndIf

Return ::Super:Events_Notify( wParam, lParam )


*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TToolBar
*-----------------------------------------------------------------------------*
   IF nMsg == WM_COMMAND .AND. LOWORD( wParam ) != 0
      // Prevents a double menu click
      Return nil
   ENDIF
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )





CLASS TToolButton FROM TControl
   DATA Type      INIT "TOOLBUTTON" READONLY
   DATA Position  INIT 0

   METHOD Define
   METHOD Value      SETGET
   METHOD Enabled    SETGET

   METHOD Events_Notify
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, x, y, Caption, ProcedureName, w, h, image, ;
               tooltip, gotfocus, lostfocus, flat, separator, autosize, ;
               check, group, dropdown, WHOLEDROPDOWN ) CLASS TToolButton
*-----------------------------------------------------------------------------*
Local ControlHandle, id, nPos

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"

Empty( FLAT )

   ::SetForm( ControlName, _OOHG_ActiveToolBar )

   ASSIGN WHOLEDROPDOWN VALUE WHOLEDROPDOWN TYPE "L" DEFAULT .F.
   ASSIGN Caption       VALUE Caption TYPE "CM" DEFAULT ""

   If valtype( ProcedureName ) == "B" .and. WHOLEDROPDOWN
      MsgOOHGError( "Action and WholeDropDown clauses can't be used simultaneously. Program terminated" )
	endif

	id := _GetId()

   ControlHandle := InitToolButton( ::ContainerhWnd, Caption, id , ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, image , 0 , separator , autosize , check , group , dropdown , WHOLEDROPDOWN )

   nPos := GetButtonBarCount( ::ContainerhWnd ) - if( separator, 1, 0 )

   ::Register( ControlHandle, ControlName, , , ToolTip, Id )

   ::OnClick := ProcedureName
   ::Position  :=  nPos
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::Caption := Caption

   nPos := At( '&', Caption )
   If nPos > 0 .AND. nPos < LEN( Caption )
      DEFINE HOTKEY 0 PARENT ( ::Parent ) KEY "ALT+" + SubStr( Caption, nPos + 1, 1 ) ACTION ::Click()
	EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( lValue ) CLASS TToolButton
*-----------------------------------------------------------------------------*
   IF VALTYPE( lValue ) == "L"
      CheckButtonBar( ::ContainerhWnd, ::Position - 1 , lValue )
   ENDIF
RETURN IsButtonBarChecked( ::ContainerhWnd, ::Position - 1 )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TToolButton
*-----------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      IF lEnabled
         cEnableToolbarButton( ::ContainerhWnd, ::Id )
      ELSE
         cDisableToolbarButton( ::ContainerhWnd, ::Id )
      ENDIF
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TToolButton
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
   If nNotify == TTN_NEEDTEXT
      If VALTYPE( ::ToolTip ) $ "CM"
         ShowToolButtonTip( lParam , ::ToolTip )
      Endif
      Return nil
   EndIf
Return ::Super:Events_Notify( wParam, lParam )

#pragma BEGINDUMP

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <stdlib.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

#define NUM_TOOLBAR_BUTTONS 20

#ifdef MAKELONG
   #undef MAKELONG
#endif
#define MAKELONG(a, b)      ((LONG)(((WORD)((DWORD_PTR)(a) & 0xffff)) | (((DWORD)((WORD)((DWORD_PTR)(b) & 0xffff))) << 16)))

HB_FUNC( INITTOOLBAR )
{
   HWND hwnd;
   HWND hwndTB;
   int Style = WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN |
               WS_CLIPSIBLINGS | TBSTYLE_TOOLTIPS;

   int ExStyle;
   int TbExStyle = TBSTYLE_EX_DRAWDDARROWS ;

   hwnd = HWNDparam( 1 );

   ExStyle = _OOHG_RTL_Status( hb_parl( 15 ) );

   if( hb_parl (14) )
   {
      ExStyle |= WS_EX_CLIENTEDGE;
   }

	if ( hb_parl (10) )
	{
		Style = Style | TBSTYLE_FLAT ;
	}

	if ( hb_parl (11) )
	{
		Style = Style | CCS_BOTTOM ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | TBSTYLE_LIST ;
	}

	if ( hb_parl (13) )
	{
		Style = Style | CCS_NOPARENTALIGN | CCS_NODIVIDER | CCS_NORESIZE;
	}

	hwndTB = CreateWindowEx( ExStyle, TOOLBARCLASSNAME, (LPSTR) NULL,
		Style ,
		0, 0 ,0 ,0,
		hwnd, (HMENU)hb_parni(3), GetModuleHandle(NULL), NULL);

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hwndTB, GWL_WNDPROC, ( LONG ) SubClassFunc );

	if (hb_parni(6) && hb_parni(7))
	{
		SendMessage(hwndTB,TB_SETBUTTONSIZE,hb_parni(6),hb_parni(7));
		SendMessage(hwndTB,TB_SETBITMAPSIZE,0,(LPARAM) MAKELONG(hb_parni(6),hb_parni(7)));
	}

    SendMessage( hwndTB, TB_SETEXTENDEDSTYLE, 0, ( LPARAM ) TbExStyle );

    ShowWindow( hwndTB, SW_SHOW );
    HWNDret( hwndTB );
}

HB_FUNC( INITTOOLBUTTON )
{
	HWND hwndTB;
	HWND himage;
	TBADDBITMAP tbab;
	TBBUTTON tbb[NUM_TOOLBAR_BUTTONS];
	int index;
	int nPoz;
	int nBtn;
	int Style ;

   memset( tbb, 0, sizeof( tbb ) );

   hwndTB = HWNDparam( 1 );

   himage = _OOHG_LoadImage( hb_parc( 8 ), LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT, 0, 0, hwndTB, -1 );

	// Add the bitmap containing button images to the toolbar.

	Style =  TBSTYLE_BUTTON ;

	if ( hb_parl(11) )
	{
		Style = Style | TBSTYLE_AUTOSIZE ;
	}

	nBtn = 0;
	tbab.hInst = NULL;
	tbab.nID   = (int)himage;
	nPoz = SendMessage(hwndTB, TB_ADDBITMAP, (WPARAM) 1,(LPARAM) &tbab);

	// Add the strings

	if (strlen(hb_parc(2)) > 0 )
	{
		index = SendMessage(hwndTB,TB_ADDSTRING,0,(LPARAM) hb_parc(2));
		tbb[nBtn].iString = index;
	}

	if ( hb_parl(12) )
	{
		Style = Style | BTNS_CHECK ;
	}

	if ( hb_parl(13) )
	{
		Style = Style | BTNS_GROUP ;
	}

	if ( hb_parl(14) )
	{
      		Style = Style | BTNS_DROPDOWN ;
	}

	if ( hb_parl(15) )
	{
      		Style = Style | BTNS_WHOLEDROPDOWN ;
	}

	SendMessage(hwndTB,TB_AUTOSIZE,0,0);

	// Button New

	tbb[nBtn].iBitmap = nPoz;
	tbb[nBtn].idCommand = hb_parni(3);
	tbb[nBtn].fsState = TBSTATE_ENABLED;
    tbb[nBtn].fsStyle = ( WORD ) Style;
	nBtn++;

   	if ( hb_parl (10) )
	{
		tbb[nBtn].fsState = 0;
		tbb[nBtn].fsStyle = TBSTYLE_SEP;
		nBtn++;
	}

   SendMessage( hwndTB, TB_BUTTONSTRUCTSIZE, ( WPARAM ) sizeof( TBBUTTON ), 0 );

   SendMessage( hwndTB, TB_ADDBUTTONS, nBtn, ( LPARAM ) &tbb );

   ShowWindow( hwndTB, SW_SHOW );

   HWNDret( himage );
}

HB_FUNC( CDISABLETOOLBARBUTTON )
{
   hb_retnl( SendMessage( HWNDparam( 1 ), TB_ENABLEBUTTON, hb_parni( 2 ), MAKELONG( 0, 0 ) ) );
}

HB_FUNC( CENABLETOOLBARBUTTON )
{
   hb_retnl( SendMessage( HWNDparam( 1 ), TB_ENABLEBUTTON, hb_parni(2), MAKELONG(1,0)) );
}

HB_FUNC( GETSIZETOOLBAR )
{
	SIZE lpSize;
	TBBUTTON lpBtn;
	int i, nBtn;
	OSVERSIONINFO osvi;

   SendMessage( HWNDparam( 1 ), TB_GETMAXSIZE, 0, (LPARAM)&lpSize );

	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	GetVersionEx(&osvi);

   nBtn = SendMessage( HWNDparam( 1 ), TB_BUTTONCOUNT, 0, 0 );

   for( i = 0 ; i < nBtn ; i++ )
	{
      SendMessage( HWNDparam( 1 ),TB_GETBUTTON, i, (LPARAM)  &lpBtn);

		if (osvi.dwPlatformId != VER_PLATFORM_WIN32_NT && osvi.dwMajorVersion >= 4)
		{
			if (lpBtn.fsStyle & BTNS_DROPDOWN )
			{
				lpSize.cx = lpSize.cx + 15 ;
			}
		}

   }

	hb_retnl( MAKELONG(lpSize.cy,lpSize.cx) );
}

LONG WidestBtn(LPCTSTR pszStr, HWND hwnd)
{
   SIZE     sz;
   LOGFONT  lf;
   HFONT    hFont;
   HDC      hdc;

   SystemParametersInfo(SPI_GETICONTITLELOGFONT,sizeof(LOGFONT),&lf,0);

   hdc = GetDC(hwnd);
   hFont = CreateFontIndirect(&lf);
   SelectObject(hdc,hFont);

   GetTextExtentPoint32(hdc, pszStr, strlen(pszStr), &sz);

   ReleaseDC(hwnd, hdc);
   DeleteObject(hFont);

   return (MAKELONG(sz.cx ,sz.cy) );
}

HB_FUNC( MAXTEXTBTNTOOLBAR )      //(HWND hwndTB, int cx, int cy)
{
	char cString[255] = "" ;

	int i,nBtn;
	int tmax = 0;
	int ty = 0;
	DWORD tSize;
	DWORD Style;
	TBBUTTON lpBtn;
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   nBtn  = SendMessage( hWnd, TB_BUTTONCOUNT,0,0);
   for( i = 0; i < nBtn; i++ )
   {
      SendMessage( hWnd, TB_GETBUTTON, i, (LPARAM)  &lpBtn);
      SendMessage( hWnd, TB_GETBUTTONTEXT , lpBtn.idCommand, (LPARAM)(LPCTSTR) cString);

      tSize = WidestBtn(cString, hWnd );
		ty = HIWORD(tSize);

	    if (tmax < LOWORD(tSize) ) tmax = LOWORD(tSize);

	}
    if (tmax == 0){
        SendMessage( hWnd, TB_SETBUTTONSIZE, hb_parni(2),hb_parni(3));//  -ty);
        SendMessage( hWnd, TB_SETBITMAPSIZE,  0,(LPARAM)MAKELONG(hb_parni(2),hb_parni(3)));
    }
    else{
      Style = SendMessage( hWnd, TB_GETSTYLE, 0, 0);
    	if (Style & TBSTYLE_LIST){
            SendMessage( hWnd, TB_SETBUTTONSIZE, hb_parni(2),hb_parni(3)+2);
            SendMessage( hWnd, TB_SETBITMAPSIZE,0,(LPARAM) MAKELONG(hb_parni(3),hb_parni(3)));
        }else{
            SendMessage( hWnd, TB_SETBUTTONSIZE, hb_parni(2),hb_parni(3)-ty+2);
            SendMessage( hWnd, TB_SETBITMAPSIZE,0,(LPARAM) MAKELONG(hb_parni(3)-ty,hb_parni(3)-ty));
        }
       SendMessage( hWnd,TB_SETBUTTONWIDTH, 0, (LPARAM) MAKELONG(hb_parni(2),hb_parni(2)+2));
    }
   SendMessage( hWnd,TB_AUTOSIZE,0,0);  //JP62
}


HB_FUNC( ISBUTTONBARCHECKED)          // hb_parni(2) -> Position in ToolBar
{
   TBBUTTON lpBtn;

   SendMessage( HWNDparam( 1 ),TB_GETBUTTON, hb_parni(2), (LPARAM)  &lpBtn);
   hb_retl( SendMessage( HWNDparam( 1 ),TB_ISBUTTONCHECKED , lpBtn.idCommand , 0 ) );
}

HB_FUNC( CHECKBUTTONBAR )          // hb_parni(2) -> Position in ToolBar
{
	TBBUTTON lpBtn;
   SendMessage( HWNDparam( 1 ),TB_GETBUTTON, hb_parni(2), (LPARAM)  &lpBtn);
   SendMessage( HWNDparam( 1 ),TB_CHECKBUTTON , lpBtn.idCommand , hb_parl(3) );
}

HB_FUNC( GETBUTTONBARRECT )
{
   RECT rc;
   SendMessage( HWNDparam( 1 ), TB_GETITEMRECT,(WPARAM) hb_parnl(2),(LPARAM) &rc);
   hb_retnl( MAKELONG(rc.left,rc.bottom) );
 }

HB_FUNC( GETBUTTONPOS )
{
   hb_retnl( (LONG) (((NMTOOLBAR FAR *) hb_parnl(1))->iItem) );
}

HB_FUNC( GETBUTTONBARCOUNT)
{
    hb_retni ( SendMessage( HWNDparam( 1 ), TB_BUTTONCOUNT,0,0) );
}

HB_FUNC( SETBUTTONID )
{
   hb_retni ( SendMessage( HWNDparam( 1 ), TB_SETCMDID,hb_parni(2),hb_parni(3)) );
}

HB_FUNC( SHOWTOOLBUTTONTIP )
{
	LPTOOLTIPTEXT lpttt;
   lpttt = (LPTOOLTIPTEXT) hb_parnl( 1 );
   lpttt->hinst = GetModuleHandle( NULL );
   lpttt->lpszText = hb_parc( 2 );
}

HB_FUNC ( GETTOOLBUTTONID )
{
	LPTOOLTIPTEXT lpttt;
	lpttt = (LPTOOLTIPTEXT) hb_parnl(1) ;
	hb_retni ( lpttt->hdr.idFrom ) ;
}

HB_FUNC( _TOOLBARGETINFOTIP )
{
   hb_retni( ( ( LPNMTBGETINFOTIP ) hb_parnl( 1 ) ) -> iItem );
}

HB_FUNC( _TOOLBARSETINFOTIP )
{
   LPNMTBGETINFOTIP lpInfo = ( LPNMTBGETINFOTIP ) hb_parnl( 1 );
   int iLen;

   iLen = hb_parclen( 2 );
   if( iLen >= lpInfo->cchTextMax )
   {
      iLen = lpInfo->cchTextMax;
      if( iLen > 0 )
      {
         iLen--;
      }
   }

   hb_xmemcpy( lpInfo->pszText, hb_parc( 2 ), iLen );
   lpInfo->pszText[ iLen ] = 0;
}

#pragma ENDDUMP
