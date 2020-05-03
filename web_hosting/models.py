from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _


class Project (models.Model):
    STATUS_APP = (
        ('Run', 'Run'),
        ('Deploying', 'Deploying'),
        ('Deploying_Fail', 'Deploying Failed'),
        ('Stop', 'Stop'),
    )
    STATUS_GITHUB = (
        ('Fail', 'Fail'),
        ('Ok', 'Ok'),
    )
    domain = models.CharField(max_length=120, unique=True)
    projectname = models.SlugField(max_length=30, unique=True)
    git_url = models.URLField(_("git url"), max_length=255)
    git_token = models.CharField(_("git token access"), max_length=255)
    updated_on = models.DateTimeField(auto_now= True)
    created_on = models.DateTimeField(auto_now_add=True)
    status_app = models.CharField(choices=STATUS_APP, max_length=30, editable=False)
    status_github = models.CharField(choices=STATUS_GITHUB, max_length=30, editable=False)
    
    class Meta:
        ordering = ['-domain']

    def __str__(self):
        return self.domain

