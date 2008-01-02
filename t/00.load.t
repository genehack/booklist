# $Id$
# $URL$

use Test::More tests => 3;

BEGIN {
use_ok( 'Booklist' );
use_ok( 'Booklist::Cmd' );
use_ok( 'Booklist::Cmd::finish' );
use_ok( 'Booklist::Cmd::start' );
use_ok( 'Booklist::DB' );
use_ok( 'Booklist::DB::Author' );
use_ok( 'Booklist::DB::AuthorBook' );
use_ok( 'Booklist::DB::Book' );
use_ok( 'Booklist::DB::Reading' );
}

diag( "Testing Booklist $Booklist::VERSION" );
