#!/usr/bin/perl

use warnings;
use strict;

use Test::More tests => 8;
use lib 'lib';

BEGIN {
	use_ok( 'Redis::Hash' );
}

ok( my $o = tie( my %h, 'Redis::Hash', 'test-redis-hash' ), 'tie' );

isa_ok( $o, 'Redis::Hash' );

$o->CLEAR();

ok( ! keys %h, 'empty' );

ok( %h = ( 'foo' => 42, 'bar' => 1, 'baz' => 99 ), '=' );

is_deeply( [ sort keys %h ], [ 'bar', 'baz', 'foo' ], 'keys' );

is_deeply( \%h, { bar => 1, baz => 99, foo => 42, }, 'structure' );

$o->del('test-redis-hash');
$o->del('test-redis-hash:bar');
$o->del('test-redis-hash:baz');
$o->del('test-redis-hash:foo');

ok( my $mem = $o->info->{used_memory}, 'info' );
diag "used memory $mem";

