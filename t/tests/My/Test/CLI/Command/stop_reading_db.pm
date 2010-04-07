package My::Test::CLI::Command::stop_reading_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'stop_reading' , '--configfile' , $config_file ];
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

  my $reading1 = $schema->resultset( 'Readings' )->create({
    book_id => $book1->id ,
    start   => '2010-01-01' ,
  });

  my $reading2 = $schema->resultset( 'Readings' )->create({
    book_id => $book2->id ,
    start   => '2010-02-01' ,
  });

  $test->{schema} = $schema;
}

sub finish_reading_by_id :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout ,
        qr/Stopped reading book 'Foo: the musical' \(reading ID=1\) on / ,
        'expected out'  );

  is( $result->stderr    , ''    , 'nothing on stderr'  );
  is( $result->error     , undef , 'expected exception' );
  is( $result->exit_code , 0     , 'expected exit code' );
}

sub finish_reading_by_id_again :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is( $result->stdout    , '' , 'expected empty output' );
  is( $result->stderr    , '' , 'nothing on stderr'  );
  is( $result->exit_code , 2  , 'expected exit code' );

  like(
    $result->error ,
    qr/Error: That book is not currently being read./ ,
    'expected exception'
  );
}

sub finish_reading_by_id_with_date :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 2 , '--date' , '02 Jan 2010' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout ,
        qr/Stopped reading book 'Bar: the outage' \(reading ID=2\) on 2010.01.02/ ,
        'expected out'  );

  is( $result->stderr    , ''    , 'nothing on stderr'  );
  is( $result->error     , undef , 'expected exception' );
  is( $result->exit_code , 0     , 'expected exit code' );
}

sub finish_reading_with_invalid_id :Tests(4) {
  my $test = shift;

  my @args = ( @{ $test->base_args}  , '--id' , 20 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is( $result->stdout    , '' , 'nothing on stdout' );
  is( $result->stderr    , '' , 'nothing on stderr'  );
  is( $result->exit_code , 2  , 'expected exit code' );

  like(
    $result->error ,
    qr/Error: Unable to locate reading with ID=20/ ,
    'expected exception'
  );
}

1;
