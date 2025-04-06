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

/**
 * @brief Checks if the user has requested to close the specified window.
 *
 * This function checks the internal state of the EMBER window to see
 * if a close event (e.g., clicking the close button) has been processed.
 *
 * @return 1 if the window should close, 0 otherwise.
 *
 * @note This function typically relies on the event polling mechanism
 * provided by emPollEvents().
 */
 int emShouldClose();

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

#ifdef __cplusplus
}
#endif

#endif