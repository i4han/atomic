
Package.describe({
  name: 'isaac:early-bird',
  summary: 'Setup environment',
  version: '0.1.6',
  documentation: 'README.md'
});

Package.on_use(function(api) {
  api.addFiles('index.js', 'server');
});

