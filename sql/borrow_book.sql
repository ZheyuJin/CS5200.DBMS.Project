
--- get user borrow limit
CREATE OR REPLACE  FUNCTION get_borrow_limit(_userid integer) RETURNS integer AS $$

DECLARE 
	_limit integer;
	_count integer;
BEGIN
	select count(*) 
	from libdb.user U
	where U.id = _userid
	into _count;
	---no such a user.
	IF _count = 0 THEN
	    RAISE EXCEPTION 'no such a userid:% ', _userid;
	END IF;

	select borrow_limit 
	from occupation O
	join libdb.user U on O.id = U.occupation_id
	where U.id = _userid
	into _limit;
RETURN _limit;
END;
$$ LANGUAGE plpgsql;

--Borrow a book
CREATE OR REPLACE  FUNCTION borrow_a_book(_userid integer, _book_copy_id integer, _days integer) RETURNS void AS $$
DECLARE 
	_count integer;
	_now date := now()::date;
	_return_date date := _now + _days * '1 day'::interval;
	_current_borrow_count  integer;
	_borrow_limit integer :=get_borrow_limit(_userid);
BEGIN

	--get current borrow count
	select count(*)
	from book_borrow BB
	where BB.user_id = _userid and return_date_actual is null
	into _current_borrow_count;
	
	--check borrow limit
	IF _current_borrow_count  >= _borrow_limit THEN
	    RAISE EXCEPTION 'cannot borrow more, limit %, current borrowed: %',_borrow_limit,_current_borrow_count ;
	END IF;
	
	-- insert into book_borrow
	insert into book_borrow(user_id, book_copy_id, borrow_date, return_date_expected)
	values (_userid, _book_copy_id, _now, _return_date );
	--change book_copy item status.

	update book_copy BC
	set status = 0
	where id = _book_copy_id;
RETURN;
END;
$$ LANGUAGE plpgsql;

--select borrow_a_book(12, 509, 30);