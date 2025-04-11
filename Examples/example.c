#include <stdio.h>
#include <glad/glad.h>
#include <ember.h>

static void key_callback(EMBERWindow* window, int key, int scancode, int action, int mods)
{
    if (key == EMBER_KEY_ESCAPE && action == EMBER_PRESS)
        emSetShouldClose(window);
}

static void cursor_enter_callback(EMBERWindow* window, int entered)
{
    if (entered)
        printf("Cursor entered window\n");
    else
        printf("Cursor left window\n");
}

static void mouse_button_callback(EMBERWindow* window, int button, int action, int mods)
{
    printf("Mouse Button: %d, Action: %d, Mods: %d\n", button, action, mods);
}

static void scroll_callback(EMBERWindow* window, double xoffset, double yoffset)
{
    printf("Scroll Offset: X = %f, Y = %f\n", xoffset, yoffset);
}

static void window_size_callback(EMBERWindow* window, int width, int height)
{
    printf("Window Size: Width = %d, Height = %d\n", width, height);
    glViewport(0, 0, width, height);
}

int main() {
    if (!emInit())
    {
        printf("Failed to initialize EMBER\n");
        return -1;
    }

    emWindowHint(EMBER_CONTEXT_MAJOR_VERSION, 4);
    emWindowHint(EMBER_CONTEXT_MINOR_VERSION, 6);
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

    emSetKeyCallback(window, key_callback);
    emSetCursorEnterCallback(window, cursor_enter_callback);
    emSetMouseButtonCallback(window, mouse_button_callback);
    emSetScrollCallback(window, scroll_callback);
    emSetResizeCallback(window, window_size_callback);

    glViewport(0, 0, 600, 600);
    glClearColor(0.17f, 0.8f, 0.4f, 1.0f);

    while (!emShouldClose(window))
    {
        glClear(GL_COLOR_BUFFER_BIT);

        emSwapBuffers(window);
        emPollEvents();
    }

    emDestroyWindow(window);
    emTerminate();
    return 0;
}