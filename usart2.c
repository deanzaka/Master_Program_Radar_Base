#include <mega162.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "usart2.h"

void printf1(char *st)
{
    int i, c;
    i = strlen(st);
    
    for(c = 0; c < i; c++)
    {
        putchar1(st[c]);
    }
}