/***************************************************************/
/*      Wissensbasisertesystem fuer Bibliothek       */
/*      who: Naveen*/
/***************************************************************/

/* tell prolog that clause definitions are not contiguous */
:- discontiguous(frage/2).
:- discontiguous(option/4).
:- discontiguous(erklaerung/2).
:- discontiguous(bewertung/1).

/*
*/

?- write(' ******* Es wird das Wissen geladen ********'),nl,nl.

wissensbasis('   ***   Bibliothek    ***').

frage(start,'Ist das Buch verloren ?').
option(start,j,'ja',[]).
option(start,n, 'nein',[zeit]).
erklaerung(start,['Wenn Sie das Buch verloren haben,',
                 'mussen sie das Buch ersetzen und strafen bezahlen.']).


frage(zeit,'Ist das Buch rechtzeitig zurückgegeben?').
option(zeit,j,'ja',[schädigung]).
option(zeit,n, 'nein',[spate]).
erklaerung(zeit,['Wenn Sie das Buch nicht rechtzetig zurückgeben,',
                 'dann gibt es strafen.']).

frage(spate,'Wie späte ist die Rückgabe ?').
option(spate,w,'weniger als ein Jahre',[schädigung]).
option(spate,m,'mehr als ein Jahre ',[schädigung]).
erklaerung(spate,['Wenn es mehr als halb Jahre späte ist',
                        'dann gibt es eine feste Geldstrafe.']).

frage(schädigung,'Gibt es schädigungen ?').
option(schädigung,j,'ja, wenigstens etwas',[strafe]).
option(schädigung,n,'nein, ueberhaupt nicht',[verlängern]).
erklaerung(schädigung,['Wenn es schädigungen gibt,',
                     'sollten Sie strafe bezahlen.']).

frage(strafe,'Ist das Buch schlecht geschädigt ?').
option(strafe,j,'ja',[verlängern]).
option(strafe,n,'nein',[verlängern]).
erklaerung(strafe,['Wenn es schlecht geschädigt ist,',
                   'mussen Sie das Buch ersetzen.']).
erklaerung(strafe,['Wenn sie nicht sicher sind,',
                   'wählen Sie bitte ja']).


frage(verlängern,['Wollen Sie das Buch verlängern?']).
option(verlängern,j,'ja',[]).
option(verlängern,n,'nein',[]).
erklaerung(verlängern,['Wenn Sie das Buch verlängern wollen,',
                       'sollen Sie ja antworten.']).



/*-- Ende der Dialogbeschreibung ------------------------------*/

/*-- Beschreibung der Beratung: -------------------------------*/

bewertung('Das Buch ersetzen und eine Strafe von 10 euro bezahlen')
       :-  wenn(start,j).
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'Das Buch wird ersetzt und verlängert.'])
       :- wenn(verlängern,j),wenn(spate,m),wenn(strafe,j),wenn(zeit,n) .
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'Das Buch wird angenommen.'])
       :- wenn(verlängern,n),wenn(spate,m),wenn(strafe,j),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird verlängert.'])
       :- wenn(verlängern,j),wenn(spate,w),wenn(strafe,n),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verlängern,n),wenn(spate,w),wenn(strafe,n),wenn(zeit,n) .
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'und es wird verlängert.'])
       :- wenn(verlängern,j),wenn(spate,m),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird verlängert.'])
       :- wenn(verlängern,j),wenn(spate,w),wenn(zeit,n) .
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verlängern,n),wenn(spate,m),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verlängern,n),wenn(spate,w),wenn(zeit,n) .
bewertung(['Das Buch ersetzen,eine Strafe von 10 euro bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verlängern,n),wenn(schädigung,j),wenn(strafe,j) .

bewertung(['Das Buch ersetzen,eine Strafe von 10 euro bezahlen,',
           'und es wird verlängert.'])
       :- wenn(verlängern,j),wenn(schädigung,j),wenn(strafe,j) .
bewertung('Das buch wird ohne Strafe angenommen!')
       :- wenn(verlängern,n),wenn(schädigung,n),wenn(zeit,j) .
bewertung('Das buch wird ohne Strafe verlängert!')
       :- wenn(verlängern,j),wenn(schädigung,n),wenn(zeit,j).

/*-- Laden der Shell und Starten der Beratung! -----------------*/
?-reconsult('wbshell').
?-expert.
/*-- end of prolog ---------------------------------------------*/

