# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'Programming Ruby';
my $author = 'Dave Thomas';
my $pages  = 830;
my $start  = '2007-01-01';
my $tags   = join ',' , qw/ ruby programming pickaxe /;

my @args = (
  'start'                  ,
  '--title'     => $title  ,
  '--author'    => $author ,
  '--pages'     => $pages  ,
  '--startdate' => $start  ,
  '--tag'       => $tags   ,
);   

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is(
  'return' ,
  'leaveby return'
);

$trap->stdout_like( qr/Started to read '$title'/ ,
    'feedback from start on comma-delimd tags' );

$trap->stderr_nok( 'and quiet on the error front' );

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
  'stderr should also have the start date' 
);

my $book = Booklist->db_handle->resultset('Book')->find( {
  title => $title
} );

foreach ( $book->tags ) {
  push @booktags , $_->tag;
}
my $booktags = join ',' , @booktags;

is( $tags , $booktags , 'tags is tags' );
