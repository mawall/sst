# sst
SST (System Setup Tool) installs and configures software packages (including my 
personal environment) on unix-based systems.

Packages - ie. scripts that handle installation and removal of software - can 
be added to the packages subdirectory and will be available for use with SST. 
All packages have to implement the following three functions:

    describe_<package_name>(){
        echo "Short description of the software included here."
    }
    
    install_<package_name>(){
        # Installation commands
    }
    
    uninstall_<package_name>(){
        # Removal commands
    }

Use `git clone git@github.com:mawall/sst.git ~/.sst` to clone
