package App::Booklist::Web::Controller::Add;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use App::Booklist::Form::Login;
use App::Booklist::Form::Add::Author;
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

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

=head1 AUTHOR

John SJ Anderson

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
