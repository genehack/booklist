# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $db         = Booklist->db_handle;
my $title      = 'Thud';
my $book       = $db->resultset('Book')->find({ title => $title });
my $id         = $book->id;
my $finish     = '2007-06-01';
my $finishdate = Booklist->ymd2epoch($finish);

# copied from t/32.*.t where we added this book in the first place...
my $startdate  = Booklist->ymd2epoch('2007-01-01');

my $reading = $db->resultset('Reading')->create( {
  book       => $book->id   ,
  startdate  => $startdate  ,
  finishdate => $finishdate ,
} );
my $duration = $reading->calc_reading_duration();

my @args = (
  'finish'                  ,
  '--id'         => $id     ,
  '--finishdate' => $finish ,
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
  qr/Finished reading '$title'/ ,
  'with expected output'
);

$trap->stdout_like(
   qr/Read for $duration/ ,
   'with correct duration'
 );

$trap->stderr_nok(
  'with no stderr'
);

