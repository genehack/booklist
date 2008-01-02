-- $Id$
-- $URL$

CREATE TABLE authors (
  id       INTEGER PRIMARY KEY,
  author   TEXT  
);

CREATE TABLE books (
  id       INTEGER PRIMARY KEY,
  pages    INTEGER ,
  title    TEXT 
);

CREATE TABLE authors_books (
  author   INTEGER,
  book     INTEGER,
  PRIMARY KEY (author,book)
);

CREATE TABLE readings (
  id           INTEGER PRIMARY KEY,
  book         INTEGER,
  startdate    INTEGER,
  finishdate   INTEGER,
  rating       INTEGER
);

