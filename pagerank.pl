#!/usr/bin/env perl
use strict;
use warnings;

package PageRank;
use base qw/Class::Accessor::Lvalue::Fast/;

__PACKAGE__->mk_accessors(qw/adj_matrix initial_vector alpha iteration/);

use PDL;
use List::Util;

sub calc {
    my $self = shift;
    my $dim = scalar @{$self->adj_matrix};

    for my $row (@{$self->adj_matrix}) {
        my $sum = List::Util::sum @$row+1;
        $_ = $_ / $sum for @$row;
    }

    ## ランダムウォークを実装
    my $r_vec = [];
    for (my $i = 0; $i < $dim; $i++) {
        $r_vec->[$i] = (1 - $self->alpha) * (1 / $dim);
    }
    $r_vec = transpose pdl $r_vec;

    my $P   = transpose pdl $self->adj_matrix;
    my $vec = transpose pdl $self->initial_vector;

    ## べき乗計算
    for (my $i = 0; $i < $self->iteration; $i++) {
        $vec = $self->alpha * $P x $vec + $r_vec;
    }

    return $vec;
}

package main;

my $pr = PageRank->new;

## リンクデータ
$pr->adj_matrix = [
    [ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 ],
    [ 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1 ],
    [ 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0 ],
    [ 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0 ],
    [ 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0 ],
    [ 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0 ],                    
    [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ]
];

#for my $alpha (1.0, 0.8, 0.5, 0) {
    $pr->initial_vector = [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0];
#    $pr->alpha = $alpha; ## ランダムウォークの確率
    $pr->alpha = 0.85;
    $pr->iteration = 100;

#    printf "alpha: %f", $alpha;
printf "alpha:0.85";
    my $v_eigen = $pr->calc;
    printf $v_eigen;
