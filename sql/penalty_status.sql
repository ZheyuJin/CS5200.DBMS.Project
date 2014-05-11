--A user’s penalty status.
CREATE OR REPLACE  FUNCTION penalty_status(_userid int) 
RETURNS table (issue_date date, clear_date date, amount real
	,des varchar, title varchar) AS $$
DECLARE 
BEGIN

RETURN QUERY 
select P.issue_date, P.clear_date, P.amount, PR.desc, B.title
from penalty P
join penalty_reason PR on PR.id = P.penalty_reason_id
join book_borrow BB on P.book_borrow_id = BB.id
join book_copy BC on BC.id = BB.book_copy_id
join book B on B.id = BC.book_id
where P.user_id = _userid
order by P.issue_date desc;
END;
$$ LANGUAGE plpgsql;

--select penalty_status(12);