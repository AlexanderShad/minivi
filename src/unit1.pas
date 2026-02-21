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
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  tiling, flag_try : Boolean;


procedure load_picture(x : string; y : byte; z : string);
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
  image_file := FindAllFiles(path, '*.png;*.xpm;*.bmp;*.cur;*.ico;*.icns;*.jpeg;*.jpg;*.jpe;*.jfif;*.tif;*.tiff;*.gif;*.pbm;*.pgm;*.ppm;*.webp', false);
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
    'left': load_picture(_left,0,'');
    'right': load_picture(_right,0,'');
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

procedure load_picture(x : string; y : byte; z : string);
var _temp_name,_e : string;
begin
  tiling:=false;
  if form1.BitBtn1.Visible then
   begin
     form1.BitBtn1.Visible:=false;
     form1.Image1.Visible:=true;
   end;
  form1.Image1.Picture.Clear;
  form1.Image1.AutoSize:=true;
  try
    form1.Image1.Picture.LoadFromFile(x);
    if y = 0 then form1.Caption:=x else form1.Caption:=z;
    if (form1.Image1.Picture.Height >= Screen.Height) or (form1.Image1.Picture.Width >= Screen.Width) then
     begin
      form1.Image1.AutoSize:=false;
      form1.Image1.Width := Screen.Width-1;
      form1.Image1.Height := Screen.Height-1;
     end;
    form1.Left:= (Screen.Width div 2)-(form1.Image1.Width div 2);
    form1.Top:= (Screen.Height div 2)-(form1.Image1.Height div 2);
    form1.Width:=form1.Image1.Width;
    form1.Height:=form1.Image1.Height;
    form1.Image1.Hint:=form1.Caption;
    form1.Image1.Left:= (form1.Width div 2)-(form1.Image1.Width div 2);
    form1.Image1.Top:= (form1.Height div 2)- (form1.Image1.Height div 2);
    if y = 1 then begin DeleteFile(x); flag_try := false; end;
  Except
    if flag_try then
     begin
       ShowMessage('File upload error -1!');
       form1.Close;
     end
    else
     begin
       flag_try := true;
       if ((UpperCase(ExtractFileExt(x)) = '.JPG') or (UpperCase(ExtractFileExt(x)) = '.JPEG')) then
         _temp_name := x+'.png';
       if UpperCase(ExtractFileExt(x)) = '.PNG' then
         _temp_name := x+'.jpg';
       if UpperCase(ExtractFileExt(x)) = '.WEBP' then
        begin
         _temp_name := x+'.png';
         try
          RunCommand('dwebp '+x+' -o '+_temp_name,_e);
         Except
          showmessage(_e);
         end;
        end;
       if UpperCase(ExtractFileExt(x)) = '.WEBP' then
        load_picture(_temp_name,1,x)
       else
        if CopyFile(x,_temp_name) then
         begin
          load_picture(_temp_name,1,x);
         end
        else
         begin
          ShowMessage('File upload error -2!');
          form1.Close;
         end;
     end;
  end;
  tiling:=true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  form1.Image1.Left:=0;
  form1.Image1.Top:=0;
  form1.BitBtn1.Left:=0;
  form1.BitBtn1.Top:=0;
  flag_try := false;
  if (paramcount >= 1) then
   begin
     form1.BitBtn1.Visible:=true;
     form1.Image1.Visible:=false;
     load_picture(paramStr(1),0,'');
   end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  form1.Label1.Visible:=true;
  if form1.OpenPictureDialog1.Execute then //load picture from button
    load_picture(form1.OpenPictureDialog1.FileName,0,'');
  form1.Label1.Visible:=false;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (key = VK_ESCAPE) or (key = VK_Q) or ((ssctrl in shift) and (key = VK_Q)) then //close application
   form1.close;
  if ((ssctrl in shift) and (key = VK_O)) or (key = VK_O) then //loading new picture
   begin
    form1.Label1.Visible:=true;
    if form1.OpenPictureDialog1.Execute then
       load_picture(form1.OpenPictureDialog1.FileName,0,'');
    form1.Label1.Visible:=false;
   end;
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

procedure TForm1.FormResize(Sender: TObject);
begin
  if tiling then
   begin
    form1.Image1.AutoSize:=false;
    form1.Image1.Width:=form1.Width;
    form1.Image1.Height:=form1.Height;
   end;
end;

initialization
  {$I unit1.lrs}

end.

