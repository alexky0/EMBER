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
    void* hwnd;          /* Window handle */
    void* hdc;           /* Device context handle */
    void* hglrc;         /* OpenGL rendering context handle */
    int quit;            /* Flag indicating whether the window should close */
    unsigned char keys[256]; /* Array of 256 key states */

    /* Callback function pointers */
    void (*keyCallback)(struct EMBERWindow_t*, int, int, int, int);
    void (*cursorPosCallback)(struct EMBERWindow_t*, double, double);
    void (*cursorEnterCallback)(struct EMBERWindow_t*, int);
    void (*mouseButtonCallback)(struct EMBERWindow_t*, int, int, int);
    void (*scrollCallback)(struct EMBERWindow_t*, double, double);
    void (*resizeCallback)(struct EMBERWindow_t*, int, int);
} EMBERWindow;

/**
 * @brief Function pointer type for key input callbacks.
 *
 * This type defines the signature for functions that will be called when
 * a keyboard key is pressed, released, or repeated.
 *
 * @param window The window that received the event.
 * @param key The keyboard key that was pressed or released. See EMBER_KEY_* constants.
 * @param scancode The system-specific scancode of the key.
 * @param action The key action. One of:
 * - EMBER_KEY_PRESSED
 * - EMBER_KEY_RELEASED
 * - EMBER_KEY_REPEAT
 * @param mods Bit field describing which modifier keys were held down.
 * Possible values (can be combined with bitwise OR):
 * - 0 (no modifiers)
 * - EMBER_MOD_SHIFT
 * - EMBER_MOD_CONTROL
 * - EMBER_MOD_ALT
 * - EMBER_MOD_SUPER
 */
typedef void (*emKeyCallback)(EMBERWindow*, int, int, int, int);

/**
 * @brief Function pointer type for cursor position callbacks.
 *
 * This type defines the signature for functions that will be called when
 * the cursor is moved within the window.
 *
 * @param window The window that received the event.
 * @param xpos The new x-coordinate of the cursor, relative to the left edge of the window.
 * @param ypos The new y-coordinate of the cursor, relative to the top edge of the window.
 */
typedef void (*emCursorPosCallback)(EMBERWindow*, int, int);

/**
 * @brief Function pointer type for cursor enter/leave callbacks.
 *
 * This type defines the signature for functions that will be called when
 * the cursor enters or leaves the window.
 *
 * @param window The window that received the event.
 * @param entered 1 if the cursor entered the window, 0 if it left.
 */
typedef void (*emCursorEnterCallback)(EMBERWindow*, int);

/**
 * @brief Function pointer type for mouse button callbacks.
 *
 * This type defines the signature for functions that will be called when
 * a mouse button is pressed or released.
 *
 * @param window The window that received the event.
 * @param button The mouse button that was pressed or released. See EMBER_MOUSE_BUTTON_* constants.
 * @param action The button action. One of:
 * - EMBER_PRESS
 * - EMBER_RELEASE
 * @param mods Bit field describing which modifier keys were held down.
 * Possible values (can be combined with bitwise OR):
 * - 0 (no modifiers)
 * - EMBER_MOD_SHIFT
 * - EMBER_MOD_CONTROL
 * - EMBER_MOD_ALT
 * - EMBER_MOD_SUPER
 */
typedef void (*emMouseButtonCallback)(EMBERWindow*, int, int, int);

/**
 * @brief Function pointer type for scroll callbacks.
 *
 * This type defines the signature for functions that will be called when
 * the user scrolls with a mouse wheel or trackpad.
 *
 * @param window The window that received the event.
 * @param xoffset The amount of horizontal scrolling.
 * @param yoffset The amount of vertical scrolling.
 */
typedef void (*emScrollCallback)(EMBERWindow*, int, int);

/**
 * @brief Function pointer type for window resize callbacks.
 *
 * This type defines the signature for functions that will be called when
 * the window is resized.
 *
 * @param window The window that was resized.
 * @param width The new width of the window in pixels.
 * @param height The new height of the window in pixels.
 */
typedef void (*emResizeCallback)(EMBERWindow*, int, int);

/* OpenGL Context Profile Constants */
#define EMBER_OPENGL_CORE_PROFILE         0x00000001
#define EMBER_OPENGL_COMPATIBILITY_PROFILE 0x00000002

/* Window Hint Types */
#define EMBER_CONTEXT_MAJOR_VERSION       1
#define EMBER_CONTEXT_MINOR_VERSION       2
#define EMBER_CONTEXT_PROFILE             3

/* Key Code Definitions */
#define EMBER_KEY_UNKNOWN         0
#define EMBER_KEY_BACKSPACE       8
#define EMBER_KEY_TAB             9
#define EMBER_KEY_ENTER           13
#define EMBER_KEY_PAUSE           19
#define EMBER_KEY_CAPS_LOCK       20
#define EMBER_KEY_ESCAPE          27
#define EMBER_KEY_SPACE           32
#define EMBER_KEY_PAGE_UP         33
#define EMBER_KEY_PAGE_DOWN       34
#define EMBER_KEY_END             35
#define EMBER_KEY_HOME            36
#define EMBER_KEY_LEFT            37
#define EMBER_KEY_UP              38
#define EMBER_KEY_RIGHT           39
#define EMBER_KEY_DOWN            40
#define EMBER_KEY_PRINT_SCREEN    44
#define EMBER_KEY_INSERT          45
#define EMBER_KEY_DELETE          46
#define EMBER_KEY_SLASH           47
#define EMBER_KEY_0               48
#define EMBER_KEY_1               49
#define EMBER_KEY_2               50
#define EMBER_KEY_3               51
#define EMBER_KEY_4               52
#define EMBER_KEY_5               53
#define EMBER_KEY_6               54
#define EMBER_KEY_7               55
#define EMBER_KEY_8               56
#define EMBER_KEY_9               57
#define EMBER_KEY_SEMICOLON       59
#define EMBER_KEY_EQUAL           61
#define EMBER_KEY_A               65
#define EMBER_KEY_B               66
#define EMBER_KEY_C               67
#define EMBER_KEY_D               68
#define EMBER_KEY_E               69
#define EMBER_KEY_F               70
#define EMBER_KEY_G               71
#define EMBER_KEY_H               72
#define EMBER_KEY_I               73
#define EMBER_KEY_J               74
#define EMBER_KEY_K               75
#define EMBER_KEY_L               76
#define EMBER_KEY_M               77
#define EMBER_KEY_N               78
#define EMBER_KEY_O               79
#define EMBER_KEY_P               80
#define EMBER_KEY_Q               81
#define EMBER_KEY_R               82
#define EMBER_KEY_S               83
#define EMBER_KEY_T               84
#define EMBER_KEY_U               85
#define EMBER_KEY_V               86
#define EMBER_KEY_W               87
#define EMBER_KEY_X               88
#define EMBER_KEY_Y               89
#define EMBER_KEY_Z               90
#define EMBER_KEY_LEFT_SUPER      91
#define EMBER_KEY_LEFT_BRACKET    91
#define EMBER_KEY_RIGHT_SUPER     92
#define EMBER_KEY_BACKSLASH       92
#define EMBER_KEY_MENU            93
#define EMBER_KEY_RIGHT_BRACKET   93
#define EMBER_KEY_GRAVE_ACCENT    96
#define EMBER_KEY_KP_0            96
#define EMBER_KEY_KP_1            97
#define EMBER_KEY_KP_2            98
#define EMBER_KEY_KP_3            99
#define EMBER_KEY_KP_4            100
#define EMBER_KEY_KP_5            101
#define EMBER_KEY_KP_6            102
#define EMBER_KEY_KP_7            103
#define EMBER_KEY_KP_8            104
#define EMBER_KEY_KP_9            105
#define EMBER_KEY_KP_MULTIPLY     106
#define EMBER_KEY_KP_ADD          107
#define EMBER_KEY_KP_SUBTRACT     109
#define EMBER_KEY_KP_DECIMAL      110
#define EMBER_KEY_KP_DIVIDE       111
#define EMBER_KEY_F1              112
#define EMBER_KEY_F2              113
#define EMBER_KEY_F3              114
#define EMBER_KEY_F4              115
#define EMBER_KEY_F5              116
#define EMBER_KEY_F6              117
#define EMBER_KEY_F7              118
#define EMBER_KEY_F8              119
#define EMBER_KEY_F9              120
#define EMBER_KEY_F10             121
#define EMBER_KEY_F11             122
#define EMBER_KEY_F12             123
#define EMBER_KEY_F13             124
#define EMBER_KEY_F14             125
#define EMBER_KEY_F15             126
#define EMBER_KEY_F16             127
#define EMBER_KEY_F17             128
#define EMBER_KEY_F18             129
#define EMBER_KEY_F19             130
#define EMBER_KEY_F20             131
#define EMBER_KEY_F21             132
#define EMBER_KEY_F22             133
#define EMBER_KEY_F23             134
#define EMBER_KEY_F24             135
#define EMBER_KEY_SCROLL_LOCK     145
#define EMBER_KEY_NUM_LOCK        144
#define EMBER_KEY_LEFT_SHIFT      160
#define EMBER_KEY_RIGHT_SHIFT     161
#define EMBER_KEY_WORLD_1         161
#define EMBER_KEY_WORLD_2         162
#define EMBER_KEY_LEFT_CONTROL    162
#define EMBER_KEY_RIGHT_CONTROL   163
#define EMBER_KEY_LEFT_ALT        164
#define EMBER_KEY_RIGHT_ALT       165
#define EMBER_KEY_KP_EQUAL        187
#define EMBER_KEY_APOSTROPHE      39
#define EMBER_KEY_COMMA           44
#define EMBER_KEY_MINUS           45
#define EMBER_KEY_PERIOD          46

/* Key State Constants */
#define EMBER_KEY_PRESSED     1
#define EMBER_KEY_RELEASED    0
#define EMBER_KEY_REPEAT      2 /* For continuous key presses */

/* Modifier Key Masks */
#define EMBER_MOD_SHIFT   0x0001
#define EMBER_MOD_CONTROL 0x0002
#define EMBER_MOD_ALT     0x0004
#define EMBER_MOD_SUPER   0x0008

/* Mouse Button Definitions */
#define EMBER_MOUSE_BUTTON_1      0
#define EMBER_MOUSE_BUTTON_LEFT   EMBER_MOUSE_BUTTON_1
#define EMBER_MOUSE_BUTTON_2      1
#define EMBER_MOUSE_BUTTON_RIGHT  EMBER_MOUSE_BUTTON_2
#define EMBER_MOUSE_BUTTON_3      2
#define EMBER_MOUSE_BUTTON_MIDDLE EMBER_MOUSE_BUTTON_3
#define EMBER_MOUSE_BUTTON_4      3
#define EMBER_MOUSE_BUTTON_5      4
#define EMBER_MOUSE_BUTTON_6      5
#define EMBER_MOUSE_BUTTON_7      6
#define EMBER_MOUSE_BUTTON_8      7

/* Mouse Button Action Constants */
#define EMBER_PRESS   1
#define EMBER_RELEASE 0

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
 * @brief Closes the given specified window.
 *
 * This function sets the quit flag of the given window to 1,
 * forcing it to quit on the next polling of events.
 *
 * @param window A pointer to the EMBERWindow structure to close.
 */
void emSetShouldClose(EMBERWindow* window);

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
 * @param key The given key to detect key presses for (see EMBER_KEY_* constants).
 * @return The state of the key, 1 for pressed, 0 for not pressed.
 */
int emGetKey(EMBERWindow* window, int key);

/**
 * @brief Sets the callback function for key events.
 *
 * This function sets the user-defined callback function that will be
 * called when a key is pressed, released, or repeated on the specified window.
 *
 * @param window The window to set the callback for.
 * @param callback The function pointer to the key callback function.
 * If NULL, the current callback will be unset.
 *
 * @sa emKeyCallback
 */
void emSetKeyCallback(EMBERWindow* window, emKeyCallback callback);

/**
 * @brief Sets the callback function for cursor position events.
 *
 * This function sets the user-defined callback function that will be
 * called when the cursor is moved within the specified window.
 *
 * @param window The window to set the callback for.
 * @param callback The function pointer to the cursor position callback function.
 * If NULL, the current callback will be unset.
 *
 * @sa emCursorPosCallback
 */
void emSetCursorPosCallback(EMBERWindow* window, emCursorPosCallback callback);

/**
 * @brief Sets the callback function for cursor enter/leave events.
 *
 * This function sets the user-defined callback function that will be
 * called when the cursor enters or leaves the specified window.
 *
 * @param window The window to set the callback for.
 * @param callback The function pointer to the cursor enter/leave callback function.
 * If NULL, the current callback will be unset.
 *
 * @sa emCursorEnterCallback
 */
void emSetCursorEnterCallback(EMBERWindow* window, emCursorEnterCallback callback);

/**
 * @brief Sets the callback function for mouse button events.
 *
 * This function sets the user-defined callback function that will be
 * called when a mouse button is pressed or released on the specified window.
 *
 * @param window The window to set the callback for.
 * @param callback The function pointer to the mouse button callback function.
 * If NULL, the current callback will be unset.
 *
 * @sa emMouseButtonCallback
 */
void emSetMouseButtonCallback(EMBERWindow* window, emMouseButtonCallback callback);

/**
 * @brief Sets the callback function for scroll events.
 *
 * This function sets the user-defined callback function that will be
 * called when the user scrolls with a mouse wheel or trackpad on the
 * specified window.
 *
 * @param window The window to set the callback for.
 * @param callback The function pointer to the scroll callback function.
 * If NULL, the current callback will be unset.
 *
 * @sa emScrollCallback
 */
void emSetScrollCallback(EMBERWindow* window, emScrollCallback callback);

/**
 * @brief Sets the callback function for window resize events.
 *
 * This function sets the user-defined callback function that will be
 * called when the specified window is resized.
 *
 * @param window The window to set the callback for.
 * @param callback The function pointer to the window resize callback function.
 * If NULL, the current callback will be unset.
 *
 * @sa emResizeCallback
 */
void emSetResizeCallback(EMBERWindow* window, emResizeCallback callback);

#ifdef __cplusplus
}
#endif
 
#endif