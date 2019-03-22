const { Client } = require('@microsoft/microsoft-graph-client')
const fetch = require('node-fetch')

const secrets = require('./secrets.json')

const USER_BY_EMAIL = `https://graph.microsoft.com/v1.0/users?$filter=mail eq '${EMAIL}'`
