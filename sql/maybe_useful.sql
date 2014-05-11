/*
set search_path TO libdb;

select * from author;
select * from authorize;
select * from book;
select * from book_borrow;
select * from book_copy;
select * from bookshelf;
select * from building;
select * from category;
select * from libdb.location;
select * from occupation;
select * from penalty;
select * from penalty_reason;
select * from publisher;
select * from sub_category;
select * from libdb.user;
select * from wishlist;

--- penalty & penalty reason 
select * from  penalty P
join penalty_reason PR on P.penalty_reason_id = PR.id;

---book & publisher
select isbn, title, name from book B
join publisher P on P.id = B.publisher_id;

---book & book_copy
select isbn, bookshelf_id, status from book_copy BC
join book B on B.id = BC.book_id;

*/



-- CREATE OR REPLACE  FUNCTION XX() RETURNS void AS $$
-- 
DECLARE 

BEGIN
	---find if there is such a book borrow history
	IF NOT FOUND THEN
	    RAISE EXCEPTION 'no such a book borrow history found bookCopyID:% userID:% ', bookCopyID,userID;
	END IF;

RETURN;
END;
$$ LANGUAGE plpgsql;





--Search books.ISBN

CREATE OR REPLACE  FUNCTION search_isbn(_isbn varchar) RETURNS TABLE
(isbn varchar,title varchar, year int, pages int, des varchar, price real, 
copy_count int, pub_name varchar) AS $$
DECLARE 

BEGIN
	RETURN QUERY
	select B.isbn, B.title, date_part('year',B.year)::integer , B.pages::integer, 
	B.desc, B.price, B.copy_count::integer, P.name
	from book B 
	join Publisher P on P.id = B.publisher_id
	where B.isbn = _isbn;

END;
$$ LANGUAGE plpgsql;

--select  * from search_isbn('XDG2G8FV1TMWL0');



--Search books. Autor or Title
CREATE OR REPLACE  FUNCTION search_autor_title(varchar) RETURNS TABLE
(isbn varchar,title varchar, year int, pages int, des varchar, price real,  
copy_count int, pub_name varchar) AS $$
DECLARE 
	_search_str varchar := '%' || $1 || '%';
BEGIN
	RETURN QUERY
	select B.isbn, B.title, date_part('year',B.year)::integer , B.pages::integer, 
	B.desc, B.price, B.copy_count::integer, P.name
	from book B 
	join Publisher P on P.id = B.publisher_id
	join authorize AZ on AZ.book_id = B.id
	join author A on AZ.author_id = A.id
	where 
		(B.title like _search_str)
		or
		(A.firstname like _search_str
		or A.lastname like _search_str
		or A.middlename like _search_str);


END;
$$ LANGUAGE plpgsql;

select  * from search_autor_title('5P');
















