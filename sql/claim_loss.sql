---Claim a book loss.
--book_copy_id, userID, penalty_amount
CREATE OR REPLACE  FUNCTION claim_loss(bookCopyID integer, userID integer, penalty_amount integer) RETURNS void AS $$

DECLARE 
	book_borrow_id_history  libdb.book_borrow.id%TYPE;
	reason_str varchar :='Losing book';
	_penalty_reason_id  penalty_reason.id%TYPE;
BEGIN
	---find if there is such a book borrow history
	select * from book_borrow BB
	where BB.book_copy_id = bookCopyID and user_id = userID
	order by BB.borrow_date DESC
	limit 1
	into book_borrow_id_history;

	IF NOT FOUND THEN
	    RAISE EXCEPTION 'no such a book borrow history found bookCopyID:% userID:% ', bookCopyID,userID;
	END IF;

	--- get penalty reason
	select id from penalty_reason PR
	where PR.desc = reason_str
	into _penalty_reason_id;

	IF NOT FOUND THEN
	    RAISE EXCEPTION 'no proper penalty reason found, % is searched for.', reason_str ;
	END IF;
	
	--- deduct 1 for book copy count
	update book B
	set copy_count = copy_count-1
	where B.id in (select BC.book_id from book_copy BC where BC.id = bookCopyID);

	
	--- set the book copy lost
	update book_copy BC
	set status = 2 -- book is lost permanently.
	where BC.id =bookCopyID;


	--- mark as the book returned now.
	update book_borrow BB
	set return_date_actual = now()::date
	where BB.book_copy_id = bookCopyID and user_id = userID;

	--- record for penalty
	insert into penalty 
	values (userID, now()::date, null, penalty_amount, book_borrow_id_history,_penalty_reason_id);

	RAISE notice 'done';

RETURN;
END;
$$ LANGUAGE plpgsql;

select claim_loss(509,12, 100000);