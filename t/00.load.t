# $Id$
# $URL$

use Test::More tests => 12;

BEGIN {
use_ok( 'Booklist' );
use_ok( 'Booklist::Cmd' );
use_ok( 'Booklist::Cmd::Command::authors' );
use_ok( 'Booklist::Cmd::Command::finish' );
use_ok( 'Booklist::Cmd::Command::list' );
use_ok( 'Booklist::Cmd::Command::make_database' );
use_ok( 'Booklist::Cmd::Command::start' );
use_ok( 'Booklist::DB' );
use_ok( 'Booklist::DB::Author' );
use_ok( 'Booklist::DB::AuthorBook' );
use_ok( 'Booklist::DB::Book' );
use_ok( 'Booklist::DB::Reading' );
}

diag( "Testing Booklist $Booklist::VERSION" );
