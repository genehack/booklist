package App::Booklist::Form::Add::Book;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Authors' );

has_field title => (
  type             => 'Text' ,
  label            => 'Title' ,
  size             => 50 ,
  maxsize          => 255 ,
  required         => 1 ,
  required_message => 'Please supply a title' ,
);

has_field author => (
  type             => 'Select' ,
  label            => 'Author' ,
  required         => 1 ,
  required_message => 'Please choose an author' ,
);

has_field isbn => (
  type             => 'Text' ,
  label            => 'ISBN' ,
  size             => 20 ,
  maxsize          => 20 ,
);

has_field pages => (
  type    => 'Text' ,
  label   => 'Pages' ,
  size    => 4 ,
  maxsize => 4 ,
);

has_field pubyear => (
  type    => 'Text' ,
  label   => 'Publication Year' ,
  size    => 4 ,
  maxsize => 4 ,
);

has_field submit => (
  type  => 'Submit' ,
  value => 'Add Book'
);
