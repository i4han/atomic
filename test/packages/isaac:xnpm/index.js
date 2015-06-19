
var fs = Npm.require('fs');
var npm = Meteor.settings.npm

var indexJs = function () {

Xnpm = Xnpm || {};

Xnpm.require = function(module) {
    return Npm.require(module);
};

Meteor.npmRequire = Xnpm.require

}

var packageJs = function () {

Package.describe({
    summary: 'Your npm packages',
    version: '1.0.0',
    name: 'x:npm'
});

Npm.depends();

Package.onUse(function(api) {
    api.add_files('index.js', 'server');
    api.export('Xnpm', 'server');
});

}

var okGo = (function () {
	return !(process.argv.length > 2 && process.argv[2] in ['test-packages', 'publish'])
})();

npm && okGo && Meteor.setTimeout(function () {
	Array.prototype.clipBoth = function () { return this.slice(1, this.length - 1) };
	var func2file = function (f) { 
		return f.toString().split('\n').clipBoth().join('\n') 
	};
	var package2file = function (f) {
		return func2file(f).replace(/Npm\.depends\(\);/m, 'Npm.depends(' + JSON.stringify(npm) + ');');
	};

	var meteorHome = (function () {
	    var dir_list = process.cwd().split('/');
	    while ( '.meteor' !== dir_list.pop() ) {}
	    return dir_list.join('/') 
	})();
	var dotMeteor = meteorHome + '/.meteor/'
	var packages  = dotMeteor + 'packages'
	var npmPackageDir = meteorHome + '/packages/x:npm/'

	var addPackage = function () { 
		fs.readFile(packages, 'utf-8', function (err, data) {
			err && console.error(err);
			var lines = data.split('\n')
			if (lines.indexOf('x:npm') === -1) {
				lines.push('x:npm');
				fs.writeFile(packages, lines.join('\n'), 'utf-8', function () {
					console.log('Create packages/x:npm. Restart meteor.');
				});
			}
		});
	};
	var indexFile   = npmPackageDir + 'index.js';
	var packageFile = npmPackageDir + 'package.js'
	var writeFiles = function () {
		fs.writeFile(indexFile,   func2file(indexJs),      'utf-8', function () {} );
		fs.writeFile(packageFile, package2file(packageJs), 'utf-8', function (err) {
			err && console.err(err);
			err || addPackage();
		});
	};

	if (fs.existsSync(npmPackageDir)) {
		if (!(fs.existsSync(indexFile) && fs.existsSync(packageFile)) || Meteor.settings.npmReset )
			writeFiles();
		else
			addPackage();
	} else { 
		fs.mkdir(npmPackageDir, function(err) {
			err || writeFiles();
		});
	}
}, 100);
