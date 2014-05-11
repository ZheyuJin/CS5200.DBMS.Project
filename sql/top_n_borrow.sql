--The top N most borrowed books list within a given periods.
CREATE OR REPLACE  FUNCTION top_n_most_borrowed(_from date, _to date) 
RETURNS table (isbn varchar, title varchar, borrow_count bigint) AS $$
DECLARE 
BEGIN
	IF _from > _to THEN
	    RAISE EXCEPTION 'from date : %d > to date: %d !  ', _from,_to;
	END IF;

	RETURN QUERY 
	select B.isbn, B.title, count(B.isbn) as borrow_count 
	from book_borrow BB
	join book_copy BC on BB.book_copy_id = BC.id
	join book B on B.id = BC.book_id	
	where borrow_date between '2010-01-01'::date and now()::date
	group by B.title, B.isbn
	order by borrow_count desc;
END;
$$ LANGUAGE plpgsql;

--select top_n_most_borrowed('2010-01-01'::date, now()::date);