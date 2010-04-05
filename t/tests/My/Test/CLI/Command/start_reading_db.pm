package My::Test::CLI::Command::start_reading_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'start_reading' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );
  my $author = $schema->resultset('Authors')->create({ lname => 'Foo' , fname => 'Bar' });

  my $book1 = $schema->resultset('Books')->create({
    title => 'Foo: the musical' ,
  });
  $book1->add_to_authors( $author );

  my $book2 = $schema->resultset('Books')->create({
    title => 'Bar: the outage' ,
    isbn  => 1565922573 ,
  });
  $book2->add_to_authors( $author );

  my $book3 = $schema->resultset('Books')->create({
    title => 'Bazzle' ,
  });
  $book3->add_to_authors( $author );

  $test->{schema} = $schema;
}

sub start_reading_by_id :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout ,
        qr/Started reading book 'Foo: the musical' \(reading ID=1\) on / ,
        'expected out'  );

  is( $result->stderr    , ''    , 'nothing on stderr'  );
  is( $result->error     , undef , 'expected exception' );
  is( $result->exit_code , 0     , 'expected exit code' );
}

sub start_reading_by_id_again :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is( $result->stdout    , '' , 'expected empty output' );
  is( $result->stderr    , '' , 'nothing on stderr'  );
  is( $result->exit_code , 2  , 'expected exit code' );

  like(
    $result->error ,
    qr/Error: That book is already being read./ ,
    'expected exception'
  );
}

sub start_reading_by_id_with_date :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 2 , '--date' , '01 Jan 2010' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout ,
        qr/Started reading book 'Bar: the outage' \(reading ID=2\) on 2010.01.01/ ,
        'expected out'  );

  is( $result->stderr    , ''    , 'nothing on stderr'  );
  is( $result->error     , undef , 'expected exception' );
  is( $result->exit_code , 0     , 'expected exit code' );
}

sub start_reading_with_invalid_id :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 20 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is( $result->stdout    , '' , 'nothing on stdout' );
  is( $result->stderr    , '' , 'nothing on stderr'  );
  is( $result->exit_code , 2  , 'expected exit code' );

  like(
    $result->error ,
    qr/Error: Unable to locate book with ID=20/ ,
    'expected exception'
  );
}

1;
