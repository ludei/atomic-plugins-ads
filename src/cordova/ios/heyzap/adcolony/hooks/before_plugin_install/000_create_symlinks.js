module.exports = function (ctx) {
  "use strict";

  console.log('[Heyzap] - Re-creating symlinks in iOS frameworks.');

  var fs, path;

  try {
    fs = require('fs');
    path = require('path');

  } catch (e) {
    console.warn('[Heyzap] - Could not find "fs" or "path" module(s). Exiting...');
    return;
  }

  /**
   * Links that need to be added to ios frameworks
   * Keys of this object are the paths to the '.framework' directory
   * The value is an object whose keys are the symlink destinations and values are the symlink source files
   * @type {Object}
   */
  var FRAMEWORKS_LINKS = {
    'Fyber_AdColony_2.6.2-r1.framework': {
      // dest: src
      'Headers': 'Versions/A/Headers',
      'Fyber_AdColony_2.6.2-r1': 'Versions/A/Fyber_AdColony_2.6.2-r1',
      'Versions/Current': 'Versions/A'
    }
  };

  var sdkDir = path.join(ctx.opts.plugin.dir, 'src', 'ios');

  for (var framework in FRAMEWORKS_LINKS) {
    var frameworkPath = path.join(sdkDir, framework);

    try {
      if (!fs.statSync(frameworkPath).isDirectory()) { // determine if '.framework' directory exists
        continue;
      }

    } catch (e) {
      continue; // framework doesn't exist
    }

    for (var symLink in FRAMEWORKS_LINKS[framework]) {
      var createSymLink = false;

      var srcPath = path.join(frameworkPath, FRAMEWORKS_LINKS[framework][symLink]);
      var destPath = path.join(frameworkPath, symLink);

      try {
        // determine if link is already there or not
        createSymLink = !fs.lstatSync(destPath).isSymbolicLink();

      } catch (e) {
        createSymLink = true; // destination file/folder doesn't exist, create symlink
      }

      if (createSymLink) {
        try {
          fs.symlinkSync(srcPath, destPath);
        } catch (e) { }
      }
    }
  }

};
