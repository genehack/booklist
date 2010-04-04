package My::Test::CLI::Command::add_book_db;
use base 'My::Test::CLI::BASE';

use Test::More;
use App::Cmd::Tester;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'add_book' , '--configfile' , $config_file ];
}

sub setup_config :Tests(startup) {
  my $test = shift;
  $test->SUPER::setup_config;

  my $db = $test->{db_file};
  my $schema = App::Booklist::CLI::BASE->deploy_db( $db );
  $schema->resultset('Authors')->create({ lname => 'Foo' , fname => 'Bar' });

  $test->{schema} = $schema;
}

sub add_book_title_author :Tests(8) {
  my $test = shift;

  my @args = ( @{ $test->base_args} ,
               '--title' , 'foo the musical' ,
               '--author_id' , 1 );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added book 'foo the musical' \(ID=1\)| , 'expected message'  );
  is(   $result->stderr    , ''                                        , 'nothing on stderr'  );
  is(   $result->error     , undef                                     , 'no exception' );
  is(   $result->exit_code , 0                                         , 'expected exit code' );

  my $book = $test->{schema}->resultset('Books')->find(1);

  isa_ok( $book , 'App::Booklist::Schema::Result::Books' );

  my( $author ) = $book->authors->all;
  is( $author->lname , 'Foo' );
  is( $author->fname , 'Bar' );
  is( $author->id    , 1 );
}

sub add_book_title_author_isbn :Tests(9) {
  my $test = shift;

  my $isbn = 1565922573;

  my @args = ( @{ $test->base_args} ,
               '--title' , 'foo the musical' ,
               '--author_id' , 1 ,
               '--isbn' , $isbn ,
             );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added book 'foo the musical' \(ID=2\)| , 'expected message'  );
  is(   $result->stderr    , ''                                        , 'nothing on stderr'  );
  is(   $result->error     , undef                                     , 'no exception' );
  is(   $result->exit_code , 0                                         , 'expected exit code' );

  my $book = $test->{schema}->resultset('Books')->find(2);

  isa_ok( $book , 'App::Booklist::Schema::Result::Books' );
  is( $book->isbn , $isbn );

  my( $author ) = $book->authors->all;
  is( $author->lname , 'Foo' );
  is( $author->fname , 'Bar' );
  is( $author->id    , 1 );
}

sub add_book_title_author_pages :Tests(9) {
  my $test = shift;

  my $pages = 666;

  my @args = ( @{ $test->base_args} ,
               '--title' , 'foo the musical' ,
               '--author_id' , 1 ,
               '--pages' , $pages ,
             );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added book 'foo the musical' \(ID=3\)| , 'expected message'  );
  is(   $result->stderr    , ''                                        , 'nothing on stderr'  );
  is(   $result->error     , undef                                     , 'no exception' );
  is(   $result->exit_code , 0                                         , 'expected exit code' );

  my $book = $test->{schema}->resultset('Books')->find(3);

  isa_ok( $book , 'App::Booklist::Schema::Result::Books' );
  is( $book->pages , $pages );

  my( $author ) = $book->authors->all;
  is( $author->lname , 'Foo' );
  is( $author->fname , 'Bar' );
  is( $author->id    , 1 );
}

sub add_book_title_author_tag :Tests(7) {
  my $test = shift;

  my $tagname = 'bargle';

  my @args = ( @{ $test->base_args} ,
               '--title' , 'foo the musical' ,
               '--author_id' , 1 ,
               '--tag' , $tagname ,
             );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added book 'foo the musical' \(ID=4\)| , 'expected message'  );
  is(   $result->stderr    , ''                                        , 'nothing on stderr'  );
  is(   $result->error     , undef                                     , 'no exception' );
  is(   $result->exit_code , 0                                         , 'expected exit code' );

  my $book = $test->{schema}->resultset('Books')->find(4);

  isa_ok( $book , 'App::Booklist::Schema::Result::Books' );

  my( $tag ) = $book->tags->all;
  is( $tag->name , $tagname );
  is( $tag->id   , 1 );
}

sub add_book_title_author_tag_id :Tests(7) {
  my $test = shift;

  my @args = ( @{ $test->base_args} ,
               '--title' , 'foo the musical' ,
               '--author_id' , 1 ,
               '--tag_id' , 1 ,
             );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added book 'foo the musical' \(ID=5\)| , 'expected message'  );
  is(   $result->stderr    , ''                                        , 'nothing on stderr'  );
  is(   $result->error     , undef                                     , 'no exception' );
  is(   $result->exit_code , 0                                         , 'expected exit code' );
  my $book = $test->{schema}->resultset('Books')->find(5);

  isa_ok( $book , 'App::Booklist::Schema::Result::Books' );

  my( $tag ) = $book->tags->all;
  is( $tag->name , 'bargle' );
  is( $tag->id   , 1 );
}

sub add_book_title_author_tag_id_tag :Tests(10) {
  my $test = shift;

  my @args = ( @{ $test->base_args} ,
               '--title' , 'foo the musical' ,
               '--author_id' , 1 ,
               '--tag' , 'whumpus' ,
               '--tag_id' , 1 ,
             );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added book 'foo the musical' \(ID=6\)| , 'expected message'  );
  is(   $result->stderr    , ''                                        , 'nothing on stderr'  );
  is(   $result->error     , undef                                     , 'no exception' );
  is(   $result->exit_code , 0                                         , 'expected exit code' );

  my $book = $test->{schema}->resultset('Books')->find(6);

  isa_ok( $book , 'App::Booklist::Schema::Result::Books' );

  is( $book->tags->count , 2 );

  my @tags = $book->tags->all();

  is( $tags[0]->name , 'bargle' );
  is( $tags[0]->id   , 1 );
  is( $tags[1]->name , 'whumpus' );
  is( $tags[1]->id   , 2 );
}

1;
