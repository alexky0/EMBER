#ifndef EMBER_H
#define EMBER_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Structure representing an EMBER window.
 *
 * This structure holds the internal data associated with a window
 * created by EMBER. You should treat instances of this struct as
 * opaque handles and not directly access its members from C/C++.
 */
 typedef struct EMBERWindow_t {
    void* hwnd;             /* Window handle */
    void* hdc;              /* Device context handle */
    void* hglrc;            /* OpenGL rendering context handle */
    int quit;               /* Flag indicating whether the window should close */
    unsigned char keys[256];/* Array of 256 key states */
} EMBERWindow;

/* OpenGL Context Profile Constants */
#define EMBER_OPENGL_CORE_PROFILE          0x00000001
#define EMBER_OPENGL_COMPATIBILITY_PROFILE 0x00000002

/* Window Hint Types */
#define EMBER_CONTEXT_MAJOR_VERSION        1
#define EMBER_CONTEXT_MINOR_VERSION        2
#define EMBER_CONTEXT_PROFILE              3

/**
 * @brief Initializes the EMBER library.
 *
 * This function must be called before any other EMBER functions.
 * It registers the window class used by EMBER with the Windows API.
 * Failure to call this function first can lead to undefined behavior.
 *
 * @return 1 on success, 0 on fail.
 */
int emInit();

/**
 * @brief Terminates the EMBER library.
 *
 * This function cleans all resources used by EMBER.
 *
 * @sa emInit()
 */
void emTerminate();

/**
 * @brief Sets global hints for the next window to be created.
 *
 * This function allows setting various global parameters for OpenGL context
 * creation. These hints will apply to all subsequent windows created
 * after the hint is set.
 *
 * @param hint The hint to set (one of the EMBER_CONTEXT_* constants).
 * @param value The value to set for the specified hint.
 *
 * Valid hints:
 * - EMBER_CONTEXT_MAJOR_VERSION: Major version of OpenGL context
 * - EMBER_CONTEXT_MINOR_VERSION: Minor version of OpenGL context
 * - EMBER_CONTEXT_PROFILE: Profile mask (EMBER_OPENGL_CORE_PROFILE or
 * EMBER_OPENGL_COMPATIBILITY_PROFILE)
 */
 void emWindowHint(int hint, int value);

/**
 * @brief Creates a new window for OpenGL rendering.
 *
 * This function creates a Windows window with the specified title,
 * width, and height. It also initializes the window for basic OpenGL
 * rendering capabilities, including setting up a double buffer
 * and associating internal window data.
 *
 * @param title A null-terminated string representing the title of the window.
 * @param width The desired width of the window in pixels.
 * @param height The desired height of the window in pixels.
 * @return An EMBERWindow handle to the newly created window on success,
 * or NULL on failure.
 */
EMBERWindow* emCreateWindow(const char* title, int width, int height);

/**
 * @brief Destroys the specified EMBER window.
 *
 * This function destroys the Windows window associated with the
 * EMBERWindow handle and releases any associated resources.
 *
 * @param window A pointer to the EMBERWindow structure of the window to destroy.
 */
void emDestroyWindow(EMBERWindow* window);

/**
 * @brief Checks if the user has requested to close the specified window.
 *
 * This function checks the internal state of the EMBER window to see
 * if a close event (e.g., clicking the close button) has been processed.
 *
 * @param window A pointer to the EMBERWindow structure of the window to check.
 * @return 1 if the window should close, 0 otherwise.
 *
 * @note This function typically relies on the event polling mechanism
 * provided by emPollEvents().
 */
int emShouldClose(EMBERWindow* window);

/**
 * @brief Polls for and processes pending window events.
 *
 * This function checks the Windows message queue for events related to
 * EMBER-created windows (e.g., keyboard input, mouse input, window resizing,
 * close requests). It dispatches these events to the appropriate window
 * procedures for handling. This function should be called regularly in
 * the application's main loop to ensure responsiveness.
 */
void emPollEvents();

/**
 * @brief Makes the OpenGL rendering context current for the specified window.
 *
 * This function makes the OpenGL rendering context associated with the
 * given EMBER window the current context, allowing OpenGL commands to
 * be drawn to that window.
 *
 * @param window A pointer to the EMBERWindow structure of the window to make the context current for.
 * @return 1 on success, 0 on fail.
 */
int emMakeContext(EMBERWindow* window);

/**
 * @brief Swaps the front and back buffer of OpenGL context.
 *
 * This function swaps the front buffer, the one displayed on the window,
 * and the back buffer, the one being drawn to in the background.
 * Swapping the buffers makes rendering while displaying visual data
 * more efficient.
 *
 * @param window A pointer to the EMBERWindow structure of the window to swap the buffers for.
 */
void emSwapBuffers(EMBERWindow* window);

/**
 * @brief Retrieves the address of an OpenGL extension function.
 *
 * This function provides a way to access OpenGL extension functions
 * that might not be directly available in the core OpenGL library.
 * You typically use this function in conjunction with a library like
 * GLAD or GLEW to load and use modern OpenGL features.
 *
 * @param procName A null-terminated string specifying the name of the
 * OpenGL extension function to retrieve.
 * @return A pointer to the requested function if found, otherwise NULL.
 */
void* emGetProc(const char* procName);

/**
 * @brief Retrieves the state of a key on a given window.
 *
 * This function retrieves the state of a given key within
 * the given window's key states array.
 *
 * @param window A pointer to the EMBERWindow structure to detect keypresses.
 * @param key The given key to detect key presses for
 * @return The state of the key, 1 for pressed, 0 for not presse
 */
int emGetKey(EMBERWindow* window, int key);

#ifdef __cplusplus
}
#endif

#endif