FROM geodan/gost-db:latest

#RUN rm /docker-entrypoint-initdb.d/gost_init_db.sql

COPY pg_dump.sql /docker-entrypoint-initdb.d/gost_init_db.sql

#USER postgres
