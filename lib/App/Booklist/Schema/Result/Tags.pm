package App::Booklist::Schema::Result::Tags;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'tags' );

__PACKAGE__->add_columns(
  'id'   => { data_type => 'INTEGER' , is_auto_increment => 1 } ,
  'name' => { data_type => 'VARCHAR' , size => 255 } ,
);

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->add_unique_constraint([ 'name' ]);

__PACKAGE__->has_many(
  'book_tags' => 'App::Booklist::Schema::Result::BookTags' ,
  { 'foreign.tag_id' => 'self.id' } ,
);
__PACKAGE__->many_to_many( 'books' , 'book_tags' , 'book' );

1;
