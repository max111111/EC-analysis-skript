clear all
close all
load Data.mat

%% iportiere Ring Daten

[fnamecell,fpath] = uigetfile('*.dta','Gamry Datei Import','Z:mAsterarbeit\Elektrochemie\Testmessungen\','MultiSelect', 'on');     
index{1} = char(fnamecell);

% Ring-Widerstand
    disp(['Ring-Widerstand [' char(937) '] der Messung eingeben: ']);
    r_ring=input('');
    index{5}(1)=r_ring;
    


                                                               %Scanne bei mutlipler Dateiabfrage 
  fileID = fopen([fpath index{1}(1,:)]);             
  x=1;   
for i= 1:100                                                                          %Scanne Zeilen innerhalb der f-ten Datei
    tline = fgetl(fileID);
if length(tline)>=11

    if (tline(1:11) == 'CURVE	TABLE')          %Lese Mess-Tabelle aus wenn sie RING-Kriterien entspricht
        fgetl(fileID);
        fgetl(fileID);
        ringcell = textscan(fileID,'%*f %f %f %f %f %f %f %f %f %*s %*f','Delimiter','\t'); %Definiere Format der CV-Tabelle
        for j=1:length(ringcell)                                                          %Convertiere Mess-Tabelle von Cell- in Array-Format
            raw{2,1}(1:length(ringcell{j}),j,1)=ringcell{j};
        end
    end
    
end
end

figure
plot(raw{2,1}(:,1,1), raw{2,1}(:,4,1))

% Daten-Offset
    disp(['Datenoffset grob abgeschätzt eingeben: ']);
    off1=input('');

figure
plot(raw{2,1}(off1:off1+length(data{1,5})*5,1,1), raw{2,1}(off1:off1+length(data{1,5})*5,4,1))

% Daten-Offset
    disp(['Datenoffset genau abgeschätzt eingeben: ']);
    off2=input('');

fehler = 0; 
    
for f = 1:index{23}
for z = 1:length(data{1,5}(1,:,1))
    for i = off2:off2+500
    int(i+1-off2) = sum(abs(raw{2,1}(i-100:i+100,4,1)));
    end
    
    [v idx(z,f)] = max(int);
    if idx(z,f) == 1 || idx(z,f) == 501
        fehler = fehler +1;
    end
    asd(z,f) = idx(z,f); 
    idx(z,f) = idx(z,f) + off2; 
    off2 = idx(z,f)+length(data{1,5})-250;
    
end
off2 = off2 + 450;
end

if fehler >= 2
    fprintf(['Bei der Zuordnung der Ringdaten sind insgesamt ' num2str(fehler) ' Fehler aufgetreten. \nBitte Datenoffset genauer abschätzen! \n']);
end


for f = 1:index{23}
    for z = 1:length(data{1,5}(1,:,1))
     data{5,5}(:,z,f) = raw{2,1}(idx(z,f)-length(data{1,5})/2:idx(z,f)+length(data{1,5})/2-1,4,1)*10^3;   
        
        
    end
end
% 
% for f = 1:index{23}
% for z = 1:length(data{1,5}(1,:,1))
% for i = o_daten:o_daten+length(data{1,5})-1
%     ir_raw(i-o_daten+1,z,f) = raw{2,1}(i,4);
% end
%     o_daten = o_daten+length(data{1,5});
% end
%     o_daten = o_daten+length(data{1,5})+v_daten;
% end
% for f = 1:index{23}
% for z = 1:length(data{1,5}(1,:,1))
% 
% data{5,5}(:,z,f) = (ir_raw(:,z+(f*3-3),1)-mean(ir_raw(50:100,z+(f*3-3),1))).*10^3;
% 
% end
% end
%daten{5,5} = ir_raw;


data{6,5} = data{5,5}(1:length(data{2,5}),:,:);
data{7,5} = data{5,5}(length(data{2,5})+1:length(data{1,5}),:,:);

data{5,7} = data{5,5}/index{7}(1);
data{6,7} = data{6,5}/index{7}(1);
data{7,7} = data{7,5}/index{7}(1);

data{5,1} = data{1,1};
data{6,1} = data{2,1};
data{7,1} = data{3,1};

data{5,4} = data{5,1}-index{5}.*abs(data{5,5}.*10^-3)+index{20}(1);
data{6,4} = data{6,1}-index{5}.*abs(data{6,5}.*10^-3)+index{20}(1);
data{7,4} = data{7,1}-index{5}.*abs(data{7,5}.*10^-3)+index{20}(1);

%% Speichern 

save('Data', 'raw', 'data', 'index', 'index_norm', 'asd');
clear all;
load('Data');

disp(['Done']);

