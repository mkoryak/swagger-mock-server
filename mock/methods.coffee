_ = require('underscore')
api = require('./../swagger_spec')
mock = require('./models')
map = {}

_.each(api.apis, (mapping) ->
  _.each(mapping.operations, (op) ->
    map[op.nickname] =
      spec:
        path: mapping.path
        summary: mapping.description
        method: op.httpMethod
        params: op.parameters
        errorResponses: op.errorResponses
        nickname: op.nickname
      action: (req, res) ->
        console.log("API: #{mapping.path} - #{op.nickname} = #{op.responseClass}")
        json = mock.getObj(op.responseClass)
        console.log(json)
        res.json(json)
  )
)

module.exports = map