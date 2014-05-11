---Pay the penalty bill. 
---Can only pay for the most recent one. 
---If there are severla pending penalties, call this function several times.
CREATE OR REPLACE  FUNCTION pay_penalty(_userid integer) RETURNS void AS $$
DECLARE 
	_target_row penalty%ROWTYPE;
BEGIN
	--get the target row. no key defined, therefore get the entire row and use it as key..
	select * 
	from penalty P
	where P.user_id = _userid and P.clear_date is NULL
	limit 1
	into _target_row;
	
	--- not found. error.
	IF NOT FOUND THEN
	    RAISE EXCEPTION 'ERROR: no such a target row with userID:% ', _userid;
	END IF;

	--- clear the pending penalty.
	update penalty P
	set clear_date = now()::date
	where P.user_id = _target_row.user_id 
	and P.issue_date = _target_row.issue_date
	and P.amount = _target_row.amount -- real number comparison for equal is bad coding habit.
	and P.book_borrow_id = _target_row.book_borrow_id
	and P.penalty_reason_id = _target_row.penalty_reason_id;

RETURN;
END;
$$ LANGUAGE plpgsql;