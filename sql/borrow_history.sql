--A user’s borrow history
CREATE OR REPLACE  FUNCTION borrow_history(_userid int) 
RETURNS table (user_id integer, borrow_date date, return_date_expected date, return_date_actual date
	,isbn varchar, title varchar, author varchar) AS $$
DECLARE 
BEGIN

RETURN QUERY 
select BB.user_id, BB.borrow_date,BB.return_date_expected, BB.return_date_actual, 
B.isbn, B.title, (A.firstname || ' ' || A.lastname)::varchar as author  
from book_borrow BB
join book_copy BC on BB.book_copy_id = BC.id
join book B on B.id = BC.book_id
join authorize AZ on AZ.book_id = B.id
join author A on A.id = AZ.author_id
where BB.user_id = _userid
order by BB.borrow_date desc;
END;
$$ LANGUAGE plpgsql;

select borrow_history(12);