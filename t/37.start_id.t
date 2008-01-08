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

my $title  = 'Halting State';
my $author = 'Charles Stross';
my $pages  = 351;

my $today  = Booklist->epoch2ymd( time() );

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
my $id   = $book->id;


@args = ( 'start' ,
          '--id' => $id ,
        );
$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/Started to read '$title'/;
ok ! $error;

