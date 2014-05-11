SET search_path TO libdb;
create role web_admin; /*admin with web interface*/
create role local_admin;/*admin with local machine*/
create role web_client; /*users form web interface*/


/*schema level*/
GRANT USAGE ON SCHEMA libdb
to web_admin, local_admin, web_client;


/* table level for admin*/
GRANT  ALL ON TABLE 
publisher, sub_category, category, penalty_reason, 
book, book_copy, penalty, authorize, bookshelf,
author,location, book_borrow, libdb.user, 
building, occupation, wishlist
TO web_admin, local_admin;


/* table level for web_client*/

GRANT select ON TABLE
publisher, sub_category, category, penalty_reason, 
book, book_copy, penalty, authorize, bookshelf,
author,location, book_borrow, libdb.user, 
building, occupation, wishlist
TO web_client;

GRANT update on TABLE
penalty, book_borrow
TO web_client;

GRANT insert on TABLE
penalty, book_borrow, wishlist
TO web_client;

/* TABLE LIST:
publisher, sub_category, category, penalty_reason, 
book, book_copy, penalty, authorize, bookshelf,
author,location book_borrow, user, 
building, occupation, wishlist
*/