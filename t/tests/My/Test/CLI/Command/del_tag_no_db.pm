package My::Test::CLI::Command::del_tag_no_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'del_tag' , '--configfile' , $config_file ];
}

sub del_tag :Tests(4) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , 9                           , 'expected exit code' );
}

sub del_tag_both :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args} , '--id' , 1 , '--name' , 'foo' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                  , 'nothing on stdout'  );
  is(   $result->stderr    , ''                                  , 'nothing on stderr'  );
  like( $result->error     , qr/Only one of .* may be specified/ , 'expected exception' );
  is(   $result->exit_code , 9                                   , 'expected exit code' );
}

sub del_tag_id :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                       , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to connect to database/ , 'expected error'  );
  is(   $result->exit_code , 1                                        , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

1;
