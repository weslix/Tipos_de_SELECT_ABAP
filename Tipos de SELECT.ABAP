*&---------------------------------------------------------------------*
*& Report  ZSELECT
*& Tipos de SELECT no SAP ABAP
*&---------------------------------------------------------------------*
*& Autor: Wesley Felix
*& Últimas modificações: 24/07/2020
*& Usando como exemplo a tabelas standard Sflight e Spfli
*&---------------------------------------------------------------------*

REPORT  zselect.

DATA: it_sflight TYPE TABLE OF sflight,
      wa_sflight TYPE sflight.

* =============================================================================== *
* Seleção de dados e jogando para uma tabela Interna
* =============================================================================== *
SELECT *
  INTO TABLE it_sflight
  FROM sflight
  WHERE fldate GT sy-datum.
* OBS: GT = >=  ( greater than / Maior ou igual )

* =============================================================================== *
* Seleção de dados e jogando para uma estrutura
* =============================================================================== *
SELECT SINGLE *
  INTO wa_sflight
  FROM sflight
  WHERE fldate GT sy-datum.
* OBS: GT = >=  ( greater than / Maior ou igual )
* OBS: SINGLE = Quando se trata apenas um único registro
* OBS: INTO = s/ TABLE quando se joga para uma estrutura

* =============================================================================== *
* Seleção de dados com mais de um parâmetro de filtro
* =============================================================================== *
SELECT SINGLE *
  INTO wa_sflight
  FROM sflight
  WHERE fldate    GT sy-datum
    AND planetype EQ '747-400'.
* OBS: GT = >=  ( greater than / Maior ou igual )
* OBS: SINGLE = Quando se trata apenas um único registro
* OBS: INTO = s/ TABLE quando se joga para uma estrutura

* =============================================================================== *
* Seleção de dados com mais de um parâmetro de filtro (OR)
* =============================================================================== *
SELECT SINGLE *
  INTO wa_sflight
  FROM sflight
  WHERE fldate GT sy-datum
     OR carrid EQ 'AA'.
* OBS: GT = >=  ( greater than / Maior ou igual )
* OBS: SINGLE = Quando se trata apenas um único registro
* OBS: INTO = s/ TABLE quando se joga para uma estrutura

* =============================================================================== *
* Seleção de dados com apenas alguns campos
* =============================================================================== *
SELECT carrid connid
  INTO TABLE it_sflight UP TO 30 ROWS
  FROM sflight.
* OBS: UP TO 'xx' ROWS = Limita a quantidade de registro que irá trazer

* =============================================================================== *
* Seleção de dados com CORRESPONDING FIELDS
* =============================================================================== *
SELECT SINGLE fldate currency
  INTO CORRESPONDING FIELDS OF wa_sflight
  FROM sflight
  WHERE fldate EQ sy-datum
     OR carrid EQ 'AA'.
* OBS: SINGLE = Quando se trata apenas um único registro
* OBS: INTO = s/ TABLE quando se joga para uma estrutura
* OBS: CORRESPONDING FIELDS = Procura um campo na estrutura WA com os mesmos nomes no SELECT SINGLE, s/ esse comando ele joga no primeiro campo da WA ( Sem se importar, se corresponde os campos )

* =============================================================================== *
* Junção de tabelas no select INNER JOIN
* =============================================================================== *
TYPES: BEGIN OF ty_spfli,
        carrid    TYPE s_carr_id,
        connid    TYPE s_conn_id,
        carrname  TYPE s_carrname,
  END OF ty_spfli.

DATA it_spfli TYPE TABLE OF ty_spfli.

SELECT a~carrid a~connid b~carrname
  INTO TABLE it_spfli
  FROM spfli AS a
  INNER JOIN scarr AS b
  ON a~carrid EQ b~carrid
  WHERE a~countryto EQ 'DE'.
* OBS: AS = Para "aplidar" a tabela
* OBS: ON = Campos em comum entre as tabelas

* =============================================================================== *
* Junção de tabelas com FOR ALL ENTRIES
* =============================================================================== *
DATA it_spfli_c TYPE TABLE OF spfli.
DATA it_scarr   TYPE TABLE OF scarr.

SELECT carrid connid
  INTO CORRESPONDING FIELDS OF TABLE it_spfli_c
  FROM spfli
  WHERE countryto EQ 'DE'.

SELECT carrname
  INTO CORRESPONDING FIELDS OF TABLE it_scarr
  FROM scarr
  FOR ALL ENTRIES IN it_spfli_c
  WHERE carrid EQ it_spfli_c-carrid.
* OBS: INTO CORRESPONDING FIELDS OF TABLE = Procura a mesma coluna do SELECT no it_xxx e armazena os registros nela
* OBS: FOR ALL ENTRIES IN = Sintaxe para entrar apenas registros que estejam no SELECT anterior, correspondendo as duas tabelas ( pelas chaves )
* OBS: É indicado fazer o IF ENDIF. no segundo SELECT ( Caso venha vazio o 1º SELECT, o 2º Trará toda a tabela correspondente )

* =============================================================================== *
* Loop na tabela transparente
* =============================================================================== *
SELECT *
  FROM sflight INTO wa_sflight
  WHERE fldate GE sy-datum.

  WRITE: wa_sflight-carrid, wa_sflight-fldate.
ENDSELECT.
