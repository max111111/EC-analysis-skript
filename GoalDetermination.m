%Part 1 des Programms: Ziel der Auswertung

function[name, project, goal] = GoalDetermination()

    %----- Experimentator und Projekt f�r Dokumentation festlegen ----

    name=input('Geben Sie Ihren Namen an und dr�cken Sie anschlie�end [ENTER]\n','s');
    project=input('Geben Sie Ihren Projekt (z.B. Bachelorarbeit) an und dr�cken Sie anschlie�end [ENTER]\n','s');

    response = sprintf('Sie haben sich als %s im Projekt "%s" angemeldet. \n',name ,project);
    disp(response)

    %---- Ziel der Auswertung -----

    %fprintf(['Geben Sie das Ziel der Auswertung an und dr�cken [ENTER] \n1. Zyklen	\n2.XXX\n') 
    %Ziel=input('');
    %index{1}=Ziel;
    goal = 'bla';
end 
