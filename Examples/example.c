#include <stdio.h>

#include <glad/glad.h>
#include <ember.h>

static void key_callback(EMBERWindow* window, int key, int scancode, int action, int mods) {
    printf("Key Callback: key=%d, scancode=%d, action=%d, mods=%d\n", key, scancode, action, mods);
}

static void cursor_pos_callback(EMBERWindow* window, int xpos, int ypos) {
    printf("Cursor Position Callback: xpos=%d, ypos=%d\n", xpos, ypos);
}

static void cursor_location_callback(EMBERWindow* window, int location) {
    printf("Cursor Location Callback: location=%d\n", location);
}

static void mouse_button_callback(EMBERWindow* window, int button, int action, int mods) {
    printf("Mouse Button Callback: button=%d, action=%d, mods=%d\n", button, action, mods);
}

static void scroll_callback(EMBERWindow* window, int xoffset, int yoffset) {
    printf("Scroll Callback: xoffset=%d, yoffset=%d\n", xoffset, yoffset);
}

static void resize_callback(EMBERWindow* window, int width, int height) {
    printf("Resize Callback: width=%d, height=%d\n", width, height);
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

    emSetKeyCallback(window, key_callback);
    emSetCursorPosCallback(window, cursor_pos_callback);
    emSetCursorLocationCallback(window, cursor_location_callback);
    emSetMouseButtonCallback(window, mouse_button_callback);
    emSetScrollCallback(window, scroll_callback);
    emSetResizeCallback(window, resize_callback);

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

        emSwapBuffers(window);
        emPollEvents();
    }

    emDestroyWindow(window);
    emTerminate();
    return 0;
}