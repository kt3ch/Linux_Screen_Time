
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <signal.h>

static unsigned long long** simple_hash;
static int notstop = 1;
static char** pid_name;

void signal_handler(int s){
  notstop = 0;
}
int hash_index(char* name){
    size_t len = strlen(name);
    int index = 0;
    for(int i = 0; i < len; i++){
      index += name[i];
    }
    while(pid_name[index] != NULL){
      if(strcmp(pid_name[index], name) == 0){
        return index;
      }
      index++;
      index = index % 1024;
    }
    char* ns = malloc(len + 1);
    strcpy(ns, name);
    ns[len] = '\0';
    pid_name[index] = ns;

    return index;
}

void get_log(){
  FILE* fptr = fopen("log.youshouldnotknow", "r");
  if(fptr == NULL){
    return;
  }
  char* buf = NULL;
  size_t l;
  ssize_t s;
  char* num;
  int n;
  int index = 0;
  while(1){
    s = getline(&buf, &l, fptr);
    if(s == -1){
      free(buf);
      break;
    }
    num = strchr(buf, '+');
    *num = '\0';
    num = num + 1;
    //printf("%s-----\n", buf);
    n = atol(num);
    index = hash_index(buf);
    simple_hash[index][1] = n;
    free(buf);
  }
  //fprintf(stdout, "%break\n");
  fclose(fptr);
}

void write_log(){
  FILE* fptr = fopen("log.youshouldnotknow", "w");
  if(fptr == NULL){
    return;
  }
  for(int i = 0; i < 1024; i++){
    if(simple_hash[i][1] != 0){
      fprintf(fptr, "%s+%u\n", pid_name[i], simple_hash[i][1]);
    }
  }
  fclose(fptr);
}


void initialize_hash(){
  pid_name = malloc(1024 * sizeof(void*));
  simple_hash = malloc(1024 * sizeof(void*));
  for(int i = 0; i < 1024; i++){
    simple_hash[i] = malloc(sizeof(unsigned long long) * 2);
    simple_hash[i][0] = 0;
    simple_hash[i][1] = 0;
    pid_name[i] = NULL;
  }
}

int add_seconds(char* name){

  int id = hash_index(name);
  simple_hash[id][1]++;
  write_log();
  return id;
}

int main(){
  initialize_hash();
  get_log();
  signal(SIGINT, signal_handler);
  int t = 0;
  size_t l;
  ssize_t bytesread;
  char* buf = NULL;
  char* namebuf = NULL;
  while(notstop){
    usleep(1000000);
    pid_t pid = fork();
    if(pid == 0){
      fclose(stderr);
      int ret = system("./nn.sh");
      exit(ret);
    }
   wait(NULL);
   FILE* fptr = fopen("f.txt", "r");
   if(fptr == NULL){
     printf("null\n");
     continue;
   }
   bytesread = getline(&namebuf, &l, fptr);
   if(bytesread == -1){
     continue;
   }
   if(namebuf[strlen(namebuf) - 1] == '\n'){
     namebuf[strlen(namebuf) - 1] = '\0';
   }
   int ind = -1;
   if(strlen(namebuf) >= 1){
     ind = add_seconds(namebuf);
   }
   //printf("%s-------\n", namebuf);
   bytesread = getline(&buf, &l, fptr);
   if(bytesread == -1){
     continue;
   }
   int temp = atoi(buf);
   //printf("%s: %d\n", buf, temp);
   if(ind != -1){
     simple_hash[ind][0] = temp;
   }
   fclose(fptr);
   free(namebuf);
   namebuf = NULL;
   free(buf);
   buf = NULL;
   t++;
 }
 write_log();
 for(int i = 0; i < 1024; i++){
   if(simple_hash[i][1] != 0){
     printf("%s: %d--%d s\n", pid_name[i], simple_hash[i][0], simple_hash[i][1]);
   }
   free(simple_hash[i]);
 }
 free(simple_hash);
}
