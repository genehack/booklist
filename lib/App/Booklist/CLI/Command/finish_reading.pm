use MooseX::Declare;

class App::Booklist::CLI::Command::finish_reading extends App::Booklist::CLI::COMPLETION_BASE {
  use 5.010;

  has dnf => (
    isa => 'Bool' , is => 'rw' ,
    documentation => 'Flag indicating that this reading was stopped, not finished' ,
    traits => [ qw(Getopt) ] ,
  );

  method execute ( $opt , $args ) { $self->complete_reading() }
}
