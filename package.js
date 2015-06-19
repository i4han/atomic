
Package.describe({
    summary: 'atomic: Ionic for Meteor without Sass and Angular.',
    version: '0.0.1',
    git: 'https://github.com/i4han/atomic.git',
    documentation: 'README.md'
});

Package.on_use( function (api) {
    api.add_files( 'css/ionic.min.css',   'client' );
    api.add_files( 'fonts/ionicons.eot',  'client' );    
    api.add_files( 'fonts/ionicons.svg',  'client' );    
    api.add_files( 'fonts/ionicons.ttf',  'client' );    
    api.add_files( 'fonts/ionicons.woff', 'client' );
    api.add_files( 'js/index.js',  'client' );
});
