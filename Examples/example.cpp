#include <stdio.h>

#include <ember.h>

int main() {
    if (!emInit())
    {
        printf("Failed to initialize EMBER");
        return -1;
    };

    EMBERWindow window = emCreateWindow("EMBER Window", 600, 600);

    if (!window)
    {
        printf("Failed to create EMBER window");
        emTerminate();
        return -1;
    }

    emTerminate();

    return 0;
}