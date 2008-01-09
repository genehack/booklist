# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $today  = Booklist->epoch2ymd();

my $title  = 'The Sleeping Dragon';
my $author = 'Joel Rosenberg';
my $pages  = 253;

my @args = (
  'add' ,
  '--title'  => $title  ,
  '--author' => $author ,
  '--pages'  => $pages  ,
);   

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby(
  'return' ,
  'return on non-error'
);

$trap->stdout_like(
  qr/Added '$title' to read later/ ,
  'with expected output' 
);

$trap->stderr_nok(
  'and nothing on stderr'
);

my $book = Booklist->db_handle->resultset('Book')->find( {
  title => $title
} );

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

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->exit_is(
  1 ,
  'should exit with status 1 when trying to start book already being read'
);

$trap->stdout_nok(
  'and should not send anything to STDOUT when doing so'
);

$trap->stderr_like(
  qr/^You have already planned to read that book/ ,
  'stderr should have error text however'
);

$trap->stderr_like(
  qr/You added it to your list on $today and have not yet started reading/ ,
  'stderr should also have the start date'
);
