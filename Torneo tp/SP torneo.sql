// Store procedures.
use torneo;

// Agregar un equipo ejercicio 1

CREATE PROCEDURE ADD_TEAM (IN name varchar(50), IN creacion datetime, OUT new_id int)
BEGIN
	insert into equipos (nombre_equipo, fecha_creacion )  values (name, creacion);
	set new_id = LAST_INSERT_ID(); 
END

call ADD_TEAM("Peñarol",now(), @id);
call ADD_TEAM("Estudiantes",now(), @id);
call ADD_TEAM("River Plate",now(), @id);

select * from equipos;

// Agregar un jugador, si no existe el equipo lanzar exception ejercicio 2 

drop procedure ADD_PLAYER;

//option 1

CREATE PROCEDURE ADD_PLAYER (IN pNombre varchar(50), IN pApellido varchar(50), In pIdEquipo int, OUT newId int)
BEGIN
	IF ((select count(id_equipo) from equipos where id_equipo = pIdEquipo) > 0) then 
		insert into jugadores (nombre, apellido, id_equipo) values (pNombre, pApellido, pIdEquipo);
		set newId = LAST_INSERT_ID();
	ELSE
		signal sqlstate '10001' 
		SET MESSAGE_TEXT = 'No existe el quipo', 
		MYSQL_ERRNO = 2.2;
	END IF;
END

// option 2

CREATE PROCEDURE ADD_PLAYER (IN pNombre varchar(50), IN pApellido varchar(50), In pIdEquipo int, OUT newId int)
BEGIN
	IF (Exists(select * from equipos where id_equipo = pIdEquipo)) then 
		insert into jugadores (nombre, apellido, id_equipo) values (pNombre, pApellido, pIdEquipo);
		set newId = LAST_INSERT_ID(); 
	ELSE
		signal sqlstate '10001' 
		SET MESSAGE_TEXT = 'No existe el quipo', 
		MYSQL_ERRNO = 2.2;
	END IF;
END

CALL ADD_PLAYER("Nico","Herrera",4,@id);
CALL ADD_PLAYER("Nico","Herrera",1,@id);
CALL ADD_PLAYER("Miguel","Bacigalupi",1,@id);
CALL ADD_PLAYER("Fran","Franco",2,@id);
CALL ADD_PLAYER("Juan","Dassun",2,@id);

select * from jugadores;

//Generar un Stored Procedure que permita agregar un jugador pero se debe pasar el nombre del equipo y no el Id. Ejercicio 3

drop procedure ADD_PLAYER_WITH_TEAM_NAME;
	
CREATE PROCEDURE ADD_PLAYER_WITH_TEAM_NAME (IN pNombre varchar(50), IN pApellido varchar(50), In nombreEquipo varchar(50), OUT newId int)
BEGIN
	DECLARE pIdEquipo int;
	IF (Exists(select * from equipos where nombre_equipo = nombreEquipo)) then
		select id_equipo into pIdEquipo from equipos where nombre_equipo = nombreEquipo;
		insert into jugadores (nombre, apellido, id_equipo) values (pNombre, pApellido, pIdEquipo);
		set newId = LAST_INSERT_ID();
	ELSE
		signal sqlstate '10001' 
		SET MESSAGE_TEXT = 'No existe el quipo', 
		MYSQL_ERRNO = 2.2;
	END IF;
END


CALL ADD_PLAYER_WITH_TEAM_NAME("Matias","De las heras","River Plate",@id);
CALL ADD_PLAYER_WITH_TEAM_NAME("Bohe","Nespral","asd",@id);
CALL ADD_PLAYER_WITH_TEAM_NAME("Bohe","Nespral","River Plate",@id);


//Generar un Stored Procedure que permita dar de alta un equipo y sus jugadores. Ejercico 4
//Devolver en un parámetro output el id del equipo.

drop procedure ADD_TEAM_WITH_PLAYERS;

CREATE PROCEDURE ADD_TEAM_WITH_PLAYERS (
IN pNombreEquipo varchar(50), pFechaCreacion varchar(50),
IN pNombre1 varchar(50), IN pApellido1 varchar(50),
IN pNombre2 varchar(50), IN pApellido2 varchar(50),
IN pNombre3 varchar(50), IN pApellido3 varchar(50))
BEGIN
	call ADD_TEAM(pNombreEquipo, pFechaCreacion, @pIdEquipo); 
	call ADD_PLAYER(pNombre1, pApellido1, @pIdEquipo, @id);
	call ADD_PLAYER(pNombre2, pApellido2, @pIdEquipo, @id);
	call ADD_PLAYER(pNombre3, pApellido3, @pIdEquipo, @id);
END

call ADD_TEAM_WITH_PLAYERS("Quilmes", now(), "pedro", "alvarez", "juan", "Perez", "Carlos", "Mendez");
call ADD_TEAM_WITH_PLAYERS("Dep Norte", now(), "Agustin", "Bonnet", "Gonzalo", "Sassoni", "Gaston", "Sassoni");

select * from equipos e
join jugadores j 
on e.id_equipo = j.id_equipo;


id_equipo_local int not null ,
id_equipo_visitante int not null,
fecha datetime,

//Generar un Stored Procedure que liste los partidos de un mes y año pasado por parametro. Ejercicio 5

insert into partidos (id_equipo_local, id_equipo_visitante, fecha) values (1, 2, "2020-04-09");
insert into partidos (id_equipo_local, id_equipo_visitante, fecha) values (1, 3, "2020-04-10");
insert into partidos (id_equipo_local, id_equipo_visitante, fecha) values (1, 4, "2020-04-11");

select * from partidos;

drop procedure LIST_MATCH;

CREATE PROCEDURE LIST_MATCH (IN pMonth int, In pYear int)
BEGIN
	select * from partidos p
	where month(p.fecha) = pMonth AND year(p.fecha) = pYear;
END

call LIST_MATCH(4,2020);

//Generar un Stored Procedure que devuelva el resultado de un partido pasando por                           Ejercicio 6
//parámetro los nombres de los equipos. El resultado debe ser devuelto en dos variables output

insert into jugadores_x_partido (id_jugador, id_partido, puntos, rebotes, asistencias) values (4, 1, 30, 1, 2);
insert into jugadores_x_partido (id_jugador, id_partido, puntos, rebotes, asistencias) values (5, 1, 27, 5, 1);

insert into jugadores_x_partido (id_jugador, id_partido, puntos, rebotes, asistencias) values (6, 1, 30, 1, 2);
insert into jugadores_x_partido (id_jugador, id_partido, puntos, rebotes, asistencias) values (7, 1, 27, 5, 1);

select * from jugadores_x_partido jxp ;
select * from partidos;
select * from jugadores;
select * from equipos;

drop procedure ID_MATCH; 

CREATE PROCEDURE ID_MATCH (IN pIdEquipo1 int, IN pIdEquipo2 int, OUT pIdPartido int)
BEGIN		
	select jp.id_partido into pIdPartido from jugadores_x_partido jp
			join partidos p on p.id_partido = jp.id_partido
			where p.id_equipo_local = pIdEquipo1 or p.id_equipo_local = pIdEquipo2
			AND p.id_equipo_visitante = pIdEquipo1 or p.id_equipo_local = pIdEquipo2
			order by p.fecha ASC
			limit 1;
END

CREATE PROCEDURE TEAM_POINTS (IN pEquipo varchar(50), IN pIdPartido int, OUT pPuntos int)
BEGIN
	select SUM(jp.puntos ) into pPuntos from jugadores_x_partido jp
				join jugadores j
				on jp.id_jugador = j.id_jugador
				join equipos e 
				on e.id_equipo = j.id_equipo
				where e.nombre_equipo = pEquipo AND jp.id_partido = pIdPartido
				group by e.id_equipo ;
END

drop procedure MATCH_RESULT ;

CREATE PROCEDURE MATCH_RESULT (IN pEquipo1 varchar(50), IN pEquipo2 varchar(50), OUT pPuntosEquipo1 int, OUT pPuntosEquipo2 int)
BEGIN
	declare idEquipo1 int;
	declare idEquipo2 int;
	select e.id_equipo into idEquipo1 from equipos e where e.nombre_equipo = pEquipo1;
	select e.id_equipo into idEquipo2 from equipos e where e.nombre_equipo = pEquipo2;
	call ID_MATCH (idEquipo1, idEquipo2, @id);
	call TEAM_POINTS(pEquipo1, @id, pPuntosEquipo1);
    call TEAM_POINTS(pEquipo2, @id, pPuntosEquipo2);
END

call MATCH_RESULT("Peñarol", "Estudiantes", @puntosPeñarol, @puntosEstudiantes);
select @puntosPeñarol;
select @puntosEstudiantes;


//Generar un stored procedure que muestre las estadisticas promedio de los jugadores de un equipo. Ejercicio 7

CREATE PROCEDURE TEAM_STADISTICS (IN pTeam varchar(50))
BEGIN
	select avg(jp.puntos) as Puntos, avg(jp.rebotes) as Rebotes, avg(jp.asistencias) as Asistencias, avg(jp.faltas) as Faltas, avg(jp.minutos) as minutos
	from jugadores_x_partido jp
	join jugadores j
	on jp.id_jugador = j.id_jugador
	join equipos e 
	on e.id_equipo = j.id_equipo
	where e.nombre_equipo = pTeam
	group by e.id_equipo ;
END

call TEAM_STADISTICS("Peñarol");
