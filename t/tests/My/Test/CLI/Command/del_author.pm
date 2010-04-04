package My::Test::CLI::Command::del_author;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'del_author' , '--configfile' , $config_file ];
}

sub del_author :Tests(4) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , 9                           , 'expected exit code' );
}

sub del_author_missing_db :Tests(5) {
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

sub del_author_not_in_db :Tests(5) {
  my $test = shift;

  use App::Booklist::Schema;
  my $db = $test->{db_file};
  App::Booklist::CLI::Command::make_database->deploy_db( $db );
  my $schema = App::Booklist::Schema->connect( "dbi:SQLite:$db" );
  $schema->resultset('Authors')->create({ fname => 'Foo' , lname => 'Bar' });

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
