# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $today  = App::Booklist->epoch2ymd();

my $title  = 'The Last Colony';
my $author = 'John Scalzi';
my $pages  = 320;

my @args = (
  'add' ,
  '--title'  => $title  ,
  '--author' => $author ,
  '--pages'  => $pages  ,
);   

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-error'
);

$trap->stdout_like (
  qr/Added '$title' to read later/ ,
  'got expected stdout'
);

$trap->stderr_nok(
  'got nothing on stderr'
);

$args[0] = 'start';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-error'
);

$trap->stdout_like (
  qr/Started to read '$title'/ ,
  'got expected stdout'
);

$trap->stderr_nok(
  'got nothing on stderr'
);

$args[0] = 'add';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'exit' ,
  'exit on error'
);

$trap->exit_is(
  1 ,
  'should exit with status 1 when trying to add book already being read'
);

$trap->stdout_nok(
  'and should not send anything to STDOUT when doing so'
);

$trap->stderr_like(
  qr/^You seem to already be reading that book/ ,
  'stderr should have error text however'
);

$trap->stderr_like(
  qr/You started it on $today and have not yet recorded a finish date/ ,
  'stderr should also have the start date'
);
