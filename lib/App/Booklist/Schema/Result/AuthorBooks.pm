package App::Booklist::Schema::Result::AuthorBooks;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'author_books' );

__PACKAGE__->add_columns(
  'author_id' => { data_type => 'INTEGER' , is_foreign_key => 1 } ,
  'book_id'   => { data_type => 'INTEGER' , is_foreign_key => 1 } ,
);

__PACKAGE__->set_primary_key( 'author_id' , 'book_id' );

__PACKAGE__->belongs_to(
  'author' => 'App::Booklist::Schema::Result::Authors' ,
  { 'foreign.id' => 'self.author_id' } ,
);

__PACKAGE__->belongs_to(
  'book' => 'App::Booklist::Schema::Result::Books' ,
  { 'foreign.id' => 'self.book_id' } ,
);

1;
