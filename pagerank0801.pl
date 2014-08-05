#!/usr/bin/env perl
# 正規化はなし
use strict;
use warnings;

package PageRank;
use base qw/Class::Accessor::Lvalue::Fast/;

__PACKAGE__->mk_accessors(qw/neighbor_matrix initial_vector iteration/);

use PDL;
use List::Util;

sub calc{
	my $self = shift;
	

	# 隣接行列の作成
	my $p = transpose pdl $self->neighbor_matrix;
	
	# 初期のランクベクトル
	my $vec = transpose pdl $self->initial_vector;
	#printf $p;
	#printf $vec;
	#printf $p x $vec;

	for(my $i = 0; $i < $self->iteration; $i++){
			$vec = $p x $vec;
	}
	return $vec / @{$self->initial_vector};
}

package main;

my $pr = PageRank->new;

# 隣接行列
$pr->neighbor_matrix = [
	[0, 0.2, 0.2, 0.2, 0.2, 0, 0.2],
	[1, 0, 0, 0, 0, 0, 0],
	[0.5, 0.5, 0, 0, 0, 0, 0],
	[0, 1/3, 1/3, 0, 1/3, 0, 0],
	[0.25, 0, 0.25, 0.25, 0, 0.25, 0],
	[0.5, 0, 0, 0, 0.5, 0, 0],
	[0, 0, 0, 0, 1, 0, 0]
];


$pr->initial_vector = [1, 1, 1, 1, 1, 1, 1];
$pr->iteration = 100;
my $res = $pr->calc;

printf $res;
	
