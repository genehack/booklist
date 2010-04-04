package My::Test::CLI::Command::list_tags_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'list_tags' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );
  $schema->resultset('Tags')->create({ name => 'Foo' });
  $schema->resultset('Tags')->create({ name => 'Bar' });

  $test->{schema} = $schema;
}

sub list_tags_with_db :Tests(6) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  like( $result->stdout    , qr/ID\s+Tag/ , 'expected header' );
  like( $result->stdout    , qr/1\s+Foo/  , 'expected first author' );
  like( $result->stdout    , qr/2\s+Bar/  , 'expected second author' );
  is(   $result->stderr    , ''           , 'nothing on stderr'  );
  is(   $result->error     , undef        , 'no exception' );
  is(   $result->exit_code , 0            , 'clean exit code' );
}

1;
