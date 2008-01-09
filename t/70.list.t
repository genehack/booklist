# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my @args = ( 'list' );   

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
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
  Booklist::Cmd->run;
};

is( $trap->stdout , $old_stdout ,
    '--unfinished and default output are the same' );

trap {
  local @ARGV = ( 'list' , '--read' );
  Booklist::Cmd->run;
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
  Booklist::Cmd->run;
};

trap {
  local @ARGV = ( 'list' , '--notstarted' );
  Booklist::Cmd->run;
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
  Booklist::Cmd->run;
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


