int myst( int n ){
 int i, j, k, l;

 j = 1;
 k = 1;
 for ( i = 3; i <= n; i++ ) {
 l = j + k;
 j = k;
 k = l;
 }
 return k;
} 