# -*- cperl -*-
# $Id$
# $URL$

use Test::More     qw/ no_plan /;
use Test::Output   qw/ stdout_from /;
use Test::Trap     qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $today  = Booklist->epoch2ymd( time() );

my $title  = 'The Sleeping Dragon';
my $author = 'Joel Rosenberg';
my $pages  = 253;

my @args = ( 'add' ,
             '--title'  => $title  ,
             '--author' => $author ,
             '--pages'  => $pages  ,
           );   

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/Added '$title' to read later/;
ok ! $error;

my $db   = Booklist->db_handle;
my $book = $db->resultset('Book')->find({title => $title });

isa_ok $book , 'DBIx::Class::Row' ,
  'get a single book back';

is $book->authors->first->author , $author ,
  'and the author is the author';

is $book->pages , $pages ,
  'and the page counts match';

is $book->readings->first->startdate , undef ,
  'and the start date is what it should be';

is $book->readings->first->finishdate , undef ,
  'and the book has no finish date yet';

my @r = trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

is( $trap->exit , 1 ,
    'should exit with status 1 when trying to start book already being read' );

is( $trap->stdout , '' ,
    'and should not send anything to STDOUT when doing so' );

like( $trap->stderr , qr/^You have already planned to read that book/ ,
      'stderr should have error text however' );

like( $trap->stderr ,
      qr/You added it to your list on $today and have not yet started reading/ ,
      'stderr should also have the start date' );
