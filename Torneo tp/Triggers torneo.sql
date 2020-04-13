use torneo;

//Generar un trigger que evite la carga de jugadores con el mismo nombre y apellido en el mismo equipo. ejercicio 1 y 2

drop trigger tbi_jugadores;

CREATE TRIGGER tbi_jugadores before insert on jugadores FOR EACH ROW
BEGIN 
	IF (Exists(select * from jugadores j where  j.id_equipo = new.id_equipo and j.nombre = "Nico" and j.apellido = "Herrera")) then
		signal sqlstate '10001' 
		SET MESSAGE_TEXT = 'El jugador ya se encuentra en la base de datos', 
		MYSQL_ERRNO = 2.2;
	END IF;
END 

call ADD_player("Nico", "Herrera", 1, @id);
call ADD_player("Nico", "Herrera", 4, @id);

select * from jugadores;
select * from jugadores_x_partido;
select * from partidos;

// Generar un trigger que no permita ingresar los datos de un jugador a la tabla jugadores_x_equipo_x_partido q​ue no haya juado el partido.

CREATE TRIGGER tbi_jugadores_x_partido before insert on jugadores_x_partido FOR EACH ROW 
BEGIN 
	declare idEquipo int;
	select j.id_equipo into idEquipo from jugadores j where id_jugador = new.id_jugador;
	
END 

select j.id_equipo from jugadores j where id_jugador = 4;