#ifndef EMBER_H
#define EMBER_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Initializes the EMBER library.
 *
 * This function must be called before any other EMBER functions.
 * It registers the window class used by EMBER.
 *
 * @return 1 on success, 0 on fail.
 */
int emInit();

/**
 * @brief Terminates the EMBER library.
 *
 * This function performs the necessary cleanup when the EMBER library
 * is no longer needed. It unregisters the window class that EMBER
 * registered during initialization. You should call this function
 * before your application exits to avoid potential resource leaks
 * or unexpected behavior.
 *
 */
void emTerminate();

#ifdef __cplusplus
}
#endif

#endif