%-----Part 3: Datei einlesen----------------
function [heading,data] = ReadFile()
    % Datei ausw�hlen
    [filename, pathname] = uigetfile('*.crv', 'Dateiauswahl: Origalys Datei Import','Z:\Auswertung','MultiSelect', 'on');
    if isequal(filename, 0)
    disp('Anwender hat die Funktion abgebrochen')
    else
    disp(['Anwender hat folgende Datei ausgew�hlt ', fullfile(pathname, filename)])
    end 
    index{1}=char(filename);
    
    % Fallunterscheidung nach Potentiostat hinzuf�gen!!
    % z.B.: if filename enth�lt '.crv' dann f�hre ReadOrigalys aus...
    [heading, data] = ReadOrigalys(pathname,index{1})
end

function [header, data] = ReadOrigalys(filepath, filename)
        %----- Einlesen der Datei -------
    Dateiname = fopen([filepath filename]);
    header = textscan(Dateiname,'%s %s %s',10);
    fgetl(Dateiname); 
    data = textscan(Dateiname,'%n %n %n');
end
