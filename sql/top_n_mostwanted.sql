
--The top N most wanted books at the moment.
CREATE OR REPLACE  FUNCTION top_n_most_wanted(_n int) 
RETURNS table (_isbn varchar, _wanted_count bigint) AS $$
DECLARE 
BEGIN

	RETURN QUERY 
	select W.isbn, count(W.isbn) as _wanted_count 
	from wishlist W
	group by W.isbn
	order by _wanted_count desc
	limit _n;
	
END;
$$ LANGUAGE plpgsql;