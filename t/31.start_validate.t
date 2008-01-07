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

my $title  = 'CSS Cookbook';
my $author = 'Christopher Schmitt';
my $pages  = 252;

my $today  = Booklist->epoch2ymd( time() );

my @args = ( 'start' );   

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $error , qr/title is a required option/ ,
  'you needs a title';

@args = ( @args ,
          '--title' => $title ,
        );

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $error , qr/author is a required option/ ,
  'you needs an author too';

@args = ( @args ,
          '--author' => $author ,
        );

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $error , qr/pages is a required option/ ,
  'and you has to track pages yo';

@args = ( @args ,
          'argument' 
        );

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $error , qr/No args allowed/ ,
  'but arguments are not allowed';

