---Ask library to import a book.

CREATE OR REPLACE  FUNCTION make_a_wish(_userid integer, _isbn varchar) RETURNS void AS $$
DECLARE 
	_the_count integer;
BEGIN
	-- check existence in book table.
	select count(isbn)
	from book B
	where B.isbn= _isbn
	into _the_count;
	---book exists
	IF _the_count <> 0 THEN
	    RAISE EXCEPTION 'ERROR: the book with ISBN:% already exists. ', _isbn;
	END IF;

	--check the existence of user isbn combination in wishilist
	_the_count := 0;
	
	select count(isbn)
	from wishlist W
	where W.isbn = _isbn and W.user_id = _userid
	into _the_count;
	---combination exists
	IF _the_count <> 0 THEN
	    RAISE EXCEPTION 'ERROR: record with user_id:% isbn:% already exists. ', _userid, _isbn;
	END IF;
	
	--insert the book into wishlist.
	insert into wishlist(isbn,request_date,status,user_id)
	values (_isbn, now()::date, 0, _userid);
RETURN;
END;
$$ LANGUAGE plpgsql;

--select make_a_wish(20, 'VERY__POPULAR');