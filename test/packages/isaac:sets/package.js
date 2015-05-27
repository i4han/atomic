
Package.describe({ 
    summary: 'Initalizing sets.',
    version: '0.0.3',
    documentation: null
});

Package.on_use( function (api) {
    api.add_files( 'sets.js', ['client', 'server'] );
    api.export( 'x',        ['client', 'server'] );    
    api.export( 'db',       ['client', 'server'] ); 
    api.export( 'Settings', ['client', 'server'] );
});
