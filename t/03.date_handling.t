# -*- cperl -*-
# $Id$
# $URL$

use Test::More qw/ no_plan /;
use Test::Exception;
use Test::File;

use Booklist;

# we don't really test epoch2ymd b/c it's really just using TimeDate
my $ymd = Booklist->epoch2ymd(0); 
is $ymd , 19700101 , '1==1';

my $epoch = Booklist->ymd2epoch($ymd);
is 0 , $epoch , '2==2';

dies_ok { Booklist->ymd2epoch(1970101) } 'ymd2epoch dies on malformed input';
like $@ , qr/Date must be in YYYYMMDD format/ , 'ymd2epoch says why it died'
