use MooseX::Declare;

class App::Booklist::CLI::Command::make_database extends App::Booklist::CLI::BASE {
  use 5.010;

  has force => (
    isa => 'Bool' , is => 'rw' ,
    documentation => 'Overwrite existing file.',
    traits => [qw(Getopt)] ,
    default => 0 ,
  );

  method execute ( $opt , $args ) {
    my $db = $self->file;

    if ( ! $self->force and -e $db ) {
      print STDERR "ERROR: Refusing to overwrite existing database at $db";
      exit(1);
    }

    $self->deploy_db();

    say "Created database at $db";
  }
};
