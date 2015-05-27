
Package.describe({ 
    summary: 'Initalizing parts.',
    version: '0.0.3',
    documentation: null
});

Package.on_use( function (api) {
    api.add_files( 'parts.js', ['client', 'server'] );
    api.export( 'x',        ['client', 'server'] );    
    api.export( 'db',       ['client', 'server'] );
    api.export( 'Parts',    ['client', 'server'] );
    api.export( 'Settings', ['client', 'server'] );
});
