#include<stdio.h>
#include<fcntl.h>
#include<errno.h>
#include<stdio.h>
extern int errno;
int main() {
	long i = 0;
	while(i < 100000000001) { // 100,000,000,000 
		//printf("%d\n", i);
		if (i % 1000000000 == 0) printf("%ld\n", i);
		i++;
	}
}
