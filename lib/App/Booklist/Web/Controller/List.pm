package App::Booklist::Web::Controller::List;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->response->redirect( '/' );
}

sub authors :Local {
  my( $self , $c , $id ) = @_;

  if ( $id ) {
    $c->stash(
      author   => $c->model( 'DB::Authors' )->find( $id ) ,
      template => 'list/author.tt' ,
    );
  } else {
    $c->stash(
      authors  => [ $c->model( 'DB::Authors' )->all ] ,
      template => 'list/authors.tt' ,
    );
  }
}

sub tags :Local {
  my( $self , $c , $id ) = @_;

  if ( $id ) {
    $c->stash(
      tag => $c->model( 'DB::Tags' )->find( $id ) ,
      template => 'list/tag.tt' ,
    );
  }
  else {
    $c->stash(
      tags => [ $c->model( 'DB::Tags' )->all ] ,
      template => 'list/tags.tt' ,
    );
  }
}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

App::Booklist::Web::Controller::List - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

=head1 AUTHOR

John SJ Anderson

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
