Package.describe({
  name: 'isaac:absurd',
  summary: 'Meteor package for github /krasimir/absurd',
  version: '0.1.0',
  documentation: 'README.md'
});

Package.on_use(function(api) {
  api.addFiles([
    'absurd.min.js'
  ], 'client');
  api.export( 'Absurd', 'client');    
});

