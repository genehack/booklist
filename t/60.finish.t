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

my @args = ( 'start' ,
             '--id'  => $id  ,
           );   

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

$args[0] = 'finish';
$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/Finished reading '$title'/;
ok ! $error;
