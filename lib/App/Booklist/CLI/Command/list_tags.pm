use MooseX::Declare;

class App::Booklist::CLI::Command::list_tags extends App::Booklist::CLI::BASE {
  use 5.010;

  method execute ( $opt , $args ){
    my $schema = $self->get_schema();

    my $fstring = "%3s %-s\n";

    printf $fstring, 'ID' , 'Tag';
    printf $fstring, '=' x 3 , '=' x 60;

    foreach my $tag ( $schema->resultset('Tags')->all) {
      printf $fstring , $tag->id , $tag->name;
    };
  }
}
