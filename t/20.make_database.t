# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan    /;
use Test::Trap    qw/ trap $trap /;

use Test::File;

use App::Booklist;

use lib './t';
require 'db.pm';

my $test_db_name  = "./.testing_booklist.db";

is( App::Booklist->db_location , $test_db_name ,
  'db_location honors environment variable' );

trap { App::Booklist->db_handle() };

$trap->leaveby_is( 'die' ,
  'db_handle dies when database file not there' );

$trap->die_like(  qr/Database file '$test_db_name' doesn't exist/ ,
  'db_handle says why it dies' );

trap {
  local @ARGV = ( 'make_database' );
  App::Booklist->run;
};

$trap->stdout_like( qr/Created database at $test_db_name/ ,
  'make_database says what it did' );

$trap->stderr_nok(
  'stderr is empty' );

file_exists_ok( $test_db_name ,
  'make_database created a file' );

isa_ok( App::Booklist->db_handle , 'DBIx::Class::Schema' ,
  'db_handle returns a DBIC::S object' );

trap {
  local @ARGV = ( 'make_database' );
  App::Booklist->run;
};

$trap->leaveby_is( 'exit' ,
  'make_database refuses to overwrite existing DB' );

$trap->stderr_like( qr/Won't replace existing database without --force/ ,
  'make_database says why it dies' );

