# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $id = App::Booklist->db_handle->resultset('Book')->find( { 
  title => 'The Sleeping Dragon'
} )->id;

my @args = ('finish');

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby( 
  'die' ,
  'die on bad args'
);

$trap->die_like ( 
  qr/Must give '--id' argument/ ,
  'must give --id argument'
);

push @args , 'foo';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};


$trap->leaveby( 
  'die' ,
  'die on bad args'
);

$trap->die_like ( 
  qr/No args allowed/ ,
  'thou shalt have no other args before me' 
);


@args = (
  'finish'      ,
  '--id' => 999 ,
);

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 
  'exit' ,
  'should exit when trying to finish a book not being read'
);

$trap->exit_is (
  1 ,
  'should exit with status 1 when trying to finish a book not being read' 
);

$trap->stdout_nok(
  'and should not send anything to STDOUT when doing so' 
);

$trap->stderr_like(
  qr/Hmm. I can't seem to find a reading with that ID.../ ,
  'not reading that' 
);

