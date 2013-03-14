  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 ' 6802 Master Version 0.06 Alpha
 ' (c) Greg Fordyce 2013 - 11 Mar
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Cls

SetPin 11, 8   ' Charger relay on pin 11
CellSelect = 0  ' highlight selected cell
'''''''''''''''' CONFIGURATION VARIABLES '''''''''''''''''''''''''''''''''
CellNo = 48

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Mode 4
Print @(25,100) "6802 Master Version 0.06 Alpha"

Pause 3000

Dim barval(CellNo)
Dim cellV(CellNo)
Cls
LoadBMP "SCREEN.BMP"

 ' parameters for the bar graphs
height = 100
margin = 45
width = MM.HRes - margin
bx = margin : by = MM.VRes-5
dx = bx : dy = by

Open "COM1:9600" As #1  ' Slave bus on TX, Master bus on RX
'Open "COM2:19200" As #2 ' Cougar controller

Print #1,Chr$(200);   ' Read cell voltage register

Main:
Do
    If Loc(#1) >= 50 THEN CellV
'    If Loc(#2) >= 67 Then CougarRTD
'    If Loc(#2) >= 67 Then RTD
  keypress$ = inkey$  'read keyboard press
  If keypress$= "1" Then Pin(11) = 1   ' Start charging
  If keypress$= "S" Then SaveBMP "image1.bmp"
  if keypress$ = chr$(131) then RightArrow
  If keypress$ = CHR$(130) then LeftArrow

Loop
'  Data string format from controller
'  "TR=xxx CR=xxx CF=xxx PW=xxx HS=xxxx RT=xxxx FB=xx BA=xxx AH=xxx.x\r\n"
'     TR-throttle CR-current reference CF-current feedback PW-PWM HS-heatsink
'     RT-raw throttle FB-fault bits BA-battery amps AH-amp hours

Sub CougarRTD  ' Get data from controller 
        local x, rtd$
        RTD$ = Input$(200,#2)
            x = 1
            Do
                If Mid$(rtd$,x,3) = "CF=" Then
                    MtrAmps = Val(Mid$(rtd$,(x+3),3))
                    BatAmps = Val(Mid$(rtd$,(x+39),3))
                    AmpHour = Val(Mid$(rtd$,(x+46),5))
                    HeatSnk = Val(Mid$(rtd$,(x+17),3))
                    FaultBt = Val(Mid$(rtd$,(x+33),2))
                    Exit
                Else
                    x = x + 1

                EndIf
            Loop
        Print @(25,15)Format$(mtramps,"%3.0f")
        Print @(35,15)Format$(batamps,"%3.0f")
        Print @(45,15)Format$(AmpHour,"%5.1f")
        Print @(55,15)Format$(heatsnk,"%4.0f")
        Print @(65,15)Format$(faultBt,"%2.0f")

end sub


Sub RTD  ' Get data from controller 
  local x, rtd$
  RTD$ = Input$(200,#2)
    x = 1
    Do
      If Mid$(rtd$,x,3) = "CF=" Then
        Print @(25,15) Mid$(rtd$,(x+3),3)
        Print @(35,15) Mid$(rtd$,(x+39),3)
        Print @(45,15) Mid$(rtd$,(x+46),5)
        Print @(55,15) Mid$(rtd$,(x+17),3)
        Print @(65,15) Mid$(rtd$,(x+33),2)
        Exit
      Else
        x = x + 1
      EndIf
    Loop
end sub




sub CellV
    Local i, arg$, x$, j
    For i = 1 To CellNo
         arg$ = ""                        ' clear ready for data
            Do                            ' loops until a specific exit
               x$ = Input$(1, #1)         ' get the character
               If x$ = "," Then Exit      ' new data field, increment i
               arg$ = arg$ + x$           ' add to the data
            Loop                          ' loop back for the next char
          CellV(i) = Val( arg$ )
          CellV(i) = CellV(i) / 100
        Next i                             ' move to the next data field
    close #1
    HiV=0 : LoV=5 : PackV=0
        For I = 1 To CellNo
            If CellV(I) < LoV Then
            LoV = CellV(I) : LoCell = I : EndIf
            If CellV(I) > HiV Then
            HiV = CellV(I) : HiCell = I : EndIf
            PackV = PackV + CellV(I)
        Next i

    If hiv > 3.65 Then Pin(11) = 0

    Locate 0,0
    ''''''''''' Display cell and pack values ''''''''''
    Print Format$(PackV," Pack %4.1fV   ")
    Print @(191,0) Time$
    Print @(27,130)Format$(HiCell,"%2.0f")
    Print @(15,144)Format$(HiV,"%3.2f")
    Print @(27,160)Format$(LoCell,"%2.0f")
    Print @(15,174)Format$(LoV,"%3.2f")
    if CellSelect = 0 then
      line(22,188)-(42,199),0,bf
      line(3,201)-(42,212),0,bf
    else
      Print @(27,188)Format$(CellSelect,"%2.0f")
      Print @(15,201)Format$(CellV(CellSelect),"%3.2f")
    endif
        ''''''''''draw the bar graphs''''''''''

    For j = 1 To CellNo
        barclr = 2  'set color to green
        If cellv(j) > 3.59 Or cellv(j) < 2.5 Then barclr = 6    'yellow
        If cellv(j) > 3.65 Or Cellv(j) < 2.3 Then barclr = 4    'red
        If j = CellSelect then barclr = 5  'Selected cell color purple
         barval(j) = (cellV(J)-2)*50
         st = 4*(j - 1) + bx
         Line(st,by)-(st+2,by-barval(j)),barclr,bf
         Line (st,by-barval(j))-(st+2,by-height),0,bf
    Next j
    Open "com1:9600" as #1
    Print #1,Chr$(202);   ' Read current sensor
    Pause 15
    arg$ = ""                        ' clear ready for data
        Do                           ' loops until a specific exit
            x$ = Input$(1, #1)        ' get the character
            If x$ = "," Then Exit     ' new data field, increment i
            arg$ = arg$ + x$          ' add to the data
        Loop                         ' loop back for the next char
    close #1
    Amps = Val( arg$ )
    Amps = amps - 506
    Amps = amps / 10
    Print @(15,15)Format$(Amps,"%3.1f")
    Open "COM1:9600" As #1  ' Slave bus on TX, Master bus on RX
    Print #1,Chr$(200);   ' Read cell voltage register
end sub

sub RightArrow
  CellSelect = CellSelect + 1
  if CellSelect > CellNo then CellSelect = 0
end sub

sub LeftArrow
  CellSelect = CellSelect - 1
  if CellSelect < 0 then CellSelect = 0
end sub
