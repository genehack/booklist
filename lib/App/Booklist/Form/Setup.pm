package App::Booklist::Form::Setup;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has_field username => (
  type              => 'Text' ,
  label             => 'Username' ,
  size              => 12 ,
  maxsize           => 50 ,
  required          => 1 ,
  required_message  => 'Please supply a username' ,
);

has_field password => (
  type              => 'Password' ,
  label             => 'Password' ,
  size              => 12 ,
  maxsize           => 50 ,
  required          => 1 ,
  required_message  => 'Please supply a password' ,
);

has_field submit => (
  type  => 'Submit' ,
  value => 'Complete Booklist Setup'
);

