#!/bin/bash

read -p "Nombre de SSH : " Pengguna

if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel $Pengguna
        echo -e "User $Pengguna eliminado."
else
        echo -e "user: User $Pengguna no existe."
fi
