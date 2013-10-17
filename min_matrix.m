function [minimum row column] = min_matrix(A);

[min_columns rows] = min(A);
[minimum column]   = min(min_columns);
row=rows(column)         ;
