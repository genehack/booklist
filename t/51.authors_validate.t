# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan    /;
use Test::Trap    qw/ trap $trap /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

trap {
  local @ARGV = ( 'authors' , 'foo' );
  Booklist::Cmd->run;
};

$trap->leaveby( 
  'die' ,
  'die on bad args'
);

$trap->die_like(
  qr/No args allowed/ ,
  'arguments are not allowed'
);

