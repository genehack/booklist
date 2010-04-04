package My::Test::CLI::Command::del_book_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'del_book' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );

  my $author1 = $schema->resultset('Authors')->create({
    fname => 'Foo' ,
    lname => 'Bar' ,
  });
  my $author2 = $schema->resultset('Authors')->create({
    fname => 'Bazzy' ,
    lname => 'Bar' ,
  });

  my $book = $schema->resultset('Books')->create({
    title => 'Foo: the musical' ,
    pages => 666 ,
    isbn  => 1565922573 ,
  });
  $book->add_to_authors( $author1 );
  $book->add_to_authors( $author2 );

  $test->{schema} = $schema;
}

sub del_book_not_in_db :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 2 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                         , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to find book with ID=2/ , 'expected error'     );
  is(   $result->exit_code , 1                                          , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

sub del_book_really_in_db :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr/Deleted book \(ID=1\)/ , 'expected message'   );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  is(   $result->error     , undef                       , 'no exception'       );
  is(   $result->exit_code , 0                           , 'expected exit code' );
}

sub del_book_really_in_db_again :Tests(5) {
  my $test = shift;

  my @args = ( @{ $test->base_args } , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                                         , 'nothing on stdout'  );
  like( $result->stderr    , qr/ERROR: Unable to find book with ID=1/ , 'expected error'     );
  is(   $result->exit_code , 1                                          , 'expected exit code' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

1;
