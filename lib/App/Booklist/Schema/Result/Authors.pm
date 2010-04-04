package App::Booklist::Schema::Result::Authors;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'authors' );

__PACKAGE__->add_columns(
  'id'    => { data_type => 'INTEGER' , is_auto_increment => 1 } ,
  'lname' => { data_type => 'TEXT'    , size => 255 } ,
  'fname' => { data_type => 'TEXT'    , size => 255 } ,
);

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many(
  'author_books' => 'App::Booklist::Schema::Result::AuthorBooks' ,
  { 'foreign.author_id' => 'self.id' } ,
);

__PACKAGE__->many_to_many( 'books' , 'author_books' , 'book' );

sub full_name {
  my( $self ) = shift;

  return sprintf '%s %s' , $self->fname , $self->lname;
}

1;
