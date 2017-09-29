%Part 1 des Programms: Ziel der Auswertung

function[name, project, goal] = GoalDetermination()

    %----- Experimentator und Projekt für Dokumentation festlegen ----

    name=input('Geben Sie Ihren Namen an und drücken Sie anschließend [ENTER]\n','s');
    project=input('Geben Sie Ihren Projekt (z.B. Bachelorarbeit) an und drücken Sie anschließend [ENTER]\n','s');

    response = sprintf('Sie haben sich als %s im Projekt "%s" angemeldet. \n',name ,project);
    disp(response)

    %---- Ziel der Auswertung -----

    %fprintf(['Geben Sie das Ziel der Auswertung an und drücken [ENTER] \n1. Zyklen	\n2.XXX\n') 
    %Ziel=input('');
    %index{1}=Ziel;
    goal = 'bla';
end 
