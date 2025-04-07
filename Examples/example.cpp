#include <stdio.h>

#include <ember.h>

int main() {
    if (!emInit())
    {
        printf("Failed to initialize EMBER");
        return -1;
    };

    EMBERWindow* window = emCreateWindow("EMBER Window", 600, 600);

    if (!window)
    {
        printf("Failed to create EMBER window");
        emTerminate();
        return -1;
    }

    if (!emMakeContext(window))
    {
        printf("Failed to create context for EMBER window");
        emTerminate();
        return -1;
    }

    while (!emShouldClose(window))
    {
        emPollEvents();
    }

    emDestroyWindow(window);
    emTerminate();

    return 0;
}