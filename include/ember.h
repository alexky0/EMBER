#ifndef EMBER_H
#define EMBER_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Opaque pointer type representing an EMBER window.
 *
 * You should treat this type as an opaque handle and not directly
 * access its members. It is used to identify and manipulate windows
 * created by EMBER.
 */
typedef void* EMBERWindow;

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
 * @brief Creates a new window for OpenGL rendering.
 *
 * This function creates a Windows window with the specified title,
 * width, and height. It also initializes the window for basic OpenGL
 * rendering capabilities, including setting up a double buffer.
 *
 * @param title A null-terminated string representing the title of the window.
 * @param width The desired width of the window in pixels.
 * @param height The desired height of the window in pixels.
 * @return An EMBERWindow handle to the newly created window on success,
 * or NULL on failure.
 */
EMBERWindow emCreateWindow(const char* title, int width, int height);


#ifdef __cplusplus
}
#endif

#endif