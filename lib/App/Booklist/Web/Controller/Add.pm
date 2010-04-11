package App::Booklist::Web::Controller::Add;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use App::Booklist::Form::Login;
use App::Booklist::Form::Add::Author;
use App::Booklist::Form::Add::Book;
use App::Booklist::Form::Add::Tag;

sub auto :Private {
  my( $self , $c ) = @_;

  return 1 if ( $c->user_exists );

  my $form = App::Booklist::Form::Login->new();

  $c->stash(
    form     => $form ,
    template => 'login.tt' ,
  );

  if ( $form->process( $c->request->parameters )) {
    return 1 if ( $c->authenticate({
      username => $form->value->{username} ,
      password => $form->value->{password} ,
    }));

    $c->stash(
      message  => 'Authentication failed.' ,
    );
    $c->detach();
  }
}

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->response->redirect( '/' );
}

sub author :Local {
  my( $self , $c ) = @_;

  my $form = App::Booklist::Form::Add::Author->new;

  $c->stash(
    form     => $form ,
    template => 'add/author.tt' ,
  );

  if ( $form->process(
    schema => $c->model( 'DB' )->schema ,
    params => $c->request->parameters ,
  )) {
    $c->stash(
      form    => App::Booklist::Form::Add::Author->new() ,
      message => 'Author added.' ,
    );
  }
}

sub book :Local {
  my( $self , $c ) = @_;

  my $form = App::Booklist::Form::Add::Book->new;

  my @authors = $c->model( 'DB::Authors' )->all();
  my $author_list_options = [ map {
    { value => $_->id , label => $_->full_name }
  } sort { $a->lname cmp $b->lname } @authors ];

  $form->field( 'author' )->options( $author_list_options );

  $c->stash(
    form     => $form ,
    template => 'add/book.tt' ,
  );

  if ( $form->process(
    params => $c->request->parameters ,
  )) {
    my $create_args;
    foreach ( qw/ title isbn pages pubyear / ) {
      $create_args->{$_} = $form->value->{ $_ }
        if $form->value->{ $_ };
    }

    my $book = $c->model( 'DB::Books' )->create( $create_args );

    ### FIXME multi author support
    my $author = $c->model( 'DB::Authors' )->find($form->value->{ 'author' });
    $book->add_to_authors( $author );

    $c->stash(
      form    => App::Booklist::Form::Add::Book->new ,
      message => 'book added' ,
    );

  }
}

sub tag :Local {
  my( $self , $c ) = @_;

  my $form = App::Booklist::Form::Add::Tag->new;

  $c->stash(
    form     => $form ,
    template => 'add/tag.tt' ,
  );

  if ( $form->process(
    schema => $c->model( 'DB' )->schema ,
    params => $c->request->parameters ,
  )) {
    $c->stash(
      form    => App::Booklist::Form::Add::Tag->new() ,
      message => 'Tag added.' ,
    );
  }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

App::Booklist::Web::Controller::Add - Catalyst Controller

=head1 METHODS

=head2 auto

Utility routine that verifies that there's a logged in user; redirects to
login form if no user is found. Also processes the submitted login form.

=head2 index

Utility routine that forces a login then redirects to '/'.

=head2 author

Handles '/add/author', both form display and processing

=head2 book

Handles '/add/book', both form display and processing

=head2 tag

Handles '/add/tag', both form display and processing

=head1 AUTHOR

John SJ Anderson

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
