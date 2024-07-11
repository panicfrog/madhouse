const path = require('path');
const exclusionList = require('metro-config/src/defaults/exclusionList');
const escape = require('escape-string-regexp');

const root = path.resolve(__dirname, '../../'); // 指向项目的根目录
const packages = path.resolve(root, 'packages'); // 指向 packages 目录
const app = path.resolve(root, 'apps/NoNonsence'); // 指向 app 目录

const modules = [
  'react',
  'react-native',
  // add other modules you want to share across packages
].map(name => path.join(root, 'node_modules', name));

module.exports = {
  projectRoot: __dirname,
  watchFolders: [root, packages],
  resolver: {
    blacklistRE: exclusionList([
      new RegExp(`^${escape(path.join(app, 'node_modules'))}\\/.*$`),
    ]),
    extraNodeModules: new Proxy(
      {},
      {
        get: (target, name) => {
          if (modules.includes(path.join(root, 'node_modules', name))) {
            return path.join(root, 'node_modules', name);
          }
          return path.join(__dirname, `node_modules/${name}`);
        },
      },
    ),
    sourceExts: ['ts', 'tsx', 'js', 'jsx', 'json'],
  },
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
};
