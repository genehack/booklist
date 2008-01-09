# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'CSS Cookbook';
my $author = 'Christopher Schmitt';
my $pages  = 252;

my $today  = Booklist->epoch2ymd();

trap {
  local @ARGV = ( 'start' );
  Booklist::Cmd->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/title is a required option/ ,
  'you needs a title' );

my @args = (
  'start'             ,
  '--title' => $title ,
);

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/author is a required option/ ,
  'you needs an author too' );

push @args , ( '--author' => $author );

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/pages is a required option/ ,
  'and you has to track pages yo' );

push @args , 'argument';

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/No args allowed/ ,
  'but arguments are not allowed' );

