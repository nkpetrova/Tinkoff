-- Пилоты
CREATE TABLE Pilots(
    pilot_id int identity(1,1) constraint PK_Pilots primary key,
    name nvarchar(100),
    age int,
    rank int,
    education_level nvarchar(max)
)

-- Самолеты
CREATE TABLE Airplanes(
    plane_id int identity(1,1) constraint PK_Airplanes primary key,
    capacity int,
    cargo_flg bit
)

-- Рейсы
CREATE TABLE Flights(
    flight_id int identity(1,1),
    flight_dt date,
    plane_id int references Airplanes(plane_id),
    first_pilot_id int references Pilots(pilot_id),
    second_pilot_id int references Pilots(pilot_id),
    destination nvarchar(max),
    quantity int,
    PRIMARY KEY (flight_id, flight_dt)
)

-- Задача 1. Напишите запрос, который выведет пилотов, которые в качестве второго пилота в августе этого года трижды ездили в аэропорт Шереметьево.
SELECT p.name FROM PILOTS p JOIN FLIGHTS f ON (p.pilot_id = f.second_pilot_id) WHERE YEAR(f.flight_dt) = YEAR(current_timestamp)
AND MONTH(f.flight_dt) = 8 AND destination = 'Шереметьево' GROUP BY p.name HAVING COUNT(flight_id) = 3

-- Задача 2. Выведите пилотов старше 45 лет, совершали полеты на самолетах с количеством пассажиров больше 30.
SELECT DISTINCT p.name FROM PILOTS p JOIN FLIGHTS f ON ((p.pilot_id = f.second_pilot_id) or (p.pilot_id = f.first_pilot_id)) JOIN Airplanes a ON 
(a.plane_id = f.plane_id) WHERE p.age > 45 AND a.cargo_flg = 0 AND a.capacity > 30 

-- Задача 3. Выведите ТОП 10 пилотов-капитанов (first_pilot_id), которые совершили наибольшее число грузовых перелетов в этом году.
SELECT TOP(10) p.name FROM PILOTS p JOIN FLIGHTS f ON (p.pilot_id = f.first_pilot_id) JOIN Airplanes a ON 
(a.plane_id = f.plane_id) WHERE a.cargo_flg = 1 AND YEAR(f.flight_dt) = YEAR(current_timestamp) GROUP BY p.name ORDER BY COUNT(f.flight_id) DESC