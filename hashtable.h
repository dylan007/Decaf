#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct node{
    char str[10000];
    int hash;
    struct node *next;
}node;

int hash(char *s){
    int val=0;
    int i;
    for(i=0;i<strlen(s);i++)
        val += s[i];
    return val%100;
}

node *createNode(char *s){
    node *n = (node *)malloc(sizeof(node));
    strcpy(n->str,s);
    n->hash = hash(s);
    n->next = NULL;
    return n;
}

node *insert(node *head,char *s){
    if(head == NULL)
        return createNode(s);
    node *n = createNode(s);
    n->next = head;
    return n;
}

void print(node *head){
    node *temp = head;
    while(temp!=NULL){
        printf("%s\n",temp->str);
        temp = temp->next;
    }
    return;
}

int search(node *head, char *s){
    if(head==NULL)
        return 0;
    node *temp = head;
    while(temp!=NULL){
        if(strcmp(s,temp->str)==0)
            return 1;
        temp = temp->next;
    }
    return 0;
}

int isEmptyList(node *head){
    return (head==NULL);
}