(function() {

	function app() nd{

		var _app = this;
		this.loader = {
			data: $.getJSON('basic_doc.json'),
			member_tempate : $.get('member_template.html')
		};

		console.log(this.loader);

		this.start = function() {

		}

		console.log(new LeDocs());

		$.when.apply(_.values(self.loader))
			.then(function() {
				_app.start();
			});
	}

	var LeDocs = Backbone.Router.extend({

		routes: {
			"members": "members",
			"members/:id" : "member",
		}

	});

	var Section = Backbone.Model.extend({

	});

	var Member = Backbone.Model.extend({

	});

	var Settings = Backbone.Model.extend({
		defaults: {
			language: 'all'
		},
		languages: {
			'all' : 'All',
			'c' : 'C',
			'cpp' : 'C++'
		}
	});

	var Sections = Backbone.Collection.extend({
		model: Section
	});

	var Members = Backbone.Collection.extend({
		model: Member
	});

	var FilterPane = Backbone.View.extend({

	});

	var MemberPane = Backbone.View.extend({

	});

	var SectionPane = Backbone.View.extend({

	});

	var Search = Backbone.View.extend({

	});

	window.App = app
	window.Model = {
		Section: Section,
		Member: Member
	};

})();

$(function() {
	new App()
});
