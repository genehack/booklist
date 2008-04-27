# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'CSS Cookbook';
my $author = 'Christopher Schmitt';
my $pages  = 252;

my $today  = App::Booklist->epoch2ymd();

trap {
  local @ARGV = ( 'start' );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/Need to supply a title/ ,
  'you needs a title' );

my @args = (
  'start'             ,
  '--title' => $title ,
);

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/Need to supply at least one author/ ,
  'you needs an author too' );

push @args , ( '--author' => $author );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/Need to supply page count/ ,
  'and you has to track pages yo' );

push @args , 'argument';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/No args allowed/ ,
  'but arguments are not allowed' );

