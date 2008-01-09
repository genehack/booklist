# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'The Sleeping Dragon';
my $id     = Booklist->db_handle->resultset('Book')->find( { 
  title => $title
} )->id;

my @args = (
  'start' ,
  '--id'  => $id  ,
);   

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby(
  'return' ,
  'just checking things still work as expected'
);

$args[0] = 'finish';

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
  'expected stdout'
);

$trap->stderr_nok(
  'and nothing on stderr'
);
