# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
WIKI_API_URL = "https://en.wikipedia.org/w/api.php"
WIKI_EN_URL = "https://en.wikipedia.org/wiki"
module.exports = (robot) ->
  enterReplies = ['Hola', 'Bienvenido', 'Wena e\'lmanito', 'Huele a otaku', 'ಠ_ಠ']

  robot.respond /listar definciones/i, (res) ->
     res.reply "Terminos disponibles calms / lean / release-manager"

  robot.respond /define (.*)/i, (res) ->
    keyword = res.match[1]
    if keyword is "calms"
      res.reply "• Culture: • Dev y Ops (y todo O&T) con un objetivo común, entregar valor rápido y frecuente \n• Automation • Pipelines de CI/CD automáticos \n• Lean • Eliminar desperdicios y restricciones \n• Measurements • Recolectar datos en todo el flujo y hacerlos visible a todos los sistemas \n• Sharing • Aumentar los canales de comunicación y colaboración"
    if keyword is "lean"
      res.reply "Lean es una filosofía que empuja a los individuos que lo utilizan a pensar cómo hacer los servicios o productos mejor en su día a día. Focalizado en la mejora continua, en la reducción o eliminación de todo aquello que genere pérdida (las 3 Mu: Muda, Muri y Mura) en el proceso extremo a extremo(E2E- End to End) buscando aportar el mayor valor al cliente.\nLean usa el Value Stream Mapping como herramienta de optimización del proceso extremo a extremo "
    if keyword is "release-manager"
      res.reply "Experto en:\n• Release Orchestration\n• Estrategias de versionamiento\n• Estrategias de release\n• Agile Service Management\n• Prácticas de Continuous integration/testing\n• Práctivas de Continuous delivery/deployment "

    else
      res.reply "Termino #{concepto} no cargado en KB, contacte al Lucho"  


  robot.hear /hola/i, (res) ->
     res.send res.random enterReplies

    robot.respond /wikipedia buscar (.+)/i, id: "wikipedia.search", (res) ->
        search = res.match[1].trim()
        params =
            action: "opensearch"
            format: "json"
            limit: 3
            search: search

        wikiRequest res, params, (object) ->
            if object[1].length is 0
                res.reply "No se encontraron articulos: \"#{search}\". pruebe un termino distinto."
                return

            for article in object[1]
                res.send "#{article}: #{createURL(article)}"

    robot.respond /wikipedia sumario (.+)/i, id: "wikipedia.summary", (res) ->
        target = res.match[1].trim()
        params =
            action: "query"
            exintro: true
            explaintext: true
            format: "json"
            redirects: true
            prop: "extracts"
            titles: target

        wikiRequest res, params, (object) ->
            for id, article of object.query.pages
                if id is "-1"
                    res.reply "El articulo ingresado (\"#{target}\") no existe."
                    return

                if article.extract is ""
                    summary = "Sumario no disponible"
                else
                    summary = article.extract.split(". ")[0..1].join ". "

                res.send "#{article.title}: #{summary}."
                res.reply "Articulo Original: #{createURL(article.title)}"
                return

createURL = (title) ->
    "#{WIKI_EN_URL}/#{encodeURIComponent(title)}"

wikiRequest = (res, params = {}, handler) ->
    res.http(WIKI_API_URL)
        .query(params)
        .get() (err, httpRes, body) ->
            if err
                res.reply "Un error fue encontrado mientras se procesaba la consulta: #{err}"
                return robot.logger.error err

            handler JSON.parse(body)




  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
