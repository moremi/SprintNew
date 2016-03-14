var express = require('express');
var passport = require('passport');
var router = express.Router();

var libs = process.cwd() + '/libs/';
var log = require(libs + 'log')(module);

var db = require(libs + 'db/mongoose');
var Article = require(libs + 'model/article');


router.get('/', passport.authenticate('bearer', { session: false }), function(req, res) {
	Article.find({userId:req.user.userId}, function (err, articles) {
		if (!err) {
			return res.json(articles);
		} else {
			res.statusCode = 500;
			
			log.error('Internal error(%d): %s',res.statusCode,err.message);
			
			return res.json({ 
				error: 'Server error' 
			});
		}
	});
});

router.post('/', passport.authenticate('bearer', { session: false }), function(req, res) {
	
	var article = new Article({
		title: req.body.title,
		subTitle: req.body.subTitle,
		userId: req.user.userId,
		content: req.body.content,
		imageUrl: req.body.imageUrl
	});

	article.save(function (err) {
		if (!err) {
			log.info("New article created with id: %s", article.id);
			return res.json({ 
				status: 'OK', 
				article:article 
			});
		} else {
			if(err.name === 'ValidationError') {
				res.statusCode = 400;
				res.json({ 
					error: 'Validation error' 
				});
			} else {
				res.statusCode = 500;
				res.json({ 
					error: 'Server error' 
				});
			}
			log.error('Internal error(%d): %s', res.statusCode, err.message);
		}
	});
});

router.get('/:id', passport.authenticate('bearer', { session: false }), function(req, res) {
	
	Article.findById(req.params.id, function (err, article) {
		
		if(!article) {
			res.statusCode = 404;
			
			return res.json({ 
				error: 'Not found' 
			});
		}
		
		if (!err) {
			return res.json({ 
				status: 'OK', 
				article:article 
			});
		} else {
			res.statusCode = 500;
			log.error('Internal error(%d): %s',res.statusCode,err.message);
			
			return res.json({ 
				error: 'Server error' 
			});
		}
	});
});

router.put('/:id', passport.authenticate('bearer', { session: false }), function (req, res){
	var articleId = req.params.id;

	Article.findById(articleId, function (err, article) {
		if(!article) {
			res.statusCode = 404;
			log.error('Article with id: %s Not Found', articleId);
			return res.json({ 
				error: 'Not found' 
			});
		}
		if (article.userId != req.user.userId)
		{
			res.statusCode = 401;
			log.error('Article with id: %s ACCESS DENIED', articleId);
			return res.json({ 
				error: 'ACCESS DENIED' 
			});
		}
		console.log(article.title);
		article.title = req.body.title,
		article.subTitle = req.body.subTitle,
		article.content = req.body.content,
		article.imageUrl = req.body.imageUrl
		article.updatedAt = Date.now();
		
		article.save(function (err) {
			if (!err) {
				log.info("Article with id: %s updated", article.id);
				return res.json({ 
					status: 'OK', 
					article:article 
				});
			} else {
				if(err.name === 'ValidationError') {
					res.statusCode = 400;
					return res.json({ 
						error: 'Validation error' 
					});
				} else {
					res.statusCode = 500;
					
					return res.json({ 
						error: 'Server error' 
					});
				}
				log.error('Internal error (%d): %s', res.statusCode, err.message);
			}
		});
	});
});

router.delete('/:id', passport.authenticate('bearer', { session: false }), function (req, res){
	var articleId = req.params.id;

	Article.findById(articleId, function (err, article) {
		if(!article) {
			res.statusCode = 404;
			log.error('Article with id: %s Not Found', articleId);
			return res.json({ 
				error: 'Not found' 
			});
		}
		if (article.userId != req.user.userId)
		{
			res.statusCode = 401;
			log.error('Article with id: %s ACCESS DENIED', articleId);
			return res.json({ 
				error: 'ACCESS DENIED' 
			});
		}
		else
		{
			Article.remove({_id:articleId}, function(err){
				if (!err) {
				log.info("Article removed");
				return res.json({ 
					status: 'OK'
				});
			}
			})
		}
		
	});
});

module.exports = router;