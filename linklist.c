#include <stdio.h>
#include <stdlib.h>

typedef struct _node
{
		int number;
		struct _node *next;
} Node;

int main()
{
		int i, number;
		Node *head = NULL;
		Node *last = NULL;
		Node *p = NULL;
		Node *thisnode = NULL;

		do
		{
				scanf("%d", &number);
				if(*p != NULL){
				p = (Node *)malloc(sizeof(Node));
				
				p->number = number;
				p->next = NULL;

				last = head;

				if(head){
				while (last->next)
				{
						last = last->next;

				}
				last->next = p;
				} else {
						head = p;
				}
				}
		} while (number != -1);

		/* Output the numbers storaged in above linklist*/
		thisnode = head;
		if(thisnode)
		 {
				 while(thisnode) {
				thisnode = thisnode->next;
				printf("%d #", thisnode->number);
				 }

				free(p);
		}
		else
		{
				printf("This linklist is empty!");
		}
}
