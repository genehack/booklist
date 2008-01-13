# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

trap {
  local @ARGV = ( 'stats' );
  Booklist::Cmd->run;
};

$trap->leaveby_is(
  'return' ,
  'return on non-err'
);

$trap->stdout_like(
  qr/SAW 4 BOOKS BY 4 AUTHORS/ , 
  'show stats'
);

$trap->stdout_like(
  qr/FINISHED 1 BOOK/ , 
  'show stats'
);

$trap->stderr_nok(
  'stderr silent'
);

