/***************************************************************/
/* Beispiele zur Scripte                                       */         
/*  Mini-Shell eines Expertensystems - nach Schnupp:"Prolog"   */
/*where: wbshell.pro        when: 3/89        who: Uwe Laemmel */
/***************************************************************/
/* Aenderungsprotokoll:
   20.04.13: weitere Empfehlungen möglich
           : '.' für break und 'h'='?' für help eingebaut

   8.11.94: 'warum' geaendert, so dass auch der Fall
            keiner Erklaerungen zu einer Frage behandelt wird
   8.11.94: 'beratung' ohne 'wenn'-Teil wird bearbeitet.
*/
?-dynamic(offene_frage/1).
?-dynamic(resultat/2).
?-dynamic(grund/2).
             
expert :-   banner,repeat,beratung,wiederholung.

beratung :-   init,repeat,not(noch_fragen),auswertung,!.
init :-   retractall(offene_frage(_)),
          retractall(resultat(_,_)),
          retractall(grund(_,_)),
          assert(offene_frage(start)),!.
noch_fragen:-   retract(offene_frage(Name)),
                stelle_frage(Name),!.
stelle_frage(X) :-   clause(resultat(X,_),true),!.
stelle_frage(X) :-   frage(X,Frage),
                     menu(X,Frage),
                     antwort(X,Antw,FolgeRegeln),
                     asserta(resultat(X,Antw)),
                     fragen_eintrag(FolgeRegeln),!.
wiederholung :-  write('Moechten Sie noch eine Beratung ? (j/n) : '),
                 read_Char(Ch),Ch \= j.

fragen_eintrag([]):-!.
fragen_eintrag([X|Y]) :- fragen_eintrag(Y),asserta(offene_frage(X)),!.

menu(X,Frage) :- screen_init,
                 writelines(0,Frage),nl,
                 auswahl(X),!.
auswahl(X) :-   option(X,Code,Antw,_),
                tab(8),write(Code),write(' - '),write(Antw),nl,
                fail.
auswahl(_) :-   nl.
antwort(X,Code,FolgeRegeln) :-   
         repeat,
           wahlaufforderung,
           read_Char(Ch),
           teste_antwort(X,Ch,Code,_,FolgeRegeln).
   
   
teste_antwort(X,Code,Code,_,FolgeRegeln):-
         option(X,Code,_,FolgeRegeln),!.
teste_antwort(_,'.',_,_,_) :-break.
teste_antwort(X,Ch,Code,_,FolgeRegeln):-  
         (Ch='?';Ch='h'),
          warum(X,'?',Code,FolgeRegeln),!.
   teste_antwort(_,_,_,_,_):-
           nl,write('  Antwort nicht verstanden !'),fail.

warum(X,'?',Code,FolgeRegeln) :-   
          repeat,
            erklaerungen(X,Text),
            nl,writelines(0,Text),nl,
            wahlaufforderung,
            read_Char(Code),
            ( not(member(Code,['?','h'])),!,option(X,Code,_,FolgeRegeln)
            ; fail
            ).



erklaerungen(X,Text) :- clause(erklaerung(X,Text),_).
erklaerungen(_,[' Keine (weitere) Hilfe !']).       

wahlaufforderung :-  write('Ihre Wahl : ').
banner :-   wissensbasis(X),
   writelines(0,['Ich bin die  *** Mini-Shell ***  und kann Sie ueber',
                 X, 'beraten. Wenn Sie meine Fragen nicht verstehen,',
    'geben Sie an Stelle der Menu-Auswahl  ?  ein !']),nl.


auswertung :-   clause(bewertung(Empf),X),X\=true,
                pruefe_Regel(Empf),
                write('Moechten Sie noch einen Ratschlag? (j/n) : '),
                read_Char(Ch),Ch \= j.

pruefe_Regel(Empf):- bewertung(Empf),
                     % retractall(grund(_,_)),
                     ausgabe(Empf).

auswertung :-   clause(bewertung(Empf),true),
                % retractall(grund(_,_)),
                (resultat(F,A),assert(grund(F,A)),fail
                ;bewertung(Empf)).
                                

auswertung :-   nl,tab(10),write('Ich bin ratlos !'),nl.
ausgabe(X) :-   screen_init,
                writelines(0,['Die Pruefung der mir vorliegenden Informationen',
                              'fuehrte zu folgendem Ergebnis :']),nl,
                writelines(8,X),nl,
                write('Denn Sie beantworteten die Frage :'),nl,
                gruende.
gruende :-   retract(grund(Frage,Code)),
               frage(Frage,Text),writelines(8,Text),
               tab(8),write(' *** mit *** '), 
               option(Frage,Code,Antw,_),
               /* writelines(12,Antw), */ write(Antw),nl,
              ( clause(grund(_,_),true),
                write('und'),!,gruende
               ;nl,!).

wenn(X,Y) :-   clause(grund(X,Y),_),!.
wenn(X,Y) :-   resultat(X,Y),assert(grund(X,Y)),!.

writelines(X,[Line|Y]) :-   nl,tab(X),write(Line),!,writelines(X,Y).
writelines(_,[])       :-   !,nl.
writelines(X,Y)        :-   writelines(X,[Y]).

screen_init :- nl.

/* SPROLOG- Variante von readChar/1, liest direkt von der Tastatur  
read_Char(Cs) :- getkbd(Ch),list([Ch],CSs), name(Cs,CSs),!.
getkbd(Ch)    :- seeing(X),see(keyboard),get0(Ch),
                  (32=<Ch,Ch=<127,put(Ch);true),seen,see(X),!.
*/
/* read_char/1 ohne Besonderheiten (Eingabe mit Return beenden):*/
read_Char(Cs) :- get(C),name(Cs,[C]),!,skip(10).

/*-- eof ----*/
