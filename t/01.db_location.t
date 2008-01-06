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

dies_ok { Booklist->db_location() } 'db_location dies when database file not there';
like $@ , qr/Database file '$test_db_name' doesn't exist/ , 'db_location says why it dies';

