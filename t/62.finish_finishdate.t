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

my $db = Booklist->db_handle;

my $title     = 'Thud';
my $book      = $db->resultset('Book')->find({ title => $title });

# copied from t/32.*.t where we added this book in the first place...
my $startdate = Booklist->ymd2epoch('2007-01-01');

my $id        = $book->id;

my $finish  = '2007-06-01';
my $finishdate = Booklist->ymd2epoch($finish);

my @args = ( 'finish'                  ,
             '--id'         => $id     ,
             '--finishdate' => $finish ,
           );

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

my $reading = $db->resultset('Reading')->create({
  book       => $book->id   ,
  startdate  => $startdate  ,
  finishdate => $finishdate ,
});
my $duration = $reading->calc_reading_duration();

like $stdout , qr/Finished reading '$title'/;
like $stdout , qr/Read for $duration/;

ok ! $error;
