package My::Test::CLI::Command::list_readings_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'list_readings' , '--configfile' , $config_file ];
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

sub list_readings_with_db :Tests(6) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  like( $result->stdout    , qr/ID\s+START\s+FINISH\s+DONE\?\s+DURN\s+TITLE/ , 'expected header' );
  like( $result->stdout    , qr/Foo: the musical/                            , 'expected first author' );
  like( $result->stdout    , qr/Bar: the outage/                             , 'expected second author' );
  is(   $result->stderr    , ''                                              , 'nothing on stderr'  );
  is(   $result->error     , undef                                           , 'no exception' );
  is(   $result->exit_code , 0                                               , 'clean exit code' );
}

1;
