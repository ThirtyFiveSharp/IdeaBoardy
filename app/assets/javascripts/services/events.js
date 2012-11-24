angular.module('idea-boardy')
    .value('events', {
        editSection:'editSection',
        cancelEditSection:'cancelEditSection',
        sectionDeleted:'sectionDeleted',
        ideaDeleted:'ideaDeleted',
        ideaMerged:'ideaMerged',
        ideaEmigrated:'ideaEmigrated'
    });