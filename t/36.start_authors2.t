# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title   = 'Dream Park';
my $authors = join ',' , ( 'Larry Niven' , 'Steven Barnes' );
my $pages   = 434;
my $start   = '2007-02-24';
my $tags    = join ', ' , qw/ science-fiction gaming /;

my @args = (
  'start'                   ,
  '--title'     => $title   ,
  '--author'    => $authors ,
  '--pages'     => $pages   ,
  '--startdate' => $start   ,
  '--tag'       => $tags    ,
);

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is(
  'return' ,
  'return on non-error'
);
  
$trap->stdout_like(
  qr/Started to read '$title'/ ,
  'expected output'
);

$trap->stderr_nok( 'nothing on stderr' );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is(
  'exit' ,
  'should exit when trying to start book already being read'
);

$trap->exit_is(
  1 ,
  'should exit with status 1 when trying to start book already being read'
);

$trap->stdout_nok(
  'and should not send anything to STDOUT when doing so'
);

$trap->stderr_like(
  qr/^You seem to already be reading that book/ ,
  'stderr should have error text however'
);

$trap->stderr_like(
  qr/You started it on $start and have not yet recorded a finish date/ ,
  'stderr should also have the start date'
);


my $db   = App::Booklist->db_handle;
my $book = $db->resultset('Book')->find({title => $title });

my @bookauthors;
foreach ( $book->authors ) {
  push @bookauthors , $_->author;
}
my $bookauthors = join ',' , sort @bookauthors;



is( $authors , $bookauthors , 'authors is authors' );
