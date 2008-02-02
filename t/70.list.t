# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my @args = ( 'list' );   

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on normal'
);

$trap->stdout_like(
  qr/1: Orbital Resonance by John Barnes/ ,
  'list unread'
);

$trap->stderr_nok(
  'stderr silent'
);

my $old_stdout = $trap->stdout;

push @args , '--unfinished';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

is( $trap->stdout , $old_stdout ,
    '--unfinished and default output are the same' );

trap {
  local @ARGV = ( 'list' , '--read' );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-error'
);

$trap->stdout_like(
  qr/2: Thud by Terry Pratchett/ ,
  'list read'
);

$trap->stderr_nok(
  'stderr silent'
);

my $title  = 'Otherness';
my $author = 'David Brin';
my $pages  = 357;

@args = (
  'add'                 ,
  '--title'  => $title  ,
  '--author' => $author ,
  '--pages'  => $pages  ,
);

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

trap {
  local @ARGV = ( 'list' , '--notstarted' );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-err'
);

$trap->stdout_like(
  qr/$title by $author/ ,
  'list notstarted'
);
  

$trap->stderr_nok(
  'stderr silent'
);

trap {
  local @ARGV = ('list','--all');
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-err'
);

$trap->stdout_like(
  qr/$title by $author/ ,
  'list notstarted'
);

$trap->stderr_nok(
  'stderr silent'
);


