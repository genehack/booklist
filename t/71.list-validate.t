# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

trap {
  local @ARGV = ('list','foo');
  App::Booklist->run;
};

$trap->leaveby_is(
  'die' ,
  'die on bad args'
);

$trap->die_like(
  qr/No args allowed/ ,
  'thou shalt have no other args before me'
);

