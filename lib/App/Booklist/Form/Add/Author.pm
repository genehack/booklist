package App::Booklist::Form::Add::Author;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Authors' );

has_field fname => (
  type              => 'Text' ,
  label             => 'First Name' ,
  size              => 50 ,
  maxsize           => 255 ,
  required          => 1 ,
  required_message  => 'Please supply a first name' ,
);

has_field lname => (
  type              => 'Text' ,
  label             => 'Last Name' ,
  size              => 50 ,
  maxsize           => 255 ,
  required          => 1 ,
  required_message  => 'Please supply a last name' ,
);

has_field submit => (
  type  => 'Submit' ,
  value => 'Add Author'
);
