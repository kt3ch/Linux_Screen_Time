#include <linux/module.h>	/* Needed by all modules */
#include <linux/kernel.h>	/* Needed for KERN_INFO */
MODULE_LICENSE("GPL");
int init_module(void)
{
  int i = 0;
  for (i = 0; i < 10; i++)
	   printk(KERN_INFO "Hello world.\n");
	return 0;
}

void cleanup_module(void)
{
	printk(KERN_INFO "Goodbye world.\n");
}
