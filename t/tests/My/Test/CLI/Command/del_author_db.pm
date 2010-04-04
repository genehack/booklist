package My::Test::CLI::Command::del_author_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'del_author' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );
  $schema->resultset('Authors')->create({ lname => 'Foo' , fname => 'Bar' });

  $test->{schema} = $schema;
}

sub del_author_not_in_db :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 2 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                         , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to find author with ID=2/ , 'expected error'     );
  is(   $result->exit_code , 1                                          , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

sub del_author_really_in_db :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr/Deleted author \(ID=1\)/ , 'expected message'   );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  is(   $result->error     , undef                       , 'no exception'       );
  is(   $result->exit_code , 0                           , 'expected exit code' );
}

sub del_author_really_in_db_again :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                         , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to find author with ID=1/ , 'expected error'     );
  is(   $result->exit_code , 1                                          , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

1;
