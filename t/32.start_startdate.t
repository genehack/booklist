# -*- cperl -*-
# $Id$
# $URL$

use Test::More     qw/ no_plan /;
use Test::Output   qw/ stdout_from /;
use Test::Trap     qw/ trap $trap /;


use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'Thud';
my $author = 'Terry Pratchett';
my $pages  = 373;
my $start  = '2007-01-01';

my @args = ( 'start' ,
             '--title'     => $title  ,
             '--author'    => $author ,
             '--pages'     => $pages  ,
             '--startdate' => $start  ,
           );   

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/Started to read '$title'/;
ok ! $error;

my @r = trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

is( $trap->exit , 1 ,
    'should exit with status 1 when trying to start book already being read' );

is( $trap->stdout , '' ,
    'and should not send anything to STDOUT when doing so' );

like( $trap->stderr , qr/^You seem to already be reading that book/ ,
      'stderr should have error text however' );

like( $trap->stderr ,
      qr/You started it on $start and have not yet recorded a finish date/ ,
      'stderr should also have the start date' );
