from django.contrib import admin
from .models import Project
from .agent import AgentClass
from .forms import AddProjectForm

def ValidateCredentialsGitHub_Admin(modeladmin, request, queryset):
    AgentInstance = AgentClass()
    for project in queryset:
        print ("Validation to " + project.projectname)
        Validate = AgentInstance.ValidateCredentialsGitHub(project)
        if (Validate) :
            project.status_github = "Ok"
            project.save()
        else:
            project.status_github = "Fail"
            project.save()
        #project.save()
ValidateCredentialsGitHub_Admin.short_description = 'Validate Github'



class ProjectAdmin(admin.ModelAdmin):
    list_display = ('projectname', 'domain', 'status_github', 'status_app')
    list_filter = ("status_github", "status_app",)
    search_fields = ['projectname', 'domain']
    prepopulated_fields = {'projectname': ('domain',)}
    form = AddProjectForm
    add_form = AddProjectForm
    actions = [ValidateCredentialsGitHub_Admin, ]



admin.site.register(Project, ProjectAdmin)
