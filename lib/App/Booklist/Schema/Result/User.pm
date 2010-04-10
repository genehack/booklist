package App::Booklist::Schema::Result::User;
use strict;
use warnings;
use 5.010;
use base 'DBIx::Class::Core';

__PACKAGE__->table( 'user' );

__PACKAGE__->add_columns(
  'id'       => { data_type => 'INTEGER' , is_auto_increment => 1 } ,
  'username' => { data_type => 'VARCHAR' , size => 255 } ,
  'password' => { data_type => 'VARCHAR' , size => 255 } ,
);

__PACKAGE__->set_primary_key( 'username' , 'password' );

1;
