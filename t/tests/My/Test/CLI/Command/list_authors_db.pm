package My::Test::CLI::Command::list_authors_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'list_authors' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );
  $schema->resultset('Authors')->create({ fname => 'Foo' , lname => 'Bar' });
  $schema->resultset('Authors')->create({ fname => 'Bar' , lname => 'Baz' });

  $test->{schema} = $schema;
}

sub list_authors_with_db :Tests(6) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  like( $result->stdout    , qr/ID\s+First Name\s+Last Name/ , 'expected header' );
  like( $result->stdout    , qr/1\s+Foo\s+Bar/               , 'expected first author' );
  like( $result->stdout    , qr/2\s+Bar\s+Baz/               , 'expected second author' );
  is(   $result->stderr    , ''                              , 'nothing on stderr'  );
  is(   $result->error     , undef                           , 'no exception' );
  is(   $result->exit_code , 0                               , 'clean exit code' );
}

1;
