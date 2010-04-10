package My::Test::CLI::Command::add_tag;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'add_tag' , '--configfile' , $config_file ];
}

sub add_tag :Tests(4) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  isnt( $result->exit_code , 1                           , 'expected exit code' );
}

sub add_tag_name :Tests(4) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--name' , 'foo' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added tag 'foo' \(ID=1\)| , 'notify that tag was added' );
  is(   $result->stderr    , ''                           , 'stderr is empty' );
  is(   $result->error     , undef                        , 'no exceptions thrown' );
  is(   $result->exit_code , 0                            , 'clean exit' );
}

sub add_tag_name_duplicate :Tests(4) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--name' , 'foo' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added tag 'foo' \(ID=1\)| , 'notify that tag was added' );
  is(   $result->stderr    , ''                           , 'stderr is empty' );
  is(   $result->error     , undef                        , 'no exceptions thrown' );
  is(   $result->exit_code , 0                            , 'clean exit' );
}

1;
