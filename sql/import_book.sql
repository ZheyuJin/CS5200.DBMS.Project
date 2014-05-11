--import a book
CREATE OR REPLACE  FUNCTION import_a_book(_isbn varchar, _title varchar, _publisher_id integer, _pub_year integer, 
_pages integer, _price real, _desc varchar, _sub_category integer, _copy_count integer ) RETURNS void AS $$
DECLARE 
	
	_AD date := '0001-01-01'::date;
	_year date := _AD + _pub_year * interval '1 year'; --smart.
	_book_id integer;
BEGIN
	insert into book (isbn ,title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count)
	values (_isbn, _title, _publisher_id, _year, _pages::smallint, _price, _desc, _sub_category, _copy_count::smallint);

	--get book id
	select B.id 
	from book B
	where B.isbn=_isbn
	into _book_id;

	FOR i IN 1.._copy_count LOOP
		insert into book_copy(book_id, status)
		values (_book_id, 1); -- 1 means available in the library.
	END LOOP;		
RETURN;
END;
$$ LANGUAGE plpgsql;

--select import_a_book('test-import2', 'test-title-import', 10, 1998, 203, 102, 'this book is more than 100 dolars.', 60, 50 );