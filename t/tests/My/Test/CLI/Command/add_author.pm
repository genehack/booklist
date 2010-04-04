package My::Test::CLI::Command::add_author;
use base 'Test::Class';

use Test::More;
use App::Cmd::Tester;

use File::Temp  qw/ tmpnam tempfile /;
use YAML        qw/ DumpFile /;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'add_author' , '--configfile' , $config_file ];
}

sub class { 'App::Booklist::CLI' }

sub setup :Tests(startup => 1) {
  my $test = shift;
  use_ok $test->class;
}

sub setup_config :Tests(startup) {
  my $test = shift;

  my( undef , $config_file ) = tempfile( 'configXXXX' , SUFFIX => '.yaml' );

  my $db_file = tmpnam() . '.db';

  DumpFile( $config_file , { file => $db_file });

  $test->{config_file} = $config_file;
  $test->{db_file}     = $db_file;
}

sub shutdown :Tests(shutdown) {
  my $test = shift;
  unlink $test->{config_file} , $test->{db_file};
}

sub add_author :Tests(4) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , 9                           , 'expected exit code' );
}

sub add_author_only_first :Tests(4) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--first' , 'Foo' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , 9                           , 'expected exit code' );
}

sub add_author_only_last :Tests(4) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--last' , 'Bar' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  is(   $result->stdout    , ''                          , 'nothing on stdout'  );
  is(   $result->stderr    , ''                          , 'nothing on stderr'  );
  like( $result->error     , qr/Required option missing/ , 'expected exception' );
  is(   $result->exit_code , 9                           , 'expected exit code' );
}

sub add_author_foo_bar :Tests(4) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--first' , 'Foo' , '--last' , 'Bar' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added author 'Foo Bar' \(ID=1\)| , 'notify that author was added' );
  is(   $result->stderr    , ''                                  , 'stderr is empty' );
  is(   $result->error     , undef                               , 'no exceptions thrown' );
  is(   $result->exit_code , 0                                   , 'clean exit' );
}

sub add_author_foo_bar_duplicate :Tests(4) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--first' , 'Foo' , '--last' , 'Bar' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  like( $result->stdout    , qr|Added author 'Foo Bar' \(ID=2\)| , 'notify that author was added' );
  is(   $result->stderr    , ''                                  , 'stderr is empty' );
  is(   $result->error     , undef                               , 'no exceptions thrown' );
  is(   $result->exit_code , 0                                   , 'clean exit' );
}

1;
