#include <stdlib.h>
#include </usr/include/linux/types.h>
//#include <iostream>
#include <signal.h>
#include <unistd.h>
#include<stdio.h>
#include<fcntl.h>
#include<errno.h>
#include<stdio.h>
#include<string.h>
void *ptrs[20];
int main() {

  char *p;
  if ((p = malloc(600 * 1024 * 1024))) {
    memset(p, 0, 500 * 1024 * 1024);
  }


  long i = 0;
	while(i < 100000000001) { // 100,000,000,000
		//printf("%d\n", i);
    //memset(p, 0, 200 * 1024 * 1024);
		if (i % 1000000000 == 0) printf("%ld\n", i);       // 20B
    if (i == 5000000000) {  // 5,000,000,000
      int index = 0;
      for (; index < 20; index++) {
        ptrs[index] = malloc(10 * 1024 * 1024);      // malloc 10MB
        memset(ptrs[index], 0, 10 * 1024 * 1024);
      }
    }

		i++;
	}
  return 0;
}
