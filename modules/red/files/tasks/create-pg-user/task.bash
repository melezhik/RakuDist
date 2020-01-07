user=$(config user)

su - postgres -l -c "createuser -d -A $user && echo user created" 2>&1
