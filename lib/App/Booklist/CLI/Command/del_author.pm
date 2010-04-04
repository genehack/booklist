use MooseX::Declare;

class App::Booklist::CLI::Command::del_author extends App::Booklist::CLI::BASE {
  use 5.010;

  has id => (
    isa => 'Num' , is => 'rw' ,
    documentation => 'ID of author to delete' ,
    traits => [ qw(Getopt)] ,
    required => 1 ,
  );

  method execute ( $opt , $args ) {
    my $schema = $self->get_schema();

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
