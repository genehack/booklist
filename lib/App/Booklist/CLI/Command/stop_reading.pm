use MooseX::Declare;

class App::Booklist::CLI::Command::stop_reading extends App::Booklist::CLI::COMPLETION_BASE {
  use 5.010;

  has _dnf => (
    accessor => 'dnf' ,
    isa => 'Bool' , is => 'rw' ,
    default => 1 ,
  );

  method execute ( $opt , $args ) { $self->complete_reading }
}
