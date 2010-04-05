package My::Test::CLI::Command::start_reading_no_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'start_reading' , '--configfile' , $config_file ];
}

sub start_reading :Tests(4) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , -1                          , 'expected exit code' );
}

sub start_reading_no_db :Tests {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                       , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to connect to database/ , 'expected error'     );
  is(   $result->exit_code , 1                                        , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

1;
