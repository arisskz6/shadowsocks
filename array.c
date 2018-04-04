#include <stdio.h>

int main(void)
{
		int a[20];
		int b[10];
		int i, A, j;

		for(i = 0; i < 20; i++)
		{
				scanf("%d", &A);
				a[i] = A;
		}

		for (j = 0; j < 10; j++)
		{
				int n;
				n = 2 * j +1;
				b[j] = a[n];
		}

		for (j = 0; j < 10; j++)
		{
				printf("%d ", b[j]);
		}
		printf("\n");

		return 0;
}
