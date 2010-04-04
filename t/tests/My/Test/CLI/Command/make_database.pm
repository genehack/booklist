package My::Test::CLI::Command::make_database;
use base 'Test::Class';

use Test::More;
use Test::File;
use App::Cmd::Tester;

use File::Temp  qw/ tmpnam tempfile /;
use YAML        qw/ DumpFile /;

sub base_args {
  my $test = shift;
  my $config_file = $test->{config_file};

  return [ 'make_database' , '--configfile' , $config_file ];
}

sub class { 'App::Booklist::CLI' }

sub setup :Tests(startup => 1 ) {
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

sub make_database :Tests(5) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  my $output = sprintf( 'Created database at %s' , $test->{db_file} );

  is( $result->stdout    , $output , 'notify that database was created' );
  is( $result->stderr    , ''      , 'stderr is empty' );
  is( $result->error     , undef   , 'no exceptions thrown' );
  is( $result->exit_code , 0       , 'clean exit' );

  file_exists_ok( $test->{db_file} );
}

sub make_database_with_existing :Tests(5) {
  my $test = shift;

  my $result = test_app( 'App::Booklist::CLI' => $test->base_args );

  my $error = sprintf( 'ERROR: Refusing to overwrite existing database at %s' , $test->{db_file} );

  is( $result->stdout    , ''     , 'nothing on stdout' );
  is( $result->stderr    , $error , 'see expected error message' );
  is( $result->exit_code , 1      , 'unclean exit' );

  my $error = $result->error;
  isa_ok( $error , 'App::Cmd::Tester::Exited' );
  is( $$error , 1 );
}

sub make_database_with_existing_and_force :Tests(5) {
  my $test = shift;

  my @args = ( @{$test->base_args} , '--force' );
  my $result = test_app( 'App::Booklist::CLI' => \@args );

  my $output = sprintf( 'Created database at %s' , $test->{db_file} );

  is( $result->stdout    , $output , 'notify that database was created' );
  is( $result->stderr    , ''      , 'stderr is empty' );
  is( $result->error     , undef   , 'no exceptions thrown' );
  is( $result->exit_code , 0       , 'clean exit' );

  file_exists_ok( $test->{db_file} );
}

sub make_database_with_provided_filename :Tests(5) {
  my $test = shift;

  my $db_file = tmpnam() . '.db';
  my @args    = ( @{$test->base_args} , '--file' , $db_file );
  my $result  = test_app( 'App::Booklist::CLI' => \@args );

  my $output = sprintf( 'Created database at %s' , $db_file );

  is( $result->stdout    , $output , 'notify that database was created' );
  is( $result->stderr    , ''      , 'stderr is empty' );
  is( $result->error     , undef   , 'no exceptions thrown' );
  is( $result->exit_code , 0       , 'clean exit' );

  file_exists_ok( $db_file );
  unlink( $db_file );
}

sub shutdown :Tests(shutdown) {
  my $test = shift;
  unlink $test->{config_file} , $test->{db_file};
};


1;
