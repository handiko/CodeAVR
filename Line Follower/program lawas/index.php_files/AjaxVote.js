/*----------------------------------------------------------------------
#Youjoomla Bumpit - 
# ----------------------------------------------------------------------
# Copyright (C) 2008 - 2009 You Joomla. All Rights Reserved.
# License: Commercial
# Website: http://www.youjoomla.com
------------------------------------------------------------------------*/

var AjaxVote = new Class({
	initialize: function(options) {
		this.options = Object.extend({
			voteClass : null,
			votesDisplayClass: 'votes',
			messageDelay: 2000
		}, options || {});
		
		this.elements = $$('.'+this.options.voteClass);
		this.start();
		
	},
	
	start: function(){
		this.elements.each(function(element, i){
			
			var voteAnchor = element.getElement('a');
			
			if( voteAnchor )
				this.addVoteEvents(i, voteAnchor);		
			
		}.bind(this));
	},
	
	addVoteEvents: function(key, voteAnchor){
		var element = this.elements[key];
		
		var votes = element.getElement('.'+this.options.votesDisplayClass);
		element.setStyle('cursor','pointer');
		
		voteAnchor.addEvent('click', function(event){ new Event(event).stop(); });
		
		element.addEvent('click', function(){
			
			votes.set({'class':this.options.votesDisplayClass+'_loading'});
			votes.empty();
			
			var request = new Json.Remote(voteAnchor.href, {
				method:'GET',
				onComplete: function(jsonObj) {
					element.removeEvents('click');
					element.removeEvents('mouseover');
					element.removeEvents('mouseout');
					element.setStyle('cursor','auto');
					voteAnchor.setStyle('cursor','auto').set({'href':'#'}).setHTML('Bumped');
					
					var cssClass = this.options.votesDisplayClass + (jsonObj.error ? '_error' : '_message');
					votes.set({'class': cssClass}).setHTML( jsonObj.error||jsonObj.message );
					
					var v = function(){ 
						votes.removeClass(cssClass);
						votes.set({'class':this.options.votesDisplayClass}).setHTML(jsonObj.votes);							
					}.bind(this);							
					v.delay(this.options.messageDelay);								
				}.bind(this)
			}).send();				
			
		}.bind(this));
		
		element.addEvent('mouseover', function(){
			this.message = votes.innerHTML;
			votes.empty();
			votes.set({'class':this.options.votesDisplayClass+'_hover'});							
		}.bind(this));
		
		element.addEvent('mouseout', function(){
			votes.set({'class':this.options.votesDisplayClass});
			votes.setHTML(this.message);			
		}.bind(this));	
	}
});