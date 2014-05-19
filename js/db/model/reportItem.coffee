mongoose = require "mongoose"

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

UserSchema = new Schema(
  id: ObjectId
  person: String
  workType: String
  date: Date
  project: String
  duration: Number
  task: String
)

mongoose.model 'ReportItem', UserSchema, 'reports'

module.exports = mongoose.model('ReportItem')