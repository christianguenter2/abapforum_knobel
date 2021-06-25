*&---------------------------------------------------------------------*
*& Report ztest_puzzle
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zss_knobel_2021_06 LINE-SIZE 1000.

CLASS lcl DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES: BEGIN OF ts_result,
             offset TYPE i,
             tier   TYPE string,
           END OF ts_result.
    TYPES: tt_results TYPE STANDARD TABLE OF ts_result WITH EMPTY KEY.
    METHODS:
      constructor,
      main,
      your_analysis IMPORTING iv_order          TYPE string
                    RETURNING VALUE(rt_results) TYPE tt_results.

    DATA: mt_tiere TYPE STANDARD TABLE OF string WITH EMPTY KEY.

ENDCLASS.

PARAMETERS: p_order TYPE string LOWER CASE DEFAULT '32 Pfannkuchen mit Apfelmus und 3x Schlemmerplatte rot/weiß'.

END-OF-SELECTION.

  NEW lcl( )->main( ).

CLASS lcl IMPLEMENTATION.

  METHOD your_analysis.

    rt_results = REDUCE #(
                   INIT result = VALUE tt_results(  )
                   FOR tier IN mt_tiere
                     LET search_string = tier(3) IN
                   FOR occ = 1 WHILE occ <= count( val = p_order sub = search_string case = abap_false )
                     LET offset = find( val = p_order sub = search_string case = abap_false occ = occ ) IN
                   NEXT result = COND #(
                                   WHEN offset = -1 THEN result
                                   ELSE VALUE #( BASE result ( offset = offset tier = tier ) ) ) ).

    SORT rt_results BY offset.

  ENDMETHOD.

  METHOD main.
    DATA(lt_suspects) = me->your_analysis( p_order ).
    LOOP AT lt_suspects ASSIGNING FIELD-SYMBOL(<ls_suspect>).
      AT FIRST.
        WRITE:/ 'Verdächtige Bestellung :', p_order.
      ENDAT.
      NEW-LINE.
      POSITION 20.
      IF <ls_suspect>-offset > 0.
        WRITE p_order(<ls_suspect>-offset) NO-GAP.
      ENDIF.
      WRITE p_order+<ls_suspect>-offset(3) COLOR 6 NO-GAP.
      DATA(lv_offset_plus_3) = <ls_suspect>-offset + 3.
      IF lv_offset_plus_3 < strlen( p_order ).
        WRITE p_order+lv_offset_plus_3 NO-GAP.
      ENDIF.

      WRITE AT 120 <ls_suspect>-tier COLOR 7.
    ENDLOOP.
  ENDMETHOD.

  METHOD constructor.
    DATA: lv_tiere TYPE string.
    lv_tiere =  'Aal;Bandwurm;Coyote;Eber;Fasan;Gans;Hahn;Igel;Kabeljau;Lama;Made;Nacktmull;Panda;Rabe;Sardelle;Tarantel;Wal;Yak'
             && ';Adler;Bär;Dachs;Echse;Faultier;Geier;Hai;Iltis;Käfer;Nashorn;Ratte;Säbelzahntiger;Waran;Zander'
             && ';Affe;Barsch;Delfin;Eichhörnchen;Flamingo;Gemse;Hamster;Impala;Kamel;Nilpferd;Papagei;Raupe;Salamander;Tausendfüßler;Zebra'
             && ';Aguti;Beluga;Dodo;Eisbär;Floh;Gepard;Heilbutt;Ibis;Känguruh;Laus;Makrele;Ochse;Pelikan;Reh;Thunfisch;Wasserbüffel;Ziege'
             && ';Alligator;Biber;Dogge;Elch;Flunder;Giraffe;Hering;Jaguar;Karpfen;Leguan;Manta;Okapi;Pfau;Rentier;Tiger;Weinbergschnecke;Zitronenfalter'
             && ';Ameisenbär;Biene;Dompfaff;Emu;Forelle;Goldfisch;Hirsch;Katze;Lemming;Marabu;Orang-Utan;Pferd;Riesenkrake;Seeadler;Tintenfisch;Wespe'
             && ';Amöbe;Bison;Dorsch;Ente;Frosch;Gorilla;Holzwurm;Klapperschlange;Leopard;Maulwurf;Otter;Pinguin;Robbe;Silberfisch;Trampeltier;Wiesel'
             && ';Amsel;Blattlaus;Drossel;Esel;Fuchs;Grizzlybär;Hornisse;Koala;Libelle;Pottwal;Rochen;Spatz;Truthahn;Windhund'
             && ';Assel;Grauwal;Eule;Guppy;Huhn;Kranich;Löwe;Meerschwein;Puma;Rotkehlchen;Specht;Tsetsefliege;Wolf'
             && ';Auster;Bonobo;Hummer;Kröte;Luchs;Mistkäfer;Pute;Spinn;Uhu;Wombat'
             && ';Büffel;Hund;Kuh;Lurch;Milbe;Qualle;Stachelschwein;Vielfraß;Wurm;Bussard;Hyäne;Mondfisch;Stör;Vogelspinne;Motte;Schwein;Möwe;Mungo;Mücke;Murmeltier;Muschel'.
    SPLIT lv_tiere AT ';' INTO TABLE me->mt_tiere.

  ENDMETHOD.

ENDCLASS.
