# -*- cperl -*-
# $Id$
# $URL$

use Test::More qw/ no_plan /;
use Test::Exception;
use Test::File;

use Booklist;
use Booklist::Cmd::Command::make_database;

my $test_db_name  = "/tmp/testing_booklist.$$";
$ENV{BOOKLIST_DB} = $test_db_name;

dies_ok { Booklist->db_handle() } 'db_handle dies when database file not there';
like $@ , qr/Database file '$test_db_name' doesn't exist/ , 'db_handle says why it dies';

lives_ok { Booklist::Cmd::Command::make_database->run }  'make_database works silently';

file_exists_ok( $test_db_name , 'make_database created a file' );

is( Booklist->db_location , $test_db_name ,  'db_location honors environment variable' );

isa_ok( Booklist->db_handle , 'DBIx::Class::Schema' , 'db_handle returns a DBIC::S object' );


# clean up
unlink $test_db_name;

