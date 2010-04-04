package My::Test::CLI::Command::list_authors;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'list_authors' , '--configfile' , $config_file ];
}

sub list_authors_missing_db :Tests(5) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                                       , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to connect to database/ , 'expected error'     );
  is(   $result->exit_code , 1                                        , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

sub list_authors_with_db :Tests(6) {
  my $test = shift;

  use App::Booklist::Schema;
  my $db = $test->{db_file};
  App::Booklist::CLI::Command::make_database->deploy_db( $db );
  my $schema = App::Booklist::Schema->connect( "dbi:SQLite:$db" );
  $schema->resultset('Authors')->create({ fname => 'Foo' , lname => 'Bar' });
  $schema->resultset('Authors')->create({ fname => 'Bar' , lname => 'Baz' });

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  like( $result->stdout    , qr/ID\s+First Name\s+Last Name/ , 'expected header' );
  like( $result->stdout    , qr/1\s+Foo\s+Bar/               , 'expected first author' );
  like( $result->stdout    , qr/2\s+Bar\s+Baz/               , 'expected second author' );
  is(   $result->stderr    , ''                              , 'nothing on stderr'  );
  is(   $result->error     , undef                           , 'no exception' );
  is(   $result->exit_code , 0                               , 'clean exit code' );
}

1;
