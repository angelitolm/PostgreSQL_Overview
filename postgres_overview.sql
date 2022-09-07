-- Algunos Objetivos a vencer

-- - Implememtar consultas de mediana y alta complejidad usando las sentencias del lenguaje SQL
-- - Implementar vistas
-- - Implementar funciones
-- - Implementar comportamiento activo en la base de datos con el uso de trigger
-- - Implementar sentencias que respondan a requisitos informacionales de seguridad de bases de datos

-- **************************************************************************************************
-- Resumen de Usuarios, Roles y Permisos (DCL)
-- **************************************************************************************************

-- Para crear un usuario de PostgreSQL, utilice la siguiente instrucción SQL:
CREATE USER myuser WITH PASSWORD 'secret_passwd';
-- También puede crear un usuario con la siguiente instrucción SQL:
CREATE ROLE myuser WITH LOGIN PASSWORD 'secret_passwd';

-- Crear un nuevo rol
comando: CREATE ROLE <role>;
Ejemplo: CREATE ROLE backend_services;
CREATE ROLE backend_services_2 WITH LOGIN; -- para permitir hacer login porque tiene ese permiso.

-- crear un rol con contraseña
CREATE ROLE <role> WITH LOGIN PASSWORD '<password>';

-- Borrar un rol existente
Comando: DROP ROLE <role>; 
Ejemplo: DROP ROLE backend_services;

-- Añadir permisos a roles
Comando: ALTER ROLE <role> WITH LOGIN;
Ejemplo: ALTER ROLE backend_services_2 WITH LOGIN;

-- Dar permisos a usuario
GRANT ALL PRIVILEGES ON DATABASE tu_bd TO tu_usuario;

-- Dar permisos a usuario a todas las tablas
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO tu_usuario;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO tu_usuario;

-- la opcion WITH GRANT OPTION permite heredar a todos sus hijos las mismas propiedades del padre
-- la opcion CASCADE permite eliminar de forma recurisva a todos sus hijos sus propiedades

-- Permisos disponibles
LOGIN/ NOLOGIN: -- permitir (o no) iniciar sesión en PostgreSQL.
SUPERUSER/ NOSUPERUSER: -- permite (o no) permisos de superusuario (*).
CREATEDB/ NOCREATEDB: -- permite (o no) la capacidad de crear nuevas bases de datos.
CREATEROLE/ NOCREATEROLE: vpermite (o no) la capacidad de crear nuevos roles.
CREATEUSER/ NOCREATEUSER: -- permite (o no) la capacidad de crear nuevos usuarios.
INHERIT/ NOINHERIT: -- permite (o no) la capacidad de hacer que los privilegios se pueda heredar.
REPLICATION/ NOREPLICATION: -- concede (o no) permisos de replica.

-- Gestión de permisos por roles grupales
-- Crear un rol grupal
Comando: CREATE ROLE <groupname>;
Ejemplo: CREATE ROLE developers WITH SUPERUSER;

-- Asignar un grupo a un rol
Comando: GRANT <groupname> TO <role>
Ejemplo: GRANT developers TO backend_services_2;

-- Eliminar un grupo a un rol
Comando: REVOKE <groupname> FROM <role>
Ejemplo: REVOKE developers FROM backend_services_2;


* CREATE USER <name> WITH [LOGIN PASSWORD SUPERUSER CREATEDB CREATEROLE CREATEUSER INHERIT]
* CREATE ROLE <name> WITH [LOGIN PASSWORD SUPERUSER CREATEDB CREATEROLE CREATEUSER INHERIT]

* GRANT <privileges_list | ALL PRIVILEGES> ON <table_name> TO <user>
* GRANT <privileges_list | ALL PRIVILEGES> ON <table_name> TO <user | group | role> WITH GRANT OPTION -- permitir que los hijos hereden sus props
* GRANT <group_privileges> TO <suer>;
* GRANT UPDATE <table_field> ON TABLE <table_name> TO <user>;

privileges_list = [SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES TRIGGER CREATE CONNECT TEMPORARY EXECUTE USAGE ALL]

* REVOKE <privileges_list | ALL> ON <table_name> FROM [user, group, role] [CASCADE]

* DROP OWNED BY <user>; -- quitar todas las relaciones que pueda tener un usuario para poder ser eliminado
* DROP USER <user>; -- elimarn usuario

-- **************************************************************************************************
-- DML
-- **************************************************************************************************
* SELECT <columns> FROM <table_name> WHERE [condition];
* INSERT INTO <table_name> (column1, column2, column3) VALUES (value1, value2, value3);
* INSERT INTO <table_name_1> (column1, column2, column3) SELECT column1, column2, column3 FROM <table_name_2> WHERE [condition];

* UPDATE <table_name> SET column1 = value1, column2 = value2...., columnN = valueN WHERE [condition];

* DELETE FROM <table_name> WHERE [condition];

* SELECT <columns>, COUNT(colum_a) FROM <table_name_1>
JOIN <table_name_2> USING(colum_b)
WHERE [condition]
GROUP BY colum_a
HAVING COUNT(colum_a) > (SELECT COUNT(colum_a) FROM <table_name_3> 
WHERE [condition]
ORDER BY colum_c [ASC | DESC];


-- Transiciones SQL proporciona las siguientes funciones agregadas:
APPROX_COUNT_DISTINCT
AVG
CHECKSUM_AGG
COUNT
COUNT_BIG
GROUPING
GROUPING_ID
MAX
MIN
STDEV
STDEVP
STRING_AGG
SUM
VAR
VARP



-- **************************************************************************************************
-- FUNCTINOS
-- **************************************************************************************************
CREATE FUNCTION <function_name>(.....)
DECLARE

<variables locales> <type> = <value>


BEGIN
  <instruction blocks>
END;

-- Conditions   
IF <CONDITION>
    THEN
      <instruction blocks>
    ELSE EXIT;
END IF;

-- Loops
WHILE counter <= 100 LOOP

END LOOP;



-- **************************************************************************************************
-- VIEWS
-- **************************************************************************************************
CREATE VIEW <view_name> (<params>)
AS <query>



-- **************************************************************************************************
-- TRIGGERS
-- **************************************************************************************************
-- Sintaxis de una funcion trigger
CREATE FUNCTION <trigger_function_name>()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $$
DECLARE

BEGIN

END;
$$;


-- Sintaxis de un trigger
CREATE TRIGGER <trigger_name> 
	[BEFORE | AFTER | INSTEAD OF] 
	[INSERT OR UPDATE OR DELETE OR TRUNCATE] 
ON <table_name>

FOR EACH ROW
<query> | EXECUTE PROCEDURE <function_trigger>();




-- **************************************************************************************************
-- Ejercicios Prácticos
-- **************************************************************************************************

Las relaciones siguientes, se corresponden con las tablas de la BD de una central 
telefónica.
cliente (persona, telef) 
cliente_servicio (servicio, cliente) 
especialista (obrero, cargo) 
llamada (cod_llamada, cliente, telef_marcado, fecha, hora_inicio, hora_fin) 
obrero (obrero, salario, annos_exp, grado_esc) 
persona (ci, nombre_completo, direccion)
servicio_suplementario (cod_serv, descripcion, importe)
Se necesita implementar los mecanismos de seguridad que permitan darle cumplimiento 
a los siguientes requerimientos:

	1. Cree un usuario “programador” con contraseña “prog2012”, cuyos privilegios 
	puedan ser heredados por otros usuarios en el momento en que los mismos se 
	creen.

	R:/ CREATE ROLE programador WITH LOGIN PASSWORD 'prog2012' INHERIT;

	2. Configure el servidor para que este usuario se pueda conectar desde una única 
	dirección IP, que le orientará su profesor, a la base de datos que se creó 
	anteriormente y a la base de datos postgres. El método de identificación debe ser 
	md5.

	3. Cree un rol administrador con contraseña “adminsistema” con permiso para iniciar 
	sección en el servidor.

	R:/ CREATE ROLE administrador WITH LOGIN PASSWORD 'adminsistema';

	4. Configure el servidor para permitir que el usuario administrador pueda conectarse 
	a todas las bases de datos del servidor desde cualquier máquina de la subred del 
	laboratorio y desde un IP externo que indique el profesor. Si se conecta desde un 
	IP externo, el método de identificación debe ser trust, pero si se conectan desde 
	una dirección de la subred, el método debe ser md5.


	5. Crear dos grupos de usuarios llamados “especialistas” y “clientes”, los cuales deben 
	tener acceso a consultar la información de las tablas LLAMADA, 
	SERVICIO_SUPLEMENTARIO, y CLIENTE_SERVICIO; y los especialistas 
	además podrán gestionar totalmente la tabla SERVICIO_SUPLEMENTARIO.

	CREATE GROUP especialistas WITH SELECT ON TABLES SERVICIO_SUPLEMENTARIO AND CLIENTE_SERVICIO;
	CREATE GROUP clientes WITH SELECT ON TABLES SERVICIO_SUPLEMENTARIO AND CLIENTE_SERVICIO;


-- **************************************************************************************************
-- RESPUESTAS DE LA 2PP DE SBD
-- **************************************************************************************************
1-
  a) CREATE USER candidato WITH CREATEROLE;
     GRANT SELECT, INSERT, UPDATE, DELETE ON medico TO candidato;

  b) GRANT colaboradores TO candidato;

  c) GRANT UPDATE (tipo) ON TABLE mision TO candidato;

  d) REVOKE DELETE ON medico FROM candidato;
 
  e) DROP OWNED BY candidato;
     DROP USER candidato;


2-
  a) UPDATE medico_mision SET tiempo = tiempo / 3 FROM medico WHERE id_medico = idmed AND especialidad = 'Neurocirugía';

  b) 
    ------ QUERY 
    SELECT p.nombre, COUNT(mm.idmed) AS cant_medicos, round(AVG(me.edad), 2) AS prom_edad FROM medico_mision AS mm
    JOIN medico AS me ON me.id_medico = mm.idmed
    JOIN mision AS mi ON mi.idmision = mm.id_mision
    JOIN pais AS p ON p.idpais = mi.idpais
    JOIN region AS r USING(idregion)
    WHERE r.tipo = (
        SELECT r.tipo FROM pais AS pa
        JOIN region AS r USING(idregion)
        WHERE pa.nombre = 'Kenya'
    )
    GROUP By p.nombre
    HAVING COUNT(mm.idmed) > 3700 AND AVG(me.edad) < (
        SELECT MIN(m.edad) FROM medico AS m WHERE m.especialidad = 'Cardiología'
    )
    ORDER BY p.nombre;


    ------ VIEW
    CREATE OR REPLACE VIEW public."getMisionCountryName"
    AS
     SELECT p.nombre, count(mm.idmed) AS cant_medicos, round(avg(me.edad), 2) AS prom_edad FROM medico_mision mm
	 JOIN medico me ON me.id_medico = mm.idmed
	 JOIN mision mi ON mi.idmision = mm.id_mision
	 JOIN pais p ON p.idpais = mi.idpais
	 JOIN region r USING (idregion)
	 WHERE r.tipo = (
	 	( 
	 		SELECT r_1.tipo FROM pais pa
	        JOIN region r_1 USING (idregion)
	        WHERE pa.nombre = 'Kenya'::text
	    )
	 )
	 GROUP BY p.nombre
	 HAVING count(mm.idmed) > 3700 AND avg(me.edad) < 
	 (
	 	( 
	 		SELECT min(m.edad) AS min FROM medico m
	        WHERE m.especialidad = 'Cardiología'::text
	    )
	 )::numeric
	 ORDER BY p.nombre;



3-
  a)
DECLARE
currentDate date = now();
numberOfMissions integer = 0;
lastMision integer = null;

BEGIN
  
  SELECT COUNT(idmision) FROM medico_mision AS mm
  JOIN mision AS mi ON mm.id_mision = mi.idmision
  JOIN medico AS me ON mm.idmed = me.id_medico
  WHERE me.id_medico = idmed INTO numberOfMissions;
  
  SELECT MAX(idmision) FROM mision INTO lastMision;
  
  IF fecha_inicio < currentDate AND tiempo < 365
    THEN 
      IF numberOfMissions > 3
        THEN 
          INSERT INTO medico_mision(id_mision, idmed, fecha_inicio, tiempo) 
          VALUES(lastMision, idmed, fecha_inicio, tiempo);
      ELSE
          INSERT INTO medico_mision(id_mision, idmed, fecha_inicio, tiempo) 
          VALUES(idmision, idmed, fecha_inicio, tiempo);
      END IF;
  END IF;

  return SELECT me.nombre, mi.nombre, mm.fecha_inicio, mm.tiempo FROM medico_mision AS mm
         JOIN mision AS mi ON mm.id_mision = mi.idmision
         JOIN medico AS me ON mm.idmed = me.id_medico
         ORDER BY me.nombre LIMIT 10;

END;




DECLARE
currentDate date = now();
numberOfMissions integer = 0;
lastMision integer = null;
results text;

BEGIN
  
  SELECT COUNT(mm.id_mision) FROM medico_mision AS mm
  JOIN mision AS mi ON mm.id_mision = mi.idmision
  JOIN medico AS me ON mm.idmed = me.id_medico
  WHERE me.id_medico = id_med INTO numberOfMissions;
  
  SELECT MAX(idmision) FROM mision INTO lastMision;
  
  IF fecha_inicio < currentDate AND tiempo < 365
    THEN 
      IF numberOfMissions > 3
        THEN 
          INSERT INTO medico_mision(id_mision, idmed, fecha_inicio, tiempo) 
          VALUES(lastMision, id_med, fecha_inicio, tiempo);
      ELSE
          INSERT INTO medico_mision(id_mision, idmed, fecha_inicio, tiempo) 
          VALUES(id_mis, id_med, fecha_inicio, tiempo);
      END IF;
  END IF;

  SELECT me.nombre, mi.nombre, mm.fecha_inicio, mm.tiempo FROM medico_mision AS mm
         JOIN mision AS mi ON mm.id_mision = mi.idmision
         JOIN medico AS me ON mm.idmed = me.id_medico
         ORDER BY mm.fecha_inicio, me.anno_graduado ASC LIMIT 10 INTO results;
  
  return results;

END; 

SELECT public."asignarMedicoAMision"(
	1, 
	4, 
	'2019-05-22', 
	250
)





-- **************************************************************************************************
-- Ejemplo práctico II
-- **************************************************************************************************
CREATE TABLE products (
    name varchar(20),
	amount smallint,
	price smallint,
	lastUpdate timestamp
);

-- CREATE FUNCTION
CREATE OR REPLACE FUNCTION validateProduct ()
RETURNS TRIGGER
AS
$BODY$
BEGIN
	IF NEW.name IS NULL OR length(NEW.name) = 0 THEN
		RAISE EXCEPTION 'The name is not null or empty';
		RETURN;
	END IF;
	IF NEW.price < 0 THEN
		RAISE EXCEPTION 'The product not cointain a valid price';
		RETURN;
    END IF;
	IF NEW.amount < 0 THEN
		RAISE EXCEPTION 'The product not cointain a valid amount';
		RETURN;
	END IF;
	
	NEW.lastUpdate = now();
	
	RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql';

-- CREATE TRIGGER
CREATE TRIGGER validateProduct
BEFORE INSERT OR UPDATE
ON products
FOR EACH ROW EXECUTE PROCEDURE validateProduct();

SELECT * FROM products;
SELECT * FROM audit_products;

INSERT INTO products (name, price, amount) VALUES('papa', 15, 420);
DELETE FROM products WHERE name = 'yuca';
UPDATE products SET amount=55 WHERE name = 'papa';

-- CREATE AUDIT TABLE
CREATE TABLE audit_products(
	action varchar(20),
	date timestamp,
	name varchar(20),
	amount smallint,
	price smallint
);


-- CREATE FUNCTION TIGGER FOR AUDITS
CREATE OR REPLACE FUNCTION productAudit()
RETURNS TRIGGER
AS
$$
BEGIN
	IF TG_OP ='INSERT' THEN
		INSERT INTO audit_products (action, date, name, amount, price)
		VALUES ('INSERTAR', now(), NEW.name, NEW.amount, NEW.price);
		RETURN NEW;
	ELSEIF TG_OP = 'DELETE' THEN
		INSERT INTO audit_products (action, date, name, amount, price)
		VALUES ('BORRAR', now(), OLD.name, OLD.amount, OLD.price);
		RETURN NULL;
	ELSEIF TG_OP = 'UPDATE' THEN
		INSERT INTO audit_products (action, date, name, amount, price)
		VALUES ('ANTES DE ACTUALIZAR', now(), OLD.name, OLD.amount, OLD.price);

		INSERT INTO audit_products (action, date, name, amount, price)
		VALUES ('DESPUES DE ACT', now(), NEW.name, NEW.amount, NEW.price);
		RETURN NEW;
	END IF;
END;
$$
LANGUAGE 'plpgsql';

-- CREATE AUDIT PRODUCT
CREATE TRIGGER productAudit AFTER INSERT OR UPDATE OR DELETE
ON products
FOR EACH ROW EXECUTE PROCEDURE productAudit();
