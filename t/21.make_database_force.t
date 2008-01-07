# -*- cperl -*-
# $Id$
# $URL$

use Test::More        qw/ no_plan /;
use Test::Exception;
use Test::File;
use Test::Output      qw/ stdout_from /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $test_db_name = Booklist->db_location;

my $error;
my $stdout = do {
  local @ARGV = ( 'make_database' , '--force' );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

ok ! $error;
like $stdout , qr/Created database at $test_db_name/ ,
  'make_database says what it did';

