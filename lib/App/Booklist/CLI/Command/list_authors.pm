use MooseX::Declare;

class App::Booklist::CLI::Command::list_authors extends App::Booklist::CLI::BASE {
  use 5.010;

  method execute ( $opt , $args ){
    my $schema = $self->get_schema();

    my $fstring = "%3s %-30s %-40s\n";

    printf $fstring, 'ID' , 'First Name', 'Last Name';
    printf $fstring, '=' x 3 , '=' x 30 , '=' x 40;

    foreach my $author ( $schema->resultset('Authors')->all) {
      printf $fstring , $author->id , $author->fname , $author->lname;
    };
  }
}
