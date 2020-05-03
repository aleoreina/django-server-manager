from django import forms
from .models import Project

class AddProjectForm(forms.ModelForm):
    error_messages = {
        'domain_taken': "domain is taken",
        'projectname_taken' : "projectname is taken",
    }

        
    class Meta:
        model = Project
        fields = ('domain', 'projectname', 'git_url', 'git_token' )

    def save(self, commit=True):
        instance = super(AddProjectForm, self).save(commit=False)
        CreateInstance = AgentClass()
        CreateInstance.CreateProject(instance)
        return instance
