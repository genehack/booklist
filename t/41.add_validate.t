# -*- cperl -*-
# $Id$
# $URL$

use Test::More    qw/ no_plan /;
use Test::Trap    qw/ trap $trap /;

use App::Booklist;

use lib './t';
require 'db.pm';

my $title  = 'Overclocked: Stories of Future Present';
my $author = 'Cory Doctorow';
my $pages  = 285;

my @args = ( 'add' );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/Need to supply a title/m ,
  'you needs a title'
);

push @args , ( '--title' => $title );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/Need to supply at least one author/ ,
  'you needs an author too'
);

push @args , ( '--author' => $author );

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby(
  'die' ,
  'die on missing required option'
);

$trap->die_like(
  qr/Need to supply page count/ ,
  'and you has to track pages yo'
);

push @args , 'argument';

trap {
  local @ARGV = ( @args );
  App::Booklist->run;
};

$trap->leaveby_is( 'die' ,
  'die on bad args' );

$trap->die_like( qr/No args allowed/ ,
  'but arguments are not allowed' );
