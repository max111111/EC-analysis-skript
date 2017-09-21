
clear all
close all

%% Definiere Variablen

index = cell(1,25);
index_norm = cell(1,25);
raw = cell(2,2);
data = cell(8,12);


%% Auswahl der Auswertemethode

 fprintf(['Wählen der Messmethode \n' ...
     '1.	Single-Elektrode-Zyklen	\n' ...
     '2	Multi-Elektroden-Zyklen \n'])
 methode=input('');

index{22}=methode;

%% Einlesen der Dateipfade/Namen

[fnamecell,fpath] = uigetfile('*.dta','Gamry Datei Import','Z:mAsterarbeit\Elektrochemie\Testmessungen\','MultiSelect', 'on');     
index{1} = char(fnamecell);
index{23} = length(index{1}(:,1));

%% Einlesen der Index Daten
for f=1:index{23}                                                               %Scanne bei mutlipler Dateiabfrage 
  fileID = fopen([fpath index{1}(f,:)]);             
     
for i= 1:1000                                                                          %Scanne Zeilen innerhalb der f-ten Datei
    tline = fgetl(fileID);
    
% Disk or Ring
if length(tline)>10
    if fix(methode) == 1 
    if (tline(1:10) == 'AREA	QUANT');
        if str2num(tline(11:23)) == 0.1256
        index{2}(f) = true;
        index{3}(f) = false;
        end
        if str2num(tline(11:23)) == 0.18840
        index{2}(f) = false;
        index{3}(f) = true;
        end
    end
    end
end

% Disk and Ring
if fix(methode) == 2
    index{2}(f) = true;
    index{3}(f) = true;
end

end
end
fclose('all');

for f=1:index{23}                                                               %Scanne bei mutlipler Dateiabfrage 
  fileID = fopen([fpath index{1}(f,:)]);             
     
for i= 1:1000                                                                          %Scanne Zeilen innerhalb der f-ten Datei
    tline = fgetl(fileID);

% Elektrodenfläche Ring & Disk
index{6}(f) = .1256;   % in cm^2
index{7}(f) = .1884;   % in cm^2

% Potentialrate Ring & Disk
if fix(methode) == 1 && index{2}(f) == 0
if length(tline)>14
    if (tline(1:14) == 'SCANRATE	QUANT');
        index{10}(f)=0;
        index{11}(f)=str2num(tline(16:27));
    end
end
else
if length(tline)>14
    if (tline(1:14) == 'SCANRATE	QUANT');
        index{10}(f)=str2num(tline(16:27));
        index{11}(f)=0;
    end
end
end 

% Initial Potential & Final Potential

if length(tline)>11
    if (tline(1:11) == 'VINIT	POTEN');
        pot1(f)=str2num(tline(13:25));
    end
end 
if length(tline)>12
    if (tline(1:12) == 'VFINAL	POTEN');
        pot2(f)=str2num(tline(14:26));
    end
end
if length(tline)>13
    if (tline(1:13) == 'VLIMIT1	POTEN');
        pot3(f)=str2num(tline(15:27));
    end
end
if length(tline)>13
    if (tline(1:13) == 'VLIMIT2	POTEN');
        pot4(f)=str2num(tline(15:27));
    end
end
if length(tline)>11
    if (tline(1:11) == 'VRING	POTEN');
        pot5(f)=str2num(tline(13:25));
    end
end 

if exist('pot3', 'var') && exist('pot4', 'var') && length(pot3) == f && length(pot4) == f
    if (fix(methode) == 1 && index{2}(f) == 1) || (fix(methode) == 2) 
    if pot3(f)>pot4(f)
    index{12}(f)=pot4(f);
    index{13}(f)=pot3(f);
    else
    index{12}(f)=pot3(f);
    index{13}(f)=pot4(f);  
    end 
    end
	if fix(methode) == 1 && index{3}(f) == 1
    if pot3(f)>pot4(f)
    index{14}(f)=pot4(f);
    index{15}(f)=pot3(f);
    else
    index{14}(f)=pot3(f);
    index{15}(f)=pot4(f);  
    end 
    end
else
    if exist('pot1', 'var') && exist('pot2', 'var') && length(pot1) == f && length(pot2) == f
    if (fix(methode) == 1 && index{2}(f) == 1) || fix(methode) == 2 
    if pot2(f)>pot1(f)
    index{12}(f)=pot2(f);
    index{13}(f)=pot1(f);
    else
    index{12}(f)=pot1(f);
    index{13}(f)=pot2(f);  
    end 
    end
	if fix(methode) == 1 && index{3}(f) == 1
    if pot1(f)>pot2(f)
    index{14}(f)=pot2(f);
    index{15}(f)=pot1(f);
    else
    index{14}(f)=pot1(f);
    index{15}(f)=pot2(f);  
    end 
    end
    end
end

if exist('pot5', 'var') && length(pot5) == f
    if fix(methode) == 2
    index{14}(f)=pot5(f);
    index{15}(f)=pot5(f);
    end
end


% Rotationsrate 
if methode ~= 3
if length(tline)>=9
    if (tline(1:9) == 'RPM	QUANT');
    if (tline(18:19) == 'E+');
        index{17}(f)=str2num(tline(10:23));
    else
        for i=1:10
        if min((tline(10+i:17+i) == 'Rotation')) == 1;
        index{17}(f)=str2num(tline(10:9+i)); 
        end
        end
    end
    end
end
end

end
end

%% Einlesen der Raw Dateien

for f=1:index{23}                                                               %Scanne bei mutlipler Dateiabfrage 
  fileID = fopen([fpath index{1}(f,:)]);             
  x=1;   
for i= 1:1000                                                                          %Scanne Zeilen innerhalb der f-ten Datei
    tline = fgetl(fileID);

% Abfrage Ring- oder Disk-Daten
if fix(methode) == 1
    if strcmp(tline,'	#	s	V vs. Ref.	A	V	V	V	#	bits')==1          %Lese Mess-Tabelle aus wenn sie CV-Kriterien entspricht
    cell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s','Delimiter','\t'); %Definiere Format der CV-Tabelle
        for j=1:length(cell)
        if index{2}(f) == 1
            raw{1,1}(x:(x-1+length(cell{j})),j,f)=cell{j};
        end
        if index{3}(f) == 1
            raw{2,1}(x:(x-1+length(cell{j})),j,f)=cell{j};
        end
        end
        x = x+length(cell{j});
    end 
end

% Abfrage Disk-Daten 
if fix(methode) == 2
if length(tline)>=15
    if (tline(1:15) == 'DISKCURVE	TABLE')          %Lese Mess-Tabelle aus wenn sie RING-Kriterien entspricht
        fgetl(fileID);
        fgetl(fileID);
        diskcell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s %*f','Delimiter','\t'); %Definiere Format der CV-Tabelle
        for j=1:length(diskcell)                                                          %Convertiere Mess-Tabelle von Cell- in Array-Format
            raw{1,1}(1:length(diskcell{j}),j,f)=diskcell{j};
        end
    end    
end
end

% Abfrage Ring-Daten 
if fix(methode) == 2
if length(tline)>=15
    if (tline(1:15) == 'RINGCURVE	TABLE')          %Lese Mess-Tabelle aus wenn sie RING-Kriterien entspricht
        fgetl(fileID);
        fgetl(fileID);
        ringcell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s %*f','Delimiter','\t'); %Definiere Format der CV-Tabelle
        for j=1:length(ringcell)                                                          %Convertiere Mess-Tabelle von Cell- in Array-Format
            raw{2,1}(1:length(ringcell{j}),j,f)=ringcell{j};
        end
    end    
end
end

end
end

%% Abfrage nicht auslesbarer Index Daten

% Disk-Widerstand
if max(index{2}) == 1
    disp(['Disk-Widerstand [' char(937) '] aller Messungen eingeben: ']);
    r_disk=input('');
    if isempty(r_disk)
        for f=1:index{23} 
        disp(['Disk-Widerstand [' num2str(char(937)) '] für Messung ' index{1}(f,:) ' eingeben: ']);
        index{4}(f)=input('');
        end
    else
        index{4}(1:index{23})=r_disk;
    end
end

% Ring-Widerstand
if max(index{3}) == 1
    disp(['Ring-Widerstand [' char(937) '] aller Messungen eingeben: ']);
    r_ring=input('');
    if isempty(r_ring)
        for f=1:index{23} 
        disp(['Ring-Widerstand [' num2str(char(937)) '] für Messung ' index{1}(f,:) ' eingeben: ']);
        index{5}(f)=input('');
        end
    else
        index{5}(1:index{23})=r_ring;
    end
end

% geometrische Fläche Disk und Ring

% Rotationsrate 
if isempty(index{17})
disp(['Rotationsrate [rpm] aller Messungen eingeben: ']);
rpm=input('');
    if isempty(rpm)
        for f=1:index{23}
        disp(['Rotationsrate [rmp] für Messung ' index{1}(f,:) ' eingeben: ']);
        index{17}(f)=input('');
        end
    else
        index{17}(1:index{23})=rpm;
    end
end

% Elektrodenmaterial
disp(['Elektrodenmaterial: ']);
index{24}=input('','s');

% Referenzelektrodenpotential gegen RHE
if isempty(index{20})
disp(['Referenzelektrodenpotential [V vs RHE] aller Messungen eingeben: ']);
refpot=input('');
    if isempty(refpot)
        for f=1:index{23}
        disp(['Referenzelektrodenpotential [V vs RHE] für Messung ' index{1}(f,:) ' eingeben: ']);
        index{20}(f)=input('');
        end
    else
        index{20}(1:index{23})=refpot;
    end
end

% % Modus
% fprintf(['Wählen des Modus \n' ...
%     '1.	Fast \n' ...
% 	'2.	Noise-Reject \n'...
%     '3.	Surface \n'])
% index{21}=input('');


fprintf(['Normierung durchführen? \n' ...
    '1.	Ja \n' ...
	'2.	Nein \n'])
index{28}=input('');

%% Berechnung weiterer Messparameter



    

%% Trenne der Messdaten in Zyklen und speichern in 'data'

for f=1:index{23}
if index{2}(f) == 1 && index{3}(f) == 0
    cycl_index = 1;
    for i=1:(length(raw{1,1}(:,:,f))-2)
    raw{1,1}(i,10,f)=cycl_index;
    if raw{1,1}(i+1,3,f)<raw{1,1}(i+2,3,f) && raw{1,1}(i+1,3,f)<raw{1,1}(i,3,f)
    cycl_index=cycl_index+1;
    end
    end
    if (sum(raw{1,1}(:,10,f)==1) < sum(raw{1,1}(:,10,f)==2)) 
    index{26}(f,1:cycl_index) = (0:cycl_index-1);
    else
    index{26}(f,1:cycl_index) = (1:cycl_index);
    end
    index{16}(f) = max(max(raw{1,1}(:,10,f)));     
end

if index{2}(f) == 0 && index{3}(f) == 1
    cycl_index = 1;
    for i=1:(length(raw{2,1}(:,:,f))-2)
    raw{2,1}(i,10,f)=cycl_index;
    if raw{2,1}(i+1,3,f)<raw{2,1}(i+2,3,f) && raw{2,1}(i+1,3,f)<raw{2,1}(i,3,f)
    cycl_index=cycl_index+1;
    end
    end
    if (sum(raw{2,1}(:,10,f)==1) < sum(raw{2,1}(:,10,f)==2)-10)
    index{26}(f,1:cycl_index) = (0:cycl_index-1);
    else
    index{26}(f,1:cycl_index) = (1:cycl_index);
    end
    index{16}(f) = max(max(raw{2,1}(:,10,f)));     
end

if index{2}(f) == 1 && index{3}(f) == 1
    cycl_index = 1;
    for i=1:(length(raw{1,1}(:,:,f))-2)
    raw{1,1}(i,10,f)=cycl_index;
    raw{2,1}(i,10,f)=cycl_index;
    if raw{1,1}(i+1,3,f)<raw{1,1}(i+2,3,f) && raw{1,1}(i+1,3,f)<raw{1,1}(i,3,f)
    cycl_index=cycl_index+1;
    end
    end
    if (sum(raw{1,1}(:,10,f)==1) < sum(raw{1,1}(:,10,f)==2)) 
    index{26}(f,1:cycl_index) = (0:cycl_index-1);
    else
    index{26}(f,1:cycl_index) = (1:cycl_index);
    end
    index{16}(f) = max([max(raw{1,1}(:,10,f)) max(raw{2,1}(:,10,f))]);
end

end


% Berechne Up- und Down-Zyklen
for f=1:index{23}
if index{2}(f) == 1 && index{3}(f) == 0
    for z=1:max(raw{1,1}(:,10,f))
       ci(1) = 1;
       cs(z) = sum(raw{1,1}(:,10,f)==z);
       data{1,1}(1:cs(z),z,f)=raw{1,1}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
       data{1,5}(1:cs(z),z,f)=raw{1,1}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA
          
       ci(z+1)=ci(z)+cs(z);          
       
       [val idx] = max(data{1,1}(:,z,f));
       data{3,1}(1:(sum(data{1,1}(:,z,f)~=0)-idx)+1,z,f)=data{1,1}(idx:sum(data{1,1}(:,z,f)~=0),z,f);
       data{3,5}(1:(sum(data{1,1}(:,z,f)~=0)-idx)+1,z,f)=data{1,5}(idx:sum(data{1,1}(:,z,f)~=0),z,f);
       data{2,1}(1:idx-1,z,f)=data{1,1}(1:idx-1,z,f);
       data{2,5}(1:idx-1,z,f)=data{1,5}(1:idx-1,z,f);
    end
end

if index{2}(f) == 0 && index{3}(f) == 1  
    for z=1:max(raw{2,1}(:,10,f))
       ci(1) = 1; 
       cs(z) = sum(raw{2,1}(:,10,f)==z);
       data{5,1}(1:cs(z),z,f)=raw{2,1}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
       data{5,5}(1:cs(z),z,f)=raw{2,1}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA
          
       ci(z+1)=ci(z)+cs(z);          
       
       [val idx] = max(data{5,1}(:,z,f));
       data{7,1}(1:(sum(data{5,1}(:,z,f)~=0)-idx)+1,z,f)=data{5,1}(idx:sum(data{5,1}(:,z,f)~=0),z,f);
       data{7,5}(1:(sum(data{5,1}(:,z,f)~=0)-idx)+1,z,f)=data{5,5}(idx:sum(data{5,1}(:,z,f)~=0),z,f);
       data{6,1}(1:idx-1,z,f)=data{5,1}(1:idx-1,z,f);
       data{6,5}(1:idx-1,z,f)=data{5,5}(1:idx-1,z,f);
    end
end

if index{2}(f) == 1 && index{3}(f) == 1
    for z=1:max(raw{1,1}(:,10,f))
       ci(1) = 1; 
       cs(z) = sum(raw{1,1}(:,10,f)==z);
       data{1,1}(1:cs(z),z,f)=raw{1,1}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
       data{1,5}(1:cs(z),z,f)=raw{1,1}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA
       data{5,1}(1:cs(z),z,f)=raw{2,1}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
       data{5,5}(1:cs(z),z,f)=raw{2,1}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA  
       
       ci(z+1)=ci(z)+cs(z);          
       
       [val idx] = max(data{1,1}(:,z,f));
       data{3,1}(1:(sum(data{1,1}(:,z,f)~=0)-idx)+1,z,f)=data{1,1}(idx:sum(data{1,1}(:,z,f)~=0),z,f);
       data{3,5}(1:(sum(data{1,1}(:,z,f)~=0)-idx)+1,z,f)=data{1,5}(idx:sum(data{1,1}(:,z,f)~=0),z,f);
       data{2,1}(1:idx-1,z,f)=data{1,1}(1:idx-1,z,f);
       data{2,5}(1:idx-1,z,f)=data{1,5}(1:idx-1,z,f);
       data{7,1}(1:(sum(data{5,1}(:,z,f)~=0)-idx)+1,z,f)=data{5,1}(idx:sum(data{5,1}(:,z,f)~=0),z,f);
       data{7,5}(1:(sum(data{5,1}(:,z,f)~=0)-idx)+1,z,f)=data{5,5}(idx:sum(data{5,1}(:,z,f)~=0),z,f);       
       data{6,1}(1:idx-1,z,f)=data{5,1}(1:idx-1,z,f);
       data{6,5}(1:idx-1,z,f)=data{5,5}(1:idx-1,z,f);       
    end
end
end

for f=1:index{23}
if index{2}(f) == 1 
for i=1:3
    data{i,2}(:,:,f) = data{i,1}(:,:,f) + index{20}(f);
    data{i,3}(:,:,f) = data{i,1}(:,:,f) - data{i,5}(:,:,f) * (10^-3) .* index{4}(f); 
    data{i,4}(:,:,f) = data{i,2}(:,:,f) - data{i,5}(:,:,f) * (10^-3) .* index{4}(f); 
    %data{i,6} = 
    data{i,7}(:,:,f) = data{i,5}(:,:,f) ./ index{6}(f);
    %data{i,8} = 
end 
end
end

for f=1:index{23}
if index{3}(f) == 1 
for i=5:7
    data{i,2}(:,:,f) = data{i,1}(:,:,f) + index{20}(f);
    data{i,3}(:,:,f) = data{i,1}(:,:,f) - data{i,5}(:,:,f) * (10^-3) .* index{5}(f); 
    data{i,4}(:,:,f) = data{i,2}(:,:,f) - data{i,5}(:,:,f) * (10^-3) .* index{5}(f); 
    %data{i,6} = 
    data{i,7}(:,:,f) = data{i,5}(:,:,f) ./ index{7}(f);
    %data{i,8} = 
end
end
end
     
%% Normierung durch Ar-gesättigte Messung

if index{28} == 1



% Abfrage Dateipfad und Dateiname
[fnamecell,fpath] = uigetfile('*.dta','Normierung Datei Import','Z:Masterarbeit\Elektrochemie\Testmessungen\','MultiSelect', 'on');     
index_norm{1} = char(fnamecell);

%Widerstand eingeben
fprintf(['Disk-Widerstand [' char(937) '] aller Normierungs-Messungen eingeben: \n'])
index_norm{4}=input('');

% Referenzelektrodenpotential gegen RHE
if isempty(index{20})
disp(['Referenzelektrodenpotential [V vs RHE] aller Messungen eingeben: ']);
refpot=input('');
    if isempty(refpot)
        for f=1:index{23}
        disp(['Referenzelektrodenpotential [V vs RHE] für Messung ' index{1}(f,:) ' eingeben: ']);
        index{20}(f)=input('');
        end
    else
        index{20}(1:index{23})=refpot;
    end
end



for f = 1:index{23}
% Einlese der Daten
  fileID = fopen([fpath index_norm{1}(f,:)]); 
  x=1;
  index_norm{2} = false;
  index_norm{3} = false;
for i= 1:1000                                                                  %Scanne Zeilen innerhalb der f-ten Datei
    tline = fgetl(fileID);

    
% Disk or Ring
if length(tline)>10
    if (tline(1:10) == 'AREA	QUANT');
        if str2num(tline(11:23)) == 0.1256
        index_norm{2} = true;
        end
        if str2num(tline(11:23)) == 0.1884
        index_norm{3} = true;
        end
    end
end

% Disk and Ring
if length(tline)>10
    if (tline(1:11) == 'TAG	COLLECT')
        index_norm{2} = true;
        index_norm{3} = true;
    end
end
   
% Abfrage Ring- oder Disk-Daten
if strcmp(tline,'	#	s	V vs. Ref.	A	V	V	V	#	bits')==1          %Lese Mess-Tabelle aus wenn sie CV-Kriterien entspricht
    cell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s','Delimiter','\t'); %Definiere Format der CV-Tabelle
    for j=1:length(cell)
    if index_norm{2} == 1 && index_norm{3} == 0
        raw{1,2}(x:(x-1+length(cell{j})),j,f)=cell{j};
    end
    if index_norm{2} == 0 && index_norm{3} == 1
        raw{2,2}(x:(x-1+length(cell{j})),j,f)=cell{j};
    end
    end
    x = x+length(cell{j});
end 



 % Abfrage Disk-Daten 
if length(tline)>=15
    if (tline(1:15) == 'DISKCURVE	TABLE')          %Lese Mess-Tabelle aus wenn sie RING-Kriterien entspricht
        fgetl(fileID);
        fgetl(fileID);
        diskcell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s %*f','Delimiter','\t'); %Definiere Format der CV-Tabelle
        for j=1:length(diskcell)                                                          %Convertiere Mess-Tabelle von Cell- in Array-Format
            raw{1,2}(1:length(diskcell{j}),j,f)=diskcell{j};
        end
    end    
end

 % Abfrage Disk-Daten 
if length(tline)>=15
    if (tline(1:15) == 'RINGCURVE	TABLE')          %Lese Mess-Tabelle aus wenn sie RING-Kriterien entspricht
        fgetl(fileID);
        fgetl(fileID);
        diskcell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s %*f','Delimiter','\t'); %Definiere Format der CV-Tabelle
        for j=1:length(diskcell)                                                          %Convertiere Mess-Tabelle von Cell- in Array-Format
            raw{2,2}(1:length(diskcell{j}),j,f)=diskcell{j};
        end
    end    
end


end
end

for f = 1:index{23}
% Trenne der Messdaten in Zyklen und speichern in 'data'
if index_norm{2} == 1 && index_norm{3} == 0 
cycl_index = 1;
for i=1:(length(raw{1,2}(:,:,f))-2)
    raw{1,2}(i,10,f)=cycl_index;
    if raw{1,2}(i+1,3,f)<=raw{1,2}(i+2,3,f) && raw{1,2}(i+1,3,f)<=raw{1,2}(i,3,f)
    cycl_index=cycl_index+1;
    end
end
index_norm{16}(f) = cycl_index;
end

if index_norm{2} == 0 && index_norm{3} == 1
cycl_index = 1;
for i=1:(length(raw{2,2}(:,:,f))-2)
    raw{2,2}(i,10,f)=cycl_index;
    if raw{2,2}(i+1,3,f)<=raw{2,2}(i+2,3,f) && raw{2,2}(i+1,3,f)<=raw{2,2}(i,3,f)
    cycl_index=cycl_index+1;
    end
end
index_norm{16}(f) = cycl_index;
end

if index_norm{2} == 1 && index_norm{3} == 1
cycl_index = 1;
for i=1:(length(raw{1,2}(:,:,f))-2)
    raw{1,2}(i,10,f)=cycl_index;
    raw{2,2}(i,10,f)=cycl_index;
    if raw{1,2}(i+1,3,f)<=raw{1,2}(i+2,3,f) && raw{1,2}(i+1,3,f)<=raw{1,2}(i,3,f)
    cycl_index=cycl_index+1;
    end
end
index_norm{16}(f) = cycl_index;
end



if index_norm{2} == 1 && index_norm{3} == 0
for z=1:max(raw{1,2}(:,10,f))
    ci(1) = 1; 
    cs(z) = sum(raw{1,2}(:,10,f)==z);
    data{1,9}(1:cs(z),z,f)=raw{1,2}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
    data{1,10}(1:cs(z),z,f)=raw{1,2}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA
      
    ci(z+1)=ci(z)+cs(z);          
end
end

if index_norm{2} == 0 && index_norm{3} == 1
for z=1:max(raw{2,2}(:,10,f))
    ci(1) = 1; 
    cs(z) = sum(raw{2,2}(:,10,f)==z);
    data{5,9}(1:cs(z),z,f)=raw{2,2}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
    data{5,10}(1:cs(z),z,f)=raw{2,2}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA
      
    ci(z+1)=ci(z)+cs(z);          
end
end

if index_norm{2} == 1 && index_norm{3} == 1
for z=1:max(raw{1,2}(:,10,f))
    ci(1) = 1; 
    cs(z) = sum(raw{1,2}(:,10,f)==z);
    data{1,9}(1:cs(z),z,f)=raw{1,2}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref  
    data{5,9}(1:cs(z),z,f)=raw{2,2}(ci(z):(ci(z)+cs(z)-1),3,f);                    % vs Ref      
    data{1,10}(1:cs(z),z,f)=raw{1,2}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA
    data{5,10}(1:cs(z),z,f)=raw{2,2}(ci(z):(ci(z)+cs(z)-1),4,f)*10^+3;              %*10^+3 berechnet A-> mA 
    
    ci(z+1)=ci(z)+cs(z);          
end
end
end


data{1,9} = data{1,9}-data{1,10}/10^3*index_norm{4}+index{20}(1);


% Berechne Up- und Down-Normierungs-Zyklen
for f = 1:index{23}
if index_norm{2} == 1 && index_norm{3} == 0
    for z=1:max(raw{1,2}(:,10,f))
       [val idx] = max(data{1,9}(:,z,f));
       data{3,9}(1:(sum(data{1,9}(:,z,f)~=0)-idx)+1,z,f)=data{1,9}(idx:sum(data{1,9}(:,z,f)~=0),z,f);
       data{2,9}(1:idx-1,z,f)=data{1,9}(1:idx-1,z,f);
       data{3,10}(1:(sum(data{1,9}(:,z,f)~=0)-idx)+1,z,f)=data{1,10}(idx:sum(data{1,9}(:,z,f)~=0),z,f);       
       data{2,10}(1:idx-1,z,f)=data{1,10}(1:idx-1,z,f);
    end
end

if index_norm{2} == 0 && index_norm{3} == 1
    for z=1:max(raw{2,2}(:,10,f))
       [val idx] = max(data{5,9}(:,z,f));
       data{7,9}(1:(sum(data{5,9}(:,z,f)~=0)-idx)+1,z,f)=data{5,9}(idx:sum(data{5,9}(:,z,f)~=0),z,f);
       data{6,9}(1:idx-1,z,f)=data{5,9}(1:idx-1,z,f);
       data{7,10}(1:(sum(data{5,9}(:,z,f)~=0)-idx)+1,z,f)=data{5,10}(idx:sum(data{5,9}(:,z,f)~=0),z,f);       
       data{6,10}(1:idx-1,z,f)=data{5,10}(1:idx-1,z,f);
    end
end

if index_norm{2} == 1 && index_norm{3} == 1
    for z=1:max(raw{1,2}(:,10,f))
       [val idx] = max(data{1,9}(:,z,f));
       data{3,9}(1:(sum(data{1,9}(:,z,f)~=0)-idx)+1,z,f)=data{1,9}(idx:sum(data{1,9}(:,z,f)~=0),z,f);
       data{2,9}(1:idx-1,z,f)=data{1,9}(1:idx-1,z,f);
       data{3,10}(1:(sum(data{1,9}(:,z,f)~=0)-idx)+1,z,f)=data{1,10}(idx:sum(data{1,9}(:,z,f)~=0),z,f);       
       data{2,10}(1:idx-1,z,f)=data{1,10}(1:idx-1,z,f);
       data{7,9}(1:(sum(data{1,9}(:,z,f)~=0)-idx)+1,z,f)=data{5,9}(idx:sum(data{1,9}(:,z,f)~=0),z,f);
       data{6,9}(1:idx-1,z,f)=data{5,9}(1:idx-1,z,f);
       data{7,10}(1:(sum(data{1,9}(:,z,f)~=0)-idx)+1,z,f)=data{5,10}(idx:sum(data{1,9}(:,z,f)~=0),z,f);       
       data{6,10}(1:idx-1,z,f)=data{5,10}(1:idx-1,z,f);       
    end
end
end


% Interpoliere Norm-Daten auf jeweilige Messdaten -> norm_i, norm_j
if index_norm{2} == 1 && index_norm{3} == 0
for f=1:index{23}
    for i=2:3
    for z=1:index{16}(f)
        
    %if index_norm{16} == index{16}(f) 
    if (sum(data{i,10}(:,z,f) ~= 0) >= 10)
        data{i,11}(:,z,f) = interp1(data{i,9}(:,z,f),data{i,10}(:,z,f),data{i,4}(:,z,f),'linear', 'extrap');
    %end
%     elseif index_norm{16} >= 2
%     if (sum(data{i,10}(:,2,f) ~= 0) >= 10)
%         data{i,11}(:,z,f) = interp1(data{i,9}(:,2,f),data{i,10}(:,2,f),data{i,1}(:,z,f),'linear', 'extrap');
%     end
    else
        disp('Keine Normierung Möglich');
    end
    end
    end
end
end


if index_norm{2} == 0 && index_norm{3} == 1
for f=1:index{23}
    for i=6:7
    for z=1:index{16}(f)
    if index_norm{16} == index{16}(f) 
    if (sum(data{i,10}(:,z,f) ~= 0) >= 10)
        data{i,11}(:,z,f) = interp1(data{i,9}(:,z,f),data{i,10}(:,z,f),data{i,4}(:,z,f),'linear', 'extrap');
    end
%     elseif index_norm{16} >= 2
%     if (sum(data{i,10}(:,2,f) ~= 0) >= 10)
%         data{i,11}(:,z,f) = interp1(data{i,9}(:,2,f),data{i,10}(:,2,f),data{i,1}(:,z,f),'linear', 'extrap');
%     end
    else
        disp('Keine Normierung Möglich');
    end
    end
    end
end
end

if index_norm{2} == 1 && index_norm{3} == 1
for f=1:index{23}
    for i=2:3
    for z=1:index{16}(f)
        
    if index_norm{16} == index{16}(f) 
    if (sum(data{i,10}(:,z,f) ~= 0) >= 10)
        data{i,11}(:,z,f) = interp1(data{i,9}(:,z,f),data{i,10}(:,z,f),data{i,4}(:,z,f),'linear', 'extrap');
    end
%     elseif index_norm{16} >= 2
%     if (sum(data{i,10}(:,2,f) ~= 0) >= 10)
%         data{i,11}(:,z,f) = interp1(data{i,9}(:,2,f),data{i,10}(:,2,f),data{i,1}(:,z,f),'linear', 'extrap');
%     end
    else
        disp('Keine Normierung Möglich');
    end 
    end
    end
    for i=6:7
    for z=1:index{16}(f)
    if index_norm{16} == index{16}(f) 
    if (sum(data{i,10}(:,z,f) ~= 0) >= 10)
        data{i,11}(:,z,f) = interp1(data{i-4,9}(:,z,f),data{i,10}(:,z,f),data{i-4,4}(:,z,f),'linear', 'extrap');
    end
%     elseif index_norm{16} >= 2
%     if (sum(data{i,10}(:,2,f) ~= 0) >= 10)
%         data{i,11}(:,z,f) = interp1(data{i-4,9}(:,2,f),data{i,10}(:,2,f),data{i-4,1}(:,z,f),'linear', 'extrap');
%     end
    else
        disp('Keine Normierung Möglich');
    end
    end
    end
end
end

data{1,11}(1:length(data{2,11}(:,1,1)),:,:) = data{2,11};
data{1,11}(length(data{2,11}(:,1,1))+1:length(data{2,11}(:,1,1))+length(data{3,11}(:,1,1)),:,:) = data{3,11};

% data{5,11}(1:length(data{6,11}(:,1,1)),:,:) = data{6,11};
% data{5,11}(length(data{6,11}(:,1,1))+1:length(data{6,11}(:,1,1))+length(data{7,11}(:,1,1)),:,:) = data{7,11};



% Berechne normierten Strom und normierte Stromdichte
if index_norm{2} == 1 
for i=1:3
    if (sum(data{i,11} ~= 0) >= 10)
    data{i,12} = data{i,11} ./ index{6}(1);   
    data{i,6} = data{i,5} - data{i,11};
    data{i,8} = data{i,7} - data{i,12}; 
    end 
end
end

if index_norm{3} == 1 
for i=5:7
    if (sum(data{i,11} ~= 0) >= 10)    
    data{i,12} = data{i,11} ./ index{7}(1);   
    data{i,6} = data{i,5} - data{i,11};
    data{i,8} = data{i,7} - data{i,12}; 
    end
end
end
end

%% Speicherung der Daten und Löschen aller temporären Variablen

save('Data', 'raw', 'data', 'index', 'index_norm');
clear all;
load('Data');


disp(['Done']);

