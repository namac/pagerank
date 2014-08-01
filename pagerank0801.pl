#!/usr/bin/env perl
# 正規化はなし
use strict;
use warnings;

package PageRank;
use base qw/Class::Accessor::Lvalue::Fast/;

__PACKAGE__->mk_accessors(qw/neighbor_matrix initial_vector iteration/);

use PDL;
use List::Util;

sub proc_eigen_vector{
	my $self = shift;
	

	# 隣接行列の作成
	my $p = transpose pdl $self->neighbor_matrix;
	
	# 初期のランクベクトル
	my $vec = transpose pdl $self->initial_vector;
	#printf $p;
	#printf $vec;
	#printf $p x $vec;

	#行列の計算 iteratorが45回で収束
	for(my $i = 0; $i < $self->iteration; $i++){
			$vec = $p x $vec;
			printf $i;
			printf $vec;
	}
}
package main;

my $pr = PageRank->new;

$pr->neighbor_matrix = [
	[0, 1, 0],
	[0.5, 0, 0.5],
	[1, 0, 0]
];

$pr->initial_vector = [1, 1, 1];
$pr->iteration = 50;
$pr->proc_eigen_vector;

	