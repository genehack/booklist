# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'Halting State';
my $author = 'Charles Stross';
my $pages  = 351;

my $today  = App::Booklist->epoch2ymd();

my @args = (
  'add' ,
  '--title'  => $title  ,
  '--author' => $author ,
  '--pages'  => $pages  ,
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
  qr/Added '$title' to read later/ ,
  'with expected output'
);
  
$trap->stderr_nok(
  'and nothing on stderr'
);

my $id = App::Booklist->db_handle->resultset('Book')->find( {
  title => $title
} )->id;

@args = (
  'start' ,
  '--id' => $id ,
);

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'return on non-error'
);

  
$trap->stdout_like(
  qr/Started to read '$title'/ ,
  'with expected output'
);

$trap->stderr_nok(
  'and nothing on stderr'
);


