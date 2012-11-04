#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "glib.h"
#include "gnome-keyring.h"

const char* SERVER = "using_gnome_keyring";

MODULE=Passwd::Keyring::Gnome    PACKAGE=Passwd::Keyring::Gnome 

SV*
_get_default_keyring_name()
    CODE:
        char *name;
        gnome_keyring_get_default_keyring_sync(&name);
        RETVAL = newSVpv(name, 0);
        g_free(name);
    OUTPUT:
        RETVAL

void
_set_password(const char *user, const char* password, const char *domain)
    CODE:
        guint32 item_id;
        if(GNOME_KEYRING_RESULT_OK == 
           gnome_keyring_set_network_password_sync(
              NULL, /* keyring (null=default) */
              user,
              domain,
              SERVER, /* server */
              NULL, /* remote object */
              NULL, /* protocol */
              NULL, /* auth-type */
              0,    /* port */
              password,    
              &item_id))
        {
              /* printf("Saved password, id: %d\n", item_id); */
              return;
        }
        else
        {
                croak("Failed to set password");
        }


SV*
_get_password(const char *user, const char *domain)
    CODE:
        GList *results;
        GnomeKeyringResult status = 
             gnome_keyring_find_network_password_sync(
                user,
                domain,
                SERVER, /* server */
                NULL, /* remote object */
                NULL, /* protocol */
                NULL, /* auth-type */
                0,    /* port */
                &results);
        if(status == GNOME_KEYRING_RESULT_OK)
        {
            GList *node;
            GnomeKeyringNetworkPasswordData *item;
            RETVAL = 0;
            for (node = g_list_first (results);
                 node != NULL;
                 node = g_list_next (node))
            {
              item = (GnomeKeyringNetworkPasswordData *) node->data;
              RETVAL = newSVpv(item->password, 0);
              /*
              printf("Found item.\n");
              printf("  item-id: %d\n", item->item_id);
              printf("  keyring: %s\n", item->keyring);
              printf("  server: %s\n", item->server);
              printf("  object: %s\n", item->object);
              printf("  port: %d\n", item->port);
              printf("  user: %s\n", item->user);
              printf("  domain: %s\n", item->domain);
              printf("  password: %s\n", item->password); */
              break;
            }

            if(! RETVAL)
            {
               RETVAL = newSV(0);
            }

            gnome_keyring_network_password_list_free(results);
        }
        else if (status == GNOME_KEYRING_RESULT_NO_MATCH)
        {
            RETVAL = newSV(0);
        }
        else
        {
            croak("Failed to find a password. Error code: %d", status);
        }
    OUTPUT:
        RETVAL

