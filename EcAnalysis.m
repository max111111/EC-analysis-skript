%Part 1 des Programms: Ziel der Auswertung

%----- Beginn und L�schen des Workspaces ------

clear all

%----------------------------------------------

% ----Part 2: Bestimmung des Ziels der Auswertung-----
[name, project, goal] = GoalDetermination();

%----- Part 3: Parameter abfragen ------------------------

Parameters = GetParameters();

%----- Standardwerte als Konstanten hier definieren ------

Konstante=0.98; %Konstante addieren f�r RHE

%----- Part 4: Datei einlesen ----------------------------

[head,data]=ReadFile()

%------ Part 5: Auswertung---------------------------------




%------- Part 6: Speichern der Daten -----------------------




