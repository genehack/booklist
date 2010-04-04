use MooseX::Declare;

class App::Booklist::CLI::Command::list_books extends App::Booklist::CLI::BASE {
  use 5.010;
  use Template;

  method execute ( $opt , $args ){
    my $schema = $self->get_schema();

    my $template = <<EOT;
#[% b.id %] [% b.title %]
  by [% b.author_list %]
    [% IF b.pages %][% b.pages %] pages[% END %][% IF b.isbn  %] (ISBN:[% b.isbn %])[% END %]
EOT
    my $T = Template->new();

    foreach my $book ( $schema->resultset('Books')->all) {
      $T->process( \$template , { b => $book } )
        or die $T->error();
    };
  }
}
