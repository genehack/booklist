# -*- cperl -*-
# $Id$
# $URL$

use Test::More tests => 17;

BEGIN {
use_ok( 'App::Booklist' );
use_ok( 'App::Booklist::Command' );
use_ok( 'App::Booklist::Command::add' );
use_ok( 'App::Booklist::Command::authors' );
use_ok( 'App::Booklist::Command::finish' );
use_ok( 'App::Booklist::Command::import' );
use_ok( 'App::Booklist::Command::list' );
use_ok( 'App::Booklist::Command::make_database' );
use_ok( 'App::Booklist::Command::start' );
use_ok( 'App::Booklist::Command::stats' );
use_ok( 'App::Booklist::DB' );
use_ok( 'App::Booklist::DB::Author' );
use_ok( 'App::Booklist::DB::AuthorBook' );
use_ok( 'App::Booklist::DB::Book' );
use_ok( 'App::Booklist::DB::BookTag' );
use_ok( 'App::Booklist::DB::Reading' );
use_ok( 'App::Booklist::DB::Tag' );
}

diag( "Testing App::Booklist $App::Booklist::VERSION" );
