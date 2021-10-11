unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

const
 MaxT=256;
 TailleLettre=40;
 TableCouleur:array[0..6] of integer=
 ($000001,$000100,$010000,
  $000101,$010100,$010001,
  $010101);
 ModeStandby=0;
 ModeWait=1;
 ModeMove=2;
 ModeExplode=3;


const    //BONNE
         //ANNEE
 BonneAnnee:array[1..110] of tpoint=
 ((x:-10;y:0;),(x:-9;y:0;),             // B
  (x:-10;y:1;),(x:-8;y:1;),             // B
  (x:-10;y:2;),(x:-9;y:2;),             // B
  (x:-10;y:3;),(x:-8;y:3;),             // B
  (x:-10;y:4;),(x:-9;y:4;),             // B

  (x:-6;y:0;),(x:-5;y:0;),(x:-4;y:0;),  // O
  (x:-6;y:1;),(x:-4;y:1;),              // O
  (x:-6;y:2;),(x:-4;y:2;),              // O
  (x:-6;y:3;),(x:-4;y:3;),              // O
  (x:-6;y:4;),(x:-5;y:4;),(x:-4;y:4;),  // O

  (x:-2;y:0;),(x:1;y:0;),               // N
  (x:-2;y:1;),(x:-1;y:1;),(x:1;y:1;),   // N
  (x:-2;y:2;),(x: 0;y:2;),(x:1;y:2;),   // N
  (x:-2;y:3;),(x:1;y:3;),               // N
  (x:-2;y:4;),(x:1;y:4;),               // N

  (x:3;y:0;),(x:6;y:0;),                // N
  (x:3;y:1;),(x:4;y:1;),(x:6;y:1;),     // N
  (x:3;y:2;),(x:5;y:2;),(x:6;y:2;),     // N
  (x:3;y:3;),(x:6;y:3;),                // N
  (x:3;y:4;),(x:6;y:4;),                // N

  (x:8;y:0;),(x:9;y:0;),(x:10;y:0;),    // E
  (x:8;y:1;),                           // E
  (x:8;y:2;),(x:9;y:2;),                // E
  (x:8;y:3;),                           // E
  (x:8;y:4;),(x:9;y:4;),(x:10;y:4;),    // E


                (x:-09;y:07;),                // A
  (x:-10;y:08;),              (x:-08;y:08;),  // A
  (x:-10;y:09;),(x:-09;y:09;),(x:-08;y:09;),  // A
  (x:-10;y:10;),              (x:-08;y:10;),  // A
  (x:-10;y:11;),              (x:-08;y:11;),  // A

  (x:-06;y:07;),              (x:-03;y:07;),  // N
  (x:-06;y:08;),(x:-05;y:08;),(x:-03;y:08;),  // N
  (x:-06;y:09;),(x:-04;y:09;),(x:-03;y:09;),  // N
  (x:-06;y:10;),              (x:-03;y:10;),  // N
  (x:-06;y:11;),              (x:-03;y:11;),  // N

  (x:-01;y:07;),             (x:02;y:07;),    // N
  (x:-01;y:08;),(x:00;y:08;),(x:02;y:08;),    // N
  (x:-01;y:09;),(x:01;y:09;),(x:02;y:09;),    // N
  (x:-01;y:10;),             (x:02;y:10;),    // N
  (x:-01;y:11;),             (x:02;y:11;),    // N

  (x:4;y:07;),(x:5;y:07;),(x:6;y:07;),        // E
  (x:4;y:08;),                                // E
  (x:4;y:09;),(x:5;y:09;),                    // E
  (x:4;y:10;),                                // E
  (x:4;y:11;),(x:5;y:11;),(x:6;y:11;),        // E

  (x:8;y:07;),(x:9;y:07;),(x:10;y:07;),       // E
  (x:8;y:08;),                                // E
  (x:8;y:09;),(x:9;y:09;),                    // E
  (x:8;y:10;),                                // E
  (x:8;y:11;),(x:9;y:11;),(x:10;y:11;));      // E


  
type
 TExplosion=record vx,vy,px,py,cl:integer; end;

 TFeu=record temps:integer;
             mode:byte;
             color:integer;
             pos:tpoint;        // position courante
                                // équation paramétrique de la position
             ax,bx,cx:integer;  // Fx(t)=(ax*tt+bx*t)/cx
             xs,dx:integer;     // Fy(t)=xs+dx*t/maxt
             explosion:array[0..50] of TExplosion;
      end;


var
  Form1: TForm1;
  feu:array[1..300] of TFeu;

implementation

{$R *.dfm}

procedure NouveauFeu(var Feu:tfeu);
var
 b,t,tt:integer;
begin
 feu.temps:=MaxT-random(5*MaxT);
 if feu.temps>=0 then feu.mode:=ModeMove
                 else feu.mode:=ModeWait;
 feu.mode:=ModeMove;
 t:=MaxT;
 tt:=random(screen.Height-200)+200;
 b:=2*(t+random(t div 2)-t div 4);
 feu.ax:=tt;
 feu.bx:=-tt*b;
 feu.cx:=t*(t-b);
 feu.xs:=random(screen.Width);
 feu.dx:=random(screen.Width)-feu.xs;
 feu.color:=TableCouleur[random(6)];
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 i,b,t,tt:integer;
begin
 randomize;
 // création des lettres du message
 for i:=1 to 110 do
  begin
   feu[i].temps:=-MaxT+random(5);
   feu[i].mode:=ModeWait;
   t:=MaxT;
   tt:=screen.Height div 2-(BonneAnnee[i].Y-5)*TailleLettre;
   b:=2*(t+random(t div 2)-t div 4);
   feu[i].ax:=tt;
   feu[i].bx:=-tt*b;
   feu[i].cx:=t*(t-b);

   feu[i].xs:=random(screen.Width);
   feu[i].dx:=screen.Width div 2+BonneAnnee[i].X*TailleLettre-feu[i].xs;
   feu[i].color:=$010101;
  end;
 // le reste des feux d'artifices
 for i:=111 to 300 do nouveaufeu(feu[i]);
end;

procedure TForm1.TimerTimer(Sender: TObject);
var
 i,t,j,angle,veloc:integer;
begin
 for i:=1 to 300 do
  case feu[i].mode of
   ModeStandby:;// rien

   ModeWait:    //attend le décollage
    begin
     inc(feu[i].temps);
     if feu[i].temps=0 then feu[i].mode:=ModeMove;
    end;

   ModeMove:  // monte dans le ciel
    begin
     inc(feu[i].temps);
     t:=feu[i].temps;
     // nouvelle position de la fusée
     feu[i].pos.x:=feu[i].xs+feu[i].dx*t div MaxT;
     feu[i].pos.y:=(feu[i].ax*t*t + feu[i].bx*t) div feu[i].cx;
     // si le temps est venu, explosion
     if feu[i].temps=MaxT then
      begin
       // création des débris
       for j:=0 to 50 do
        begin
         angle:=random(360);
         veloc:=random(64);
         feu[i].explosion[j].vx:=round(cos(angle*pi/180)*veloc);
         feu[i].explosion[j].vy:=round(sin(angle*pi/180)*veloc);
         feu[i].explosion[j].px:=feu[i].pos.x*32;
         feu[i].explosion[j].py:=feu[i].pos.y*32;
        end;
       feu[i].mode:=ModeExplode;
       feu[i].temps:=255;
      end;
    end;

   ModeExplode:   // les débris retombent
    begin
     dec(feu[i].temps,2);
     if feu[i].temps<0 then nouveaufeu(feu[i])
     else
      begin
       for j:=0 to 50 do
        begin
         dec(feu[i].explosion[j].cl);
         dec(feu[i].explosion[j].vy);
         feu[i].explosion[j].px:=feu[i].explosion[j].px+feu[i].explosion[j].vx;
         feu[i].explosion[j].py:=feu[i].explosion[j].py+feu[i].explosion[j].vy;
         feu[i].explosion[j].cl:=feu[i].color*feu[i].temps;
        end;
      end;
   end;
  end;// end case;


 //affichage
 canvas.FillRect(clientrect);
 for i:=1 to 300 do
  case feu[i].mode of
   ModeStandby,ModeWait:;// rien
   ModeMove: canvas.Pixels[feu[i].pos.x,clientheight-feu[i].pos.y]:=feu[i].color*255;
   ModeExplode:
    for j:=0 to 50 do
      canvas.Pixels[feu[i].explosion[j].px div 32,clientheight-feu[i].explosion[j].py div 32]:=feu[i].explosion[j].cl;
  end;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
 close;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
 close;
end;

end.