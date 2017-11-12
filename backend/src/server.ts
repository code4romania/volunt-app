import * as express from 'express'
import * as winston from 'winston'
import * as boom from 'express-boom'
import * as morgan from 'morgan'
import * as cors from 'cors'
import * as expressValidator from 'express-validator'
import { json, urlencoded } from 'body-parser'
import { Express } from 'express'
import * as routes from './routes/_index'
import * as jwt from 'jsonwebtoken'
import * as passport from 'passport'
import { Strategy as JwtStrategy, ExtractJwt, StrategyOptions } from 'passport-jwt'
import * as db from './sqlz/models/_index'

const User = db.default.User

let jwtOptions: StrategyOptions = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderWithScheme('jwt'),
  secretOrKey: 'test'
}

passport.use(new JwtStrategy(jwtOptions, (payload, done) => {
  User.findById(payload.id).then((user) => {
    done(null, user)
  }).catch((err) => {
    done(null, null)
  })
}))

const PORT: number = 3000

/**
 * Root class of your node server.
 * Can be used for basic configurations, for instance starting up the server or registering middleware.
 */
export class Server {

  private app: Express

  constructor() {
    this.app = express()

    // Init passport
    this.app.use(passport.initialize())

    // Express middleware
    this.app.use(cors({
      optionsSuccessStatus: 200
    }))
    this.app.use(urlencoded({
      extended: true
    }))
    this.app.use(json())
    this.app.use(boom())
    this.app.use(morgan('combined'))
    this.app.use(expressValidator())
    this.app.listen(PORT, () => {
      winston.log('info', '--> Server successfully started at port %d', PORT)
    })
    routes.initRoutes(this.app)
  }

  getApp() {
    return this.app
  }
}
new Server()
