unit Unit2;

{$mode ObjFPC}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, LCLType,
  StdCtrls,Clipbrd;

type

  { TForm2 }

  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{ TForm2 }

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
    if (key = VK_ESCAPE) or (key = VK_Q) or ((ssctrl in shift) and (key = VK_Q)) then //close application
   form2.close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  form2.Left:= (Screen.Width div 2)-(form2.Width div 2);
  form2.Top:= (Screen.Height div 2)- (form2.Height div 2);
end;

procedure TForm2.Label2Click(Sender: TObject);
begin
 Clipboard.AsText := 'https://github.com/AlexanderShad';
 showmessage('Copied to clipboard.');
end;

initialization
  {$I unit2.lrs}

end.

