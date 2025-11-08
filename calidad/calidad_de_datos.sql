---------------QUERYS-CALIDAD-DE-DATOS--------------
----------------------------------------------------
--COMPLETITUD-L1BOOKS-------------------------------
select * from l1books limit 1; 
select count(*) from l1books;--212404
select count(*) from l1books where authors is not null;--31413
select count(*) from l1books where title is null or upper(title)='NULL' or title='';--1
select count(*) from l1books where description is null or upper(description)='NULL' or description='';--68442
select count(*) from l1books where image is null or upper(image)='NULL' or image='';--52075
select count(*) from l1books where previewlink is null or upper(previewlink)='NULL' or previewlink='';--23836
select count(*) from l1books where publisher is null or upper(publisher)='NULL' or publisher='';--75886
select count(*) from l1books where infolink is null or upper(infolink)='NULL' or infolink='';--23836
select count(*) from l1books where categories is null;--41199
select count(*) from l1books where publisheddate is null or upper(publisheddate)='NULL' or publisheddate='' or publisheddate='0';--25305
--COMPLETITUD-L2BOOKS-------------------------------
select * from l2books limit 1;
select count(*) from l2books;--271379
select count(*) from l2books where isbn is null or upper(isbn)='NULL' or isbn='';--0
select count(*) from l2books where "Book-Title" is null or upper("Book-Title")='NULL' or "Book-Title"='';--0
select count(*) from l2books where "Book-Author" is null or upper("Book-Author")='NULL' or "Book-Author"='';--0
select count(*) from l2books where "Year-Of-Publication" is null OR "Year-Of-Publication"=0;--4619
select count(*) from l2books where Publisher is null or upper(Publisher)='NULL' or Publisher='';--0
select count(*) from l2books where "Image-URL-M" is null or upper("Image-URL-M")='NULL' or "Image-URL-M"='';--0
--COMPLETITUD-l1ratings-----------------------------
select * from l1ratings limit 1;
select count(*) from l1ratings;--3000000
select count(*) from l1ratings where id is null or upper(id)='NULL' or id='';--0
select count(*) from l1ratings where title is null or upper(title)='NULL' or title='';--215
select count(*) from l1ratings where user_id is null or upper(user_id)='NULL' or user_id='';--561787
select count(*) from l1ratings where "review/score" is null;--0
--COMPLETITUD-l2ratings-----------------------------
select * from l2ratings limit 1;
select count(*) from l2ratings;--1149780
select count(*) from l2ratings where "User-ID" is null;--0
select count(*) from l2ratings where isbn is null or upper(isbn)='NULL' or isbn='';--0
select count(*) from l2ratings where "Book-Rating" is null;--0
--COMPLETITUD-L2USERS-------------------------------
select * from l2users limit 1;
select count(*) from l2users where "User-ID" is null;--0
----------------------------------------------------
--UNICIDAD-L1BOOKS----------------------------------
select count(*) from (select title, count(*)-1 as cantDup from l1books group by title having count(*)>1);--0
select count(*) from (select publisher, count(*)-1 as cantDup from l1books group by publisher having count(*)>1);--6752
select count(*) from (select authors, count(*)-1 as cantDup from l1books group by authors having count(*)>1);--22425
select count(*) from (select previewlink, count(*)-1 as cantDup from l1books group by previewlink having count(*)>1);--294
select count(*) from (select infolink, count(*)-1 as cantDup from l1books group by infolink having count(*)>1);--3087
--UNICIDAD-L2BOOKS----------------------------------
select count(*) from (select isbn, count(*)-1 as cantDup from l2books group by isbn having count(*)>1);--0
select count(*) from (select "Book-Title", count(*)-1 as cantDup from l2books group by "Book-Title" having count(*)>1);--19907
select count(*) from (select "Book-Author", count(*)-1 as cantDup from l2books group by "Book-Author" having count(*)>1);--33633
select count(*) from (select Publisher, count(*)-1 as cantDup from l2books group by Publisher having count(*)>1);--7667
select count(*) from (select "Image-URL-L", count(*)-1 as cantDup from l2books group by "Image-URL-L" having count(*)>1);--316
--UNICIDAD-l1ratings--------------------------------
select count(*) from (select id, count(*)-1 as cantDup from l1ratings group by id having count(*)>1);--152425
select count(*) from (select user_id, count(*)-1 as cantDup from l1ratings group by user_id having count(*)>1);--315257
select count(*) from (select title, count(*)-1 as cantDup from l1ratings group by title having count(*)>1);--141178
--UNICIDAD-l2ratings--------------------------------
select count(*) from (select "User-ID", count(*)-1 as cantDup from l2ratings group by "User-ID" having count(*)>1);--46117
select count(*) from (select ISBN, count(*)-1 as cantDup from l2ratings group by ISBN having count(*)>1);--143511
--UNICIDAD-L2USERS----------------------------------
select count(*) from (select "User-ID", count(*)-1 as cantDup from l2users group by "User-ID" having count(*)>1);--0
----------------------------------------------------
--CONSISTENCIA-L1BOOKS------------------------------
select count(*) from l1books where length(publisheddate)<8 or length(publisheddate)>10;--102285
--CONSISTENCIA-L2BOOKS------------------------------
select count(*) from l2books where length(ISBN)<>10;--4
select count(*) from l2books where length("Year-Of-Publication"::TEXT)<>4;--4619
--CONSISTENCIA-l1ratings----------------------------
select count(*) from l1ratings where length(id)<>10;--0
select count(*) from l1ratings where "review/score" < 0 OR "review/score" > 5;--0
--CONSISTENCIA-l2ratings----------------------------
select count(*) from l2ratings where length(ISBN)<>10;--10417
select count(*) from l2ratings where length("Book-Rating"::TEXT)>2 and "Book-Rating"<>'10';--0
--CONSISTENCIA-L2USERS------------------------------
----------------------------------------------------
--INTEGRIDAD-L1-------------------------------------
select count(*) from l1ratings r where not exists (select 1 from l1books b where upper(r.title)=upper(b.title));--1432743
--INTEGRIDAD-L2-------------------------------------
select count(*) from l2users;
select count(*) from l2ratings r where not exists (select 1 from l2books b where upper(r.ISBN)=upper(b.ISBN));--118605
select count(*) from l2ratings r where not exists (select 1 from l2users u where r."User-ID"=u."User-ID");--0
select count(*) from l2users u where not exists (select 1 from l2ratings r where r."User-ID"=u."User-ID");--173575
----------------------------------------------------
----------------------------------------------------
--COMPLETITUD-LNBOOKS-------------------------------
select count(*) from lnbooks;--304806
select count(*) from lnbooks where identifier is null or upper(identifier)='NULL' or identifier='';--0
select count(*) from lnbooks where title is null or upper(title)='NULL' or title='';--4
select count(*) from lnbooks where creator is null or upper(creator)='NULL' or creator='';--1808
select count(*) from lnbooks where description is null or upper(description)='NULL' or description='';--274434
select count(*) from lnbooks where imageurl is null or upper(imageurl)='NULL' or imageurl='';--5424
select count(*) from lnbooks where preview is null or upper(preview)='NULL' or preview='';--264809
select count(*) from lnbooks where publisher is null or upper(publisher)='NULL' or publisher='';--9208
select count(*) from lnbooks where date is null or date=0;--4890
select count(*) from lnbooks where source is null or upper(source)='NULL' or source='';--264809
select count(*) from lnbooks where genres is null;--268220
--UNICIDAD-LNBOOKS----------------------------------
select count(*) from (select identifier, count(*)-1 as cantDup from lnbooks group by identifier having count(*)>1);--0
select count(*) from (select title, count(*)-1 as cantDup from lnbooks group by title having count(*)>1);--31265
select count(*) from (select creator, count(*)-1 as cantDup from lnbooks group by creator having count(*)>1);--36768
select count(*) from (select description, count(*)-1 as cantDup from lnbooks group by description having count(*)>1);--614
select count(*) from (select imageurl, count(*)-1 as cantDup from lnbooks group by imageurl having count(*)>1);--398
select count(*) from (select preview, count(*)-1 as cantDup from lnbooks group by preview having count(*)>1);--247
select count(*) from (select publisher, count(*)-1 as cantDup from lnbooks group by publisher having count(*)>1);--9082
select count(*) from (select date, count(*)-1 as cantDup from lnbooks group by date having count(*)>1);--190
select count(*) from (select source, count(*)-1 as cantDup from lnbooks group by source having count(*)>1);--334
select count(*) from (select genres, count(*)-1 as cantDup from lnbooks group by genres having count(*)>1);--1239
--CONSISTENCIA-LNBOOKS------------------------------
select count(*) from lnbooks where length(date::TEXT)<>4;--4557
select count(*) from lnbooks where length(identifier)<>10;--0
--COMPLETITUD-LNREVIEWS-----------------------------
select count(*) from lnreviews;--1294960
select count(*) from lnreviews where isbn is null or upper(isbn)='NULL' or isbn='';--0
select count(*) from lnreviews where user_id is null or user_id=0;--0
select count(*) from lnreviews where rating is null;--0
--UNICIDAD-LNREVIEWS--------------------------------
select count(*) from (select isbn, count(*)-1 as cantDup from lnreviews group by isbn having count(*)>1);--132933
select count(*) from (select user_id, count(*)-1 as cantDup from lnreviews group by user_id having count(*)>1);--66228
--CONSISTENCIA-LNREVIEWS----------------------------
select count(*) from lnreviews where length(isbn)<>10;--0
--COMPLETITUD-LNUSERS-------------------------------
select count(*) from lnusers;--957549
select count(*) from lnusers where user_id is null or user_id=0;--0
--UNICIDAD-LNUSERS----------------------------------
select count(*) from (select user_id, count(*)-1 as cantDup from lnusers group by user_id having count(*)>1);--0
--CONSISTENCIA-LNUSERS------------------------------
----------------------------------------------------
--INTEGRIDAD-LN-------------------------------------
select count(*) from lnreviews r where not exists(select 1 from lnbooks b where upper(b.identifier)=upper(r.isbn));--0
select count(*) from lnreviews r where not exists(select 1 from lnusers u where u.user_id=r.user_id);--0
select count(*) from lnusers u where not exists(select 1 from lnreviews r where u.user_id=r.user_id);--677505
----------------------------------------------------
----------------------------------------------------