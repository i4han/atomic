
var fs = Npm.require('fs');
var env = Meteor.settings.env;

env && (function () {

	var isMode = function (mode) { 
		return mode === process.env.NODE_ENV && env[mode]; 
	};

	var setEnv = function (mode) {
		if (env[mode]) {
			['MAIL_URL', 'MONGO_URL'].forEach( function (v) {
				env[mode][v] && ( process.env[v] = env[mode][v] );
			});
		}
	};

	isMode('production') ? setEnv('production') : setEnv('development');

	Package.mongo && (function () {
		var packages = (function () {
		    var dir_list = process.cwd().split('/');
		    while ( '.meteor' !== dir_list.pop() ) {}
		    return dir_list.join('/') + '/.meteor/packages';
		})();

		fs.readFile( packages, 'utf-8', function (err, data) {
			err && console.error(err);
			var lines = data.split('\n');
			var firstLine = 0;
			while ( ! lines[firstLine]  .match(/^[a-z0-9]+:?[a-z0-9-]+$/) ) firstLine++;
			var packageLine = firstLine + 1;

			while ( lines.length !== packageLine ) { 
				if ( lines[packageLine].match(/^isaac:early-bird/) ) {
					var package = lines.splice(packageLine, 1)[0];
					lines.splice(firstLine, 0, package);
					fs.writeFile( packages, lines.join('\n'), 'utf-8', function () {
						console.info('Setup early-bird to start its earliest moment.');
					});
				}
				packageLine++;
			}
		});
	})();
})();
