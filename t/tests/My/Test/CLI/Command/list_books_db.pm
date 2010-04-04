package My::Test::CLI::Command::list_books_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'list_books' , '--configfile' , $config_file ];
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

  my $book1 = $schema->resultset('Books')->create({
    title => 'Foo: the musical' ,
    pages => 666 ,
    isbn  => 1565922573 ,
  });
  $book1->add_to_authors( $author1 );
  $book1->add_to_authors( $author2 );

  my $book2 = $schema->resultset('Books')->create({
    title => 'Bazzy Bar: A Life' ,
    pages => 1234 ,
  });
  $book2->add_to_authors( $author1 );

  $test->{schema} = $schema;
}

sub list_books_with_db :Tests(5) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  my $stdout = $result->stdout;
  like( $stdout , qr/Foo: the musical/ );
  like( $stdout , qr/Foo Bar & Bazzy Bar/ );

  is(   $result->stderr    , ''    , 'nothing on stderr'  );
  is(   $result->error     , undef , 'no exception' );
  is(   $result->exit_code , 0     , 'clean exit code' );
}

1;
