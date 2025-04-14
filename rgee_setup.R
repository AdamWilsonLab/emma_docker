system("which python3") #report on current location
reticulate::use_python('/usr/bin/python3')  # set up rgee
reticulate::py_discover_config()  # print current status
reticulate::py_config() # see the name of your conda (python) environment, in my case 'r-reticulate' 
reticulate::py_install('earthengine-api', envname='r-reticulate') \ #==0.1.370

# Check the installation of 'earthengine-api' with 
reticulate::py_list_packages() 
reticulate::py_list_packages()[reticulate::py_list_packages()$package == 'earthengine-api', ] 

# check python version with 
reticulate::py_run_string('import sys; print(sys.version)') 
rgee::ee_install_set_pyenv('/usr/bin/python3','r-reticulate', confirm = F) 

# install custom rgee version
devtools::install_github(repo = 'bmaitner/rgee', ref = 'noninteractive_auth')



