
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

use Test::More;

use Test::Requires {
    'Test::Pod' => '1.14', # skip all if not installed
};

all_pod_files_ok();
