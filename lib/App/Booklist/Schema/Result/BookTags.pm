package App::Booklist::Schema::Result::BookTags;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'book_tags' );

__PACKAGE__->add_columns(
  'book_id' => { data_type => 'INTEGER' , is_foreign_key => 1 } ,
  'tag_id'  => { data_type => 'INTEGER' , is_foreign_key => 1 } ,
);

__PACKAGE__->set_primary_key( 'book_id' , 'tag_id' );

__PACKAGE__->belongs_to(
  'book' => 'App::Booklist::Schema::Result::Books' ,
  { 'foreign.id' => 'self.book_id' } ,
);

__PACKAGE__->belongs_to(
  'tag' => 'App::Booklist::Schema::Result::Tags' ,
  { 'foreign.id' => 'self.tag_id' } ,
);

1;
