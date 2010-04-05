package My::Test::CLI::Command::add_book_no_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'add_book' , '--configfile' , $config_file ];
}

sub add_book :Tests(4) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , 2                           , 'expected exit code' );
}

sub add_book_only_author :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args} , '--author_id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , -1                          , 'expected exit code' );
}

sub add_book_only_title :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args} , '--title' , 'foo the musical' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , -1                          , 'expected exit code' );
}

1;
