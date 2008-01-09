# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'Thud';
my $author = 'Terry Pratchett';
my $pages  = 373;
my $start  = '2007-01-01';

my @args = (
  'start'                  ,
  '--title'     => $title  ,
  '--author'    => $author ,
  '--pages'     => $pages  ,
  '--startdate' => $start  ,
);   

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is( 'return' ,
    'leave by return without errors' );

$trap->stdout_like( qr/Started to read '$title'/ ,
    'start gives title' );

$trap->stderr_nok(
    'stderr is silent' ); 

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->exit_is( 1 ,
    'should exit with status 1 when trying to start book already being read' );

$trap->stdout_nok(
    'and should not send anything to STDOUT when doing so' );

$trap->stderr_like( qr/^You seem to already be reading that book/ ,
      'stderr should have error text however' );

$trap->stderr_like(
      qr/You started it on $start and have not yet recorded a finish date/ ,
      'stderr should also have the start date' );
