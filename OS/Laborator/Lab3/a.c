#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

int main()
{
	const int SZ_MAX = 1000;
	char a[SZ_MAX];
	char b[SZ_MAX];
	memset(b, 0, sizeof b);

	printf("Ce mesaj vreti sa copiati?\n");
	scanf("%s", a);

	int l = strlen(a), copied = 0;
	int x;
	
	while ((x = syscall(331, a + copied, b + copied, l - copied)) > 0)
		copied += x;
	
	if (x < 0) {
		printf("Error while copying string!\n");
		return -1;
	}

	printf("Successfully copied string:\n%s\n", b);

       	return 0;
}	
