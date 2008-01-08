# -*- cperl -*-
# $Id$
# $URL$

use Test::More     qw/ no_plan /;
use Test::Output   qw/ stdout_from /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $error;
my $stdout = do {
  local @ARGV = ( 'authors' );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/^###  #bk  author/ , 'see expected header';
ok ! $error;

like $stdout , qr/^\s+9\s+1\s+Charles Stross\s*$/m ,
  'see charlie stross at expected position';
