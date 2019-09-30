/*

ORDINEA APELARII:

1. cream baza de date proiect si o selectam ca baza de date curenta
2. cream si apelam procedura tabele(), din Proceduri
3. cream functia format_data(), din Functii
4. cream triggerele fill_fulldate si fill_from_veche din Triggers
5. apelam LOAD DATA din Populare tabele
6. cream si apelam rutina rapoarte(), din Proceduri

-- OPTIONAL --

* Am implementat un view care sa recreeze tabela veche din noile tabele, in OPTIONAL - View old_table
* La pasul 4 putem sa nu cream view-ul fill_from_veche, ci sa cream procedura populeaza_tabele() din Proceduri, pe care sa o apelam la pasul 5, dupa LOAD DATA

*/