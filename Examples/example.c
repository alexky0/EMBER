#include <stdio.h>
#include <glad/glad.h>
#include <ember.h>
#include <windows.h>

int main() {
    if (!emInit()) {
        printf("Failed to initialize EMBER\n");
        return -1;
    }

    EMBERWindow* window = emCreateWindow("EMBER Window", 600, 600);
    if (!window) {
        printf("Failed to create EMBER window\n");
        emTerminate();
        return -1;
    }

    emWindowHint(window, EMBER_CONTEXT_MAJOR_VERSION, 4);
    emWindowHint(window, EMBER_CONTEXT_MINOR_VERSION, 6);
    emWindowHint(window, EMBER_CONTEXT_PROFILE, EMBER_OPENGL_CORE_PROFILE);

    if (!emMakeContext(window)) {
        printf("Failed to make context current\n");
        emDestroyWindow(window);
        emTerminate();
        return -1;
    }

    while (!emShouldClose(window)) {
        emSwapBuffers(window);
        emPollEvents();
    }

    emDestroyWindow(window);
    emTerminate();
    return 0;
}