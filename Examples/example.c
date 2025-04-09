#include <stdio.h>
#include <glad/glad.h>
#include <ember.h>

int main() {
    if (!emInit())
    {
        printf("Failed to initialize EMBER\n");
        return -1;
    }

    emWindowHint(EMBER_CONTEXT_MAJOR_VERSION, 3);
    emWindowHint(EMBER_CONTEXT_MINOR_VERSION, 3);
    emWindowHint(EMBER_CONTEXT_PROFILE, EMBER_OPENGL_CORE_PROFILE);

    EMBERWindow* window = emCreateWindow("EMBER Window", 600, 600);
    if (!window)
    {
        printf("Failed to create EMBER window\n");
        emTerminate();
        return -1;
    }

    if (!emMakeContext(window))
    {
        printf("Failed to make context current\n");
        emDestroyWindow(window);
        emTerminate();
        return -1;
    }

    if (!gladLoadGLLoader((GLADloadproc)emGetProc))
    {
        printf("Failed to initialize GLAD\n");
        emDestroyWindow(window);
        emTerminate();
        return -1;
    }

    glViewport(0, 0, 600, 600);
    glClearColor(0.17f, 0.8f, 0.4f, 1.0f);

    while (!emShouldClose(window))
    {
        glClear(GL_COLOR_BUFFER_BIT);

        if (emGetKey(window, EMBER_KEY_ESCAPE) == EMBER_KEY_PRESSED)
            emSetShouldClose(window);
        
        emSwapBuffers(window);
        emPollEvents();
    }

    emDestroyWindow(window);
    emTerminate();
    return 0;
}