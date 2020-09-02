CREATE TABLE public.book (
	id serial NOT NULL,
	title varchar(100) NULL,
	author varchar(100) NULL,
	CONSTRAINT book_pkey PRIMARY KEY (id)
);

GRANT ALL ON table book TO ngbilling;
GRANT ALL ON DATABASE bookdb TO ngbilling;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ngbilling;
