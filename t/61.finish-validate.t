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

my $title  = 'The Sleeping Dragon';
my $book   = $db->resultset('Book')->find({ title => $title });
my $id     = $book->id;

my @args = ('finish');

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like( $error , qr/Must give '--id' argument/ ,
        'must give --id argument' );

@args = ( @args , 'foo' );

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like( $error , qr/No args allowed/ ,
        'thou shalt have no other args before me' );


@args = ( 'finish' ,
          '--id' => $id
        );

my @r = trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

is( $trap->exit , 1 ,
    'should exit with status 1 when trying to finish a book not being read' );

is( $trap->stdout , '' ,
    'and should not send anything to STDOUT when doing so' );

like( $trap->stderr ,
      qr/You don't seem to be currently reading a book with that title/ ,
        'not reading that' );


$args[-1] = 9999;

@r = trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

is( $trap->exit , 1 ,
    'should exit with status 1 when trying to finish a book that does not exist' );

is( $trap->stdout , '' ,
    'and should not send anything to STDOUT when doing so' );

like( $trap->stderr ,
      qr/Hmm. I can't seem to find a book with that ID.../ ,
        'not reading that' );


