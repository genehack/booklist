package App::Booklist::Form::Add::Tag;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Tags' );

has_field name => (
  type              => 'Text' ,
  label             => 'Tag Name' ,
  size              => 50 ,
  maxsize           => 255 ,
  required          => 1 ,
  required_message  => 'Please supply a tag name' ,
);

has_field submit => (
  type  => 'Submit' ,
  value => 'Add Tag'
);
