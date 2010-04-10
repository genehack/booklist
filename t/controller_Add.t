use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'App::Booklist::Web' }
BEGIN { use_ok 'App::Booklist::Web::Controller::Add' }

ok( request('/add')->is_success, 'Request should succeed' );
done_testing();
