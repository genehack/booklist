# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'Guilty Pleasures';
my $author = 'Laurell K. Hamilton';
my $pages  = 266;
my $start  = '20070103';
my @tags   = qw/ vampires werewolves sex /;

my @args = (
  'start'                  ,
  '--title'     => $title  ,
  '--author'    => $author ,
  '--pages'     => $pages  ,
  '--startdate' => $start  ,
);

push @args , ( '--tag' => $_ ) foreach ( @tags );

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby(
  'return' ,
  'leave by return on success'
);

$trap->stdout_like(
  qr/Started to read '$title'/ ,
  'see expected stdout'
);

$trap->stderr_nok( 
  'see nothing on stderr'
);

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is(
  'exit' ,
  'should exit when trying to start book already being read' 
);

$trap->exit_is(
  1 ,
  'should exit with status 1 when trying to start book already being read' 
);

$trap->stdout_nok(
  'and should not send anything to STDOUT when doing so' 
);

$trap->stderr_like(
  qr/^You seem to already be reading that book/ ,
  'stderr should have error text however' 
);

$trap->stderr_like(
  qr/You started it on 2007-01-03 and have not yet recorded a finish date/ ,
  'stderr should also have the start date' 
);


my $book = Booklist->db_handle->resultset('Book')->find( {
  title => $title
} );

my @booktags;
foreach ( $book->tags ) {
  push @booktags , $_->tag;
}

@booktags = sort @booktags;
@tags     = sort @tags;

is_deeply( \@tags , \@booktags , 'tags is tags' );
