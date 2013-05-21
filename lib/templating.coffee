nunjucks = require('nunjucks')
_ = require('underscore')

env = new nunjucks.Environment(new nunjucks.FileSystemLoader(['templates']));

exports.configure = (app) ->
  env.express(app);


exports.env = env