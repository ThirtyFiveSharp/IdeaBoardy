angular.module('idea-boardy-services')
  .value 'events',
    editSection: 'editSection'
    sectionEditingFinished: 'sectionEditingFinished'
    sectionDeleted: 'sectionDeleted'
    ideaDeleted: 'ideaDeleted'
    ideaMerged: 'ideaMerged'
    ideaEmigrated: 'ideaEmigrated'
    tagCreated: 'tagCreated'
    querableTargetChanged: 'querableTargetChanged'