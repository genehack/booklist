# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use Booklist;
use Booklist::Cmd;

use lib './t';
require 'db.pm';

my $title  = 'Overclocked: Stories of Future Present';
my $author = 'Cory Doctorow';
my $pages  = 285;

my @args = ( 'add' );

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/title is a required option/ ,
  'you needs a title'
);

push @args , ( '--title' => $title );

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/author is a required option/ ,
  'you needs an author too'
);

push @args , ( '--author' => $author );

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/pages is a required option/ ,
  'and you has to track pages yo'
);

push @args , 'argument';

trap {
  local @ARGV = ( @args );
  Booklist::Cmd->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/No args allowed/ ,
  'but arguments are not allowed' );
