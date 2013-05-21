require('coffee-script')
_ = require('underscore')
express = require("express")
url = require("url")
path = require("path")
swagger = require("swagger-node-express")
api = require('./swagger_spec')
mockMethods = require('./mock/methods')
templating = require('./lib/templating')

app = express()


setHeaders = (res) ->
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With')
  res.header("Content-Type", "text/json; charset=utf-8")

app.use((req, res, next) ->
  setHeaders(res)

  # intercept OPTIONS method
  if ('OPTIONS' == req.method)
    res.send(200);
  else
    next()

)
app.use(express.bodyParser())
swagger.setAppHandler(app)
swagger.addModels(api.models)

_.each(mockMethods, (obj, name) ->
  method = obj.spec.method
  swagger['add'+method.toUpperCase()](obj)
)

swagger.setHeaders = setHeaders
swagger.configure("localhost", "0.1");

app.get('/api/swagger.json', (req, res) ->
  api.basePath = 'http://localhost:4000/'
  res.json(api)
)


client = express()
templating.configure(client)
client.use('/static', express.static(path.join(__dirname, 'public')))
client.use(express.bodyParser())



client.get('/', (req, res) ->
  res.render('index.html')
)

app.listen(4000, ->
  console.log('rest api listening on localhost:4000')
);

client.listen(5000, ->
  console.log('swagger client listening on localhost:5000')
)