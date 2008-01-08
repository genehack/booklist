# -*- cperl -*-
# $Id$
# $URL$

use Test::More     qw/ no_plan /;
use Test::Output   qw/ stdout_from /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

my @args = ( 'authors' , 'foo' );   

my $error;
my $stdout = do {
  local @ARGV = ( 'authors' , 'foo' );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $error , qr/No args allowed/ ,
  'arguments are not allowed';

