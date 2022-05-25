    include \masm32\include\masm32rt.inc
    include \masm32\include\dialogs.inc
     
    dlgproc PROTO :DWORD,:DWORD,:DWORD,:DWORD
    GetTextDialog PROTO :DWORD,:DWORD

.data?
      hInstance dd ?   
.data
       frm db " Result: %d",13,10

       mytitle  db 0            
.code

start:
    mov hInstance, rv(GetModuleHandle,NULL)
    call main
    invoke ExitProcess,eax


main proc

    LOCAL ptxt  :DWORD     ;variable declaration
    LOCAL hIcon :DWORD

    invoke InitCommonControls   ;this will initialize the common controls

    mov hIcon, rv(LoadIcon,hInstance,10)

    mov ptxt, rv(GetTextDialog," ACLC WINDOWS APPLICATION"," Enter firstnum ")

    .if ptxt != 0
      fn MessageBox,0,ptxt,"Title",MB_OK
    .endif

    invoke GlobalFree,ptxt

    ret

main endp


GetTextDialog proc dgltxt:DWORD,grptxt:DWORD

    LOCAL arg1[4]:DWORD
    LOCAL parg  :DWORD

    lea eax, arg1
    mov parg, eax

  ; ---------------------------------------
  ; load the array with the stack arguments
  ; ---------------------------------------
    mov ecx, dgltxt
    mov [eax], ecx
    mov ecx, grptxt
    mov [eax+4], ecx
 
    Dialog "Get User Text", \               ; caption
           "Arial",8, \                     ; font,pointsize
            WS_OVERLAPPED or \              ; styles for
            WS_SYSMENU or DS_CENTER, \      ; dialog window
            6, \                            ; number of controls
            50,50,162,170, \                ; x y co-ordinates
            4096                            ; memory buffer size
    ;Элементы управления количество должно совпадать с 63 строкой;
    DlgGroup  " Enter firstnum ",8,4,140,31,300
    DlgEdit   ES_LEFT or WS_BORDER or WS_TABSTOP,17,16,121,11,301

    DlgGroup  " Enter secondnum ",8,40,140,31,302
    DlgEdit   ES_LEFT or WS_BORDER or WS_TABSTOP,17,52,121,11,303

    DlgButton "Calck",WS_TABSTOP,8,120,70,13,IDOK
    DlgButton "Close",WS_TABSTOP,92,120,55,13,IDCANCEL

    CallModalDialog hInstance,0,dlgproc,parg

    ret

GetTextDialog endp

dlgproc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

;Локальные переменные на стеке;
    LOCAL tlen  :DWORD
    LOCAL num1  :DWORD
    LOCAL num2  :DWORD
    LOCAL result  :DWORD
    LOCAL buffer[260]:BYTE



    switch uMsg
      case WM_INITDIALOG
      ; -------------------------------------------------
      ; get the arguments from the array passed in lParam
      ; -------------------------------------------------
        push esi
        mov esi, lParam
        fn SetWindowText,hWin,[esi]                         ; title text address
        fn SetWindowText,rv(GetDlgItem,hWin,300),[esi+4]    ; groupbox text
      
        xor eax, eax
        ret

      case WM_COMMAND
        switch wParam
          case IDOK

               mov tlen, rv(GetWindowTextLength,rv(GetDlgItem,hWin,301));301 - команда 1 textbox;
            .if tlen == 0
              invoke SetFocus,rv(GetDlgItem,hWin,301)
              ret
            .endif
            add tlen, 1
            mov num1, alloc(tlen)
            fn GetWindowText,rv(GetDlgItem,hWin,301),num1,tlen

               mov tlen, rv(GetWindowTextLength,rv(GetDlgItem,hWin,303));303 - команда 2 textbox;
            .if tlen == 0
              invoke SetFocus,rv(GetDlgItem,hWin,303)
              ret
            .endif
            add tlen, 1
            mov num2, alloc(tlen)
            fn GetWindowText,rv(GetDlgItem,hWin,303),num2,tlen

            invoke atol, num1        
            mov num1,eax

            invoke atol, num2 
            mov num2,eax

            mov eax, num1
            mov edx, num2
            add eax, edx
            mov result, eax
            

            invoke wsprintf, addr buffer,addr frm, result

                ; show Results             
              invoke MessageBox,0, addr buffer, addr mytitle, MB_OK
     
          case IDCANCEL
            invoke EndDialog,hWin,0
        endsw
      case WM_CLOSE
        invoke EndDialog,hWin,0
    endsw

    xor eax, eax
    ret

dlgproc endp

end start