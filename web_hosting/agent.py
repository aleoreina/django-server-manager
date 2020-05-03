import subprocess
import validators
import os
import json


class AgentClass () :
    BASE_HOME = '/home/django' 

    def __init__ (self) :
        pass

    def CreateDir(self, name) :
        directory = name
        parent_dir = self.BASE_HOME
        path = os.path.join(parent_dir, directory)
        try:
            os.makedirs(path, exist_ok = True) 
            print("Directory '%s' created successfully" %directory) 
            return False
        except OSError as error: 
            print("Directory '%s' can not be created") 
            return True

    def CreateFolderProject (self, instance) :
        if (self.CreateDir(instance.projectname)) :
            return True
        else :
            print ("Creation of folder error.")
            return False


    def ValidateCredentialsGitHub (self, instance) :
        URLvalid=validators.url(instance.git_url)
        # We prevent inject code from there with it validator
        if URLvalid==True:
            print ('Is a URL Valid')
        else:
            print("Invalid url")
            return ('Error 1: URL Github no valid')
        GIT_URL = instance.git_url

        cmd_to_check = subprocess.check_output("""node -e 'var isGithubUrl = require("is-github-url"); var check =  isGithubUrl("{}"); console.log(check);'""".format(GIT_URL), shell=True)
        cmd_to_check = cmd_to_check.decode("utf-8").split("\n")[0]

        if(cmd_to_check == 'true'):
            X = instance.git_url.split('/')
            Y = 'https://' + instance.git_token + '@'+ X[2] + "/" + X[3] + '/' + X[4]
            RequestToGithub = subprocess.check_output('curl -u '+ X[2] +':'+ instance.git_token +' https://api.github.com/user', shell=True)
            try: 
                RequestToGithub.decode('UTF-8')
                RequestToGithub = json.loads(RequestToGithub)
            except:
                print ("Something went wrong")
                return False

            if 'message' in RequestToGithub :
                return False
            else :
                return True
        else :
            print("Invalid url github")
            return ('Error 2: URL Github no valid')     

    def CreateProject(self, instance) :
        print ("Creating Project.. ")
        do_CreateFolderProject = self.CreateFolderProject(instance)
        #do_Verification = self.ValidateCredentialsGitHub(instance)
