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

my @args = ( 'list' );   

my $error;
my $stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/1: Orbital Resonance by John Barnes/ ,
  'list unread';
ok ! $error;

my $old_stdout = $stdout;

@args = ( @args , '--unfinished' );

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

is( $stdout , $old_stdout ,
  '--unfinished and default output are the same' );

@args = ('list','--read');

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/2: Thud by Terry Pratchett/ ,
  'list read';
ok ! $error;

my $title  = 'Otherness';
my $author = 'David Brin';
my $pages  = 357;

@args = ( 'add' ,
             '--title'  => $title  ,
             '--author' => $author ,
             '--pages'  => $pages  ,
           );
$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

@args = ('list','--notstarted');

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/$title by $author/ ,
  'list notstarted';
ok ! $error;


@args = ('list','--all');

$stdout = do {
  local @ARGV = ( @args );
  stdout_from( sub {
    eval { Booklist::Cmd->run ; 1 } or $error = $@;
  } );
};

like $stdout , qr/$title by $author/ ,
  'list notstarted';
ok ! $error;

