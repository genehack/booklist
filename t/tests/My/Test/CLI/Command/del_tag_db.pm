package My::Test::CLI::Command::del_tag_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'del_tag' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );
  $schema->resultset('Tags')->create({ name => 'foo' });
  $schema->resultset('Tags')->create({ name => 'bar' });

  $test->{schema} = $schema;
}

sub del_tag_not_in_db :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 3 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                      , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to find tag with id=3/ , 'expected error'  );
  is(   $result->exit_code , 1                                       , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

sub del_tag_really_in_db :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr/Deleted tag \(id=1\)/ , 'expected message'   );
  is(   $result->stderr    , ''                       , 'nothing on stderr'  );
  is(   $result->error     , undef                    , 'no exception'       );
  is(   $result->exit_code , 0                        , 'expected exit code' );
}

sub del_tag_really_in_db_again :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                      , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to find tag with id=1/ , 'expected error'     );
  is(   $result->exit_code , 1                                       , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

sub del_tag_using_name :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args} , '--name' , 'bar' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr/Deleted tag \(name=bar\)/ , 'expected message'   );
  is(   $result->stderr    , ''                           , 'nothing on stderr'  );
  is(   $result->error     , undef                        , 'no exception'       );
  is(   $result->exit_code , 0                            , 'expected exit code' );
}

1;
