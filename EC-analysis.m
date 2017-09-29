function [  ] = Paramterabfrage(Name, Projekt, YYYY, Ru, Strom, Spannung, pH, C )

%Part 1 des Programms: Ziel der Auswertung

%----- Beginn und Löschen des Workspaces ------

clear all

%----- Experimentator und Projekt für Dokumentation festlegen ----

Name=input('Geben Sie Ihren Namen an und drücken Sie anschließend [ENTER]\n','s');
Projekt=input('Geben Sie Ihren Projekt (z.B. Bachelorarbeit) an und drücken Sie anschließend [ENTER]\n','s');

YYYY = sprintf('Sie haben sich als %s im Projekt "%s" angemeldet. \n',Name ,Projekt);
disp(YYYY)

%---- Ziel der Auswertung -----

%fprintf(['Geben Sie das Ziel der Auswertung an und drücken [ENTER] \n1. Zyklen	\n2.XXX\n') 
%Ziel=input('');
%index{1}=Ziel;

%----- Part 2 des Programms: Parameterabfrage -----

fprintf('Parameterabfrage zum Versuchsaufbau und zur Auswertung\n')

fprintf('Geben Sie den Zellenaufbau an \n 1.Teflon-Zelle\n 2.Glas-Zelle\n 3.hermetische Zelle\n')
Zellen=input('')
    switch Zellen
        case 1
           Zelle=('Teflon')
        case 2
           Zelle=('Glas') 
        case 3
            Zelle=('Hermetisch')  
    end
   
fprintf('Geben Sie den Referenzelektrode(typ)an\n 1.RHE\n 2.SCE\n')
Referenz=input('')
  switch Referenz
        case 1
           Ref=('RHE')
        case 2
           Ref=('SCE')  
    end

Ru=input('Bitte geben Sie den Ru an und drücken [ENTER]\n')

Ae=input('Geben Sie den Elektrodenfläche an und drücken [ENTER]\n')

Material=input('Geben Sie das Elektrodenmaterial an und drücken Sie [ENTER]\n','s')

Ar=input('Geben Sie die Ringfläche an und drücken [ENTER]\n')

pH=input('Geben Sie den pH-Wert an und drücken [ENTER]\n')

Elektrolyt=input('Geben Sie den Elektrolyten an (z.B. 0.1M KOH Ar-purged) und drücken Sie [ENTER]\n','s')

Vorschub=input('Geben Sie die Vorschubsgeschwindigkeit an und drücken [ENTER]\n')

rpm=input('Geben Sie die Rotationsrate (RPM) an und drücken [ENTER]\n')

Kommentar=input('Hier können Sie einen zusätzlichen Kommentar eingeben und drücken Sie anschließend [ENTER]\n','s')


%----- Standardwerte als Konstanten hier definierenieren ------

Konstante=0.98; %Konstannte addieren für RHE

%-----Part2: Einlesen Dateipfad ------
[filename, pathname] = uigetfile('*.crv', 'Dateiauswahl: Origalys Datei Import','Z:\Auswertung','MultiSelect', 'on');
if isequal(filename, 0)
 disp('Anwender hat die Funktion abgebrochen')
 else
 disp(['Anwender hat folgende Datei ausgewählt ', fullfile(pathname, filename)])
 end 
index{1}=char(filename);

%----- Einlesen der Datei -------
Dateiname = fopen([pathname index{1}]);
heading = textscan(Dateiname,'%s %s %s',10);
fgetl(Dateiname); 
data = textscan(Dateiname,'%n %n %n');

%----- Daten die entsprechenden Variablen zuweisen------
Spannung=data{1,1}; %Spannung
Strom=data{1,2}; %Strom
%Zeit=data{1,3}; %Zeit

%----- Zyklenzahl ermitteln -------
Zyklus=max(Spannung) 

%----- Berechnung ------
Impedanzabziehen=Spannung-Strom*Ru; %Ru abziehen

W=Impedanzabziehen+Konstante; %Konstante für RHE addieren

Norm=Strom/Ae; %Normierung auf Oberfläche

Interpolation=interpn(Norm,W,'linear');
%Interpolation=rot90(Interpolation1);%Array Drehung

Anzahl=numel(Interpolation)
m=Anzahl*0.002+1.42-0.002;

range=[1.42:0.002:m]; %Range der gewünschte Spannung

%---- Plot Rohdaten+ Interpoliert ----
S=figure
subplot(2,1,1);
plot(Spannung,Strom)

subplot(2,1,2);
plot(range,Interpolation)

Y=figure
subplot(2,2,1);
plot(Spannung,Strom,'b');
title('Rohdaten')

subplot(2,2,2);
plot(range,Interpolation,'g');
title('Interpoliert')

subplot(2,2,[3,4]);
plot(Spannung,Strom,'b',range,Interpolation,'g');
title('gemeinsame Darstellung')

range1=rot90(range);
Interpolation1=rot90(Interpolation);

%----- Speicherung der (Roh)Daten als .mat und .txt und der Plots als pdf----

save('Auswertung','Strom', 'Spannung', 'Zelle', 'Interpolation', 'range', 'Ru', 'Vorschub', 'Ae', 'Ar', 'pH', 'Kommentar', 'rpm', 'Material', 'Norm', 'Elektrolyt');

save('Spannung.txt','Spannung','-ascii');
type('Spannung.txt'); 
save('Strom.txt','Strom','-ascii');
type('Strom.txt');
save('Interpolation.txt','Interpolation1','-ascii');
type('Interpolation.txt');
save('Range.txt','range1','-ascii');
type('Range.txt');

fid = fopen('Parameter.txt','wt');
fprintf(fid, 'Experiment durchgeführt von %s im Rahmen des Projekts %s. \nZellenaufbau: %s \nReferenzelektrode: %s \nElektrolyt: %s \nElektrodenmaterial: %s \npH-Wert: %s \nElektrodenfläche: %s \n', Name, Projekt, Zelle, Ref, Elektrolyt, Material, pH, Ae);
fprintf(fid, 'Ringfläche: %s \nRotationsrate: %s \nVorschubgeschwindigkeit: %s \nRu: %s \nKommentar: %s', Ar, rpm, Vorschub, Ru, Kommentar)
fclose(fid)

print(Y,'-dpdf','-r1200','Plot.pdf');

disp(['Auswertung beendet']);
end

 