
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Declare class attributes Moose-style",
  "AUTHOR" => "Dave Rolsky <autarch\@urth.org>",
  "BUILD_REQUIRES" => {
    "Test::Fatal" => 0,
    "Test::More" => "0.88",
    "Test::Requires" => "0.05",
    "vars" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "MooseX-ClassAttribute",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "MooseX::ClassAttribute",
  "PREREQ_PM" => {
    "List::MoreUtils" => 0,
    "Moose" => "2.00",
    "Moose::Exporter" => 0,
    "Moose::Meta::Role::Attribute" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "Moose::Util::MetaRole" => 0,
    "Scalar::Util" => 0,
    "namespace::autoclean" => "0.11",
    "namespace::clean" => "0.20",
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.27",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



