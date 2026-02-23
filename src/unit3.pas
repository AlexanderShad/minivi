unit Unit3;

{$mode ObjFPC}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, LCLType,
  StdCtrls, Clipbrd;

type

  { TForm3 }

  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{ TForm3 }

uses unit1;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (key = VK_ESCAPE) or (key = VK_Q) or ((ssctrl in shift) and (key = VK_Q)) then //close application
 form3.close;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  form3.Label2.Caption:= ExtractFileName(form1.Caption);
  form3.Label6.Caption:= IntToStr(original_width)+'x'+IntToStr(original_height);
  form3.Label8.Caption:= FormatDateTime('dd.mm.yyyy hh:mm', FileDateToDateTime(FileAge(form1.Caption)));
  form3.Label4.Caption:= ExtractFilePath(form1.Caption);
end;

procedure TForm3.Label4Click(Sender: TObject);
begin
  Clipboard.AsText := form3.Label4.Caption;
  showmessage('Copied to clipboard.');
end;

initialization
  {$I unit3.lrs}

end.

