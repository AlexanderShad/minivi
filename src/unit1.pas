unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ExtDlgs,LCLType, PrintersDlgs, printers, process,FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    PrintDialog1: TPrintDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;


procedure load_picture(x : string);
procedure printing;
procedure setwlp;

implementation

{ TForm1 }

uses unit2;

procedure setwlp;
var _session,_e : string;
begin
  _session := GetEnvironmentVariable('XDG_SESSION_DESKTOP');
  Screen.Cursor := crHourGlass;
  form1.Image1.Picture.SaveToFile(GetEnvironmentVariable('HOME')+'/.config/background');
  try
    case UpperCase(_session) of
      'GNOME' :    begin
                     RunCommand('gsettings set org.gnome.desktop.background picture-uri file://'+GetEnvironmentVariable('HOME')+'/.config/background',_e);
                     RunCommand('gsettings set org.gnome.desktop.background picture-uri-dark file://'+GetEnvironmentVariable('HOME')+'/.config/background',_e);
                   end;
      'MATE' :     RunCommand('gsettings set org.mate.desktop.background picture-uri file://'+GetEnvironmentVariable('HOME')+'/.config/background',_e);
      'CINNAMON' : RunCommand('gsettings set org.cinnamon.desktop.background picture-uri file://'+GetEnvironmentVariable('HOME')+'/.config/background',_e);
      'XFCE' :     Showmessage('Sorry, not supported yet!');
      'plasma' :      Showmessage('Sorry, not supported yet!');
    end;
   Except
    showmessage(_e);
   end;
  Screen.Cursor := crDefault;
end;

procedure printing;
var _printer: TPrinter;
begin
 { if form1.PrintDialog1.Execute then
     begin
     end;
  }
end;

procedure load_picture(x : string);
begin
  if form1.BitBtn1.Visible then
   begin
     form1.BitBtn1.Visible:=false;
     form1.Image1.Visible:=true;
   end;
  form1.Image1.Picture.Clear;
  form1.Image1.AutoSize:=true;
  form1.Image1.Picture.LoadFromFile(x);
  form1.Caption:=x;
  if (form1.Image1.Picture.Height >= Screen.Height) or (form1.Image1.Picture.Width >= Screen.Width) then
   begin
     form1.Image1.AutoSize:=false;
     form1.Image1.Height := Screen.Height-50;
     form1.Image1.Width := Screen.Width-50;
   end;
  form1.Left:= (Screen.Width div 2)-(form1.Image1.Width div 2);
  form1.Top:= (Screen.Height div 2)- (form1.Image1.Height div 2);
  form1.Width:=form1.Image1.Width;
  form1.Height:=form1.Image1.Height;
  form1.Image1.Hint:=form1.Caption;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  form1.Image1.Left:=0;
  form1.Image1.Top:=0;
  form1.BitBtn1.Left:=0;
  form1.BitBtn1.Top:=0;
  if (paramcount >= 1) then
   begin
     form1.BitBtn1.Visible:=true;
     form1.Image1.Visible:=false;
     load_picture(paramStr(1));
   end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if form1.OpenPictureDialog1.Execute then //load picture from button
   load_picture(form1.OpenPictureDialog1.FileName);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (key = VK_ESCAPE) or (key = VK_Q) or ((ssctrl in shift) and (key = VK_Q)) then //close application
   form1.close;
  if ((ssctrl in shift) and (key = VK_O)) or (key = VK_O) then //loading new picture
    if form1.OpenPictureDialog1.Execute then
       load_picture(form1.OpenPictureDialog1.FileName);
  if ((ssctrl in shift) and (key = VK_P)) or (key = VK_P) then //printing picture
   printing;
  if key = VK_W then //desktop picture
   if MessageDlg('Question', 'Set background wallpaper?', mtConfirmation, [mbYes, mbNo],0) = mrYes then setwlp;
  if (key = VK_DELETE) or (key = VK_D) then //desktop picture
   if MessageDlg('Question', 'Delete this picture?', mtConfirmation, [mbYes, mbNo],0) = mrYes then begin DeleteFile(form1.Caption); form1.Close; end;
  if key = VK_F1 then //help
   form2.ShowModal;
end;

initialization
  {$I unit1.lrs}

end.

