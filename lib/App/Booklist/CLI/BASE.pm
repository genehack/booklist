package App::Booklist::CLI::BASE;
use Moose;
use namespace::autoclean;
use FindBin;
use 5.010;
extends 'MooseX::App::Cmd::Command';
with 'MooseX::SimpleConfig';

has file => (
  isa => 'Str' ,
  is  => 'rw' ,
  documentation => 'Location of DB file.' ,
  traits => [qw(Getopt)],
  default => "$FindBin::Bin/../db/booklist.db",
);
1;
