# -*- cperl -*-
# $Id$
# $URL$

use Test::More        qw/ no_plan /;
use Test::Exception;
use Test::File;
use Test::Output      qw/ stdout_from /;

use Booklist;
use Booklist::Cmd;
use Booklist::Cmd::Command::make_database;

use lib './t';
require 'db.pm';

my $test_db_name  = "./.testing_booklist.db";

is( Booklist->db_location , $test_db_name ,
  'db_location honors environment variable' );

dies_ok { Booklist->db_handle() }
  'db_handle dies when database file not there';

like $@ , qr/Database file '$test_db_name' doesn't exist/ ,
  'db_handle says why it dies';

my $error;
my $stdout = do {
  local @ARGV = ( 'make_database' );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/Created database at $test_db_name/ ,
  'make_database says what it did';
ok ! $error;


file_exists_ok( $test_db_name ,
  'make_database created a file' );

isa_ok( Booklist->db_handle , 'DBIx::Class::Schema' ,
  'db_handle returns a DBIC::S object' );

dies_ok { Booklist::Cmd::Command::make_database->run }
  'make_database refuses to overwrite existing DB';

like $@ , qr/Won't replace existing database without --force/ ,
  'make_database says why it dies';
