'use strict';

module.exports = function(grunt) {
  require('time-grunt');
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    shell: {
      jekyllBuild: {
        command: 'bundle exec jekyll build'
      },
      jekyllServe: {
        command: 'bundle exec jekyll serve'
      }
    }
  });

  // register tasks
  grunt.registerTask('serve', ['serve']);

  grunt.registerTask('build', [
    'shell:jekyllBuild',
  ]);

  // default task
  grunt.registerTask('default', 'build');
};
