# -*- cperl -*-
# $Id$
# $URL$

use Test::More qw/ no_plan /;

use Test::File;

use Booklist;

use lib './t';
require 'db.pm';

my $file = Booklist->db_location();
unlink $file;

file_not_exists_ok $file , 
  'database file was properly cleaned up';
