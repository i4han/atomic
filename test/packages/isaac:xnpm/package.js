
Package.describe({
  name: 'isaac:xnpm',
  summary: 'Manage, deploy and use npm with Meteor.',
  version: '0.1.8',
  documentation: 'README.md'
});

Package.on_use(function(api) {
  api.addFiles('index.js', 'server');
});

