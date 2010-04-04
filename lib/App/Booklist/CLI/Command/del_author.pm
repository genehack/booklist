use MooseX::Declare;

class App::Booklist::CLI::Command::del_author extends App::Booklist::CLI::BASE {
  use 5.010;
  use App::Booklist::Schema;

  has id => (
    isa => 'Num' , is => 'rw' ,
    documentation => 'ID of author to delete' ,
    traits => [ qw(Getopt)] ,
    required => 1 ,
  );

  sub execute {
    my( $self , $opt , $args ) = @_;

    my $db = $self->file;

    unless ( -e $db ) {
      printf STDERR <<EOM and exit(1);
ERROR: Unable to connect to database.
Do you need to run 'make_database'?
EOM
    }

    my $schema = App::Booklist::Schema->connect( "dbi:SQLite:$db" );

    if ( my $author = $schema->resultset('Authors')->find($self->id) ) {
      $author->delete;
      printf "Deleted author (ID=%d)\n" , $self->id;
    }
    else {
      printf STDERR "ERROR: Unable to find author with ID=%d\n" , $self->id;
      exit(1);
    }
  }
}
