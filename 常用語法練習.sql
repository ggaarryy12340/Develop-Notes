--1、查詢“c001”課程比“c002”課程成績高的所有學生的學號； 
select a.sno from
(select sc.* from sc where sc.cno = 'c001')a,
(select sc.* from sc where sc.cno = 'c002')b
where a.sno = b.sno and a.score > b.score 

--2、查詢平均成績大於60 分的同學的學號和平均成績；
select sc.sno, avg(sc.score) from sc sc
group by sc.sno
having AVG(sc.score)>60 

--3、查詢所有同學的學號、姓名、選課數、總成績； 
select s.sno, s.sname, count(sc.score), sum(sc.score) from sc
left join student s on s.sno = sc.sno
group by s.sno, s.sname

--4、查詢姓“劉”的老師的個數； 
select count(t.tno) from teacher t where t.tname like '劉%' 

--5、查詢沒學過“諶燕”老師課的同學的學號、姓名；
select s.sno,s.sname from student s 
where s.sno
not in 
(select distinct sc.sno from sc sc
left join student s on s.sno = sc.sno,
	(select c.cno from course c, 
		(select t.tno from teacher t where t.tname = '諶燕')a
	where c.tno = a.tno)b  
where sc.cno = b.cno)

--6、查詢學過“c001”並且也學過編號“c002”課程的同學的學號、姓名； 
--7、查詢學過“諶燕”老師所教的所有課的同學的學號、姓名；
select distinct sc.sno, s.sname from sc sc
left join student s on s.sno = sc.sno,
	(select c.cno from course c, 
		(select t.tno from teacher t where t.tname = '諶燕')a
	where c.tno = a.tno)b  
where sc.cno = b.cno

--8、查詢課程編號“c002”的成績比課程編號“c001”課程低的所有同學的學號、姓名； 
select a.sno, s.sname from 
(select sc.* from sc sc where sc.cno = 'c001')a,
(select sc.* from sc sc where sc.cno = 'c002')b
left join student s on s.sno = b.sno
where a.sno = b.sno and a.score > b.score

--9、查詢所有課程成績小於60 分的同學的學號、姓名；
select sc.sno, s.sname, sc.score from sc sc
left join student s on sc.sno = s.sno
where sc.score < 60  

--10、查詢沒有學全所有課的同學的學號、姓名； 
select sc.sno, s.sname, count(sc.sno)from sc sc
left join student s on s.sno = sc.sno
group by sc.sno, s.sname
having count(sc.sno) < (select count(c.cno) from course c)

--11、查詢至少有一門課與學號为“s001”的同學所學相同的同學的學號和姓名； 
select sc.sno 
(select sc.cno from sc sc where sc.sno = 's001')a

--12、查詢至少學過學號为“s001”同學所有一門課的其他同學學號和姓名； 
select distinct sc.sno, s.sname from sc sc
left join student s on s.sno = sc.sno
where sc.cno in 
(select sc.cno from sc sc where sc.sno = 's001')

--13、把“SC”表中“諶燕”老師教的課的成績都更改为此課程的平均成績； 
select sc.cno, avg(sc.score) from sc,
(select c.cno from course c, 
		(select t.tno from teacher t where t.tname = '諶燕')a
where c.tno = a.tno)b
where sc.cno = b.cno  
group by sc.cno 

--14、查詢和“s001”號的同學學習的課程完全相同的其他同學學號和姓名； 


--15、刪除學習“諶燕”老師課的SC 表記錄； 
select sc.* from sc where sc.cno in
(select c.cno from course c, 
		(select t.tno from teacher t where t.tname = '諶燕')a
where c.tno = a.tno)

--16、向SC 表中插入一些記錄，這些記錄要求符合以下條件：沒有上過編號“c002”課程的同學學號、“c002”號課的平均成績； 
--17、查詢各科成績最高和最低的分：以如下形式顯示：課程ID，最高分，最低分 
select sc.cno, MAX(sc.score) as 最高分, Min(sc.score) as最低分 from sc sc 
group by sc.cno

--18、按各科平均成績從低到高和及格率的百分數從高到低順序 
select sc.cno, 
avg(sc.score),
sum(case when sc.score >= 60 then 1 else 0 end)/count(sc.sno)
from sc sc
group by sc.cno
order by avg(sc.score)

--19、查詢不同老師所教不同課程平均分從高到低顯示 
select c.cno, t.tname ,AVG(sc.score) from sc
left join course c on c.cno = sc.cno
left join teacher t on c.tno = t.tno 
group by c.cno, t.tname
order by AVG(sc.score) desc

--20、統計列印各科成績,各分數段人數:課程ID,課程名稱,[100-85],[85-70],[70-60],[ <60] 
select sc.cno, c.cname,
sum(case when sc.score between 85 and 100 then 1 else 0 end) as '[100-85]',
sum(case when sc.score between 70 and 85 then 1 else 0 end) as '[85-10]',
sum(case when sc.score between 60 and 70 then 1 else 0 end) as '[70-60]',
sum(case when sc.score <60 then 1 else 0 end) as '[<60]'
from sc sc 
left join course c on c.cno = sc.cno
group by sc.cno, c.cname

--21、查詢各科成績前三名的記錄:(不考慮成績並列情況) 
--22、查詢每門課程被選修的學生數 
select sc.cno, count(sc.sno) from sc sc
group by sc.cno

--23、查詢出只選修了一門課程的全部學生的學號和姓名 
select s.sno, s.sname, count(sc.sno) from sc sc
left join student s on s.sno = sc.sno
group by s.sno, s.sname
having count(sc.sno) = 1

--24、查詢男生、女生人數 
select count(s.sno) from student s group by s.ssex

--25、查詢姓“張”的學生名單 
select s.* from student s where s.sname like '張%'

--26、查詢同名同性學生名單，並統計同名人數 
select s.sname, count(s.sname) from student s 
group by s.sname 
having count(s.sname) > 1

--27、1981 年出生的學生名單(注：Student 表中Sage 列的類型是number) 
select s.* from student s where 2016 - s.sage < 1981

--28、查詢每門課程的平均成績，結果按平均成績升序排列，平均成績相同時，按課程號降序排列 
select sc.cno, avg(sc.score) 
from sc sc 
group by sc.cno 
order by avg(sc.score) asc,
sc.cno desc

--29、查詢平均成績大於85 的所有學生的學號、姓名和平均成績 
select s.sno, s.sname, AVG(sc.score) from sc sc
left join student s on s.sno = sc.sno
group by s.sno, s.sname
having AVG(sc.score) > 85

--30、查詢課程名稱为“數據庫”，且分數低於60 的學生姓名和分數 
select s.sname, sc.score, c.cname from sc
left join student s on s.sno = sc.sno
left join course c on c.cno = sc.cno 
where c.cname = '數據庫' and sc.score < 60

--31、查詢所有學生的選課情況； 
select sc.sno, count(sc.cno) from sc
group by sc.sno

--32、查詢任何一門課程成績在70 分以上的姓名、課程名稱和分數； 
select s.sname, c.cname, sc.score from sc sc
join student s on s.sno = sc.sno
join course c on c.cno = sc.cno 
where sc.score > 70

--33、查詢不及格的課程，並按課程號從大到小排列 
select s.sname, c.cname, sc.score from sc sc
join student s on s.sno = sc.sno
join course c on c.cno = sc.cno 
where sc.score < 60
order by sc.cno asc

--34、查詢課程編號为c001 且課程成績在80 分以上的學生的學號和姓名； 
select s.sno, s.sname, sc.score from sc sc 
left join student s on s.sno = sc.sno
where sc.score > 80

--35、求選了課程的學生人數 
select count(a.次數) from
(select count(sc.score) as 次數 from sc sc group by sc.sno)a
having count(a.次數) > 0

--36、查詢選修“諶燕”老師所授課程的學生中，成績最高的學生姓名及其成績 
select st.sname,score from student st,sc ,course c,teacher t 
where 
st.sno=sc.sno and sc.cno=c.cno and c.tno=t.tno 
and t.tname='諶燕' and sc.score= 
(select max(score)from sc where sc.cno=c.cno) 

--37、查詢各個課程及相應的選修人數 
select sc.cno, count(sc.sno) from sc
group by sc.cno

--38、查詢不同課程成績相同的學生的學號、課程號、學生成績 
select sc.sno, sc.cno, sc.score from sc

--39、查詢每門功課成績最好的前兩名 
--40、統計每門課程的學生選修人數（超過10 人的課程才統計）。要求輸出課程號和選修人數，查詢結果按人數降序排列，若人數相同，按課程號升序排列 
select sc.cno, count(sc.sno) from sc sc 
group by sc.cno
having  count(sc.sno) > 10
order by count(sc.sno) asc, sc.cno desc

--41、檢索至少選修兩門課程的學生學號 
select sc.sno, count(sc.cno) from sc
group by sc.sno
having count(sc.cno) >= 2

--42、查詢全部學生都選修的課程的課程號和課程名 
select count(sc.sno), sc.cno, c.cname from sc sc
left join course c on c.cno = sc.cno
group by sc.cno, c.cname
having count(sc.sno) = (select count(s.sno) from student s)

--43、查詢沒學過“諶燕”老師講授的任一門課程的學生姓名 
select s.sname from student s 
where s.sno
not in 
(select distinct sc.sno from sc sc
left join student s on s.sno = sc.sno,
	(select c.cno from course c, 
		(select t.tno from teacher t where t.tname = '諶燕')a
	where c.tno = a.tno)b  
where sc.cno = b.cno)

--44、查詢兩門以上不及格課程的同學的學號及其平均成績 
select sc.sno, avg(sc.score) 
from (select sc.*, sc. from)sc 
group by sc.sno

--45、檢索“c004”課程分數小於60，按分數降序排列的同學學號 
select sc.sno from sc sc where sc.cno = 'c004' and sc.score < 60 order by sc.sno asc

--46、刪除“s002”同學的“c001”課程的成績 
select sc.score from sc sc where sc.sno = 's002' and sc.cno = 'c001'