var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// Article

var Article = new Schema({
	userId: { type: String, required: true },
	title: { type: String },
	subTitle: { type: String },
	content: { type: String },
	imageUrl: { type: String },
	updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Article', Article);