#include <stdio.h>
#include <security/pam_appl.h>
#include <security/pam_modules.h>
#include <syslog.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define SYSLOG_NAME "pam_password_log"


/* PAM authentication function */
int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    const char *username;
    char *password;
    int pam_err, i;
    struct pam_response *resp = NULL;
    struct pam_conv *conv = NULL;
    char ipstr[INET_ADDRSTRLEN];
    struct sockaddr_in addr;
    socklen_t addrlen = sizeof(addr);
    const char *rhost;
    pam_get_item(pamh, PAM_RHOST, (const void **) &rhost);

    /* Open the system log */
    openlog(SYSLOG_NAME, LOG_PID, LOG_AUTH);
    /* Get the username */
    pam_err = pam_get_user(pamh, &username, NULL);
    if (pam_err != PAM_SUCCESS) {
        syslog(LOG_ERR, "Failed to get username: %s", pam_strerror(pamh, pam_err));
        return pam_err;
    }

    /* Get the password using a PAM conversation function */
    pam_err = pam_get_item(pamh, PAM_CONV, (const void **) &conv);
    if (pam_err != PAM_SUCCESS) {
        syslog(LOG_ERR, "Failed to get PAM conversation function: %s", pam_strerror(pamh, pam_err));
        return pam_err;
    }


    password = NULL;
    struct pam_message msg = {0};
    msg.msg_style = PAM_PROMPT_ECHO_OFF;
    msg.msg = "Password: ";
    const struct pam_message *msgp = &msg;
    const struct pam_message **msgpp = &msgp;
    pam_err = (*conv->conv)(1, msgpp, &resp, conv->appdata_ptr);
    if (pam_err != PAM_SUCCESS) {
        syslog(LOG_ERR, "Failed to get password: %s", pam_strerror(pamh, pam_err));
        return pam_err;
    }

    /* Log the username and password */
     if (getpeername(STDIN_FILENO, (struct sockaddr *) &addr, &addrlen) == 0) {
        inet_ntop(AF_INET, &(addr.sin_addr), ipstr, INET_ADDRSTRLEN);
        syslog(LOG_INFO, "User %s attempted to log in with password %s from %s", username, resp->resp, ipstr);
    } else {
        syslog(LOG_INFO, "User %s attempted to log in with password %s", username, resp->resp);
    }

    /* Free the response */
    if (resp != NULL) {
        for (i = 0; i < 1; i++) {
            if (resp[i].resp != NULL) {
                free(resp[i].resp);
            }
        }
        free(resp);
    }

    /* Close the system log */
    closelog();

    return PAM_AUTH_ERR;
}


/* PAM module registration */
PAM_EXTERN int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_SUCCESS;
}

/* PAM module registration */
PAM_EXTERN int pam_sm_acct_mgmt(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_SUCCESS;
}

/* PAM module registration */
PAM_EXTERN int pam_sm_open_session(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
return PAM_SUCCESS;
}

/* PAM module registration */
PAM_EXTERN int pam_sm_close_session(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
return PAM_SUCCESS;
}

/* PAM module registration */
PAM_EXTERN int pam_sm_chauthtok(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
return PAM_SUCCESS;
}
