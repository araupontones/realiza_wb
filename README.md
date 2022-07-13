# Realiza

# Dependencies
plyr,dplyr, httr, jsonlite,rio, araupontones/gmdacr

# Dashboard

## Look up tables

This are created once via `R_/0.LookUps/create_lookup_tables.R`. Run this file to update the look up tables. The lookup tables are saved in `data/0look_ups`





Attendance tracker for the realiza program

# Data base

## Cidades

-   Beira

-   Maputo

-   Nampula

## Grupos

-   SGR : = Realiza & Cresça
-   SGR + FNM : Realiza & Movimenta
-   FNM: Realiza & Conecta

In Maputo: 4 SGR + FNM, 4 FNM

In Beira: 2 SGR + FNM , 2FNM

In Nampula : same as Beira

## Tematicas

The tematicas are linked to the workshops tematicos, emprendoras must
attend at least one workshop of each.

1.  Procurement,

2.  Finanças,

3.  Recursos Humanos,

4.  Novas Tecnologias,

5.  Marketing,

6.  Serviços Legais ,

7.  Vendas.

## Sectores

The sectores are linked to the mulher para mulher activities,
emprendoras must attend at least one workshop of each.

1.  Alimentício,

2.  Estética,

3.  Revenda de produtos,

4.  Entretenimento,

5.  Serviços em geral,

6.  Educação

## Agentes

16 agents who made the registration of the emprendedoras to the
different activities every two months (during the individual sessions).

-   40 emprendedoras by agente.
-   The agente schedules the activity of each emprendedora every two
    months

## Facilitadoras

Details of facilitadoras, associated with Turmas

## Actividades

**Preguntas**

## Emprendedoras

Personal details of emprendedoras, associated with cidade, turma, agente

## Parceiros

Details of parceiros, associated with tematicas and sectores.

## Follow ups

Via phone or during the one to one sessions.

-   Consigio informacao

-   Engago com contacto

-   Consiguio servicios

# Dashboard

To manage the implementation:

-   Schedule events and activities

-   See the agenda of the participants

-   Track attendance: every fatla, a MSN will be sent, every 2 faltas, a
    follow up call should be trigger

# Roles and responsibilities

## Data manager

This person is responsible to guarantee that all the data is enter
timely and with no errors into the database. They will have to
coordinate with the agentes, facilitadoras, and all the stakeholders
during the whole time of the implementation.

Moreover, they will be in charge of populating the information of the
emprendedoras (associate them to a turma and to their agente).

## Agentes

They will be responsible to schedule the events and activities of their
participants every two months and to report their attendance status for
each of these activities.

## Facilitadoras

How do the sessoes fixas work? are they divided into groups? How many
groups per city? And names?

# Useful resources

Code Meaning %S second (00-59) %M minute (00-59) %l hour, in 12-hour
clock (1-12) %I hour, in 12-hour clock (01-12) %H hour, in 24-hour clock
(01-24) %a day of the week, abbreviated (Mon-Sun) %A day of the week,
full (Monday-Sunday) %e day of the month (1-31) %d day of the month
(01-31) %m month, numeric (01-12) %b month, abbreviated (Jan-Dec) %B
month, full (January-December) %y year, without century (00-99) %Y year,
with century (0000-9999)
