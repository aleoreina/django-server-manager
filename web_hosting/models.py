from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _


class Account (models.Model):
    STATUS_ACCOUNT = (
        ('Running', 'Running'),
        ('Deploying', 'Deploying'),
        ('Deploying_Fail', 'Deploying Failed'),
        ('Online', 'Online'),
        ('Stop', 'Stop'),
    )
    projectname = models.CharField(max_length=10, unique=True)
    domain = models.SlugField(max_length=253, unique=True)
    port = models.IntegerField(_("port"), max_length=5)
    git_url = models.IntegerField(_("git url"), max_length=255)
    git_token = models.IntegerField(_("git token access"), max_length=255)
    updated_on = models.DateTimeField(auto_now= True)
    created_on = models.DateTimeField(auto_now_add=True)
    status = models.CharField(choices=STATUS_ACCOUNT)

    class Meta:
        ordering = ['-domain']

    def __str__(self):
        return self.domain

class Database (models.Model):
    STATUS_ACCOUNT = (
        ('Running', 'Running'),
        ('Online', 'Online'),
        ('Stop', 'Stop'),
    )
    user = models.CharField(max_length=10, unique=True)
    name = models.SlugField(max_length=253, unique=True)
    updated_on = models.DateTimeField(auto_now= True)
    created_on = models.DateTimeField(auto_now_add=True)
    status = models.CharField(choices=STATUS_DATABASE)

    class Meta:
        ordering = ['-domain']

    def __str__(self):
        return self.domain
        