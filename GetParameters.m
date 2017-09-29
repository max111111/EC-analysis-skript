%----- Part 2 des Programms: Parameterabfrage -----

function [Parameters] = GetParameters()%evtl. goal als argument übergeben?!
    
    Parameters = containers.Map() %Initialisiert ein neues Map-Objekt welches die gesamten Parameter enthalten wird.
    fprintf('Parameterabfrage zum Versuchsaufbau und zur Auswertung\n')

    fprintf('Geben Sie den Zellenaufbau an \n 1.Teflon-Zelle\n 2.Glas-Zelle\n 3.hermetische Zelle\n')
    Zellen=input('')
        switch Zellen
            case 1
                Parameters('Cell')='Teflon'
            case 2
                Parameters('Cell')='Glas' 
            case 3
                Parameters('Cell')='Hermetisch'  
        end
   
    fprintf('Geben Sie den Referenzelektrode(typ)an\n 1.RHE\n 2.SCE\n')
    Referenz=input('')
    switch Referenz
        case 1
           Parameters('ReferenceElectrode')='RHE'
        case 2
           Parameters('ReferenceElectrode')='SCE'  
    end

    Parameters('Resistance')=input('Bitte geben Sie den realen Widerstand des Systems an und drücken [ENTER]\n')

    Parameters('ElectrodeArea')=input('Geben Sie den Elektrodenfläche an und drücken [ENTER]\n')

    Parameters('Material')=input('Geben Sie das Elektrodenmaterial an und drücken Sie [ENTER]\n','s')

    Parameters('RingArea')=input('Geben Sie die Ringfläche an und drücken [ENTER]\n')

    Parameters('pH')=input('Geben Sie den pH-Wert an und drücken [ENTER]\n')

    Parameters('Elektrolyt')=input('Geben Sie den Elektrolyten an (z.B. 0.1M KOH Ar-purged) und drücken Sie [ENTER]\n','s')

    Parameters('Vorschub')=input('Geben Sie die Vorschubsgeschwindigkeit an und drücken [ENTER]\n')

    Parameters('RPM')=input('Geben Sie die Rotationsrate (RPM) an und drücken [ENTER]\n')

    Parameters('Kommentar')=input('Hier können Sie einen zusätzlichen Kommentar eingeben und drücken Sie anschließend [ENTER]\n','s')

end