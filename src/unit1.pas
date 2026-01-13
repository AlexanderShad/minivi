unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ExtDlgs, LCLType, PrintersDlgs, printers, StdCtrls, process,
  FileUtil, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
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
procedure setwlp;
procedure move_picture(x : string);

implementation

{ TForm1 }

uses unit2;

procedure move_picture(x : string);
var path, _left, _right : string;
    image_file : TStringList;
    i : integer;
begin
  form1.Label1.Visible:=true;
  path := ExtractFilePath(form1.Caption);
  image_file := FindAllFiles(path, '*.png;*.xpm;*.bmp;*.cur;*.ico;*.icns;*.jpeg;*.jpg;*.jpe;*.jfif;*.tif;*.tiff;*.gif;*.pbm;*.pgm;*.ppm', false);
  image_file.Sort;
  _left := '1';
  _right := '1';
  for i := 0 to image_file.Count-1 do
   begin
     if image_file.Strings[i] = form1.Caption then
      begin
        if i-1 < 0 then _left := '';
        if i+1 > image_file.Count-1 then _right := '';
        if _left <> '' then _left := image_file.Strings[i-1];
        if _right <> '' then _right := image_file.Strings[i+1];
        if _left = '' then _left := image_file.Strings[image_file.Count-1];
        if _right = '' then _right := image_file.Strings[0];
        break;
      end;
     Application.ProcessMessages;
   end;
  case x of
    'left': load_picture(_left);
    'right': load_picture(_right);
  end;
    form1.Label1.Visible:=false;
end;

procedure setwlp;
var _session,_e,metka : string;
    f : TIniFile;
begin
  _session := GetEnvironmentVariable('XDG_SESSION_DESKTOP');
  Screen.Cursor := crHourGlass;
  metka := '';
  if FileExists(GetEnvironmentVariable('HOME')+'/.config/minivi.cfg') then
   begin
     f := TIniFile.Create(GetEnvironmentVariable('HOME')+'/.config/minivi.cfg');
     metka := f.ReadString('metka','id','');
     if FileExists(GetEnvironmentVariable('HOME')+'/.config/background'+metka) then DeleteFile(GetEnvironmentVariable('HOME')+'/.config/background'+metka);
     f.Free;
   end
  else
   if FileExists(GetEnvironmentVariable('HOME')+'/.config/background') then DeleteFile(GetEnvironmentVariable('HOME')+'/.config/background');
  metka := DateToStr(Date)+TimeToStr(Time);
  f := TIniFile.Create(GetEnvironmentVariable('HOME')+'/.config/minivi.cfg');
  f.WriteString('metka','id',metka);
  f.Free;
  form1.Image1.Picture.SaveToFile(GetEnvironmentVariable('HOME')+'/.config/background'+metka);
  try
    case UpperCase(_session) of
      'GNOME' :    begin
                     RunCommand('gsettings set org.gnome.desktop.background picture-uri file://'+GetEnvironmentVariable('HOME')+'/.config/background'+metka,_e);
                     RunCommand('gsettings set org.gnome.desktop.background picture-uri-dark file://'+GetEnvironmentVariable('HOME')+'/.config/background'+metka,_e);
                   end;
      'MATE' :     RunCommand('gsettings set org.mate.desktop.background picture-uri file://'+GetEnvironmentVariable('HOME')+'/.config/background'+metka,_e);
      'CINNAMON' : RunCommand('gsettings set org.cinnamon.desktop.background picture-uri file://'+GetEnvironmentVariable('HOME')+'/.config/background'+metka,_e);
      'XFCE' :     Showmessage('Sorry, not supported yet!');
      'PLASMA' :   RunCommand('plasma-apply-wallpaperimage '+GetEnvironmentVariable('HOME')+'/.config/background'+metka,_e);
    end;
   Except
    showmessage(_e);
   end;
  Screen.Cursor := crDefault;
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
  try
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
  Except
    ShowMessage('File upload error!');
    form1.Close;
  end;
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
  if key = VK_W then //desktop picture
   if MessageDlg('Question', 'Set background wallpaper?', mtConfirmation, [mbYes, mbNo],0) = mrYes then setwlp;
  if (key = VK_DELETE) or (key = VK_D) then //desktop picture
   if MessageDlg('Question', 'Delete this picture?', mtConfirmation, [mbYes, mbNo],0) = mrYes then begin DeleteFile(form1.Caption); form1.Close; end;
  if key = VK_F1 then //help
   form2.ShowModal;
  if key = VK_RIGHT then //right image
    move_picture('right');
  if key = VK_LEFT then //left image
    move_picture('left');
end;

initialization
  {$I unit1.lrs}

end.

