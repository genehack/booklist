# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'The Sleeping Dragon';
my $id     = App::Booklist->db_handle->resultset('Book')->find( { 
  title => $title
} )->id;

my @args = (
  'start' ,
  '--id'  => $id  ,
);   

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'return' ,
  'just checking things still work as expected'
);

$args[0] = 'finish';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};


$trap->leaveby(
  'return' ,
  'return on non-error' 
);

$trap->stdout_like(
  qr/Finished reading '$title'/ ,
  'expected stdout'
);

$trap->stderr_nok(
  'and nothing on stderr'
);
