# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title   = 'Myth-Gotten Gains';
my @authors = ( 'Robert Asprin' , 'Jody Lynn Nye' );
my $pages   = 278;
my $start   = '2007-01-14';
my @tags    = qw/ fantasy puns /;

my @args = (
  'start' ,
  '--title'     => $title  ,
  '--pages'     => $pages  ,
  '--startdate' => $start  ,
);
push @args , ( '--author' => $_ ) foreach( @authors );
push @args , ( '--tag' => $_ ) foreach ( @tags );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return without error'
);

$trap->stdout_like(
  qr/Started to read '$title'/ ,
  'say what you did'
);

$trap->stderr_nok(
  'nothing on stderr'
);

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

my $book = App::Booklist->db_handle->resultset('Book')->find( {
  title => $title
} );

my @bookauthors;
foreach ( $book->authors ) {
  push @bookauthors , $_->author;
}
@bookauthors = sort @bookauthors;
@authors     = sort @authors;

is_deeply( \@authors , \@bookauthors , 'authors is authors' );
