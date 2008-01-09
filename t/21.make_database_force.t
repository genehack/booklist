# -*- cperl -*-
# $Id$
# $URL$

use Test::More        qw/ no_plan    /;
use Test::Trap        qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $test_db_name = Booklist->db_location();

trap {
  local @ARGV = ( 'make_database' , '--force' );
  Booklist::Cmd->run;
};

$trap->stderr_nok(
  'stderr is empty' );

$trap->stdout_like ( qr/Created database at $test_db_name/ ,
  'make_database says what it did' );

