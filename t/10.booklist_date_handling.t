# -*- cperl -*-
# $Id$
# $URL$

use Test::More tests => 5;

use Test::Exception;
use Test::File;

use App::Booklist;

# we don't really test epoch2ymd b/c it's really just using TimeDate
my $ymd = App::Booklist->epoch2ymd(0); 
is $ymd , '1970-01-01' , '1==1';

my $epoch = App::Booklist->ymd2epoch($ymd);
is 0 , $epoch , '2==2';

my $other_epoch = App::Booklist->ymd2epoch('19700101');
is 0 , $other_epoch , '3==3';

dies_ok { App::Booklist->ymd2epoch(1970101) }
  'ymd2epoch dies on malformed input';

like $@ , qr/Date must be in YYYYMMDD format/ ,
  'ymd2epoch says why it died'
