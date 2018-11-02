var kfloatLayer = {
	init:function(n,offX,offY,spd){
		this.obj = $(n);
		this._name = n;
		this.floatX = offX;
		this.floatY = offY;
		this.steps = spd;
		this.tm = null;
		this.alignHorizontal=(offX>=0)?this.leftFloater:this.rightFloater;
		this.alignVertical =(offY>=0)?this.topFloater:this.bottomFloater;
		this.ifloatX = Math.abs(offX);
		this.ifloatY = Math.abs(offY);
		
		this.prevX = this.obj.offsetLeft;
		this.prevY = this.obj.offsetTop;
		this.width = this.obj.offsetWidth;
		this.height = this.obj.offsetHeight;
		
		this.startFloat();
	},
	
	getXCoord:function(){
		var x=0;
		var el = this.obj;
		while(el){
			x += el.offsetLeft;
			el = el.offsetParent;
		}
		return x;
	},
	
	getYCoord:function(){
		y=0;
		var el = this.obj;
		while(el){
			y += el.offsetTop;
			el = el.offsetParent;
		}
		return y;
	},
	
	startFloat:function(){
		lay = this.obj;
		l = this.getXCoord();
		t = this.getYCoord();
		lay.style.position='absolute';
		//alert('top = ' + t);
		lay.style.top = t + "px";
		lay.style.left = l + "px";
		//getFloatLayer('floatlayer').initialize();
		this.alignFloatLayer();
		/*
		Event.observe(window, 'scroll', this.alignFloatLayer);
		Event.observe(window, 'resize', this.alignFloatLayer);
		*/
	},
	
	alignFloatLayer:function(){
		if(this.obj != null){
			this.alignHorizontal();
			this.alignVertical();
			//alert('floatX = ' + this.floatX + ', floatY = ' + this.floatY);
			//alert('prevy = ' + this.prevY + ', floatY = ' + this.floatY);
			if(this.prevX != this.floatX || this.prevY != this.floatY){
				if(this.tm==null){
					this.tm= setTimeout('kfloatLayer.adjustFloater()',50);
					
				}
			}
		}
	},
	
	adjustFloater:function(){
		this.tm = null;
		if(this.obj.style.position!='absolute')return;

		var dx = Math.abs(this.floatX-this.prevX);
		var dy = Math.abs(this.floatY-this.prevY);
		
		//alert('dx = ' + dx);

		if (dx < this.steps/2)
		cx = (dx>=1) ? 1 : 0;
		else
		cx = Math.round(dx/this.steps);

		if (dy < this.steps/2)
		cy = (dy>=1) ? 1 : 0;
		else
		cy = Math.round(dy/this.steps);

		if (this.floatX > this.prevX)
		this.prevX += cx;
		else if (this.floatX < this.prevX)
		this.prevX -= cx;

		if (this.floatY > this.prevY)
		this.prevY += cy;
		else if (this.floatY < this.prevY)
		this.prevY -= cy;

		this.obj.style.left = this.prevX + "px";
		this.obj.style.top = this.prevY + "px";

		if (cx!=0||cy!=0){
			if(this.tm==null)this.tm=setTimeout('kfloatLayer.adjustFloater()',50);
		}else{
			this.alignFloatLayer();
		}
	},
	
	leftFloater:function(){
		this.floatX = document.body.scrollLeft + this.ifloatX;
	},
	
	topFloater:function(){
		if((document.documentElement.scrollTop != document.body.scrollTop) && (document.body.scrollTop != 0)){
			this.floatY = document.body.scrollTop + this.ifloatY;
		}else{
			this.floatY = document.documentElement.scrollTop + this.ifloatY;
		}
		//alert(document.documentElement.scrollTop);
	},
	
	rightFloater:function(){
		this.floatX = document.body.scrollLeft + document.body.clientWidth - this.ifloatX - this.width;
	},
	
	bottomFloater:function(){
		if((document.documentElement.scrollTop != document.body.scrollTop) && (document.body.scrollTop != 0)){
			this.floatY = document.body.scrollTop + document.body.clientHeight - this.ifloatY - this.height;
		}else{
			this.floatY = document.documentElement.scrollTop + document.body.clientHeight - this.ifloatY - this.height;
		}
	}
	//*/
};