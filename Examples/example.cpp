#include <stdio.h>

#include <ember.h>

int main() {
    if (!emInit())
    {
        printf("Failed to initialize EMBER");
        return -1;
    };

    emTerminate();

    return 0;
}