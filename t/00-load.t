#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Booklist' ) || print "Bail out!
";
}

diag( "Testing App::Booklist $App::Booklist::VERSION, Perl $], $^X" );
