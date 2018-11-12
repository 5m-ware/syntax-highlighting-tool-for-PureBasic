; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Keyboard
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    Enumeration
      #pure_keycode_down    = 40
      #pure_keycode_up      = 38
      #pure_keycode_left    = 37
      #pure_keycode_right   = 39
      #pure_keycode_enter   = 13
      #pure_keycode_delete  =  8
      #pure_keycode_space   = 32
      #pure_keycode_escape  = 27
      #pure_keycode_p_down  = 34
      #pure_keycode_p_up    = 33
      #pure_keycode_pos     = 36
      #pure_keycode_end     = 35
      #pure_keycode_shifted = 16
      #pure_keycode_tabbed  =  9
      #pure_keycode_remove = 127
    EndEnumeration
  CompilerCase #PB_OS_MacOS
    Enumeration
      #pure_keycode_down    = 31
      #pure_keycode_up      = 30
      #pure_keycode_left    = 28
      #pure_keycode_right   = 29
      #pure_keycode_enter   = 13
      #pure_keycode_delete  =  8
      #pure_keycode_space   = 32
      #pure_keycode_escape  = 27
      #pure_keycode_p_down  = 22
      #pure_keycode_p_up    = 11
      #pure_keycode_pos     =  1
      #pure_keycode_end     =  4
      #pure_keycode_shifted = 16 ; ???? 16
      #pure_keycode_tabbed  =  9
      #pure_keycode_remove = 127
    EndEnumeration
  CompilerCase #PB_OS_Linux
    Enumeration
      #pure_keycode_down    = 65364
      #pure_keycode_up      = 65362
      #pure_keycode_left    = 65361
      #pure_keycode_right   = 65363
      #pure_keycode_enter   = 65293
      #pure_keycode_delete  = 65535
      #pure_keycode_space   = 32
      #pure_keycode_escape  = 65307
      #pure_keycode_p_down  = 65365
      #pure_keycode_p_up    = 65366
      #pure_keycode_pos     = 65360
      #pure_keycode_end     = 65367
      #pure_keycode_shifted = 65505
      #pure_keycode_tabbed  = 9
      #pure_keycode_remove  = 65288
    EndEnumeration
CompilerEndSelect

Enumeration
  #fenster = 10
  #feld
  #hintergrund ; Hintergrundabbild
  #eingabe ; Aktuelle Eingabe
EndEnumeration

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Wie groß ist ein Integer?
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  #intsize = 8
CompilerElse
  #intsize = 4
CompilerEndIf

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Türkisch LCase
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure.s TLCase( value.s )
  Protected t.s = value
;  ; ***
;  t = ReplaceString( t, "I", "ı" )
;  t = ReplaceString( t, "İ", "i" )
;  t = ReplaceString( t, "Ş", "ş" )
;  t = ReplaceString( t, "Ç", "ç" )
;  t = ReplaceString( t, "Ğ", "ğ" )
  ; ***
  ProcedureReturn LCase(t)
EndProcedure

Procedure.s TUCase( value.s )
  Protected t.s = value
  ; ***
;  t = ReplaceString( t, "ı", "I" )
;  t = ReplaceString( t, "i", "İ" )
;  t = ReplaceString( t, "ş", "Ş" )
;  t = ReplaceString( t, "ç", "Ç" )
;  t = ReplaceString( t, "ğ", "Ğ" )
  ; ***
  ProcedureReturn LCase(t)
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Der Stringlisten-Objekt wird verwendet, um String-Arrays zu realisieren
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Interface stringlist
  add( value.s )
  set( index.i, value.s )
  get.s( index.i )
  length.i()
  find.a( value.s, casesens.a = #False, index.i = -1 )
  count.i( value.s, casesens.a = #False, index.i = -1 )
  lines.i()
  remove( index.i )
  clear()
EndInterface

Structure stringlist_body
  met.i
  cnt.i
  *ram
EndStructure

Procedure   stringlist__add( *this.stringlist_body, value.s )
  Protected p.i, *mem
  ; ***
  If *this\ram = 0
    *this\ram = AllocateMemory( #intsize )
  Else
    *this\ram = ReAllocateMemory( *this\ram, MemorySize(*this\ram) + #intsize )
  EndIf
  ; ***
  p = MemorySize(*this\ram) - #intsize
  ; ***
  *mem = AllocateMemory( (Len(value)*2) + 2 )
  ; ***
  PokeS( *mem, value, (Len(value)*2) + 2, #PB_Unicode )
  ; ***
  PokeI( *this\ram + p, *mem )
  ; ***
  *this\cnt + 1
EndProcedure

Procedure   stringlist__set( *this.stringlist_body, index.i, value.s )
  Protected p.i, *mem
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = #intsize * index
    ; ***
    *mem = PeekI( *this\ram + p )
    ; ***
    *mem = ReAllocateMemory( *mem, (Len(value)*2) + 2 )
    ; ***
    PokeS( *mem, value, (Len(value)*2) + 2, #PB_Unicode )
    ; ***
    PokeI( *this\ram + p, *mem )
  EndIf
EndProcedure

Procedure.s stringlist__get( *this.stringlist_body, index.i )
  Protected p.i, *mem
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = #intsize * index
    ; ***
    *mem = PeekI( *this\ram + p )
    ; ***
    ProcedureReturn PeekS( *mem, -1, #PB_Unicode )
  EndIf
EndProcedure

Procedure.i stringlist__length( *this.stringlist_body )
  ; - wegen dem chr(13)
  If *this\cnt
    If *this\ram
      ProcedureReturn MemorySize( *this\ram ) - *this\cnt
    EndIf
  EndIf
EndProcedure

Procedure.a stringlist__find( *this.stringlist_body, value.s, casesens.a = #False, index.i = -1 )
  Protected p.i, i.i = 0, l.i, sz.i, s.s = "", c.i = 0, f.i = 0
  ; ***
  Protected *tmp = AllocateMemory( 2048 )
  ; ***
  If *this\ram And *this\cnt
    For p = 0 To MemorySize(*this\ram) - 1
      If PeekA( *this\ram + p ) = 13
        s = PeekS( *tmp, -1, #PB_Unicode )
        ; ***
        If casesens = #False
          s = TLCase(s)
        EndIf
        ; ***
        If index = -1
          If FindString( s, value )
            f = 1
            Break
          EndIf
        Else
          If i = index
            If FindString( s, value )
              f = 1
            EndIf
            ; ***
            Break
          EndIf
        EndIf
        ; ***
        sz + ( Len(s) * 2 ) + 1
        l = p + 1
        i + 1
        ; ***
        s = ""
        ; ***
        c = 0
        ; ***
        FreeMemory( *tmp )
        *tmp = AllocateMemory( 2048 )
      Else
        PokeA( *tmp + c, PeekA( *this\ram + p ) )
        c + 1
      EndIf
    Next
  EndIf
  ; ***
  FreeMemory( *tmp )
  ; ***
  ProcedureReturn f
EndProcedure

Procedure.i stringlist__count( *this.stringlist_body, value.s, casesens.a = #False, index.i = -1 )
  Protected p.i, i.i = 0, l.i, sz.i, s.s = "", c.i = 0, f.i = 0
  ; ***
  Protected *tmp = AllocateMemory( 2048 )
  ; ***
  If *this\ram And *this\cnt
    For p = 0 To MemorySize(*this\ram) - 1
      If PeekA( *this\ram + p ) = 13
        s = PeekS( *tmp, -1, #PB_Unicode )
        ; ***
        If casesens = #False
          s = TLCase(s)
        EndIf
        ; ***
        If index = -1
          f + CountString( s, value )
        Else
          If i = index
            f + CountString( s, value )
            ; ***
            Break
          EndIf
        EndIf
        ; ***
        sz + ( Len(s) * 2 ) + 1
        l = p + 1
        i + 1
        ; ***
        s = ""
        ; ***
        c = 0
        ; ***
        FreeMemory( *tmp )
        *tmp = AllocateMemory( 2048 )
      Else
        PokeA( *tmp + c, PeekA( *this\ram + p ) )
        c + 1
      EndIf
    Next
  EndIf
  ; ***
  FreeMemory( *tmp )
  ; ***
  ProcedureReturn f
EndProcedure

Procedure.i stringlist__lines( *this.stringlist_body )
  ProcedureReturn *this\cnt
EndProcedure

Procedure   stringlist__remove( *this.stringlist_body, index.i )
  Protected p.i, n.i = -1, *mem
  Protected Dim *lst(*this\cnt)
  ; ***
  If *this\ram
    For p = 0 To *this\cnt - 1
      If p <> index
        n + 1
        ; ***
        *lst(n) = PeekI( *this\ram + (p * #intsize) )
      EndIf
    Next
    ; ***
    FreeMemory( *this\ram )
    ; ***
    *this\cnt - 1
    ; ***
    If *this\cnt
      *this\ram = AllocateMemory( *this\cnt * #intsize )
      ; ***
      For p = 0 To *this\cnt - 1
        If *lst(p)
          PokeI( *this\ram + (p * #intsize), *lst(p) )
        EndIf
      Next
    EndIf
  EndIf
EndProcedure

Procedure   stringlist__clear( *this.stringlist_body )
  Protected p.i, *mem
  ; ***
  If *this\ram
    For p = 0 To *this\cnt - 1
      *mem = PeekI( *this\ram + (p * #intsize) )
      FreeMemory( *mem )
    Next
    ; ***
    FreeMemory( *this\ram )
    ; ***
    *this\ram = 0
    *this\cnt = 0
  EndIf
EndProcedure

Procedure   stringlist()

  Protected *this.stringlist_body

  *this = AllocateMemory(SizeOf(stringlist_body))

  If *this
    InitializeStructure(*this, stringlist_body)
    ; ***
    *this\ram = *ram
    ; ***
    *this\Met.i = ?_stringlist_
  EndIf

  ProcedureReturn *this

EndProcedure

DataSection
  _stringlist_:
  Data.i @stringlist__add()
  Data.i @stringlist__set()
  Data.i @stringlist__get()
  Data.i @stringlist__length()
  Data.i @stringlist__find()
  Data.i @stringlist__count()
  Data.i @stringlist__lines()
  Data.i @stringlist__remove()
  Data.i @stringlist__clear()
EndDataSection

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Der editor_dataset-Objekt wird verwendet, um String-Arrays zu realisieren
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Interface editor_dataset
  add( value.s, intvalue.i = 0, mode.a = 0, altindex.i = 0, flag.a = 0 )
  set( index.i, value.s )
  get.s( index.i )
  length.i()
  find.a( value.s, casesens.a = #False, index.i = -1 )
  count.i( value.s, casesens.a = #False, index.i = -1 )
  lines.i()
  remove( index.i )
  clear()
  cursor.w( index.i, value.w = -1 )
  fold.a( index.i, value.a = 200 )
  locked.a( index.i, value.a = 200 )
  attr.l( index.i, value.i = -2147483648 )
  insert( index.i, value.s, intvalue.i = 0 )
EndInterface

Structure editor_dataset_body
  met.i
  cnt.u
  *ram
  *atr
  *org
EndStructure

Procedure   editor_dataset__add( *this.editor_dataset_body, value.s, intvalue.i = 0, mode.a = 0, altindex.i = 0, flag.a = 0 )
  ; value    = Die Stringzeile selbst
  ; intvalue = Attributswert
  ; mode     = Passt die relativen Zeilenpositionen an
  ; altindex = Relevant ab mode>=1 und definiert den relativen Zeilenindex für die Verschiebung
  ; flag     = Regelt die Darstellbarkeit und Erreichbarkeit der Zeilen in Kombination mit dem Verhalten des Code-Editors
  ; ***
  Protected p.i, *mem, u.u, aix.i, rix.u, flg.a
  ; ***
  If *this\ram = 0
    *this\ram = AllocateMemory( #intsize )
    *this\atr = AllocateMemory( 4 )
    *this\org = AllocateMemory( 3 )
  Else
    *this\ram = ReAllocateMemory( *this\ram, MemorySize(*this\ram) + #intsize )
    *this\atr = ReAllocateMemory( *this\atr, MemorySize(*this\atr) + 4 )
    *this\org = ReAllocateMemory( *this\org, MemorySize(*this\org) + 3 )
  EndIf
  ; ***
  p = MemorySize(*this\ram) - #intsize
  ; ***
  *mem = AllocateMemory( (Len(value)*2) + 2 )
  ; ***
  PokeS( *mem, value, (Len(value)*2) + 2, #PB_Unicode )
  ; ***
  PokeI( *this\ram + p, *mem )
  ; ***
  p = MemorySize(*this\atr) - 4
  ; ***
  PokeL( *this\atr + p, intvalue )
  ; ***
  p = MemorySize(*this\org) - 3
  ; ***
  Select mode
    Case 0
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; Die neue Zeile wurde ganz unten normal angehangen.
      ; Deshalb ist die absolute sowie die relative
      ; Zeilennummer dieselbe.
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; ***
      u = *this\cnt
    Case 1
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; Der Anwender hat im Editor auf den Enter gedrückt
      ; und damit alle anderen Zeilen, welche unterhalb
      ; des Cursors lagen, nach untenhin verschoben
      ; ***
      ; Der altindex ist nun die absolute Zeilennummer
      ; der Zeile, auf dem sich der Anwender gerade 
      ; befindet, die nun als "LEER" markiert ist.
      ; ***
      ; Diese Zeile wird zur relativen Index dieser neu
      ; angelegten Zeile.
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; ***
      u = altindex
      ; ***
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; Nun haben wir das Problem, dass auch alle anderen
      ; relativen Zeilennummern, die nach dem Cursor
      ; folgen, um einen Punkt nach untenhin verschoben
      ; werden. Da die Cursorposition altindex ist, wird
      ; also dessen absolute Gegenstück im DataSet als 
      ; Grundlage genommen und von dort aus wird nun
      ; die Anpassung durchgeführt.
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; ***
      If MemorySize(*this\org) > 3
        For aix = (altindex + 1) * 3 To (MemorySize(*this\org) - 1) - 3 Step 3
          rix = PeekU( *this\org + aix + 0 )
          flg = PeekA( *this\org + aix + 2 )
          ; ***
          rix + 1
          ; ***
          PokeU( *this\org + aix + 0,  rix )
          PokeA( *this\org + aix + 2,  flg )
        Next
      EndIf
    Case 2
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; Der Anwender hat im Editor die aktuelle Zeile
      ; getilgt, in dem er mit dem Cursor zum übergeordneten
      ; Zeile gesprungen ist, in dem er an der Cursor-
      ; Position 0 auf die Delete-Taste gedrückt hat.
      ; ***
      ; Die altindex ist nun die Zeilennummer der 
      ; übergeordneten Zeile. Die relative Index der 
      ; gelöschten Zeile wird nun auf den maximalen Wert
      ; 65535 gesetzt.
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; ***
      aix = altindex + 1
      ; ***
      PokeU( *this\org + aix + 0, 65535 ) ; Die Position wird ganz nach hinten verlegt
      PokeA( *this\org + aix + 2,    10 ) ; Die Zeile wird als Gelöscht markiert
      ; ***
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; alle anderen Zeilen nach dem Cursor werden num um
      ; eine Position nach oben verschoben.
      ; - - - - - - - - - - - - - - - - - - - - - - - - - - ;
      ; ***
      If MemorySize(*this\org) > 6
        For aix = (altindex + 2) * 3 To (MemorySize(*this\org) - 1) - 3 Step 3
          rix = PeekU( *this\org + aix + 0 )
          flg = PeekA( *this\org + aix + 2 )
          ; ***
          rix - 1
          ; ***
          PokeU( *this\org + aix + 0,  rix )
          PokeA( *this\org + aix + 2,  flg )
        Next
      EndIf
  EndSelect
  ; ***
  ; Relative Index einer Zeile nach außen (rli)
  PokeU( *this\org + p + 0,    u )
  ; Flag um das Verhalten der Zeile im Code-Editor zu regeln
  PokeA( *this\org + p + 2, flag )
  ; ***
  *this\cnt + 1
EndProcedure

Procedure   editor_dataset__set( *this.editor_dataset_body, index.i, value.s )
  Protected p.i, *mem, idx.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    idx = PeekU( *this\org + (index * 3) )
    ; ***
    p = #intsize * index;idx
    ; ***
    *mem = PeekI( *this\ram + p )
    ; ***
    *mem = ReAllocateMemory( *mem, (Len(value)*2) + 2 )
    ; ***
    PokeS( *mem, value, (Len(value)*2) + 2, #PB_Unicode )
    ; ***
    PokeI( *this\ram + p, *mem )
  EndIf
EndProcedure

Procedure.s editor_dataset__get( *this.editor_dataset_body, index.i )
  Protected p.i, *mem, idx.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    idx = PeekU( *this\org + (index * 3) )
    ; ***
    p = #intsize * index;idx
    ; ***
    *mem = PeekI( *this\ram + p )
    ; ***
    ProcedureReturn PeekS( *mem, -1, #PB_Unicode )
  EndIf
EndProcedure

Procedure.i editor_dataset__length( *this.editor_dataset_body )
  ; - wegen dem chr(13)
  If *this\cnt
    If *this\ram
      ProcedureReturn MemorySize( *this\ram ) - *this\cnt
    EndIf
  EndIf
EndProcedure

Procedure.a editor_dataset__find( *this.editor_dataset_body, value.s, casesens.a = #False, index.i = -1 )
  Protected p.i, i.i = 0, l.i, sz.i, s.s = "", c.i = 0, f.i = 0
  ; ***
  Protected *tmp = AllocateMemory( 2048 )
  ; ***
  If *this\ram And *this\cnt
    For p = 0 To MemorySize(*this\ram) - 1
      If PeekA( *this\ram + p ) = 13
        s = PeekS( *tmp, -1, #PB_Unicode )
        ; ***
        If casesens = #False
          s = TLCase(s)
        EndIf
        ; ***
        If index = -1
          If FindString( s, value )
            f = 1
            Break
          EndIf
        Else
          If i = index
            If FindString( s, value )
              f = 1
            EndIf
            ; ***
            Break
          EndIf
        EndIf
        ; ***
        sz + ( Len(s) * 2 ) + 1
        l = p + 1
        i + 1
        ; ***
        s = ""
        ; ***
        c = 0
        ; ***
        FreeMemory( *tmp )
        *tmp = AllocateMemory( 2048 )
      Else
        PokeA( *tmp + c, PeekA( *this\ram + p ) )
        c + 1
      EndIf
    Next
  EndIf
  ; ***
  FreeMemory( *tmp )
  ; ***
  ProcedureReturn f
EndProcedure

Procedure.i editor_dataset__count( *this.editor_dataset_body, value.s, casesens.a = #False, index.i = -1 )
  Protected p.i, i.i = 0, l.i, sz.i, s.s = "", c.i = 0, f.i = 0
  ; ***
  Protected *tmp = AllocateMemory( 2048 )
  ; ***
  If *this\ram And *this\cnt
    For p = 0 To MemorySize(*this\ram) - 1
      If PeekA( *this\ram + p ) = 13
        s = PeekS( *tmp, -1, #PB_Unicode )
        ; ***
        If casesens = #False
          s = TLCase(s)
        EndIf
        ; ***
        If index = -1
          f + CountString( s, value )
        Else
          If i = index
            f + CountString( s, value )
            ; ***
            Break
          EndIf
        EndIf
        ; ***
        sz + ( Len(s) * 2 ) + 1
        l = p + 1
        i + 1
        ; ***
        s = ""
        ; ***
        c = 0
        ; ***
        FreeMemory( *tmp )
        *tmp = AllocateMemory( 2048 )
      Else
        PokeA( *tmp + c, PeekA( *this\ram + p ) )
        c + 1
      EndIf
    Next
  EndIf
  ; ***
  FreeMemory( *tmp )
  ; ***
  ProcedureReturn f
EndProcedure

Procedure.i editor_dataset__lines( *this.editor_dataset_body )
  ProcedureReturn *this\cnt
EndProcedure

Procedure   editor_dataset__remove( *this.editor_dataset_body, index.i )
  Protected p.i, n.i = -1, *mem
  Protected Dim *lst(*this\cnt)
  Protected Dim atr.l(*this\cnt)
  ; ***
  If *this\ram
    For p = 0 To *this\cnt - 1
      If p <> index
        n + 1
        ; ***
        *lst(n) = PeekI( *this\ram + (p * #intsize) )
        ; ***
        atr(n) = PeekL( *this\atr + (p * 4) )
      EndIf
    Next
    ; ***
    FreeMemory( *this\ram )
    FreeMemory( *this\atr )
    ; ***
    *this\cnt - 1
    ; ***
    If *this\cnt
      *this\ram = AllocateMemory( *this\cnt * #intsize )
      *this\atr = AllocateMemory( *this\cnt * 4 )
      ; ***
      For p = 0 To *this\cnt - 1
        If *lst(p)
          PokeI( *this\ram + (p * #intsize), *lst(p) )
          ; ***
          PokeL( *this\atr + (p * 4), atr(p) )
        EndIf
      Next
    EndIf
  EndIf
EndProcedure

Procedure   editor_dataset__clear( *this.editor_dataset_body )
  Protected p.i, *mem
  ; ***
  If *this\ram
    For p = 0 To *this\cnt - 1
      *mem = PeekI( *this\ram + (p * #intsize) )
      FreeMemory( *mem )
    Next
    ; ***
    FreeMemory( *this\ram )
    FreeMemory( *this\atr )
    FreeMemory( *this\org )
    ; ***
    *this\org = 0
    *this\atr = 0
    *this\ram = 0
    *this\cnt = 0
  EndIf
EndProcedure

Procedure.w editor_dataset__cursor( *this.editor_dataset_body, index.i, value.w = -1 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value <= -1
      ProcedureReturn PeekW( *this\atr + p )
    Else
      PokeW( *this\atr + p, value )
    EndIf
  EndIf
EndProcedure

Procedure.a editor_dataset__fold( *this.editor_dataset_body, index.i, value.a = 200 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value = 200
      ProcedureReturn PeekA( *this\atr + p + 1 )
    Else
      If value = #True Or value = #False
        PokeA( *this\atr + p + 1, value )
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.a editor_dataset__locked( *this.editor_dataset_body, index.i, value.a = 200 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value = 200
      ProcedureReturn PeekA( *this\atr + p + 2 )
    Else
      If value = #True Or value = #False
        PokeA( *this\atr + p + 2, value )
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.l editor_dataset__attr( *this.editor_dataset_body, index.i, value.i = -2147483648 )
  Protected p.i
  ; ***
  If *this\ram And index >= 0 And index < *this\cnt And *this\cnt
    p = 4 * index
    ; ***
    If value = -2147483648
      ProcedureReturn PeekL( *this\atr + p )
    Else
      PokeL( *this\atr + p, value )
    EndIf
  EndIf
EndProcedure

Procedure   editor_dataset__insert( *this.editor_dataset_body, index.i, value.s, intvalue.i = 0 )
  Protected n.i, g.i = 0, p.i, p1.i, p2.i, *adr, *ram, *atr
  ; ***
  If *this\ram
    editor_dataset__add(*this,"")
    ; ***
    If *this\cnt And index < *this\cnt - 1
      p = *this\cnt -1
      ; ***
      p1 = MemorySize(*this\ram)
      p2 = MemorySize(*this\atr)
      ; ***
      *adr = PeekI( *this\ram + p1 - #intsize )
      ; ***
      *ram = AllocateMemory(p1)
      *atr = AllocateMemory(p2)
      ; ***
      For n = 0 To p
        If g = index
          g + 1
        EndIf
        ; ***
        PokeI( *ram + (g * #intsize), PeekI( *this\ram + (n * #intsize) ) )
        PokeL( *atr + (g * 4), PeekL( *this\atr + (n * 4) ) )
        ; ***
        g + 1
      Next
      ; ***
      PokeI( *ram + (index * #intsize), *adr )
      PokeL( *atr + (index * 4), intvalue )
      ; ***
      FreeMemory(*this\ram) : *this\ram = *ram
      FreeMemory(*this\atr) : *this\atr = *atr
    EndIf
  EndIf
EndProcedure

Procedure   editor_dataset()

  Protected *this.editor_dataset_body

  *this = AllocateMemory(SizeOf(editor_dataset_body))

  If *this
    InitializeStructure(*this, editor_dataset_body)
    ; ***
    *this\ram = *ram
    ; ***
    *this\Met.i = ?_editor_dataset_
  EndIf

  ProcedureReturn *this

EndProcedure

DataSection
  _editor_dataset_:
  Data.i @editor_dataset__add()
  Data.i @editor_dataset__set()
  Data.i @editor_dataset__get()
  Data.i @editor_dataset__length()
  Data.i @editor_dataset__find()
  Data.i @editor_dataset__count()
  Data.i @editor_dataset__lines()
  Data.i @editor_dataset__remove()
  Data.i @editor_dataset__clear()
  Data.i @editor_dataset__cursor()
  Data.i @editor_dataset__fold()
  Data.i @editor_dataset__locked()
  Data.i @editor_dataset__attr()
  Data.i @editor_dataset__insert()
EndDataSection

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Daten des Editors
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Structure struct_intellisence
  ; Das sind die CommandKeys, die zum Aufklappen der 
  ; Intellisence-Box erkannt werden
  groupkeys.stringlist
  ; Der Inhalt
  content.stringlist
  ; Einfügen mit oder ohne Leerabstand
  space.a
  ; Maximalbreite der Liste
  width.u
EndStructure

Structure struct_intellisence_list
  cnt.u
  lst.struct_intellisence[1000]
EndStructure

Structure struct_current_line_char
  char.s
  color.l
  pos.w
EndStructure

Structure struct_pure_multiline_code_editor
  ; Aktueller Zeichnen-Status
  justdraw.a
  ; CanvasGadet
  id.i
  ; Intellisense-Anbindung
  *intellisence.struct_intellisence_list
  ; Inhalt
  content.editor_dataset
  ; Syntax-Highlighting für die Schlüsselwörter
  *keywords.editor_dataset
  ; Groß- und Kleinschreibung beachten für Keywords?
  casesens.a
  ; Kommantierung aktiv?
  comment.a
  ; Stringeingabe aktiv?
  stringi.a
  ; Kommentarzeichen
  comment_char.s
  ; Stringketten-Zeichen
  string_char.s
  ; Double-Trenner für Zahlen
  double_separator.s
  ; Farben
  color_comment.l
  color_string.l
  color_number.l
  color_operator.l
  color_bkg.l
  color_selbkg.l
  color_errorbkg.l
  color_marked_bkg.l
  color_marked_border.l
  color_number_block_txt.l
  color_number_block_bkg.l
  color_number_block_active.l
  color_intelli_background.l
  color_intelli_border.l
  color_intelli_lborder.l
  color_intelli_dborder.l
  color_intelli_text.l
  color_intelli_sel_bkg.l
  color_intelli_sel_txt.l
  ; Zeilennummer anzeigen
  linenumbers.a
  ; Temporärer Abbild
  tempor.i
  ; Visible Background:
  ; Das ist der aktuelle Hintergrund, der alle sichtbaren 
  ; Code-Zeilen wiedergibt
  visbkg.i
  ; Temporary Background:
  ; Dieses Bild wird bei up/down gentzt, um eine Kopie 
  ; des visbkg zu nehmen und es um eine Zeile nach oben
  ; oder nach unten zu reduzieren und die neu dazu kommende
  ; Zeile anzuhängen
  tmpbkg.i
  ; Last active Line- Image
  lalimg.i
  ; Current Line Inkey
  inkey.s
  ; Current Line:
  ; Das Abbild der aktuellen Zeile wird beim up/down oder
  ; Mausklick aus dem Background-Bereich herauskopiert oder
  ; beim JIT-Eingabe automatisch realisiert, jedoch nur ab dem
  ; Part, der gerade bearbeitet wird
  curlin.i
  ; Aktuelles Start-Zeichen der aktuellen Zeile, ab dem
  ; neugezeichnet wird
  curpos.w
  ; Aktuelle Tokenlänge
  curlen.w
  ; Zeichencursor
  cursor.w
  ; Aktuelle Länge der Eingabe
  length.w
  ; Zeichenstrom der aktuellen Zeile
  strom.struct_current_line_char[20000]
  ; Temporärer Token
  tmptok.s
  ; Letzte Tokenstart
  lastpo.w
  ; Aktuelle Zeilenindex : Tatsächliche Zeilennummer
  index.i
  ; Top-Limit
  toplimit.i
  ; Vis-Limit
  vislimit.u
  ; Cursor-Row-Position : Relative Zeilennummer im sichtbaren Feld
  ; Ermittlung: position = index - toplimit
  position.i
  ; Hintergrund-Update
  update_bkg.a
  ; Nummernblock-Abstand
  nwid.u
  ; Text-Height
  theight.u
  ; Cursor-Display
  cursorDisplay.a
  ; Richtung der Content-Aktualisierung
  condir.a
  ; Cursor-Blinker
  curstate.w
  ; Den Cursor ganz nach hinter der Zeile verschieben
  movetolast.a
  ; Letzte Zeichenfolge
  lastkey.s
  ; Letzte im Intellisence-Box ausgewählter Eintrag
  intellitok.s
  ; Intellisence-Anzeige-Modus
  intellivis.a
  ; Intellisence-Index
  intellicur.w
  ; Intellisence-Total vom aktuellen Inhalt
  intellitot.u
  ; Intellisence-Abstand
  intellimar.a
  ; Letzte Intellisence-Breite
  intelliLastWidth.l
  ; Markierungsflag
  mark.a
  ; Markierungsmodus:
  ; 0 = Nur die aktuelle Zeile
  ; 1 = Mehrere Zeilen
  markmode.a
  ; Markierungspunkt
  markrow.l : markrel.l
  ; Startposition der Markierung auf der Startzeile für die Markierung
  markCursorFrom.w
  ; Endposition der Markierung auf der Endzeile für die Markierung
  markCursorInto.w
  ; Startzeile
  markstart.u
  ; Endzeile
  markclose.u
  ; Begin der Markierung an Zeichen X
  markpos.w
  ; Ende der Markierung an Zeichen N
  marklen.w
  ; Markierungsstartzeichen-Differenz variiert um einen Wert zwischen
  ; der Tastaturmarkierung und der Mauszeigermarkierung
  markdif.a
EndStructure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Funktionen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure.s pick( index.l, char.s, value.s )
  Protected n.l, s.s, idx.l = 0
  ; ***
  For n = 1 To Len( value )
    Select Mid( value, n, 1 )
      Case char
        If idx = index
          Break
        Else
          idx + 1
          ; ***
          s = ""
        EndIf
      Default
        s + Mid( value, n, 1 )
    EndSelect
  Next
  ; ***
  If idx > index
    s = ""
  EndIf
  ; ***
  If index < 0
    s = ""
  EndIf
  ; ***
  If index > CountString( value, char )
    s = ""
  EndIf
  ; ***
  ProcedureReturn s
EndProcedure

Procedure.i opaque( value.i, transparency.u = 255 )
  ProcedureReturn RGBA( Red(value), Green(value), Blue(value), transparency )
EndProcedure

;https://physikunterricht-online.de/hilfsmittel/physikalische-groessen-und-einheiten/
; ***
;https://www.gut-erklaert.de/mathematik/gewichtseinheiten-tabelle.html
;https://www.gut-erklaert.de/mathematik/volumeneinheiten-tabelle-mit-liter.html
;https://www.gut-erklaert.de/mathematik/laengeneinheiten-tabelle.html
;https://www.frustfrei-lernen.de/mathematik/laengeneinheiten.html
;https://www.gut-erklaert.de/mathematik/zeiteinheiten-tabelle-und-abkuerzungen.html
;http://www.tabelle.info/elektrische_einheiten.htm

Procedure.a is_arithmetical( value.s )
  Protected p.i, ret.a = 1, v.s = value, tk.s, ti.s, fn.s, nu.a = 0
  ; ***
  ; ha = Hektar
  ; g = gramm
  ; mg = milligramm
  ; kg = kilogramm
  ; dt = Dezitonne
  ; cg = Centigramm
  ; t = Tonne
  ; kt = Kilotonne
  ; mt = Megatonne
  ; gt = Gigatonne
  ; ml = milliliter
  ; cl = centiliter
  ; dl = deziliter
  ; hl = hektoliter
  ; mi,mil = mil
  ; yd = yard
  ; ft = foot
  ; sm = seemeile
  ; in,inc=inc
  ; a=ampere,strom
  ; c=coulomb,ladung
  ; v=volt,spannung
  ; w=watt,leistung
  ; o=ohm,Widerstand
  ; f=farad,Kapazität
  ; si=siemens,leitwert
  tk = "yıl,gün,hafta,ay,saat,dakika,saniye,milisaniye,bayt,ppi,dpi,kb,mb,tb,bit,mbit,kbit,tbit,km,dm,cm,mm,ml,ms,pt,px,inç,mil,ha,mg,kg,dt,cg,kt,mt,gt,cl,dl,hl,in,mi,yd,ft,sm,si,a,c,v,w,o,f,m,t,l,s,h,b,o,g"
  ; ***
  v = TLCase(v)
  v = Trim(v)
  ; ***
  For p = 0 To CountString(tk,",")+1
    ti = pick(p,",",tk) 
    ; ***
    If ti
      If FindString( v, ti )
        fn = ti
        ; ***
        v = Trim(ReplaceString( v, ti, "" ))
        ; ***
        Break
      EndIf
    EndIf
  Next
  ; ***
  For p = 1 To Len(v)
    Select Mid( v, p, 1 )
      Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        nu = 1
      Default
        nu = 0
        ret = 0
        Break
    EndSelect
  Next
  ; ***
  If nu = 0
    ret = 0
  EndIf
  ; ***
  ProcedureReturn ret
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Zeichnen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

LoadFont(100,"Anonymous Pro",20)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Markierungsfeldinhalt ermitteln
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure.s getMarkedText(*daten.struct_pure_multiline_code_editor)
  Protected p.w, y.w, h.w, x.w, w.w, t.s
  ; ***
  y = *daten\markstart + *daten\toplimit
  h = *daten\markclose + *daten\toplimit
  ; ***
  If h > y
    h - 1
  EndIf
  ; ***
  x = *daten\markpos
  w = *daten\marklen
  ; ***
  If w < x
    p = x
    x = w
    w = p
  EndIf
  ; ***
  x + *daten\markdif
  ; ***
  For p = y To h
    If p > y
      t + #CRLF$
    EndIf
    ; ***
    t + Mid( *daten\content\get(p), x, (w - x) + 1 )
  Next
  ; ***
  ProcedureReturn t
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Markierungsfeldinhalt leeren
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure clearMarkedText(*daten.struct_pure_multiline_code_editor)
  Protected p.w, n.i, y.w, h.w, x.w, w.w, t.s, s.s
  ; ***
  y = *daten\markstart + *daten\toplimit
  h = *daten\markclose + *daten\toplimit
  ; ***
  x = *daten\markpos
  w = *daten\marklen
  ; ***
  If w < x
    p = x
    x = w
    w = p
  EndIf
  ; ***
  For p = y To h
    t = Mid( *daten\content\get(p), x, (w - x) + 1 )
    ; ***
    For n = 1 To Len(t)
      If n >= x And n <= (w - x) + 1
        s + " "
      Else
        s + Mid( t, n, 1 )
      EndIf
    Next
    ; ***
    *daten\content\set(p,s)
  Next
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Ermittelt die Zeichen des aktuell angesteuerten Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure update_current_token(*daten.struct_pure_multiline_code_editor,pos.w,lth.w)
  If IsGadget(#feld)
    Protected w.i, h.i, p.i, n.i, c.i, g.i = 0, t.s, s.s, b.s, com.a = 0, stg.a = 0, ps.i, ls.i, spa.a = 0
    ; ***
    w = GadgetWidth(#feld)
    h = GadgetHeight(#feld)
    ; ***
    ls = lth
    ; ***
    ps = pos
    ; ***
    For p = ps To ls
      *daten\strom[p]\color = 0
      ; ***
      If com = 1 And stg = 0
        *daten\strom[p]\color = *daten\color_comment
      ElseIf stg = 1 And com = 0
        *daten\strom[p]\color = *daten\color_string
      EndIf
      ; ***
      Select *daten\strom[p]\char
        Case *daten\comment_char
          If stg = 0
            com = 1
            ; ***
            *daten\strom[p]\color = *daten\color_comment
          EndIf
        Case *daten\string_char
          If com = 0
            Select stg
              Case 0 : stg = 1
              Case 1 : spa = 1
            EndSelect
            ; ***
            *daten\strom[p]\color = *daten\color_string
          EndIf
        Case " ", ".", "(", ")", "{", "}", "[", "]", "/", "\", "%", "+", "-", "&", "'",
             "*", ":", ";", ",", "<", ">", "|", "#", "=", "!", "|", "^", "°", "$", "§",
             "~", "≈", Chr(10), Chr(13)
          If com = 0 And stg = 1
            *daten\strom[p]\color = *daten\color_string
          ElseIf com = 1 And stg = 0
            *daten\strom[p]\color = *daten\color_comment
          ElseIf com = 0 And stg = 0
            *daten\strom[p]\color = *daten\color_operator
            ; ***
            g = p - Len(t)
            ; ***
            For c = 0 To Len(b) - 1
              *daten\strom[g + c]\color = 0
            Next
            ; ***
            If *daten\keywords
              For n = 0 To *daten\keywords\lines() -1
                If TLCase(*daten\keywords\get(n)) = TLCase(t)
                  t = *daten\keywords\get(n)
                  ; ***
                  g = p - Len(*daten\keywords\get(n))
                  ; ***
                  For c = 0 To Len(*daten\keywords\get(n)) - 1
                    *daten\strom[c + g]\color = *daten\keywords\attr(n)
                    *daten\strom[c + g]\char = Mid( t, c + 1, 1 )
                  Next
                  ; ***
                  Break
                EndIf
              Next
            EndIf
          EndIf
          ; ***
          t = ""
          ; ***
          If spa = 1
            spa = 0
            stg = 0
          EndIf
        Default
          t + *daten\strom[p]\char
      EndSelect
    Next
    ; ***
    If spa = 1
      spa = 0
      stg = 0
    EndIf
    ; ***
    If t
      p = *daten\cursor + lth
      ; ***
      If com = 0 And stg = 0
        *daten\strom[p]\color = *daten\color_operator
        ; ***
        g = p - Len(t)
        ; ***
        For c = 0 To Len(b) - 1
          *daten\strom[g + c]\color = 0
        Next
        ; ***
        If *daten\keywords
          For n = 0 To *daten\keywords\lines() -1
            If TLCase(*daten\keywords\get(n)) = TLCase(t)
              t = *daten\keywords\get(n)
              ; ***
              g = p - Len(*daten\keywords\get(n))
              ; ***
              For c = 0 To Len(*daten\keywords\get(n)) - 1
                *daten\strom[c + g]\color = *daten\keywords\attr(n)
                *daten\strom[c + g]\char = Mid( t, c + 1, 1 )
              Next
              ; ***
              Break
            EndIf
          Next
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Setzt den Syntax-Färbung der aktuellen Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure update_current_syntax(*daten.struct_pure_multiline_code_editor)
  If IsGadget(#feld)
    Protected w.i, h.i, p.i, n.i, c.i, g.i = 0, t.s, s.s, b.s, com.a = 0, stg.a = 0, ps.i, ls.i, spa.a = 0
    ; ***
    w = GadgetWidth(#feld)
    h = GadgetHeight(#feld)
    ; ***
    ls = *daten\length
    ; ***
    ps = 0
    ; ***
    If ps < 0 : ProcedureReturn : EndIf
    If ls > 19999 : ProcedureReturn : EndIf
    ; ***
    For p = ps To ls
      *daten\strom[p]\color = 0
      ; ***
      If com = 1 And stg = 0
        *daten\strom[p]\color = *daten\color_comment
      ElseIf stg = 1 And com = 0
        *daten\strom[p]\color = *daten\color_string
      EndIf
      ; ***
      Select *daten\strom[p]\char
        Case *daten\comment_char
          If stg = 0
            com = 1
            ; ***
            *daten\strom[p]\color = *daten\color_comment
          EndIf
        Case *daten\string_char
          If com = 0
            Select stg
              Case 0 : stg = 1
              Case 1 : spa = 1
            EndSelect
            ; ***
            *daten\strom[p]\color = *daten\color_string
          EndIf
        Case " ", ".", "(", ")", "{", "}", "[", "]", "/", "\", "%", "+", "-", "&", "'",
             "*", ":", ";", ",", "<", ">", "|", "#", "=", "!", "|", "^", "°", "$", "§",
             "~", "≈", Chr(10), Chr(13)
          If com = 0 And stg = 1
            *daten\strom[p]\color = *daten\color_string
          ElseIf com = 1 And stg = 0
            *daten\strom[p]\color = *daten\color_comment
          ElseIf com = 0 And stg = 0
            *daten\strom[p]\color = *daten\color_operator
            ; ***
            If t
              If is_arithmetical( t ) = #True
                g = p - Len(t)
                ; ***
                For c = 0 To Len(t) - 1
                  *daten\strom[g + c]\color = *daten\color_number
                Next
                ; ***
                Select *daten\strom[p]\char
                  Case ".", "%"
                    *daten\strom[p]\color = *daten\color_number
                EndSelect
                ; ***
                If g - 1 > 0
                  If *daten\strom[g - 1]\char = "%"
                    *daten\strom[g - 1]\color = *daten\color_number
                  EndIf
                EndIf
              Else
                g = p - Len(t)
                ; ***
                For c = 0 To Len(b) - 1
                  *daten\strom[g + c]\color = 0
                Next
                ; ***
                If *daten\keywords
                  For n = 0 To *daten\keywords\lines() -1
                    If TLCase(*daten\keywords\get(n)) = TLCase(t)
                      t = *daten\keywords\get(n)
                      ; ***
                      g = p - Len(*daten\keywords\get(n))
                      ; ***
                      For c = 0 To Len(*daten\keywords\get(n)) - 1
                        *daten\strom[c + g]\color = *daten\keywords\attr(n)
                        *daten\strom[c + g]\char = Mid( t, c + 1, 1 )
                      Next
                      ; ***
                      Break
                    EndIf
                  Next
                EndIf
              EndIf
            EndIf
          EndIf
          ; ***
          t = ""
          ; ***
          If spa = 1
            spa = 0
            stg = 0
          EndIf
        Default
          t + *daten\strom[p]\char
      EndSelect
      ; ***
      *daten\comment = com
      *daten\stringi = stg
    Next
    ; ***
    If spa = 1
      spa = 0
      stg = 0
    EndIf
    ; ***
    If t
      p = ls
      ; ***
      If com = 0 And stg = 0
        *daten\strom[p]\color = *daten\color_operator
        ; ***
        If is_arithmetical( t ) = #True
          g = p - Len(t)
          ; ***
          For c = 0 To Len(t) - 1
            *daten\strom[g + c]\color = *daten\color_number
          Next
          ; ***
          Select *daten\strom[p]\char
            Case ".", "%"
              *daten\strom[p]\color = *daten\color_number
          EndSelect
          ; ***
          If g - 1 > 0
            If *daten\strom[g - 1]\char = "%"
              *daten\strom[g - 1]\color = *daten\color_number
            EndIf
          EndIf
        Else
          g = p - Len(t)
          ; ***
          For c = 0 To Len(b) - 1
            *daten\strom[g + c]\color = 0
          Next
          ; ***
          If *daten\keywords
            For n = 0 To *daten\keywords\lines() -1
              If TLCase(*daten\keywords\get(n)) = TLCase(t)
                t = *daten\keywords\get(n)
                ; ***
                g = p - Len(*daten\keywords\get(n))
                ; ***
                For c = 0 To Len(*daten\keywords\get(n)) - 1
                  *daten\strom[c + g]\color = *daten\keywords\attr(n)
                  *daten\strom[c + g]\char = Mid( t, c + 1, 1 )
                Next
                ; ***
                Break
              EndIf
            Next
          EndIf
        EndIf
      EndIf
    EndIf
  EndIf
  ; ***
  *daten\comment = com
  *daten\stringi = stg
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Beim Eintritt auf die neue Zeile wird dieser leer geräumt, wenn sie keine
; Tokens enthalten darf, weil sie eigentlich leer ist
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure clear_new_line(*daten.struct_pure_multiline_code_editor)
  Protected p.i
  ; ***
  *daten\length = 19999
  ; ***
  For p = 0 To *daten\length
    *daten\strom[p]\char = ""
    ; ***
    *daten\strom[p]\color = 0
    *daten\strom[p]\pos = 0
    ; ***
    If *daten\strom[p]\char = ""
      Break
    EndIf
  Next
  ; ***
  *daten\strom[0]\char = ""
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Threadspezifisch, leert den Rest einer Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure clear_current_line(*daten.struct_pure_multiline_code_editor)
  Protected p.i
  ; ***
  For p = *daten\length To 19999
    *daten\strom[p]\color = 0
    *daten\strom[p]\char = ""
    *daten\strom[p]\pos = 0
  Next
  ; ***
  If IsThread(*daten)
    KillThread(*daten)
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Ermittelt die aktuell angesteuerte Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure allocate_current_line(*daten.struct_pure_multiline_code_editor)
  Protected p.i, s.s
  ; ***
  *threaded_current_line = *daten
  ; ***
  *daten\strom[0]\color = 0
  *daten\strom[0]\char = ""
  *daten\strom[0]\pos = 0
  ; ***
  *daten\strom[1]\color = 0
  *daten\strom[1]\char = ""
  *daten\strom[1]\pos = 0
  ; ***
  *daten\strom[2]\color = 0
  *daten\strom[2]\char = ""
  *daten\strom[2]\pos = 0
  ; ***
  If *daten\content\lines()
    *daten\index = *daten\position + *daten\toplimit
    ; ***
    *daten\length = Len(s)
    ; ***
    If IsThread(*daten)
      KillThread(*daten)
    EndIf
    ; ***
    CreateThread( @clear_current_line(), *daten )
    ; ***
    If *daten\index >= 0 And *daten\index < *daten\content\lines()
      s = *daten\content\get(*daten\index)
      ; ***
      If Trim(s)
        *daten\length = 19999
        ; ***
        For p = 1 To *daten\length
          If p <= Len(s)
            *daten\strom[p]\char = Mid( s, p, 1 )
          Else
            *daten\strom[p]\char = ""
          EndIf
          ; ***
          *daten\strom[p]\color = 0
          *daten\strom[p]\pos = 0
          ; ***
          If p > Len(s)
            If *daten\strom[p]\char = ""
              Break
            EndIf
          EndIf
        Next
        ; ***
        *daten\strom[0]\char = ""
        ; ***
        *daten\length = Len(s) + 1
        ; ***
        update_current_syntax( *daten )
      Else
        *daten\cursor = 1
        *daten\length = 0
        ; ***
        *daten\strom[0]\color = 0
        *daten\strom[0]\char = ""
        *daten\strom[0]\pos = 0
      EndIf
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Geht zu einer Zeile
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure goto_current_line(*daten.struct_pure_multiline_code_editor,w.i,h.i,currentUpdate.a=#False)
  Protected ww.d, hh.i
  ; ***
  If *daten\index >= 0
    If *daten\index < *daten\content\lines()
      *daten\position = *daten\index - *daten\toplimit
      ; ***
;Debug Str(*daten\position) + ":" + Str(*daten\index) + " > " + *daten\content\get(*daten\index)
      allocate_current_line( *daten )
      ; ***
      If IsImage( *daten\visbkg ) > 0
        CopyImage( *daten\visbkg, *daten\tmpbkg )
      EndIf
      ; ***
      If *daten\justdraw = 0
        *daten\justdraw = 1
        ; ***
        If CreateImage( *daten\visbkg, w, h, 32, #PB_Image_Transparent ) And 
           StartDrawing( ImageOutput( *daten\visbkg ) )
          ; ***
          DrawingMode( #PB_2DDrawing_AlphaBlend )
          ; ***
          If IsFont(100):DrawingFont(FontID(100)):EndIf
          ; ***
          If IsImage( *daten\tmpbkg )
            DrawAlphaImage( ImageID( *daten\tmpbkg ), 0, 0 )
          EndIf
          ; ***
          DrawingMode( #PB_2DDrawing_AlphaChannel )
          ; ***
          Box( 0, TextHeight("A") * *daten\position, w, TextHeight("A"), RGBA(0,0,0,0) )
          ; ***
          StopDrawing()
          ; ***
          CopyImage( *daten\visbkg, *daten\tmpbkg )
          ; ***
          If currentUpdate
            ww = 0
            ; ***
            If CreateImage( *daten\curlin, w, 100, 32, #PB_Image_Transparent ) And 
               StartDrawing( ImageOutput( *daten\curlin ) )
              If IsFont(100):DrawingFont(FontID(100)):EndIf
              ; ***
              hh = TextHeight("A")
              ; ***
              StopDrawing()
            EndIf
            ; ***
            If CreateImage( *daten\curlin, w, hh, 32, #PB_Image_Transparent ) And 
               StartDrawing( ImageOutput( *daten\curlin ) )
              DrawingMode( #PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend )
              ; ***
              If IsFont(100):DrawingFont(FontID(100)):EndIf
              ; ***
              For p = 0 To *daten\length ;- 1
                DrawText( ww, 0, *daten\strom[p]\char, opaque(*daten\strom[p]\color) )
                ; ***
                *daten\strom[p]\pos = ww : ww + TextWidth(*daten\strom[p]\char)
              Next
              ; ***
              StopDrawing()
            EndIf
          EndIf
          ; ***
          *daten\justdraw = 0
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Hintergrundbild zeichnen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure update_content(*daten.struct_pure_multiline_code_editor,id,w.i,h.i)
  Protected p.i, a.a = 0, tw.i
  ; ***
  If IsGadget(id)
    If *daten\condir <> 0
      allocate_current_line( *daten )
      ; ***
      If *daten\theight < 8
        *daten\theight = 8
      EndIf
      ; ***
      If CreateImage(*daten\curlin,w,*daten\theight) And StartDrawing(ImageOutput(*daten\curlin))
        Box( 0, 0, w, h, $FFFFFF ) ; VORÜBRGEHEND
        ; ***
        If IsFont(100)
          DrawingFont( FontID(100) )
        EndIf
        ; ***
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        If evt = #PB_EventType_Input
          *daten\theight = TextHeight("A")
          ; ***
          *daten\vislimit = (h / *daten\theight) - 1
          ; ***
          If *daten\vislimit <= 0
            *daten\vislimit = 1
          EndIf
        EndIf
        ; ***
        For p = 0 To *daten\length -1
          If p = 0
            DrawText( 0, 0, *daten\strom[p]\char, *daten\strom[p]\color )
          Else
            DrawText( tw, 0, *daten\strom[p]\char, *daten\strom[p]\color )
          EndIf
          ; ***
          tw + TextWidth(*daten\strom[p]\char)
        Next
        ; ***
        StopDrawing()
      EndIf
    EndIf
    ; ***
    If IsImage(*daten\visbkg)
      a = 1
      CopyImage( *daten\visbkg, *daten\tmpbkg )
    EndIf
    ; ***
    If CreateImage(*daten\visbkg,w,h) And StartDrawing(ImageOutput(*daten\visbkg))
      If a = 0
        ; Es wird das erste Mal gezeichnet, deshalb kommt auch der
        ; vollständige Hintergrund gleich mit
        Box( 0, 0, w, h, *daten\color_bkg )
      EndIf
      ; ***
      Select *daten\condir
        Case 0 ; Normal
          If a = 1
            If IsImage(*daten\tmpbkg)
              DrawImage( ImageID(*daten\tmpbkg), 0, 0 )
            EndIf
          EndIf
          ; ***
          If IsImage(*daten\curlin)
            DrawImage( ImageID(*daten\curlin), 0, *daten\position * *daten\theight )
          EndIf
        Case 1 ; Rauf
          If a = 1
            If IsImage(*daten\tmpbkg)
              DrawImage( ImageID(*daten\tmpbkg), 0, *daten\theight )
            EndIf
          EndIf
          ; ***
          If IsImage(*daten\curlin)
            DrawImage( ImageID(*daten\curlin), 0, 0 )
          EndIf
        Case 2 ; Runter
          If a = 1
            If IsImage(*daten\tmpbkg)
              DrawImage( ImageID(*daten\tmpbkg), 0, - *daten\theight )
            EndIf
          EndIf
          ; ***
          If IsImage(*daten\curlin)
            DrawImage( ImageID(*daten\curlin), 0, h - *daten\theight )
          EndIf
      EndSelect
      ; ***
      *daten\condir = 0
      ; ***
      StopDrawing()
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Aktuelle Zeile in ein echtes String umwandeln
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure.s getInputStringLine(*daten.struct_pure_multiline_code_editor)
  Protected p.i, s.s
  ; ***
  For p = 0 To *daten\length
    s + *daten\strom[p]\char
  Next
  ; ***
  ProcedureReturn s
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Markierungsfeldumfeld leeren
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure clearImageArea(*daten.struct_pure_multiline_code_editor,id,w,h)
  Protected mmx.i
  ; ***
  y = *daten\markstart + *daten\toplimit
  h = *daten\markclose + *daten\toplimit
  ; ***
  x = *daten\markCursorFrom
  w = *daten\markCursorInto
  ; ***
Debug "Y: " + Str(y) + " | H: " + Str(h) + " | X: " + Str(x) + " | W: " + Str(w)
  If IsGadget(id)
    If StartDrawing(ImageOutput(*daten\visbkg))
      If IsFont(100)
        DrawingFont( FontID(100) )
      EndIf
      ; ***
      mmx = ImageWidth(*daten\visbkg) - (*daten\markCursorInto - *daten\markCursorFrom)
      ; ***
      Box( ImageWidth(*daten\tempor) + 6 + *daten\markCursorFrom, *daten\markstart * *daten\theight, w - mmx, (*daten\markclose - *daten\markstart) * *daten\theight, *daten\color_bkg )
      ; ***
      StopDrawing()
    EndIf
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Markierungsstart und Richtungskorrektur setzen, sobald die Markierung
; mittels Tastatur durchgeführt wird
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

Procedure setKeyMarkStart(key.i, *daten.struct_pure_multiline_code_editor)
  Protected p.i, tww.i, cc.i = *daten\cursor
  ; ***
  Select key
    Case #pure_keycode_left
      cc + 1
    Case #pure_keycode_right
      cc - 1
  EndSelect
  ; ***
  If StartDrawing(ImageOutput(*daten\curlin))
    If IsFont(100)
      DrawingFont( FontID(100) )
    EndIf
    ; ***
    DrawingMode( #PB_2DDrawing_Transparent )
    ; ***
    For p = 0 To 19999
      If cc = p
        Break
      EndIf
      ; ***
      *daten\markpos = p
      *daten\markCursorFrom = tww
      ; ***
      If *daten\strom[p]\char
        tww + TextWidth(*daten\strom[p]\char)
      Else
        tww + TextWidth(" ")
      EndIf
    Next
    ; ***
    StopDrawing()
    ; ***
    *daten\marklen = *daten\markpos
    *daten\markCursorInto = *daten\markCursorFrom
    ; ***
;Debug Str(*daten\markpos) + " -> " + Str(*daten\markCursorFrom)
    *daten\mark = #True
    *daten\markmode = #False
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Realisiert den Syntax-Editor, samt Eingabe und Maus-Events
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
  #ControlUpMore = #PB_Canvas_Command
CompilerElse
  #ControlUpMore = #PB_Canvas_Control
CompilerEndIf

Procedure update(*daten.struct_pure_multiline_code_editor,id.i,evt.i,key.i,inp.i,mx.i,my.i)
  If IsGadget(id)
    Protected w.i, h.i, p.i, n.i, tw.d, cc.s, du.a = #False, sb.a = #False, top.i, pos.i
    Protected tt.i, tx.s, ti.i, m.i, tww.d, mmx.i, emi.a = 0, gi.i, gu.i, tps.s = "", dd.d
    Protected tix.i, tiy.i, tiw.i, tih.i
    ; ***
    w = GadgetWidth(id)
    h = GadgetHeight(id)
    ; ***
    Select evt
      Case #PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown, #PB_EventType_MiddleButtonDown
        ;{
        mmx = -90000
        ; ***
        *daten\markdif = 0
        ; ***
        If *daten\mark = #True
          tix = ImageWidth(*daten\tempor) + 6 + *daten\markCursorFrom
          tiy = *daten\markstart * *daten\theight
          tiw = w - ImageWidth(*daten\visbkg) - (*daten\markCursorInto - *daten\markCursorFrom)
          tih = (*daten\markclose - *daten\markstart) * *daten\theight
          ; ***
          ;Box( ImageWidth(*daten\tempor) + 6 + *daten\markCursorFrom, *daten\markstart * *daten\theight, w - mmx, (*daten\markclose - *daten\markstart) * *daten\theight, *daten\color_marked_bkg )
          If mx >= tix And mx <= tix + tiw And my >= tiy And my <= tiy + tih
            ; nix
          Else
            *daten\mark = #False
            *daten\markmode = #False
          EndIf
        EndIf
        ; ***
        For m = 0 To *daten\vislimit
          If my >= ( m * *daten\theight ) And my <= ( m * *daten\theight ) + *daten\theight
            *daten\index = *daten\position + *daten\toplimit
            ; ***
            update_current_syntax(*daten)
            ; ***
            update_content( *daten, id, w, h )
            ; ***
            *daten\content\set( *daten\index, getInputStringLine(*daten) )
            ; ***
            *daten\position = m
            ; ***
            *daten\index = *daten\position + *daten\toplimit
            ; ***
            allocate_current_line( *daten )
            ; ***
            mmx = mx - ImageWidth(*daten\tempor)
            ; ***
            If mmx < 0
              *daten\cursor = 1
            Else
              If StartDrawing(ImageOutput(*daten\curlin))
                If IsFont(100)
                  DrawingFont( FontID(100) )
                EndIf
                ; ***
                DrawingMode( #PB_2DDrawing_Transparent )
                ; ***
                For p = 0 To *daten\length -1
                  If mmx >= tww And mmx <= tww + TextWidth(*daten\strom[p]\char)
                    *daten\cursor = p
                    ; ***
                    emi = 1
                    ; ***
                    *daten\markCursorFrom = tww
                    ; ***
                    *daten\markpos = p
                    ; ***
                    Break
                  EndIf
                  ; ***
                  tww + TextWidth(*daten\strom[p]\char)
                Next
                ; ***
                StopDrawing()
                ; ***
                If emi = 0
                  *daten\cursor = *daten\length
                EndIf
              EndIf
            EndIf
            ; ***
            du = #True
            ; ***
            Break
          EndIf
        Next
        ; ***
        If mx <= ImageWidth(*daten\tempor)
          *daten\markpos = 0
          *daten\marklen = 19999
          *daten\markCursorFrom = 0
          *daten\markCursorInto = ImageWidth(*daten\visbkg) - ImageWidth(*daten\tempor) - 6
        EndIf
        ; ***
        If mmx <> -90000
          If evt = #PB_EventType_LeftButtonDown
            *daten\mark = #True
            ; ***
            *daten\markrel = *daten\position
            *daten\markrow = *daten\index
            ; ***
            *daten\markstart = *daten\markrel
            *daten\markclose = *daten\markrel
          EndIf
        EndIf
        ;}
      Case #PB_EventType_LeftButtonUp
        ;{
        *daten\markmode = #True
        ProcedureReturn
        ;}
      Case #PB_EventType_MouseMove
        ;{
        If *daten\mark = #True And *daten\markmode = #False
          mmx = mx - ImageWidth(*daten\tempor) : tww = 0
          ; ***
          If StartDrawing(ImageOutput(*daten\curlin))
            If IsFont(100)
              DrawingFont( FontID(100) )
            EndIf
            ; ***
            DrawingMode( #PB_2DDrawing_Transparent )
            ; ***
            For p = 0 To 19999
              If tww >= w - ImageWidth(*daten\tempor)
                Break
              EndIf
              ; ***
              If mmx >= tww And mmx <= tww + TextWidth(*daten\strom[p]\char)
                *daten\markCursorInto = tww
                ; ***
                *daten\marklen = p
                ; ***
                Break
              EndIf
              ; ***
              If *daten\strom[p]\char
                tww + TextWidth(*daten\strom[p]\char)
              Else
                tww + TextWidth(" ")
              EndIf
            Next
            ; ***
            StopDrawing()
          EndIf
          ; ***
          mmx = -90000
          ; ***
          tww = 0
          ; ***
          For m = 0 To *daten\vislimit
            If my >= ( m * *daten\theight ) And my <= ( m * *daten\theight ) + *daten\theight
              mmx = m
              ; ***
              Break
            EndIf
          Next
          ; ***
          If mmx <> -90000
            If mmx >= *daten\markrel
              *daten\markstart = *daten\markrel
              *daten\markclose = mmx + 1
            Else
              *daten\markstart = mmx
              *daten\markclose = *daten\markrel + 1
            EndIf
          EndIf
        Else
          ProcedureReturn
        EndIf
        ;}
      Case #PB_EventType_MouseWheel
        ;{
        
        ;}
      Case #PB_EventType_Input
        ;{
        If Not GetGadgetAttribute(id, #PB_Canvas_Modifiers) & #ControlUpMore
        If inp = 32 Or inp = 9 Or inp = 10 Or inp = 13
          If *daten\curlen
            If *daten\curpos >= 0 And *daten\curpos < *daten\length
              cc = ""
              ; ***
              update_current_token( *daten, *daten\curpos, *daten\curlen )
            EndIf
          EndIf
          ; ***
          *daten\curpos = *daten\cursor + 1
          *daten\curlen = 0
        ElseIf inp <> 32 And inp <> 9
          *daten\curlen + 1
        EndIf
        ; ***
        If *daten\cursor = 0
          If *daten\length
            p = *daten\length
            ; ***
            If p >= 0 And p < 20000
              Repeat
                *daten\strom[p+1]\char = *daten\strom[p]\char
                *daten\strom[p+1]\color = *daten\strom[p]\color
                *daten\strom[p]\color = 0
                ; ***
                p - 1
              Until p = 0
            EndIf
          EndIf
          ; ***
          *daten\strom[0]\char = Chr(inp)
        ElseIf *daten\cursor = *daten\length
          *daten\strom[*daten\cursor]\char = Chr(inp)
        Else
          p = *daten\length
          ; ***
          Repeat
            If p >= 0 And p <= 19998
              *daten\strom[p+1]\char = *daten\strom[p]\char
              *daten\strom[p+1]\color = *daten\strom[p]\color
            Else
              Break
            EndIf
            ; ***
            p - 1
          Until p = *daten\cursor -1
          ; ***
          *daten\strom[*daten\cursor]\char = Chr(inp)
          *daten\strom[*daten\cursor]\color = 0
        EndIf
        ; ***
        *daten\cursor + 1
        *daten\length + 1
        ; ***
        *daten\cursorDisplay = #True
        ; ***
        update_current_syntax(*daten)
        ; ***
        *daten\mark = #False
        *daten\markmode = #False
        ; ***
        *daten\markrel = *daten\position
        *daten\markrow = *daten\index
        ; ***
        *daten\markstart = *daten\markrel
        *daten\markclose = *daten\markrel
        ; ***
        du = #True
        EndIf
        ;}
      Case #PB_EventType_KeyUp
        ;{
        If *daten\intellivis = #False
          If *daten\mark = #True
            *daten\markmode = #True
            ; ***
            *daten\markdif = 1
            ; ***
            ;*daten\markrel = *daten\position
            ;*daten\markrow = *daten\index
            ; ***
            *daten\markstart = *daten\markrel
            *daten\markclose = *daten\markrel + 1
            ; ***
            *daten\index = *daten\position + *daten\toplimit
            ; ***
            update_current_syntax(*daten)
            ; ***
            update_content( *daten, id, w, h )
            ; ***
            *daten\content\set( *daten\index, getInputStringLine(*daten) )
          EndIf
        EndIf
        ;}
      Case #PB_EventType_KeyDown
        Select key
          Case #pure_keycode_tabbed
            ;{
            If *daten\cursor < 19998 - 1
              *daten\length + 1
              *daten\cursor + 1
              *daten\strom[*daten\cursor]\char = " "
              *daten\strom[*daten\cursor]\color = 0
              *daten\strom[*daten\cursor]\pos = 0
              ; ***
              If *daten\cursor < 19998 - 1
                *daten\length + 1
                *daten\cursor + 1
                *daten\strom[*daten\cursor]\char = " "
                *daten\strom[*daten\cursor]\color = 0
                *daten\strom[*daten\cursor]\pos = 0
                ; ***
                If *daten\cursor < 19998 - 1
                  *daten\length + 1
                  *daten\cursor + 1
                  *daten\strom[*daten\cursor]\char = " "
                  *daten\strom[*daten\cursor]\color = 0
                  *daten\strom[*daten\cursor]\pos = 0
                  ; ***
                  SetActiveGadget( id )
                  ; ***
                  du = #True
                EndIf
              EndIf
            EndIf
            ;}
          Case #pure_keycode_pos
            *daten\cursor = 1
          Case #pure_keycode_end
            *daten\cursor = *daten\length
          Case #pure_keycode_up
            ;{
            If *daten\intellivis = #False
              If *daten\position = 0 And *daten\toplimit = 0
                ProcedureReturn
              EndIf
              ; ***
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              update_current_syntax(*daten)
              ; ***
              update_content( *daten, id, w, h )
              ; ***
              *daten\content\set( *daten\index, getInputStringLine(*daten) )
              ; ***
              *daten\position - 1
              ; ***
              If *daten\position < 0
                *daten\toplimit - 1
                *daten\position = 0
                ; ***
                If *daten\toplimit < 0
                  *daten\toplimit = 0
                EndIf
                ; ***
                *daten\condir = 1
                update_content( *daten, id, w, h )
                ; ***
                sb = #True
              EndIf
              ; ***
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              allocate_current_line( *daten )
              ; ***
              If *daten\movetolast = #True
                *daten\movetolast = #False
                ; ***
                *daten\cursor = *daten\length
              EndIf
              ; ***
              du = #True
            Else
              *daten\intellicur - 1
              ; ***
              If *daten\intellicur < 0
                *daten\intellicur = 0
              EndIf
            EndIf
            ;}
          Case #pure_keycode_enter, #pure_keycode_down
            ;{
            If *daten\intellivis = #False
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              update_current_syntax(*daten)
              ; ***
              update_content( *daten, id, w, h )
              ; ***
              *daten\content\set( *daten\index, getInputStringLine(*daten) )
              ; ***
              If *daten\index > *daten\content\lines() -2
                If key = #pure_keycode_down
                  ProcedureReturn
                EndIf
              EndIf
              ; ***
              *daten\position + 1
              ; ***
              If *daten\position > *daten\vislimit
                *daten\toplimit + 1
                ; ***
                If *daten\toplimit > *daten\content\length() - 1 - *daten\vislimit
                  *daten\toplimit = *daten\content\length() - 1 - *daten\vislimit
                  *daten\position = *daten\vislimit
                Else
                  *daten\position - 1
                EndIf
                ; ***
                *daten\condir = 2
                update_content( *daten, id, w, h )
                ; ***
                sb = #True
              EndIf
              ; ***
              *daten\index = *daten\position + *daten\toplimit
              ; ***
              du = #True
              ; ***
              If key = #pure_keycode_enter
                *daten\content\add(" ")
                ; ***
                *daten\cursor = 1
              ElseIf key = #pure_keycode_down
                If *daten\index > *daten\content\length() - 1
                  *daten\index = *daten\content\length() - 1
                  *daten\toplimit = *daten\content\length() - *daten\vislimit
                  *daten\position = *daten\index - *daten\toplimit
                EndIf
              EndIf
              ; ***
              allocate_current_line( *daten )
            Else
              If key = #pure_keycode_enter
                If *daten\intellimar
                  tps + " "
                EndIf
                ; ***
                tps + *daten\intellitok
                ; ***
                *daten\intellivis = 12
                ; ***
                *daten\intellitok = ""
                ; ***
                *daten\index = *daten\position + *daten\toplimit
                ; ***
                *daten\content\set( *daten\index, getInputStringLine(*daten) + tps )
                ; ***
                *daten\cursor + Len(tps)
                *daten\length + Len(tps)
                ; ***
                allocate_current_line( *daten )
                ; ***
                update_current_syntax(*daten)
                ; ***
                update_content( *daten, id, w, h )
                ; ***
                du = #True
              ElseIf key = #pure_keycode_down
                *daten\intellicur + 1
                ; ***
                If *daten\intellicur > *daten\intellitot -1
                  *daten\intellicur = *daten\intellitot -1
                EndIf
              EndIf
            EndIf
            ;}
          Case #pure_keycode_delete
            ;{
            If *daten\cursor = 0
              ; Rauf auf die obere Zeile oder ignorieren
            ElseIf *daten\cursor = *daten\length
              *daten\strom[*daten\cursor]\char = ""
              *daten\strom[*daten\cursor]\color = 0
              *daten\strom[*daten\cursor]\pos = 0
              *daten\cursor -1
              *daten\length -1
            Else
              For p = *daten\cursor To *daten\length
                *daten\strom[p-1]\char = *daten\strom[p]\char
                *daten\strom[p-1]\color = *daten\strom[p]\color
                *daten\strom[p-1]\pos = *daten\strom[p]\pos
              Next
              ; ***
              *daten\strom[*daten\length]\char = ""
              *daten\strom[*daten\length]\color = 0
              *daten\strom[*daten\length]\pos = 0
              ; ***
              *daten\cursor -1
              *daten\length -1
            EndIf
            ; ***
            If *daten\cursor = 1
              If *daten\length <= 1
                *daten\strom[0]\char = ""
                *daten\strom[0]\color = 0
                *daten\strom[0]\pos = 0
              EndIf
            EndIf
            ; ***
            du = #True
            ;}
          Case #pure_keycode_left
            ;{
            If *daten\intellivis = #False
              If *daten\cursor <= 1
                *daten\movetolast = #True
                update(*daten,id,#PB_EventType_KeyDown,#pure_keycode_up,0,0,0)
                ProcedureReturn
              Else
                *daten\cursor - 1
                ; ***
                If *daten\cursor < 0
                  *daten\cursor = 0
                EndIf
                ; ***
                *daten\curpos = *daten\cursor
                ; ***
                du = #True
              EndIf
              ; ***
              ;setKeyMarkStart(*daten)
            Else
              *daten\intellivis = 12
            EndIf
            ;}
          Case #pure_keycode_right
            ;{
            If *daten\intellivis = #False
              If *daten\cursor = *daten\length
                update(*daten,id,#PB_EventType_KeyDown,#pure_keycode_down,0,0,0)
                ProcedureReturn
              Else
                *daten\cursor + 1
                ; ***
                If *daten\cursor > *daten\length
                  *daten\cursor = *daten\length
                EndIf
                ; ***
                *daten\curpos = *daten\cursor
                ; ***
                du = #True
              EndIf
              ; ***
              ;setKeyMarkStart(*daten)
            Else
              *daten\intellivis = 12
            EndIf
            ;}
          Case #pure_keycode_escape, #pure_keycode_space
            ;{
            If *daten\intellivis = #True
              *daten\intellivis = 12
            EndIf
            ;}
        EndSelect
        ; ***
        If GetGadgetAttribute(id, #PB_Canvas_Modifiers) & #ControlUpMore
          Select key
            Case Asc("c"), Asc("C") ; Kopieren
              ClearClipboard()
              SetClipboardText(getMarkedText(*daten))
            Case Asc("x"), Asc("X") ; Schneiden
              ClearClipboard()
              SetClipboardText(getMarkedText(*daten))
              clearMarkedText(*daten)
              clearImageArea(*daten,id,w,h)
            Case Asc("v"), Asc("V") ; Einfügen
              Debug "Paste"
            Case Asc("a"), Asc("A") ; Alles markieren
              Debug "Select all"
          EndSelect
        ElseIf GetGadgetAttribute(id, #PB_Canvas_Modifiers) & #PB_Canvas_Shift
          tww = 0
          ; ***
          Select key
            Case #pure_keycode_up
              If *daten\mark = #True
                *daten\markstart - 1
                ; ***
                If *daten\markstart < 0
                  *daten\markstart = 0
                Else
                  *daten\markclose = *daten\markrel + 1
                  ; ***
                  If *daten\markclose > *daten\vislimit
                    *daten\markclose = *daten\vislimit
                  EndIf
                EndIf
              EndIf
            Case #pure_keycode_down
              If *daten\mark = #True
                *daten\markclose + 1
                ; ***
                If *daten\markclose > *daten\vislimit
                  *daten\markclose = *daten\vislimit
                Else
                  *daten\markstart = *daten\markrel
                  ; ***
                  If *daten\markstart < 0
                    *daten\markstart = 0
                  EndIf
                EndIf
              EndIf
            Case #pure_keycode_left, #pure_keycode_right
              If *daten\mark = #False
                setKeyMarkStart(key,*daten)
                ; ***
                *daten\markrel = *daten\position
                *daten\markrow = *daten\index
              Else;If *daten\mark = #True And *daten\markmode = #False
                If StartDrawing(ImageOutput(*daten\curlin))
                  If IsFont(100)
                    DrawingFont( FontID(100) )
                  EndIf
                  ; ***
                  DrawingMode( #PB_2DDrawing_Transparent )
                  ; ***
                  For p = 0 To 19999
                    If tww >= w - ImageWidth(*daten\tempor)
                      Break
                    EndIf
                    ; ***
                    If *daten\cursor = p
                      Break
                    EndIf
                    ; ***
                    *daten\marklen = p
                    *daten\markCursorInto = tww
                    ; ***
                    If *daten\strom[p]\char
                      tww + TextWidth(*daten\strom[p]\char)
                    Else
                      tww + TextWidth(" ")
                    EndIf
                  Next
                  ; ***
                  StopDrawing()
                EndIf
              EndIf
          EndSelect
          ; ***
          tww = 0
        Else
          *daten\mark = #False
          *daten\markmode = #False
        EndIf
    EndSelect
    ; ***
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; Cursor korrigieren
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; ***
    ;{
    If *daten\cursor <= 0
      *daten\cursor = 1
    EndIf
    ; ***
    If *daten\length < *daten\cursor
      *daten\length = *daten\cursor
    EndIf
    ;}
    ; ***
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; Zeilennummernblock
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; ***
    ;{
    If *daten\theight = 0
      sb = #True
    EndIf
    ; ***
    If sb
      du = #True
      ; ***
      If CreateImage(*daten\tempor,w,h) And StartDrawing(ImageOutput(*daten\tempor))
        If IsFont(100)
          DrawingFont( FontID(100) )
        EndIf
        ; ***
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        *daten\theight = TextHeight("A")
        ; ***
        *daten\vislimit = (h / *daten\theight) - 1
        ; ***
        If *daten\vislimit <= 0
          *daten\vislimit = 1
        EndIf
        ; ***
        ti = TextWidth(Str(*daten\content\lines())) + 60
        ; ***
        StopDrawing()
      EndIf
      ; ***
      If CreateImage(*daten\tempor,ti,h) And StartDrawing(ImageOutput(*daten\tempor))
        If IsFont(100)
          DrawingFont( FontID(100) )
        EndIf
        ; ***
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        Box( 0, 0, ti, h, *daten\color_number_block_bkg )
        ; ***
        For n = 0 To *daten\vislimit + 2
          tx = Str(n + *daten\toplimit + 1)
          ; ***
          DrawText( ti - 50 - TextWidth(tx), n * *daten\theight, tx, *daten\color_number_block_txt )
        Next
        ; ***
        StopDrawing()
      EndIf
    EndIf
    ;}
    ; ***
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; Aktuelle Zeile zeichnen
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; ***
    ;{
    If du
      *daten\lastkey = ""
      ; ***
      If CreateImage(*daten\curlin,w,*daten\theight) And StartDrawing(ImageOutput(*daten\curlin))
        Box( 0, 0, w, h, $FFFFFF ) ; VORÜBRGEHEND
        ; ***
        If IsFont(100)
          DrawingFont( FontID(100) )
        EndIf
        ; ***
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        If evt = #PB_EventType_Input
          *daten\theight = TextHeight("A")
          ; ***
          *daten\vislimit = (h / *daten\theight) - 1
          ; ***
          If *daten\vislimit <= 0
            *daten\vislimit = 1
          EndIf
        EndIf
        ; ***
        For p = 0 To *daten\length -1
          If p = 0
            DrawText( 0, 0, *daten\strom[p]\char, *daten\strom[p]\color )
          Else
            DrawText( tw, 0, *daten\strom[p]\char, *daten\strom[p]\color )
          EndIf
          ; ***
          If *daten\strom[p]\char = " "
            *daten\lastkey = ""
          Else
            *daten\lastkey + *daten\strom[p]\char
          EndIf
          ; ***
          *daten\strom[p]\pos = tw
          ; ***
          tw + TextWidth(*daten\strom[p]\char)
          ; ***
          If p = *daten\cursor -1
            pos = tw
          EndIf
        Next
        ; ***
        StopDrawing()
      EndIf
    EndIf
    ;}
    ; ***
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; CanvasGadget aktualisieren
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
    ; ***
    ;{
    top = *daten\position * *daten\theight
    ; ***
    If du
      *daten\curstate = pos + ImageWidth(*daten\tempor) + 6
    EndIf
    ; ***
    If StartDrawing(CanvasOutput(id))
      ;{ Abbilder für die Darstellung
      Box( 0, 0, w, h, *daten\color_bkg )
      ; ***
      If IsFont(100)
        DrawingFont( FontID(100) )
      EndIf
      ; ***
      If IsImage(*daten\tempor)
        DrawImage( ImageID(*daten\tempor), 0, 0 )
      EndIf
      ; ***
      If IsImage(*daten\visbkg)
        DrawImage( ImageID(*daten\visbkg), ImageWidth(*daten\tempor) + 6, 0 )
      EndIf
      ; ***
      If IsImage(*daten\curlin)
        DrawImage( ImageID(*daten\curlin), ImageWidth(*daten\tempor) + 6, top )
      EndIf
      ; ***
      If *daten\cursorDisplay; And *daten\intellivis = #False
        Box( *daten\curstate, top, 2, *daten\theight, 0 )
      EndIf
      ; ***
      Box( ImageWidth(*daten\tempor) - 50 + 4, top, 46, *daten\theight, *daten\color_number_block_active )
      ;}
      ; ***
      ;{ Markierung zeichnen
      DrawingMode( #PB_2DDrawing_Transparent )
      ; ***
      If *daten\mark = #True
        If *daten\markstart * *daten\theight - (*daten\markclose - *daten\markstart) * *daten\theight <> 6
          Box( ImageWidth(*daten\tempor) - 50 + 4, *daten\markstart * *daten\theight, 46, (*daten\markclose - *daten\markstart) * *daten\theight, *daten\color_number_block_active )
          ; ***
          DrawingMode( #PB_2DDrawing_AlphaBlend )
          ; ***
          mmx = ImageWidth(*daten\visbkg) - (*daten\markCursorInto - *daten\markCursorFrom)
          ; ***
          Box( ImageWidth(*daten\tempor) + 6 + *daten\markCursorFrom, *daten\markstart * *daten\theight, w - mmx, (*daten\markclose - *daten\markstart) * *daten\theight, *daten\color_marked_bkg )
          ; ***
          DrawingMode( #PB_2DDrawing_Outlined )
          ; ***
          Box( ImageWidth(*daten\tempor) + 6 + *daten\markCursorFrom, *daten\markstart * *daten\theight, w - mmx, (*daten\markclose - *daten\markstart) * *daten\theight, *daten\color_marked_border )
        EndIf
      EndIf
      ;}
      ; ***
      ;{ Cursor
      Box( ImageWidth(*daten\tempor), 0, 6, h, *daten\color_bkg )
      ;}
      ; ***
      ; DIESEN PART IN EIN THREAD AUSLAGERN!!!
      ;{ Intellisence*
      If *daten\intellivis = 12
        *daten\intellivis = #False
      ElseIf evt = #PB_EventType_KeyDown Or *daten\intellivis = #True
        If key = 46 Or *daten\intellivis = #True Or TLCase(*daten\lastkey) = "belirle" Or TLCase(*daten\lastkey) = "dizilim" Or TLCase(*daten\lastkey) = "değişken"
          If *daten\intellivis = #False
            *daten\intellivis = #True
            *daten\intellicur = 0
          EndIf
          ; ***
          If *daten\lastkey And *daten\intellisence And *daten\comment = 0 And *daten\stringi = 0
            For p = 0 To *daten\intellisence\cnt -1
              For x = 0 To *daten\intellisence\lst[p]\groupkeys\lines() -1
                If Trim(TLCase(*daten\intellisence\lst[p]\groupkeys\get(x))) = Trim(TLCase(*daten\lastkey))
                  *daten\intelliLastWidth = *daten\intellisence\lst[p]\width + 16
                  ; ***
                  If *daten\curstate + *daten\intelliLastWidth > w
                    *daten\curstate = w - *daten\intelliLastWidth
                  EndIf
                  ; ***
                  If top > h - (4 * *daten\theight) - 16
                    top = h - (4 * *daten\theight) - 16
                  EndIf
                  ; ***
                  Box( *daten\curstate + 10, top, *daten\intellisence\lst[p]\width + 6, (4 * *daten\theight) + 6, *daten\color_intelli_background )
                  ; ***
                  DrawingMode( #PB_2DDrawing_Outlined )
                  ; ***
                  Box( *daten\curstate + 10, top, *daten\intellisence\lst[p]\width + 5, (4 * *daten\theight) + 5, *daten\color_intelli_dborder )
                  Box( *daten\curstate + 10 + 1, top + 1, *daten\intellisence\lst[p]\width + 5, (4 * *daten\theight) + 5, *daten\color_intelli_lborder )
                  Box( *daten\curstate + 10, top, *daten\intellisence\lst[p]\width + 6, (4 * *daten\theight) + 6, *daten\color_intelli_border )
                  ; ***
                  DrawingMode( #PB_2DDrawing_Transparent )
                  ; ***
                  m = 0
                  ; ***
                  *daten\intellimar = *daten\intellisence\lst[p]\space
                  ; ***
                  *daten\intellitot = *daten\intellisence\lst[p]\content\lines()
                  ; ***
                  ti = *daten\intellicur
                  ; ***
                  If ti > *daten\intellitot - 4
                    ti = *daten\intellitot - 4
                  EndIf
                  ; ***
                  For n = ti To ti + 3
                    If n = *daten\intellicur
                      Box( *daten\curstate + 13, top + 3 + (m * *daten\theight), *daten\intellisence\lst[p]\width, *daten\theight, *daten\color_intelli_sel_bkg )
                      DrawText( *daten\curstate + 10 + 6, top + 3 + (m * *daten\theight), *daten\intellisence\lst[p]\content\get(n), *daten\color_intelli_sel_txt )
                      *daten\intellitok = *daten\intellisence\lst[p]\content\get(n)
                    Else
                      DrawText( *daten\curstate + 10 + 6, top + 3 + (m * *daten\theight), *daten\intellisence\lst[p]\content\get(n), *daten\color_intelli_text )
                    EndIf
                    m + 1
                  Next
                  ; ***
                  Break
                EndIf
              Next
            Next
          EndIf
        EndIf
      EndIf
      ;}
      ; ***
      StopDrawing()
    EndIf
    ;}
  EndIf
EndProcedure

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;
; Test
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

ExamineDesktops()
OpenWindow(#fenster,0,0,800,700,"Eingabe",
           #PB_Window_SystemMenu|#PB_Window_Invisible)
CanvasGadget(#feld,0,0,800,700,#PB_Canvas_Keyboard)
SetActiveGadget(#feld)
ResizeWindow(#fenster,DesktopWidth(0)-800,
             DesktopHeight(0)-800,800,700)
StickyWindow(#fenster,1)
HideWindow(#fenster,0)
AddWindowTimer(#fenster,#fenster,400)

Global ib.struct_intellisence_list
; ***
ib\cnt = 0

keyw.editor_dataset = editor_dataset()
mich.struct_pure_multiline_code_editor

mich\intellisence = ib

mich\content = editor_dataset()
For vi = 0 To 99
  mich\content\add( "" )
Next

mich\color_comment = RGB( 147, 133, 148 )
mich\color_string = RGB( 106, 144, 166 )
mich\color_number = RGB( 204, 51, 153 )
mich\color_operator = RGB( 170, 148, 84 );RGB( 153, 51, 255 );RGB( 118, 92, 163 )
mich\color_bkg = RGB( 255, 255, 255 )
mich\color_selbkg = RGB( 238, 238, 238 )
mich\color_errorbkg = RGB( 239, 207, 203 )
mich\color_number_block_active = RGB( 228, 228, 228 )
mich\color_number_block_bkg = RGB( 238, 238, 238 );RGB( 154, 149, 166 );RGB( 137, 121, 158 );RGB( 98, 62, 133 )
mich\color_number_block_txt = RGB( 154, 149, 166 );RGB(255,255,255)

mich\color_intelli_background = RGB( 238, 238, 238 )
mich\color_intelli_border = RGB(140,150,160)
mich\color_intelli_lborder = RGB(245,248,251)
mich\color_intelli_dborder = RGB(160,170,180)
mich\color_intelli_text = 0
mich\color_intelli_sel_bkg = RGB( 0, 153, 204 )
mich\color_intelli_sel_txt = RGB( 243, 255, 255 )

mich\color_marked_border = RGB( 0, 153, 204 )
mich\color_marked_bkg = RGBA( 0, 153, 204, 20 )

mich\intellivis = #False

c = RGB( 51, 153, 204 );RGB( 36, 134, 255 )
keyw\add( "Define", c )
keyw\add( "Global", c )
keyw\add( "Protected", c )
keyw\add( "Static", c )
keyw\add( "Threaded", c )
keyw\add( "ElseIf", c )
keyw\add( "Else", c )
keyw\add( "EndIf", c )
keyw\add( "If", c )
keyw\add( "ForEach", c )
keyw\add( "For", c )
keyw\add( "Next", c )
keyw\add( "Break", c )
keyw\add( "Repeat", c )
keyw\add( "Forever", c )
keyw\add( "Until", c )
keyw\add( "EndProcedure", c )
keyw\add( "Procedure", c )
keyw\add( "EndInterface", c )
keyw\add( "Interface", c )
keyw\add( "EndStructure", c )
keyw\add( "Structure", c )
keyw\add( "ReDim", c )
keyw\add( "Dim", c )
keyw\add( "XIncludeFile", c )
keyw\add( "IncludeFile", c )
keyw\add( "Debug", c )
keyw\add( "CompilerElseIf", c )
keyw\add( "CompilerElse", c )
keyw\add( "CompilerIf", c )
keyw\add( "CompilerEndIf", c )
keyw\add( "And", c )
keyw\add( "Not", c )
keyw\add( "Or", c )
keyw\add( "CompilerEndSelect", c )
keyw\add( "CompilerCase", c )
keyw\add( "CompilerDefault", c )
keyw\add( "CompilerSelect", c )
keyw\add( "EndSelect", c )
keyw\add( "Case", c )
keyw\add( "Default", c )
keyw\add( "Select", c )
; ***
c = RGB( 102, 102, 153 )
keyw\add( "Len", c )
keyw\add( "Mid", c )
keyw\add( "Left", c )
keyw\add( "Right", c )
keyw\add( "Trim", c )
keyw\add( "LTrim", c )
keyw\add( "RTrim", c )
keyw\add( "ReplaceString", c )
keyw\add( "FindString", c )
keyw\add( "CountString", c )
keyw\add( "ReverseString", c )
keyw\add( "LCase", c )
keyw\add( "UCase", c )
keyw\add( "StrD", c )
keyw\add( "StrF", c )
keyw\add( "Str", c )
keyw\add( "ValD", c )
keyw\add( "ValF", c )
keyw\add( "Val", c )
keyw\add( "RunProgram", c )
keyw\add( "Delay", c )
keyw\add( "OpenWindow", c )
keyw\add( "ButtonGadget", c )
keyw\add( "ButtonImageGadget", c )
keyw\add( "CheckBoxGadget", c )
keyw\add( "OptionGadget", c )
keyw\add( "CanvasGadget", c )
keyw\add( "ImageGadget", c )
keyw\add( "PanelGadget", c )
keyw\add( "TreeGadget", c )
keyw\add( "ListViewGadget", c )
keyw\add( "ListIconGadget", c )
keyw\add( "SpinGadget", c )
keyw\add( "SplitterGadget", c )
keyw\add( "WebGadget", c )
keyw\add( "StringGadget", c )
keyw\add( "TextGadget", c )
keyw\add( "ComboBoxGadget", c )
keyw\add( "DateGadget", c )
keyw\add( "CalenderGadget", c )
; ***
c = RGB( 154, 71, 193 )
keyw\add( "PB_Compiler_OS", c )
keyw\add( "PB_OS_MacOS", c )
keyw\add( "PB_OS_Linux", c )
keyw\add( "PB_OS_Windows", c )
keyw\add( "PB_Event_Gadget", c )
keyw\add( "PB_Event_CloseWindow", c )
keyw\add( "PB_Event_SizeWindow", c )
keyw\add( "PB_Event_MoveWindow", c )
keyw\add( "PB_Event_MaximizeWindow", c )
keyw\add( "PB_Event_MinimizeWindow", c )
keyw\add( "True", c )
keyw\add( "False", c )
keyw\add( "PB_Any", c )
keyw\add( "PB_Ignore", c )

mich\comment_char = ";"
mich\string_char = Chr(34)
mich\double_separator = "."
mich\keywords = keyw
mich\visbkg = 10
mich\tmpbkg = 11
mich\curlin = 12
mich\tempor = 13

update(mich,#feld,0,0,0,0,0)

Repeat
  ev.i = WaitWindowEvent()
  ; ***
  If ev = #PB_Event_CloseWindow
    ;For r = 0 To mich\content\lines() -1
      ;Debug Str(r) + ":" + Str(r+1) + " >> " + mich\content\get(r)
    ;Next
  EndIf
  ; ***
  If ev = #PB_Event_Timer And EventTimer() = #fenster
    Select mich\cursorDisplay
      Case 0 : mich\cursorDisplay = 1
      Case 1 : mich\cursorDisplay = 0
    EndSelect
    ; ***
    update(mich,#feld,0,0,0,0,0)
  EndIf
  ; ***
  If ev = #PB_Event_Gadget And EventGadget() = #feld
    Select EventType()
      Case #PB_EventType_Input, #PB_EventType_KeyDown, #PB_EventType_KeyUp,
           #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp,
           #PB_EventType_RightButtonUp, #PB_EventType_MouseMove,
           #PB_EventType_MouseWheel
        update(mich,#feld,EventType(),
               GetGadgetAttribute(#feld,#PB_Canvas_Key),
               GetGadgetAttribute(#feld,#PB_Canvas_Input),
               GetGadgetAttribute(#feld,#PB_Canvas_MouseX),
               GetGadgetAttribute(#feld,#PB_Canvas_MouseY))
    EndSelect
  EndIf
Until ev = #PB_Event_CloseWindow

End
; IDE Options = PureBasic 5.60 (MacOS X - x86)
; CursorPosition = 2976
; FirstLine = 2944
; Folding = ------------
; EnableXP
