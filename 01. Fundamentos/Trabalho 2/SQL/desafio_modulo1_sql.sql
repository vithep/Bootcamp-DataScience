/*
ComposiÁ„o de CL√°usar no comando Select:
SELECT: selecionar os campos (* significa todos);
FROM: de tabela origem;
(INNER/RIGHT/LEFT/FULL OUTER) JOIN: com a inclus„o de tabela(s) de relacionamento por intersecÁ„o (INNER), uni„o (FULL OUTER), tabela de origem inteira (LEFT) ou tabela de relacionamento inteira (RIGHT). AlÈm disso, tem a necessidade de informar o campo que liga as tabelas (cl√°usula ON);
WHERE: filtrar por condisıes com 'E' logico (AND) ou 'OU' logico(OR);
GROUP BY: agrupar por campos;
ORDER BY: ordenar pelos campos de forma ascendente (ASC) ou descendente (DESC);
LIMIT: limitar pelos primeiros n registros.

FunÁıes de agregaÁıes ou resumo (utilizadas geralmente em SELECT combinadas geralmente com a cl√°usula GROUP BY):
COUNT: quantidade de registros agrupados (√© poss√≠vel utilizar qualquer campo ou, at√© mesmo, um n√∫mero 1 para identificar um registro da tabela e somar as quantidades);
SUM: somatorio de campo em registros agrupados;
AVG: media de campo em registros agrupados;
MAX: valor maximo de campo em registros agrupados;
MIN: valor minimo de campo em registros agrupados.

OBS(1): Tanto as tabelas quanto os campos apresentados podem ter aliases ou apelidos em portugues
OBS(2): Costuma-se incluir o ; para separar os comandos Select e permitir a execu√ß√£o de cada comando separadamente.
*

INICIO:
CRIAR TABELAS
CREATE TABLE DEPARTAMENTO (DNOME VARCHAR(15) NOT NULL ,DNUMERO INT NOT NULL ,GERSSN CHAR(9) NULL ,GERDATAINICIO DATE,PRIMARY KEY (DNUMERO) ,UNIQUE (DNOME) ,FOREIGN KEY (GERSSN) REFERENCES EMPREGADO(SSN));
CREATE TABLE DEPENDENTE(ESSN CHAR(9) NOT NULL ,NOME_DEPENDENTE VARCHAR(15) NOT NULL,SEX CHAR,DATANASC DATE,PARENTESCO VARCHAR(8) ,PRIMARY KEY (ESSN, NOME_DEPENDENTE) ,FOREIGN KEY (ESSN) REFERENCES EMPREGADO(SSN));
CREATE TABLE DEPTO_LOCALIZACOES (DNUMERO INT NOT NULL,DLOCALIZACAO VARCHAR(15) NOT NULL,PRIMARY KEY (DNUMERO, DLOCALIZACAO) ,FOREIGN KEY (DNUMERO) REFERENCES DEPARTAMENTO(DNUMERO));
CREATE TABLE EMPREGADO( PNOME VARCHAR(15) NOT NULL,DNO INTEGER,MINICIAL CHAR,UNOME VARCHAR(15) NOT NULL,SSN CHAR(9) NOT NULL,DATANASC DATE,ENDERECO VARCHAR(30),SEXO CHAR,SALARIO DECIMAL(10,2),SUPERSSN CHAR(9),PRIMARY KEY(SSN),FOREIGN KEY(SUPERSSN) REFERENCES EMPREGADO(SSN),FOREIGN KEY(DNO) REFERENCES DEPARTAMENTO(DNUMERO));
CREATE TABLE PROJETO (PJNOME VARCHAR(15) NOT NULL ,PNUMERO INT NOT NULL ,PLOCALIZACAO VARCHAR(15),DNUM INT NOT NULL ,PRIMARY KEY (PNUMERO) , UNIQUE (PJNOME) ,FOREIGN KEY (DNUM) REFERENCES DEPARTAMENTO(DNUMERO));
CREATE TABLE TRABALHA_EM (ESSN CHAR(9) NOT NULL ,PNO INT NOT NULL,HORAS DECIMAL(3,1) NOT NULL ,PRIMARY KEY (ESSN, PNO) ,FOREIGN KEY (ESSN) REFERENCES EMPREGADO(SSN) ,FOREIGN KEY (PNO) REFERENCES PROJETO(PNUMERO));
CREATE TABLE demo (ID integer primary key, Name varchar(20), Hint text );

-- Pergunta 8
SELECT
    ROUND(AVG(EM.salario), 2) AS "MÈdia Salarial"
FROM
    empregado AS EM
ORDER BY
    SUM(EM.salario) DESC
;
-- 35125.00

-- Pergunta 9
SELECT
    COUNT(1) AS "Quantidade Empregados"
FROM
    empregado AS EM
INNER JOIN
    trabalha_em AS EMPR ON
        EMPR.essn = EM.ssn
INNER JOIN
    projeto AS PR ON
        PR.pnumero = EMPR.pno
WHERE
    EM.dno = 5
    AND EMPR.horas > 10
    AND PR.pjnome = 'ProductX'
;
-- 2

-- Pergunta 10
SELECT
    COUNT(1) AS "Quantidade Empregados"
FROM
    empregado AS EM
INNER JOIN
    dependente AS DD ON
        DD.essn = EM.ssn
WHERE
    EM.pnome LIKE DD.nome_dependente
;
-- 0

-- Pergunta 11
-- SSN do Franklin: 333445555
SELECT
    EM.pnome AS "Nome Empregado"
FROM
    empregado AS EM
WHERE
    EM.superssn = '333445555'
;

-- Outra forma
SELECT
    EM.pnome AS "Nome Empregado"
FROM
    empregado AS EM
INNER JOIN
    empregado AS SUP ON
        SUP.ssn = EM.superssn
WHERE
    SUP.pnome = 'Franklin'
;
-- Joyce e Ramesh

-- Pergunta 12
SELECT
    EM.pnome AS "Nome Empregado"
FROM
    empregado AS EM
INNER JOIN
    trabalha_em AS EMPR ON
        EMPR.essn = EM.ssn
INNER JOIN
    projeto AS PR ON
        PR.pnumero = EMPR.pno
WHERE
    PR.pjnome LIKE 'Newbenefits'
ORDER BY
    EMPR.horas DESC
LIMIT
    1
;
-- Alicia

-- Pergunta 13
SELECT
    ROUND(SUM(EM.salario), 2) AS "Soma Salarial"
FROM
    empregado AS EM
INNER JOIN
    departamento AS DP ON
        DP.dnumero = EM.dno
WHERE
    DP.dnome LIKE 'Research'
;
-- 133000,00

-- Pergunta 14
-- Sal√°rios Anteriores e Posteriores dos Funcion√°rio
SELECT
    SUM(EM.salario * 1.1) AS "Sal√°rio Final"
FROM
    empregado AS EM
INNER JOIN
    trabalha_em AS EMPR ON
        EMPR.essn = EM.ssn
INNER JOIN
    projeto AS PR ON
        PR.pnumero = EMPR.pno
WHERE
    PR.pjnome LIKE 'ProductX'
;
-- 60500,00

-- Pergunta 15
SELECT
    DP.dnome AS "Departamento",
    AVG(EM.salario) AS "M√©dia Salarial"
FROM
    departamento AS DP
INNER JOIN
    empregado AS EM ON
        EM.dno = DP.dnumero
GROUP BY
    DP.dnome
ORDER BY
    AVG(EM.salario)
LIMIT
    1
;
-- Administration