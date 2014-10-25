package MooseX::ClassAttribute::Meta::Method::Accessor;
BEGIN {
  $MooseX::ClassAttribute::Meta::Method::Accessor::VERSION = '0.14';
}

use strict;
use warnings;

use namespace::autoclean;
use Moose;

extends 'Moose::Meta::Method::Accessor';

sub _generate_predicate_method_inline {
    my $attr = (shift)->associated_attribute;

    my $code
        = eval 'sub {'
        . $attr->associated_class()
        ->inline_is_class_slot_initialized( $attr->name() ) . '}';

    confess "Could not generate inline predicate because : $@" if $@;

    return $code;
}

sub _generate_clearer_method_inline {
    my $attr          = (shift)->associated_attribute;
    my $meta_instance = $attr->associated_class->instance_metaclass;

    my $code
        = eval 'sub {'
        . $attr->associated_class()
        ->inline_deinitialize_class_slot( $attr->name() ) . '}';

    confess "Could not generate inline clearer because : $@" if $@;

    return $code;
}

sub _inline_store {
    my $self = shift;
    shift;
    my $value = shift;

    my $attr = $self->associated_attribute();

    my $meta = $attr->associated_class();

    my $code
        = $meta->inline_set_class_slot_value( $attr->slots(), $value ) . ";";
    $code
        .= $meta->inline_weaken_class_slot_value( $attr->slots(), $value )
        . ";"
        if $attr->is_weak_ref();

    return $code;
}

sub _inline_get {
    my $self = shift;

    my $attr = $self->associated_attribute;
    my $meta = $attr->associated_class();

    return $meta->inline_get_class_slot_value( $attr->slots() );
}

sub _inline_access {
    my $self = shift;

    my $attr = $self->associated_attribute;
    my $meta = $attr->associated_class();

    return $meta->inline_class_slot_access( $attr->slots() );
}

sub _inline_has {
    my $self = shift;

    my $attr = $self->associated_attribute;
    my $meta = $attr->associated_class();

    return $meta->inline_is_class_slot_initialized( $attr->slots() );
}

sub _inline_init_slot {
    my $self = shift;

    return $self->_inline_store( undef, $_[-1] );
}

sub _inline_check_lazy {
    my $self = shift;

    return $self->SUPER::_inline_check_lazy( q{'}
            . $self->associated_attribute()->associated_class()->name()
            . q{'} );
}

sub _inline_get_old_value_for_trigger {
    my $self = shift;

    my $attr = $self->associated_attribute();
    return '' unless $attr->has_trigger();

    my $pred = $attr->associated_class()
        ->inline_is_class_slot_initialized( $attr->name() );

    return
          'my @old = ' 
        . $pred . q{ ? }
        . $self->_inline_get()
        . q{ : ()} . ";\n";

}

1;

# ABSTRACT: Accessor method generation for class attributes



=pod

=head1 NAME

MooseX::ClassAttribute::Meta::Method::Accessor - Accessor method generation for class attributes

=head1 VERSION

version 0.14

=head1 DESCRIPTION

This class overrides L<Moose::Meta::Method::Accessor> to do code
generation properly for class attributes.

=head1 BUGS

See L<MooseX::ClassAttribute> for details.

=head1 AUTHOR

  Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Dave Rolsky.

This is free software, licensed under:

  The Artistic License 2.0

=cut


__END__

