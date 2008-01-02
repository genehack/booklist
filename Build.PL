use strict;
use warnings;

use Module::Build;

# $Id$ 
# $URL$

my $builder = Module::Build->new(
    module_name         => 'Booklist',
    license             => 'perl',
    dist_author         => 'John SJ Anderson <genehack@genehack.org>',
    dist_version_from   => 'lib/Booklist.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    script_files        => [ 'bin/booklist' ] ,
    add_to_cleanup      => [ 'Booklist-*' ],
);

$builder->create_build_script();
