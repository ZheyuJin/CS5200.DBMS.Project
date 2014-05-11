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