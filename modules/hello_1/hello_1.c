#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/kernel.h>   

MODULE_LICENSE("GPL");

static int hello_init(void)
{
	printk(KERN_ALERT "Module loaded: Hello World !\n");
	return 0;
}

static void hello_cleanup(void)
{
	printk(KERN_WARNING "Done already ?\n");
}

module_init(hello_init);
module_exit(hello_cleanup);
