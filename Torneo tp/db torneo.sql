drop database torneo;

create database torneo;
USE torneo;

CREATE TABLE equipos ( 
id_equipo int auto_increment primary key,
nombre_equipo varchar(50),
fecha_creacion datetime,
CONSTRAINT UNQ_EQUIPOS_NOMBRE_EQUIPO UNIQUE (nombre_equipo));

ALTER  TABLE equipos ADD COLUMN fecha_creacion date not null;

CREATE TABLE partidos(
id_partido int AUTO_INCREMENT primary key,
id_equipo_local int not null ,
id_equipo_visitante int not null,
fecha date,
CONSTRAINT FK_PARTIDOS_ID_EQUIPO_LOCAL_EQUIPOS foreign key (id_equipo_local) references equipos(id_equipo),
CONSTRAINT FK_PARTIDOS_ID_EQUIPO_VISITANTE_EQUIPOS  foreign key (id_equipo_visitante) references equipos(id_equipo));

create table jugadores ( 
id_jugador int auto_increment primary key,
nombre varchar(50),
apellido varchar(50),
id_equipo int,
CONSTRAINT fk_jugadores_jugadores_equipos foreign key (id_equipo) references equipos(id_equipo)); 

ALTER TABLE jugadores modify column id_equipo int not null;

create table jugadores_x_partido (
id_jugador_x_partido int auto_increment primary key,
id_jugador int,
id_partido int,
puntos int,
rebotes int,
asistencias int,
minutos int,
faltas int,
constraint fk_jugadores_x_partido_jugadores foreign key (id_jugador) references jugadores(id_jugador),
constraint fk_jugadores_x_partido_partidos foreign key (id_partido) references partidos(id_partido));
