package App::Booklist::Schema::Result::Books;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'books' );

__PACKAGE__->add_columns(
  'id'      => { data_type => 'INTEGER' , is_auto_increment => 1 } ,
  'title'   => { data_type => 'VARCHAR' , size => 255 } ,
  'isbn'    => { data_type => 'VARCHAR' , size => 13  , is_nullable => 1 } ,
  'pages'   => { data_type => 'INTEGER' , size => 5   , is_nullable => 1 } ,
  'pubyear' => { data_type => 'INTEGER' , size => 4   , is_nullable => 1 } ,
);

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many(
  'author_books' => 'App::Booklist::Schema::Result::AuthorBooks' ,
  { 'foreign.book_id' => 'self.id' } ,
);
__PACKAGE__->many_to_many( 'authors' , 'author_books' , 'author' );

__PACKAGE__->has_many(
  'book_tags' => 'App::Booklist::Schema::Result::BookTags' ,
  { 'foreign.book_id' => 'self.id' } ,
);
__PACKAGE__->many_to_many( 'tags' , 'book_tags' , 'tag' );

__PACKAGE__->has_many(
  'book_readings' => 'App::Booklist::Schema::Result::Readings' ,
  { 'foreign.book_id' => 'self.id' } ,
);
__PACKAGE__->many_to_many( 'readings' , 'book_readings' , 'reading' );

1;
