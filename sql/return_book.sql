--return a book
CREATE OR REPLACE  FUNCTION return_a_book(_userid integer, _book_copy_id integer) RETURNS void AS $$
DECLARE 
BEGIN
	update book_borrow BB
	set return_date_actual = now()::date
	where BB.user_id = _userid 
	and BB.book_copy_id = _book_copy_id
	and BB.return_date_actual is null;
RETURN;
END;
$$ LANGUAGE plpgsql;

select return_a_book(12, 509);
