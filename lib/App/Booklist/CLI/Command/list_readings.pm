use MooseX::Declare;

class App::Booklist::CLI::Command::list_readings extends App::Booklist::CLI::BASE {
  use 5.010;
  use Date::Parse;

  method execute ( $opt , $args ){
    my $schema = $self->get_schema();

    my $fstring = "%3s %-10s %-10s %5s %4s %s\n";
    printf $fstring , 'ID' , 'START' , 'FINISH' , 'DONE?' , 'DURN' , 'TITLE';
    printf $fstring , '=' x 3 , '=' x 10 , '=' x 10, '=' x 5 , '=' x 4 , '=' x 35;

    foreach my $reading ( $schema->resultset('Readings')->all) {
      my $done = ( $reading->finished ) ? '  X  ' : ' ' x 5;

      my $dur;
      if ( $reading->duration ) {
        $dur = $reading->duration->in_units( 'days' ) + 1;
        $dur .= 'd';
      }
      else { $dur = 'n/a' }

      printf $fstring , $reading->id , $reading->start , $reading->finish ,
        $done , $dur , $reading->book->title;
     };
  }
}
