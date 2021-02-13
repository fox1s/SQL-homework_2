# 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select *
from client
where length(FirstName) < 6;
#################################################################################

# 2. +Вибрати львівські відділення банку.+
select *
from department
where DepartmentCity = 'Lviv';
#################################################################################

# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select *
from client
where Education = 'high'
order by LastName;
#################################################################################

# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select *
from application
order by idApplication DESC limit 5 offset 5;
#################################################################################
# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select *
from client
where LastName like '%OV'
   or '%OVA';

#################################################################################
# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.

select idClient,
       FirstName,
       LastName,
       Education,
       City,
       DepartmentCity
from client
         join department d on d.idDepartment = client.Department_idDepartment
where d.DepartmentCity = 'Kyiv';

#################################################################################
# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
select FirstName, Passport
from client
group by FirstName;

#################################################################################
# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select idClient,
       FirstName,
       LastName,
       City,
       Sum,
       CreditState
from client
         join application a on client.idClient = a.Client_idClient
where Sum > 5000;

#################################################################################
# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(idClient), City
from client
         join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'lviv';

select count(idClient)
from client;

#################################################################################
# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select Client_idClient, max(Sum)
from application
group by Client_idClient;

#################################################################################
# 11. Визначити кількість заявок на крдеит для кожного клієнта.
select count(Client_idClient), FirstName, LastName
from application
         join client c on c.idClient = application.Client_idClient
group by Client_idClient;

# 12. Визначити найбільший та найменший кредити.
select max(Sum) as max, min(Sum) as min
from application;

#################################################################################
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select count(idApplication), FirstName, LastName
from application
         join client c on c.idClient = application.Client_idClient
where Education = 'high'
group by Client_idClient;

#################################################################################
# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select avg(Sum) as max, FirstName, LastName
from client
         join application a on client.idClient = a.Client_idClient
group by Client_idClient
order by max desc
limit 1;

#################################################################################
# 15. Вивести відділення, яке видало в кредити найбільше грошей

select DepartmentCity, sum(Sum) as sum
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by idDepartment
order by sum desc
limit 1;

#################################################################################
# 16. Вивести відділення, яке видало найбільший кредит.
select max(Sum), idDepartment, DepartmentCity
from application
         join client c on c.idClient = application.Client_idClient
         join department d on d.idDepartment = c.Department_idDepartment;

#################################################################################
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application
    join client c on c.idClient = application.Client_idClient
set Sum      = 6000,
    Currency = 'Gryvnia'
where Education = 'high';

#################################################################################
# 18. Усіх клієнтів київських відділень пересилити до Києва.
update client
    join department d on d.idDepartment = client.Department_idDepartment
set City = 'Kyiv'
where DepartmentCity = 'Kyiv';

#################################################################################
# 19. Видалити усі кредити, які є повернені.

delete
from application
where CreditState = 'Returned';

#################################################################################
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
# delete from application where

#################################################################################
#################################################################################
#################################################################################
# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select DepartmentCity, Department_idDepartment, sum(Sum) as sum
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
where DepartmentCity = 'Lviv'
group by idDepartment;


#################################################################################
# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

select Client_idClient, FirstName, LastName
from client
         join application a on client.idClient = a.Client_idClient
where a.CreditState = 'Returned'
  and Sum > 5000;

#################################################################################
# /* Знайти максимальний неповернений кредит.*/
select idApplication, max(Sum)
from application
where CreditState != 'Returned';

#################################################################################
# /*Знайти клієнта, сума кредиту якого найменша*/
select sum(Sum) as sum, idClient, FirstName, LastName
from application
         join client c on c.idClient = application.Client_idClient
group by idClient
order by sum
limit 1;

#################################################################################
# /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
select idApplication, Sum
from application
where Sum > (select avg(Sum) from application)
group by idApplication;

#################################################################################
# /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
select *
from client
where City = (select City
              from application
                       join client c on c.idClient = application.Client_idClient
              group by idClient
              order by count(Client_idClient) desc
              limit 1);

#################################################################################
# #місто чувака який набрав найбільше кредитів

select City, count(idClient), idClient, FirstName, LastName
from client
         join application a on client.idClient = a.Client_idClient
group by Client_idClient
order by COUNT(Client_idClient) desc limit 1;


#################################################################################
# set sql_safe_updates = 0;
# set sql_safe_updates = 1;
