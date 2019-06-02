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


frage(zeit,'Ist das Buch rechtzeitig zur�ckgegeben?').
option(zeit,j,'ja',[sch�digung]).
option(zeit,n, 'nein',[spate]).
erklaerung(zeit,['Wenn Sie das Buch nicht rechtzetig zur�ckgeben,',
                 'dann gibt es strafen.']).

frage(spate,'Wie sp�te ist die R�ckgabe ?').
option(spate,w,'weniger als ein Jahre',[sch�digung]).
option(spate,m,'mehr als ein Jahre ',[sch�digung]).
erklaerung(spate,['Wenn es mehr als halb Jahre sp�te ist',
                        'dann gibt es eine feste Geldstrafe.']).

frage(sch�digung,'Gibt es sch�digungen ?').
option(sch�digung,j,'ja, wenigstens etwas',[strafe]).
option(sch�digung,n,'nein, ueberhaupt nicht',[verl�ngern]).
erklaerung(sch�digung,['Wenn es sch�digungen gibt,',
                     'sollten Sie strafe bezahlen.']).

frage(strafe,'Ist das Buch schlecht gesch�digt ?').
option(strafe,j,'ja',[verl�ngern]).
option(strafe,n,'nein',[verl�ngern]).
erklaerung(strafe,['Wenn es schlecht gesch�digt ist,',
                   'mussen Sie das Buch ersetzen.']).
erklaerung(strafe,['Wenn sie nicht sicher sind,',
                   'w�hlen Sie bitte ja']).


frage(verl�ngern,['Wollen Sie das Buch verl�ngern?']).
option(verl�ngern,j,'ja',[]).
option(verl�ngern,n,'nein',[]).
erklaerung(verl�ngern,['Wenn Sie das Buch verl�ngern wollen,',
                       'sollen Sie ja antworten.']).



/*-- Ende der Dialogbeschreibung ------------------------------*/

/*-- Beschreibung der Beratung: -------------------------------*/

bewertung('Das Buch ersetzen und eine Strafe von 10 euro bezahlen')
       :-  wenn(start,j).
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'Das Buch wird ersetzt und verl�ngert.'])
       :- wenn(verl�ngern,j),wenn(spate,m),wenn(strafe,j),wenn(zeit,n) .
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'Das Buch wird angenommen.'])
       :- wenn(verl�ngern,n),wenn(spate,m),wenn(strafe,j),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird verl�ngert.'])
       :- wenn(verl�ngern,j),wenn(spate,w),wenn(strafe,n),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verl�ngern,n),wenn(spate,w),wenn(strafe,n),wenn(zeit,n) .
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'und es wird verl�ngert.'])
       :- wenn(verl�ngern,j),wenn(spate,m),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird verl�ngert.'])
       :- wenn(verl�ngern,j),wenn(spate,w),wenn(zeit,n) .
bewertung(['Eine Strafe von 100 euro bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verl�ngern,n),wenn(spate,m),wenn(zeit,n) .
bewertung(['Eine Strafe von 1 euro pro woche bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verl�ngern,n),wenn(spate,w),wenn(zeit,n) .
bewertung(['Das Buch ersetzen,eine Strafe von 10 euro bezahlen,',
           'und es wird angenommen.'])
       :- wenn(verl�ngern,n),wenn(sch�digung,j),wenn(strafe,j) .

bewertung(['Das Buch ersetzen,eine Strafe von 10 euro bezahlen,',
           'und es wird verl�ngert.'])
       :- wenn(verl�ngern,j),wenn(sch�digung,j),wenn(strafe,j) .
bewertung('Das buch wird ohne Strafe angenommen!')
       :- wenn(verl�ngern,n),wenn(sch�digung,n),wenn(zeit,j) .
bewertung('Das buch wird ohne Strafe verl�ngert!')
       :- wenn(verl�ngern,j),wenn(sch�digung,n),wenn(zeit,j).

/*-- Laden der Shell und Starten der Beratung! -----------------*/
?-reconsult('wbshell').
?-expert.
/*-- end of prolog ---------------------------------------------*/

