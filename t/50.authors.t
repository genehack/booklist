# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan    /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

trap {
  local @ARGV = ( 'authors' );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-error'
);

$trap->stdout_like(
  qr/^###  #bk  author/ ,
  'see expected header'
);
$trap->stdout_like(
  qr/^\s+9\s+1\s+Charles Stross\s*$/m ,
  'see charlie stross at expected position'
);

$trap->stderr_nok(
  'stderr empty'
);


