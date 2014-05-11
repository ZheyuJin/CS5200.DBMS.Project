-- Borrow Books
--- Search books.ISBN
DROP FUNCTION borrow_book;
-- userID, book_cpoy_number, borrow_period
CREATE OR REPLACE  FUNCTION borrow_book( integer, integer, integer ) RETURNS integer AS $$
	IF (select BC.status from book_copy BC where BC.id = $2) = 1 THEN
		insert into book_borrow (user_id, book_copy_id, borrow_date , return_date_expected) 
		values ($1, $2, now()::date, (now()::date + ($3 * interval '1 day') )::date);
	END IF;
$$ LANGUAGE SQL;

select  borrow_book(12,509,30);