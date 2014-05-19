mongoose = require "mongoose"

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

UserSchema = new Schema(
  id: ObjectId
  name: String
  email: String
)

mongoose.model 'UserAccount', UserSchema, 'persons'

module.exports = mongoose.model('UserAccount')