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
  qr/1: Orbital Resonance by John Barnes/ ,
  'list unread'
);

$trap->stderr_nok(
  'stderr silent'
);

