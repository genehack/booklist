# -*- cperl -*-
# $Id$
# $URL$

use Test::More     qw/ no_plan /;
use Test::Output   qw/ stdout_from /;
use Test::Trap     qw/ trap $trap /;


use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title   = 'Dream Park';
my $authors = join ',' , ( 'Larry Niven' , 'Steven Barnes' );
my $pages   = 434;
my $start   = '2007-02-24';
my $tags    = join ', ' , qw/ science-fiction gaming /;

my @args = ( 'start' ,
             '--title'     => $title   ,
             '--author'    => $authors ,
             '--pages'     => $pages   ,
             '--startdate' => $start   ,
             '--tag'       => $tags    ,
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


my $db   = Booklist->db_handle;
my $book = $db->resultset('Book')->find({title => $title });

my @bookauthors;
foreach ( $book->authors ) {
  push @bookauthors , $_->author;
}
my $bookauthors = join ',' , sort @bookauthors;

is( $authors , $bookauthors , 'authors is authors' );
