//MooTools, My Object Oriented Javascript Tools. Copyright (c) 2006 Valerio Proietti, <http://mad4milk.net>, MIT Style License.

var MooTools={version:'1.12'};function $defined(obj){return(obj!=undefined);};function $type(obj){if(!$defined(obj))return false;if(obj.htmlElement)return'element';var type=typeof obj;if(type=='object'&&obj.nodeName){switch(obj.nodeType){case 1:return'element';case 3:return(/\S/).test(obj.nodeValue)?'textnode':'whitespace';}}
if(type=='object'||type=='function'){switch(obj.constructor){case Array:return'array';case RegExp:return'regexp';case Class:return'class';}
if(typeof obj.length=='number'){if(obj.item)return'collection';if(obj.callee)return'arguments';}}
return type;};function $merge(){var mix={};for(var i=0;i<arguments.length;i++){for(var property in arguments[i]){var ap=arguments[i][property];var mp=mix[property];if(mp&&$type(ap)=='object'&&$type(mp)=='object')mix[property]=$merge(mp,ap);else mix[property]=ap;}}
return mix;};var $extend=function(){var args=arguments;if(!args[1])args=[this,args[0]];for(var property in args[1])args[0][property]=args[1][property];return args[0];};var $native=function(){for(var i=0,l=arguments.length;i<l;i++){arguments[i].extend=function(props){for(var prop in props){if(!this.prototype[prop])this.prototype[prop]=props[prop];if(!this[prop])this[prop]=$native.generic(prop);}};}};$native.generic=function(prop){return function(bind){return this.prototype[prop].apply(bind,Array.prototype.slice.call(arguments,1));};};$native(Function,Array,String,Number);function $chk(obj){return!!(obj||obj===0);};function $pick(obj,picked){return $defined(obj)?obj:picked;};function $random(min,max){return Math.floor(Math.random()*(max-min+1)+min);};function $time(){return new Date().getTime();};function $clear(timer){clearTimeout(timer);clearInterval(timer);return null;};var Abstract=function(obj){obj=obj||{};obj.extend=$extend;return obj;};var Window=new Abstract(window);var Document=new Abstract(document);document.head=document.getElementsByTagName('head')[0];window.xpath=!!(document.evaluate);if(window.ActiveXObject)window.ie=window[window.XMLHttpRequest?'ie7':'ie6']=true;else if(document.childNodes&&!document.all&&!navigator.taintEnabled)window.webkit=window[window.xpath?'webkit420':'webkit419']=true;else if(document.getBoxObjectFor!=null||window.mozInnerScreenX!=null)window.gecko=true;window.khtml=window.webkit;Object.extend=$extend;if(typeof HTMLElement=='undefined'){var HTMLElement=function(){};if(window.webkit)document.createElement("iframe");HTMLElement.prototype=(window.webkit)?window["[[DOMElement.prototype]]"]:{};}
HTMLElement.prototype.htmlElement=function(){};if(window.ie6)try{document.execCommand("BackgroundImageCache",false,true);}catch(e){};var Class=function(properties){var klass=function(){return(arguments[0]!==null&&this.initialize&&$type(this.initialize)=='function')?this.initialize.apply(this,arguments):this;};$extend(klass,this);klass.prototype=properties;klass.constructor=Class;return klass;};Class.empty=function(){};Class.prototype={extend:function(properties){var proto=new this(null);for(var property in properties){var pp=proto[property];proto[property]=Class.Merge(pp,properties[property]);}
return new Class(proto);},implement:function(){for(var i=0,l=arguments.length;i<l;i++)$extend(this.prototype,arguments[i]);}};Class.Merge=function(previous,current){if(previous&&previous!=current){var type=$type(current);if(type!=$type(previous))return current;switch(type){case'function':var merged=function(){this.parent=arguments.callee.parent;return current.apply(this,arguments);};merged.parent=previous;return merged;case'object':return $merge(previous,current);}}
return current;};var Chain=new Class({chain:function(fn){this.chains=this.chains||[];this.chains.push(fn);return this;},callChain:function(){if(this.chains&&this.chains.length)this.chains.shift().delay(10,this);},clearChain:function(){this.chains=[];}});var Events=new Class({addEvent:function(type,fn){if(fn!=Class.empty){this.$events=this.$events||{};this.$events[type]=this.$events[type]||[];this.$events[type].include(fn);}
return this;},fireEvent:function(type,args,delay){if(this.$events&&this.$events[type]){this.$events[type].each(function(fn){fn.create({'bind':this,'delay':delay,'arguments':args})();},this);}
return this;},removeEvent:function(type,fn){if(this.$events&&this.$events[type])this.$events[type].remove(fn);return this;}});var Options=new Class({setOptions:function(){this.options=$merge.apply(null,[this.options].extend(arguments));if(this.addEvent){for(var option in this.options){if($type(this.options[option]=='function')&&(/^on[A-Z]/).test(option))this.addEvent(option,this.options[option]);}}
return this;}});Array.extend({forEach:function(fn,bind){for(var i=0,j=this.length;i<j;i++)fn.call(bind,this[i],i,this);},filter:function(fn,bind){var results=[];for(var i=0,j=this.length;i<j;i++){if(fn.call(bind,this[i],i,this))results.push(this[i]);}
return results;},map:function(fn,bind){var results=[];for(var i=0,j=this.length;i<j;i++)results[i]=fn.call(bind,this[i],i,this);return results;},every:function(fn,bind){for(var i=0,j=this.length;i<j;i++){if(!fn.call(bind,this[i],i,this))return false;}
return true;},some:function(fn,bind){for(var i=0,j=this.length;i<j;i++){if(fn.call(bind,this[i],i,this))return true;}
return false;},indexOf:function(item,from){var len=this.length;for(var i=(from<0)?Math.max(0,len+from):from||0;i<len;i++){if(this[i]===item)return i;}
return-1;},copy:function(start,length){start=start||0;if(start<0)start=this.length+start;length=length||(this.length-start);var newArray=[];for(var i=0;i<length;i++)newArray[i]=this[start++];return newArray;},remove:function(item){var i=0;var len=this.length;while(i<len){if(this[i]===item){this.splice(i,1);len--;}else{i++;}}
return this;},contains:function(item,from){return this.indexOf(item,from)!=-1;},associate:function(keys){var obj={},length=Math.min(this.length,keys.length);for(var i=0;i<length;i++)obj[keys[i]]=this[i];return obj;},extend:function(array){for(var i=0,j=array.length;i<j;i++)this.push(array[i]);return this;},merge:function(array){for(var i=0,l=array.length;i<l;i++)this.include(array[i]);return this;},include:function(item){if(!this.contains(item))this.push(item);return this;},getRandom:function(){return this[$random(0,this.length-1)]||null;},getLast:function(){return this[this.length-1]||null;}});Array.prototype.each=Array.prototype.forEach;Array.each=Array.forEach;function $A(array){return Array.copy(array);};function $each(iterable,fn,bind){if(iterable&&typeof iterable.length=='number'&&$type(iterable)!='object'){Array.forEach(iterable,fn,bind);}else{for(var name in iterable)fn.call(bind||iterable,iterable[name],name);}};Array.prototype.test=Array.prototype.contains;String.extend({test:function(regex,params){return(($type(regex)=='string')?new RegExp(regex,params):regex).test(this);},toInt:function(){return parseInt(this,10);},toFloat:function(){return parseFloat(this);},camelCase:function(){return this.replace(/-\D/g,function(match){return match.charAt(1).toUpperCase();});},hyphenate:function(){return this.replace(/\w[A-Z]/g,function(match){return(match.charAt(0)+'-'+match.charAt(1).toLowerCase());});},capitalize:function(){return this.replace(/\b[a-z]/g,function(match){return match.toUpperCase();});},trim:function(){return this.replace(/^\s+|\s+$/g,'');},clean:function(){return this.replace(/\s{2,}/g,' ').trim();},rgbToHex:function(array){var rgb=this.match(/\d{1,3}/g);return(rgb)?rgb.rgbToHex(array):false;},hexToRgb:function(array){var hex=this.match(/^#?(\w{1,2})(\w{1,2})(\w{1,2})$/);return(hex)?hex.slice(1).hexToRgb(array):false;},contains:function(string,s){return(s)?(s+this+s).indexOf(s+string+s)>-1:this.indexOf(string)>-1;},escapeRegExp:function(){return this.replace(/([.*+?^${}()|[\]\/\\])/g,'\\$1');}});Array.extend({rgbToHex:function(array){if(this.length<3)return false;if(this.length==4&&this[3]==0&&!array)return'transparent';var hex=[];for(var i=0;i<3;i++){var bit=(this[i]-0).toString(16);hex.push((bit.length==1)?'0'+bit:bit);}
return array?hex:'#'+hex.join('');},hexToRgb:function(array){if(this.length!=3)return false;var rgb=[];for(var i=0;i<3;i++){rgb.push(parseInt((this[i].length==1)?this[i]+this[i]:this[i],16));}
return array?rgb:'rgb('+rgb.join(',')+')';}});Function.extend({create:function(options){var fn=this;options=$merge({'bind':fn,'event':false,'arguments':null,'delay':false,'periodical':false,'attempt':false},options);if($chk(options.arguments)&&$type(options.arguments)!='array')options.arguments=[options.arguments];return function(event){var args;if(options.event){event=event||window.event;args=[(options.event===true)?event:new options.event(event)];if(options.arguments)args.extend(options.arguments);}
else args=options.arguments||arguments;var returns=function(){return fn.apply($pick(options.bind,fn),args);};if(options.delay)return setTimeout(returns,options.delay);if(options.periodical)return setInterval(returns,options.periodical);if(options.attempt)try{return returns();}catch(err){return false;};return returns();};},pass:function(args,bind){return this.create({'arguments':args,'bind':bind});},attempt:function(args,bind){return this.create({'arguments':args,'bind':bind,'attempt':true})();},bind:function(bind,args){return this.create({'bind':bind,'arguments':args});},bindAsEventListener:function(bind,args){return this.create({'bind':bind,'event':true,'arguments':args});},delay:function(delay,bind,args){return this.create({'delay':delay,'bind':bind,'arguments':args})();},periodical:function(interval,bind,args){return this.create({'periodical':interval,'bind':bind,'arguments':args})();}});Number.extend({toInt:function(){return parseInt(this);},toFloat:function(){return parseFloat(this);},limit:function(min,max){return Math.min(max,Math.max(min,this));},round:function(precision){precision=Math.pow(10,precision||0);return Math.round(this*precision)/precision;},times:function(fn){for(var i=0;i<this;i++)fn(i);}});var Element=new Class({initialize:function(el,props){if($type(el)=='string'){if(window.ie&&props&&(props.name||props.type)){var name=(props.name)?' name="'+props.name+'"':'';var type=(props.type)?' type="'+props.type+'"':'';delete props.name;delete props.type;el='<'+el+name+type+'>';}
el=document.createElement(el);}
el=$(el);return(!props||!el)?el:el.set(props);}});var Elements=new Class({initialize:function(elements){return(elements)?$extend(elements,this):this;}});Elements.extend=function(props){for(var prop in props){this.prototype[prop]=props[prop];this[prop]=$native.generic(prop);}};function $(el){if(!el)return null;if(el.htmlElement)return Garbage.collect(el);if([window,document].contains(el))return el;var type=$type(el);if(type=='string'){el=document.getElementById(el);type=(el)?'element':false;}
if(type!='element')return null;if(el.htmlElement)return Garbage.collect(el);if(['object','embed'].contains(el.tagName.toLowerCase()))return el;$extend(el,Element.prototype);el.htmlElement=function(){};return Garbage.collect(el);};document.getElementsBySelector=document.getElementsByTagName;function $$(){var elements=[];for(var i=0,j=arguments.length;i<j;i++){var selector=arguments[i];switch($type(selector)){case'element':elements.push(selector);case'boolean':break;case false:break;case'string':selector=document.getElementsBySelector(selector,true);default:elements.extend(selector);}}
return $$.unique(elements);};$$.unique=function(array){var elements=[];for(var i=0,l=array.length;i<l;i++){if(array[i].$included)continue;var element=$(array[i]);if(element&&!element.$included){element.$included=true;elements.push(element);}}
for(var n=0,d=elements.length;n<d;n++)elements[n].$included=null;return new Elements(elements);};Elements.Multi=function(property){return function(){var args=arguments;var items=[];var elements=true;for(var i=0,j=this.length,returns;i<j;i++){returns=this[i][property].apply(this[i],args);if($type(returns)!='element')elements=false;items.push(returns);};return(elements)?$$.unique(items):items;};};Element.extend=function(properties){for(var property in properties){HTMLElement.prototype[property]=properties[property];Element.prototype[property]=properties[property];Element[property]=$native.generic(property);var elementsProperty=(Array.prototype[property])?property+'Elements':property;Elements.prototype[elementsProperty]=Elements.Multi(property);}};Element.extend({set:function(props){for(var prop in props){var val=props[prop];switch(prop){case'styles':this.setStyles(val);break;case'events':if(this.addEvents)this.addEvents(val);break;case'properties':this.setProperties(val);break;default:this.setProperty(prop,val);}}
return this;},inject:function(el,where){el=$(el);switch(where){case'before':el.parentNode.insertBefore(this,el);break;case'after':var next=el.getNext();if(!next)el.parentNode.appendChild(this);else el.parentNode.insertBefore(this,next);break;case'top':var first=el.firstChild;if(first){el.insertBefore(this,first);break;}
default:el.appendChild(this);}
return this;},injectBefore:function(el){return this.inject(el,'before');},injectAfter:function(el){return this.inject(el,'after');},injectInside:function(el){return this.inject(el,'bottom');},injectTop:function(el){return this.inject(el,'top');},adopt:function(){var elements=[];$each(arguments,function(argument){elements=elements.concat(argument);});$$(elements).inject(this);return this;},remove:function(){return this.parentNode.removeChild(this);},clone:function(contents){var el=$(this.cloneNode(contents!==false));if(!el.$events)return el;el.$events={};for(var type in this.$events)el.$events[type]={'keys':$A(this.$events[type].keys),'values':$A(this.$events[type].values)};return el.removeEvents();},replaceWith:function(el){el=$(el);this.parentNode.replaceChild(el,this);return el;},appendText:function(text){this.appendChild(document.createTextNode(text));return this;},hasClass:function(className){return this.className.contains(className,' ');},addClass:function(className){if(!this.hasClass(className))this.className=(this.className+' '+className).clean();return this;},removeClass:function(className){this.className=this.className.replace(new RegExp('(^|\\s)'+className+'(?:\\s|$)'),'$1').clean();return this;},toggleClass:function(className){return this.hasClass(className)?this.removeClass(className):this.addClass(className);},setStyle:function(property,value){switch(property){case'opacity':return this.setOpacity(parseFloat(value));case'float':property=(window.ie)?'styleFloat':'cssFloat';}
property=property.camelCase();switch($type(value)){case'number':if(!['zIndex','zoom'].contains(property))value+='px';break;case'array':value='rgb('+value.join(',')+')';}
this.style[property]=value;return this;},setStyles:function(source){switch($type(source)){case'object':Element.setMany(this,'setStyle',source);break;case'string':this.style.cssText=source;}
return this;},setOpacity:function(opacity){if(opacity==0){if(this.style.visibility!="hidden")this.style.visibility="hidden";}else{if(this.style.visibility!="visible")this.style.visibility="visible";}
if(!this.currentStyle||!this.currentStyle.hasLayout)this.style.zoom=1;if(window.ie)this.style.filter=(opacity==1)?'':"alpha(opacity="+opacity*100+")";this.style.opacity=this.$tmp.opacity=opacity;return this;},getStyle:function(property){property=property.camelCase();var result=this.style[property];if(!$chk(result)){if(property=='opacity')return this.$tmp.opacity;result=[];for(var style in Element.Styles){if(property==style){Element.Styles[style].each(function(s){var style=this.getStyle(s);result.push(parseInt(style)?style:'0px');},this);if(property=='border'){var every=result.every(function(bit){return(bit==result[0]);});return(every)?result[0]:false;}
return result.join(' ');}}
if(property.contains('border')){if(Element.Styles.border.contains(property)){return['Width','Style','Color'].map(function(p){return this.getStyle(property+p);},this).join(' ');}else if(Element.borderShort.contains(property)){return['Top','Right','Bottom','Left'].map(function(p){return this.getStyle('border'+p+property.replace('border',''));},this).join(' ');}}
if(document.defaultView)result=document.defaultView.getComputedStyle(this,null).getPropertyValue(property.hyphenate());else if(this.currentStyle)result=this.currentStyle[property];}
if(window.ie)result=Element.fixStyle(property,result,this);if(result&&property.test(/color/i)&&result.contains('rgb')){return result.split('rgb').splice(1,4).map(function(color){return color.rgbToHex();}).join(' ');}
return result;},getStyles:function(){return Element.getMany(this,'getStyle',arguments);},walk:function(brother,start){brother+='Sibling';var el=(start)?this[start]:this[brother];while(el&&$type(el)!='element')el=el[brother];return $(el);},getPrevious:function(){return this.walk('previous');},getNext:function(){return this.walk('next');},getFirst:function(){return this.walk('next','firstChild');},getLast:function(){return this.walk('previous','lastChild');},getParent:function(){return $(this.parentNode);},getChildren:function(){return $$(this.childNodes);},hasChild:function(el){return!!$A(this.getElementsByTagName('*')).contains(el);},getProperty:function(property){var index=Element.Properties[property];if(index)return this[index];var flag=Element.PropertiesIFlag[property]||0;if(!window.ie||flag)return this.getAttribute(property,flag);var node=this.attributes[property];return(node)?node.nodeValue:null;},removeProperty:function(property){var index=Element.Properties[property];if(index)this[index]='';else this.removeAttribute(property);return this;},getProperties:function(){return Element.getMany(this,'getProperty',arguments);},setProperty:function(property,value){var index=Element.Properties[property];if(index)this[index]=value;else this.setAttribute(property,value);return this;},setProperties:function(source){return Element.setMany(this,'setProperty',source);},setHTML:function(){this.innerHTML=$A(arguments).join('');return this;},setText:function(text){var tag=this.getTag();if(['style','script'].contains(tag)){if(window.ie){if(tag=='style')this.styleSheet.cssText=text;else if(tag=='script')this.setProperty('text',text);return this;}else{this.removeChild(this.firstChild);return this.appendText(text);}}
this[$defined(this.innerText)?'innerText':'textContent']=text;return this;},getText:function(){var tag=this.getTag();if(['style','script'].contains(tag)){if(window.ie){if(tag=='style')return this.styleSheet.cssText;else if(tag=='script')return this.getProperty('text');}else{return this.innerHTML;}}
return($pick(this.innerText,this.textContent));},getTag:function(){return this.tagName.toLowerCase();},empty:function(){Garbage.trash(this.getElementsByTagName('*'));return this.setHTML('');}});Element.fixStyle=function(property,result,element){if($chk(parseInt(result)))return result;if(['height','width'].contains(property)){var values=(property=='width')?['left','right']:['top','bottom'];var size=0;values.each(function(value){size+=element.getStyle('border-'+value+'-width').toInt()+element.getStyle('padding-'+value).toInt();});return element['offset'+property.capitalize()]-size+'px';}else if(property.test(/border(.+)Width|margin|padding/)){return'0px';}
return result;};Element.Styles={'border':[],'padding':[],'margin':[]};['Top','Right','Bottom','Left'].each(function(direction){for(var style in Element.Styles)Element.Styles[style].push(style+direction);});Element.borderShort=['borderWidth','borderStyle','borderColor'];Element.getMany=function(el,method,keys){var result={};$each(keys,function(key){result[key]=el[method](key);});return result;};Element.setMany=function(el,method,pairs){for(var key in pairs)el[method](key,pairs[key]);return el;};Element.Properties=new Abstract({'class':'className','for':'htmlFor','colspan':'colSpan','rowspan':'rowSpan','accesskey':'accessKey','tabindex':'tabIndex','maxlength':'maxLength','readonly':'readOnly','frameborder':'frameBorder','value':'value','disabled':'disabled','checked':'checked','multiple':'multiple','selected':'selected'});Element.PropertiesIFlag={'href':2,'src':2};Element.Methods={Listeners:{addListener:function(type,fn){if(this.addEventListener)this.addEventListener(type,fn,false);else this.attachEvent('on'+type,fn);return this;},removeListener:function(type,fn){if(this.removeEventListener)this.removeEventListener(type,fn,false);else this.detachEvent('on'+type,fn);return this;}}};window.extend(Element.Methods.Listeners);document.extend(Element.Methods.Listeners);Element.extend(Element.Methods.Listeners);var Garbage={elements:[],collect:function(el){if(!el.$tmp){Garbage.elements.push(el);el.$tmp={'opacity':1};}
return el;},trash:function(elements){for(var i=0,j=elements.length,el;i<j;i++){if(!(el=elements[i])||!el.$tmp)continue;if(el.$events)el.fireEvent('trash').removeEvents();for(var p in el.$tmp)el.$tmp[p]=null;for(var d in Element.prototype)el[d]=null;Garbage.elements[Garbage.elements.indexOf(el)]=null;el.htmlElement=el.$tmp=el=null;}
Garbage.elements.remove(null);},empty:function(){Garbage.collect(window);Garbage.collect(document);Garbage.trash(Garbage.elements);}};window.addListener('beforeunload',function(){window.addListener('unload',Garbage.empty);if(window.ie)window.addListener('unload',CollectGarbage);});var Event=new Class({initialize:function(event){if(event&&event.$extended)return event;this.$extended=true;event=event||window.event;this.event=event;this.type=event.type;this.target=event.target||event.srcElement;if(this.target.nodeType==3)this.target=this.target.parentNode;this.shift=event.shiftKey;this.control=event.ctrlKey;this.alt=event.altKey;this.meta=event.metaKey;if(['DOMMouseScroll','mousewheel'].contains(this.type)){this.wheel=(event.wheelDelta)?event.wheelDelta/120:-(event.detail||0)/3;}else if(this.type.contains('key')){this.code=event.which||event.keyCode;for(var name in Event.keys){if(Event.keys[name]==this.code){this.key=name;break;}}
if(this.type=='keydown'){var fKey=this.code-111;if(fKey>0&&fKey<13)this.key='f'+fKey;}
this.key=this.key||String.fromCharCode(this.code).toLowerCase();}else if(this.type.test(/(click|mouse|menu)/)){this.page={'x':event.pageX||event.clientX+document.documentElement.scrollLeft,'y':event.pageY||event.clientY+document.documentElement.scrollTop};this.client={'x':event.pageX?event.pageX-window.pageXOffset:event.clientX,'y':event.pageY?event.pageY-window.pageYOffset:event.clientY};this.rightClick=(event.which==3)||(event.button==2);switch(this.type){case'mouseover':this.relatedTarget=event.relatedTarget||event.fromElement;break;case'mouseout':this.relatedTarget=event.relatedTarget||event.toElement;}
this.fixRelatedTarget();}
return this;},stop:function(){return this.stopPropagation().preventDefault();},stopPropagation:function(){if(this.event.stopPropagation)this.event.stopPropagation();else this.event.cancelBubble=true;return this;},preventDefault:function(){if(this.event.preventDefault)this.event.preventDefault();else this.event.returnValue=false;return this;}});Event.fix={relatedTarget:function(){if(this.relatedTarget&&this.relatedTarget.nodeType==3)this.relatedTarget=this.relatedTarget.parentNode;},relatedTargetGecko:function(){try{Event.fix.relatedTarget.call(this);}catch(e){this.relatedTarget=this.target;}}};Event.prototype.fixRelatedTarget=(window.gecko)?Event.fix.relatedTargetGecko:Event.fix.relatedTarget;Event.keys=new Abstract({'enter':13,'up':38,'down':40,'left':37,'right':39,'esc':27,'space':32,'backspace':8,'tab':9,'delete':46});Element.Methods.Events={addEvent:function(type,fn){this.$events=this.$events||{};this.$events[type]=this.$events[type]||{'keys':[],'values':[]};if(this.$events[type].keys.contains(fn))return this;this.$events[type].keys.push(fn);var realType=type;var custom=Element.Events[type];if(custom){if(custom.add)custom.add.call(this,fn);if(custom.map)fn=custom.map;if(custom.type)realType=custom.type;}
if(!this.addEventListener)fn=fn.create({'bind':this,'event':true});this.$events[type].values.push(fn);return(Element.NativeEvents.contains(realType))?this.addListener(realType,fn):this;},removeEvent:function(type,fn){if(!this.$events||!this.$events[type])return this;var pos=this.$events[type].keys.indexOf(fn);if(pos==-1)return this;var key=this.$events[type].keys.splice(pos,1)[0];var value=this.$events[type].values.splice(pos,1)[0];var custom=Element.Events[type];if(custom){if(custom.remove)custom.remove.call(this,fn);if(custom.type)type=custom.type;}
return(Element.NativeEvents.contains(type))?this.removeListener(type,value):this;},addEvents:function(source){return Element.setMany(this,'addEvent',source);},removeEvents:function(type){if(!this.$events)return this;if(!type){for(var evType in this.$events)this.removeEvents(evType);this.$events=null;}else if(this.$events[type]){this.$events[type].keys.each(function(fn){this.removeEvent(type,fn);},this);this.$events[type]=null;}
return this;},fireEvent:function(type,args,delay){if(this.$events&&this.$events[type]){this.$events[type].keys.each(function(fn){fn.create({'bind':this,'delay':delay,'arguments':args})();},this);}
return this;},cloneEvents:function(from,type){if(!from.$events)return this;if(!type){for(var evType in from.$events)this.cloneEvents(from,evType);}else if(from.$events[type]){from.$events[type].keys.each(function(fn){this.addEvent(type,fn);},this);}
return this;}};window.extend(Element.Methods.Events);document.extend(Element.Methods.Events);Element.extend(Element.Methods.Events);Element.Events=new Abstract({'mouseenter':{type:'mouseover',map:function(event){event=new Event(event);if(event.relatedTarget!=this&&!this.hasChild(event.relatedTarget))this.fireEvent('mouseenter',event);}},'mouseleave':{type:'mouseout',map:function(event){event=new Event(event);if(event.relatedTarget!=this&&!this.hasChild(event.relatedTarget))this.fireEvent('mouseleave',event);}},'mousewheel':{type:(window.gecko)?'DOMMouseScroll':'mousewheel'}});Element.NativeEvents=['click','dblclick','mouseup','mousedown','mousewheel','DOMMouseScroll','mouseover','mouseout','mousemove','keydown','keypress','keyup','load','unload','beforeunload','resize','move','focus','blur','change','submit','reset','select','error','abort','contextmenu','scroll'];Function.extend({bindWithEvent:function(bind,args){return this.create({'bind':bind,'arguments':args,'event':Event});}});Elements.extend({filterByTag:function(tag){return new Elements(this.filter(function(el){return(Element.getTag(el)==tag);}));},filterByClass:function(className,nocash){var elements=this.filter(function(el){return(el.className&&el.className.contains(className,' '));});return(nocash)?elements:new Elements(elements);},filterById:function(id,nocash){var elements=this.filter(function(el){return(el.id==id);});return(nocash)?elements:new Elements(elements);},filterByAttribute:function(name,operator,value,nocash){var elements=this.filter(function(el){var current=Element.getProperty(el,name);if(!current)return false;if(!operator)return true;switch(operator){case'=':return(current==value);case'*=':return(current.contains(value));case'^=':return(current.substr(0,value.length)==value);case'$=':return(current.substr(current.length-value.length)==value);case'!=':return(current!=value);case'~=':return current.contains(value,' ');}
return false;});return(nocash)?elements:new Elements(elements);}});function $E(selector,filter){return($(filter)||document).getElement(selector);};function $ES(selector,filter){return($(filter)||document).getElementsBySelector(selector);};$$.shared={'regexp':/^(\w*|\*)(?:#([\w-]+)|\.([\w-]+))?(?:\[(\w+)(?:([!*^$]?=)["']?([^"'\]]*)["']?)?])?$/,'xpath':{getParam:function(items,context,param,i){var temp=[context.namespaceURI?'xhtml:':'',param[1]];if(param[2])temp.push('[@id="',param[2],'"]');if(param[3])temp.push('[contains(concat(" ", @class, " "), " ',param[3],' ")]');if(param[4]){if(param[5]&&param[6]){switch(param[5]){case'*=':temp.push('[contains(@',param[4],', "',param[6],'")]');break;case'^=':temp.push('[starts-with(@',param[4],', "',param[6],'")]');break;case'$=':temp.push('[substring(@',param[4],', string-length(@',param[4],') - ',param[6].length,' + 1) = "',param[6],'"]');break;case'=':temp.push('[@',param[4],'="',param[6],'"]');break;case'!=':temp.push('[@',param[4],'!="',param[6],'"]');}}else{temp.push('[@',param[4],']');}}
items.push(temp.join(''));return items;},getItems:function(items,context,nocash){var elements=[];var xpath=document.evaluate('.//'+items.join('//'),context,$$.shared.resolver,XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE,null);for(var i=0,j=xpath.snapshotLength;i<j;i++)elements.push(xpath.snapshotItem(i));return(nocash)?elements:new Elements(elements.map($));}},'normal':{getParam:function(items,context,param,i){if(i==0){if(param[2]){var el=context.getElementById(param[2]);if(!el||((param[1]!='*')&&(Element.getTag(el)!=param[1])))return false;items=[el];}else{items=$A(context.getElementsByTagName(param[1]));}}else{items=$$.shared.getElementsByTagName(items,param[1]);if(param[2])items=Elements.filterById(items,param[2],true);}
if(param[3])items=Elements.filterByClass(items,param[3],true);if(param[4])items=Elements.filterByAttribute(items,param[4],param[5],param[6],true);return items;},getItems:function(items,context,nocash){return(nocash)?items:$$.unique(items);}},resolver:function(prefix){return(prefix=='xhtml')?'http://www.w3.org/1999/xhtml':false;},getElementsByTagName:function(context,tagName){var found=[];for(var i=0,j=context.length;i<j;i++)found.extend(context[i].getElementsByTagName(tagName));return found;}};$$.shared.method=(window.xpath)?'xpath':'normal';Element.Methods.Dom={getElements:function(selector,nocash){var items=[];selector=selector.trim().split(' ');for(var i=0,j=selector.length;i<j;i++){var sel=selector[i];var param=sel.match($$.shared.regexp);if(!param)break;param[1]=param[1]||'*';var temp=$$.shared[$$.shared.method].getParam(items,this,param,i);if(!temp)break;items=temp;}
return $$.shared[$$.shared.method].getItems(items,this,nocash);},getElement:function(selector){return $(this.getElements(selector,true)[0]||false);},getElementsBySelector:function(selector,nocash){var elements=[];selector=selector.split(',');for(var i=0,j=selector.length;i<j;i++)elements=elements.concat(this.getElements(selector[i],true));return(nocash)?elements:$$.unique(elements);}};Element.extend({getElementById:function(id){var el=document.getElementById(id);if(!el)return false;for(var parent=el.parentNode;parent!=this;parent=parent.parentNode){if(!parent)return false;}
return el;},getElementsByClassName:function(className){return this.getElements('.'+className);}});document.extend(Element.Methods.Dom);Element.extend(Element.Methods.Dom);Element.extend({getValue:function(){switch(this.getTag()){case'select':var values=[];$each(this.options,function(option){if(option.selected)values.push($pick(option.value,option.text));});return(this.multiple)?values:values[0];case'input':if(!(this.checked&&['checkbox','radio'].contains(this.type))&&!['hidden','text','password'].contains(this.type))break;case'textarea':return this.value;}
return false;},getFormElements:function(){return $$(this.getElementsByTagName('input'),this.getElementsByTagName('select'),this.getElementsByTagName('textarea'));},toQueryString:function(){var queryString=[];this.getFormElements().each(function(el){var name=el.name;var value=el.getValue();if(value===false||!name||el.disabled)return;var qs=function(val){queryString.push(name+'='+encodeURIComponent(val));};if($type(value)=='array')value.each(qs);else qs(value);});return queryString.join('&');}});Element.extend({scrollTo:function(x,y){this.scrollLeft=x;this.scrollTop=y;},getSize:function(){return{'scroll':{'x':this.scrollLeft,'y':this.scrollTop},'size':{'x':this.offsetWidth,'y':this.offsetHeight},'scrollSize':{'x':this.scrollWidth,'y':this.scrollHeight}};},getPosition:function(overflown){overflown=overflown||[];var el=this,left=0,top=0;do{left+=el.offsetLeft||0;top+=el.offsetTop||0;el=el.offsetParent;}while(el);overflown.each(function(element){left-=element.scrollLeft||0;top-=element.scrollTop||0;});return{'x':left,'y':top};},getTop:function(overflown){return this.getPosition(overflown).y;},getLeft:function(overflown){return this.getPosition(overflown).x;},getCoordinates:function(overflown){var position=this.getPosition(overflown);var obj={'width':this.offsetWidth,'height':this.offsetHeight,'left':position.x,'top':position.y};obj.right=obj.left+obj.width;obj.bottom=obj.top+obj.height;return obj;}});Element.Events.domready={add:function(fn){if(window.loaded){fn.call(this);return;}
var domReady=function(){if(window.loaded)return;window.loaded=true;window.timer=$clear(window.timer);this.fireEvent('domready');}.bind(this);if(document.readyState&&window.webkit){window.timer=function(){if(['loaded','complete'].contains(document.readyState))domReady();}.periodical(50);}else if(document.readyState&&window.ie){if(!$('ie_ready')){var src=(window.location.protocol=='https:')?'://0':'javascript:void(0)';document.write('<script id="ie_ready" defer src="'+src+'"><\/script>');$('ie_ready').onreadystatechange=function(){if(this.readyState=='complete')domReady();};}}else{window.addListener("load",domReady);document.addListener("DOMContentLoaded",domReady);}}};window.onDomReady=function(fn){return this.addEvent('domready',fn);};window.extend({getWidth:function(){if(this.webkit419)return this.innerWidth;if(this.opera)return document.body.clientWidth;return document.documentElement.clientWidth;},getHeight:function(){if(this.webkit419)return this.innerHeight;if(this.opera)return document.body.clientHeight;return document.documentElement.clientHeight;},getScrollWidth:function(){if(this.ie)return Math.max(document.documentElement.offsetWidth,document.documentElement.scrollWidth);if(this.webkit)return document.body.scrollWidth;return document.documentElement.scrollWidth;},getScrollHeight:function(){if(this.ie)return Math.max(document.documentElement.offsetHeight,document.documentElement.scrollHeight);if(this.webkit)return document.body.scrollHeight;return document.documentElement.scrollHeight;},getScrollLeft:function(){return this.pageXOffset||document.documentElement.scrollLeft;},getScrollTop:function(){return this.pageYOffset||document.documentElement.scrollTop;},getSize:function(){return{'size':{'x':this.getWidth(),'y':this.getHeight()},'scrollSize':{'x':this.getScrollWidth(),'y':this.getScrollHeight()},'scroll':{'x':this.getScrollLeft(),'y':this.getScrollTop()}};},getPosition:function(){return{'x':0,'y':0};}});var Fx={};Fx.Base=new Class({options:{onStart:Class.empty,onComplete:Class.empty,onCancel:Class.empty,transition:function(p){return-(Math.cos(Math.PI*p)-1)/2;},duration:500,unit:'px',wait:true,fps:50},initialize:function(options){this.element=this.element||null;this.setOptions(options);if(this.options.initialize)this.options.initialize.call(this);},step:function(){var time=$time();if(time<this.time+this.options.duration){this.delta=this.options.transition((time-this.time)/this.options.duration);this.setNow();this.increase();}else{this.stop(true);this.set(this.to);this.fireEvent('onComplete',this.element,10);this.callChain();}},set:function(to){this.now=to;this.increase();return this;},setNow:function(){this.now=this.compute(this.from,this.to);},compute:function(from,to){return(to-from)*this.delta+from;},start:function(from,to){if(!this.options.wait)this.stop();else if(this.timer)return this;this.from=from;this.to=to;this.change=this.to-this.from;this.time=$time();this.timer=this.step.periodical(Math.round(1000/this.options.fps),this);this.fireEvent('onStart',this.element);return this;},stop:function(end){if(!this.timer)return this;this.timer=$clear(this.timer);if(!end)this.fireEvent('onCancel',this.element);return this;},custom:function(from,to){return this.start(from,to);},clearTimer:function(end){return this.stop(end);}});Fx.Base.implement(new Chain,new Events,new Options);Fx.CSS={select:function(property,to){if(property.test(/color/i))return this.Color;var type=$type(to);if((type=='array')||(type=='string'&&to.contains(' ')))return this.Multi;return this.Single;},parse:function(el,property,fromTo){if(!fromTo.push)fromTo=[fromTo];var from=fromTo[0],to=fromTo[1];if(!$chk(to)){to=from;from=el.getStyle(property);}
var css=this.select(property,to);return{'from':css.parse(from),'to':css.parse(to),'css':css};}};Fx.CSS.Single={parse:function(value){return parseFloat(value);},getNow:function(from,to,fx){return fx.compute(from,to);},getValue:function(value,unit,property){if(unit=='px'&&property!='opacity')value=Math.round(value);return value+unit;}};Fx.CSS.Multi={parse:function(value){return value.push?value:value.split(' ').map(function(v){return parseFloat(v);});},getNow:function(from,to,fx){var now=[];for(var i=0;i<from.length;i++)now[i]=fx.compute(from[i],to[i]);return now;},getValue:function(value,unit,property){if(unit=='px'&&property!='opacity')value=value.map(Math.round);return value.join(unit+' ')+unit;}};Fx.CSS.Color={parse:function(value){return value.push?value:value.hexToRgb(true);},getNow:function(from,to,fx){var now=[];for(var i=0;i<from.length;i++)now[i]=Math.round(fx.compute(from[i],to[i]));return now;},getValue:function(value){return'rgb('+value.join(',')+')';}};Fx.Style=Fx.Base.extend({initialize:function(el,property,options){this.element=$(el);this.property=property;this.parent(options);},hide:function(){return this.set(0);},setNow:function(){this.now=this.css.getNow(this.from,this.to,this);},set:function(to){this.css=Fx.CSS.select(this.property,to);return this.parent(this.css.parse(to));},start:function(from,to){if(this.timer&&this.options.wait)return this;var parsed=Fx.CSS.parse(this.element,this.property,[from,to]);this.css=parsed.css;return this.parent(parsed.from,parsed.to);},increase:function(){this.element.setStyle(this.property,this.css.getValue(this.now,this.options.unit,this.property));}});Element.extend({effect:function(property,options){return new Fx.Style(this,property,options);}});Fx.Styles=Fx.Base.extend({initialize:function(el,options){this.element=$(el);this.parent(options);},setNow:function(){for(var p in this.from)this.now[p]=this.css[p].getNow(this.from[p],this.to[p],this);},set:function(to){var parsed={};this.css={};for(var p in to){this.css[p]=Fx.CSS.select(p,to[p]);parsed[p]=this.css[p].parse(to[p]);}
return this.parent(parsed);},start:function(obj){if(this.timer&&this.options.wait)return this;this.now={};this.css={};var from={},to={};for(var p in obj){var parsed=Fx.CSS.parse(this.element,p,obj[p]);from[p]=parsed.from;to[p]=parsed.to;this.css[p]=parsed.css;}
return this.parent(from,to);},increase:function(){for(var p in this.now)this.element.setStyle(p,this.css[p].getValue(this.now[p],this.options.unit,p));}});Element.extend({effects:function(options){return new Fx.Styles(this,options);}});Fx.Elements=Fx.Base.extend({initialize:function(elements,options){this.elements=$$(elements);this.parent(options);},setNow:function(){for(var i in this.from){var iFrom=this.from[i],iTo=this.to[i],iCss=this.css[i],iNow=this.now[i]={};for(var p in iFrom)iNow[p]=iCss[p].getNow(iFrom[p],iTo[p],this);}},set:function(to){var parsed={};this.css={};for(var i in to){var iTo=to[i],iCss=this.css[i]={},iParsed=parsed[i]={};for(var p in iTo){iCss[p]=Fx.CSS.select(p,iTo[p]);iParsed[p]=iCss[p].parse(iTo[p]);}}
return this.parent(parsed);},start:function(obj){if(this.timer&&this.options.wait)return this;this.now={};this.css={};var from={},to={};for(var i in obj){var iProps=obj[i],iFrom=from[i]={},iTo=to[i]={},iCss=this.css[i]={};for(var p in iProps){var parsed=Fx.CSS.parse(this.elements[i],p,iProps[p]);iFrom[p]=parsed.from;iTo[p]=parsed.to;iCss[p]=parsed.css;}}
return this.parent(from,to);},increase:function(){for(var i in this.now){var iNow=this.now[i],iCss=this.css[i];for(var p in iNow)this.elements[i].setStyle(p,iCss[p].getValue(iNow[p],this.options.unit,p));}}});Fx.Scroll=Fx.Base.extend({options:{overflown:[],offset:{'x':0,'y':0},wheelStops:true},initialize:function(element,options){this.now=[];this.element=$(element);this.bound={'stop':this.stop.bind(this,false)};this.parent(options);if(this.options.wheelStops){this.addEvent('onStart',function(){document.addEvent('mousewheel',this.bound.stop);}.bind(this));this.addEvent('onComplete',function(){document.removeEvent('mousewheel',this.bound.stop);}.bind(this));}},setNow:function(){for(var i=0;i<2;i++)this.now[i]=this.compute(this.from[i],this.to[i]);},scrollTo:function(x,y){if(this.timer&&this.options.wait)return this;var el=this.element.getSize();var values={'x':x,'y':y};for(var z in el.size){var max=el.scrollSize[z]-el.size[z];if($chk(values[z]))values[z]=($type(values[z])=='number')?values[z].limit(0,max):max;else values[z]=el.scroll[z];values[z]+=this.options.offset[z];}
return this.start([el.scroll.x,el.scroll.y],[values.x,values.y]);},toTop:function(){return this.scrollTo(false,0);},toBottom:function(){return this.scrollTo(false,'full');},toLeft:function(){return this.scrollTo(0,false);},toRight:function(){return this.scrollTo('full',false);},toElement:function(el){var parent=this.element.getPosition(this.options.overflown);var target=$(el).getPosition(this.options.overflown);return this.scrollTo(target.x-parent.x,target.y-parent.y);},increase:function(){this.element.scrollTo(this.now[0],this.now[1]);}});Fx.Slide=Fx.Base.extend({options:{mode:'vertical'},initialize:function(el,options){this.element=$(el);this.wrapper=new Element('div',{'styles':$extend(this.element.getStyles('margin'),{'overflow':'hidden'})}).injectAfter(this.element).adopt(this.element);this.element.setStyle('margin',0);this.setOptions(options);this.now=[];this.parent(this.options);this.open=true;this.addEvent('onComplete',function(){this.open=(this.now[0]===0);});if(window.webkit419)this.addEvent('onComplete',function(){if(this.open)this.element.remove().inject(this.wrapper);});},setNow:function(){for(var i=0;i<2;i++)this.now[i]=this.compute(this.from[i],this.to[i]);},vertical:function(){this.margin='margin-top';this.layout='height';this.offset=this.element.offsetHeight;},horizontal:function(){this.margin='margin-left';this.layout='width';this.offset=this.element.offsetWidth;},slideIn:function(mode){this[mode||this.options.mode]();return this.start([this.element.getStyle(this.margin).toInt(),this.wrapper.getStyle(this.layout).toInt()],[0,this.offset]);},slideOut:function(mode){this[mode||this.options.mode]();return this.start([this.element.getStyle(this.margin).toInt(),this.wrapper.getStyle(this.layout).toInt()],[-this.offset,0]);},hide:function(mode){this[mode||this.options.mode]();this.open=false;return this.set([-this.offset,0]);},show:function(mode){this[mode||this.options.mode]();this.open=true;return this.set([0,this.offset]);},toggle:function(mode){if(this.wrapper.offsetHeight==0||this.wrapper.offsetWidth==0)return this.slideIn(mode);return this.slideOut(mode);},increase:function(){this.element.setStyle(this.margin,this.now[0]+this.options.unit);this.wrapper.setStyle(this.layout,this.now[1]+this.options.unit);}});Fx.Transition=function(transition,params){params=params||[];if($type(params)!='array')params=[params];return $extend(transition,{easeIn:function(pos){return transition(pos,params);},easeOut:function(pos){return 1-transition(1-pos,params);},easeInOut:function(pos){return(pos<=0.5)?transition(2*pos,params)/2:(2-transition(2*(1-pos),params))/2;}});};Fx.Transitions=new Abstract({linear:function(p){return p;}});Fx.Transitions.extend=function(transitions){for(var transition in transitions){Fx.Transitions[transition]=new Fx.Transition(transitions[transition]);Fx.Transitions.compat(transition);}};Fx.Transitions.compat=function(transition){['In','Out','InOut'].each(function(easeType){Fx.Transitions[transition.toLowerCase()+easeType]=Fx.Transitions[transition]['ease'+easeType];});};Fx.Transitions.extend({Pow:function(p,x){return Math.pow(p,x[0]||6);},Expo:function(p){return Math.pow(2,8*(p-1));},Circ:function(p){return 1-Math.sin(Math.acos(p));},Sine:function(p){return 1-Math.sin((1-p)*Math.PI/2);},Back:function(p,x){x=x[0]||1.618;return Math.pow(p,2)*((x+1)*p-x);},Bounce:function(p){var value;for(var a=0,b=1;1;a+=b,b/=2){if(p>=(7-4*a)/11){value=-Math.pow((11-6*a-11*p)/4,2)+b*b;break;}}
return value;},Elastic:function(p,x){return Math.pow(2,10*--p)*Math.cos(20*p*Math.PI*(x[0]||1)/3);}});['Quad','Cubic','Quart','Quint'].each(function(transition,i){Fx.Transitions[transition]=new Fx.Transition(function(p){return Math.pow(p,[i+2]);});Fx.Transitions.compat(transition);});var Drag={};Drag.Base=new Class({options:{handle:false,unit:'px',onStart:Class.empty,onBeforeStart:Class.empty,onComplete:Class.empty,onSnap:Class.empty,onDrag:Class.empty,limit:false,modifiers:{x:'left',y:'top'},grid:false,snap:6},initialize:function(el,options){this.setOptions(options);this.element=$(el);this.handle=$(this.options.handle)||this.element;this.mouse={'now':{},'pos':{}};this.value={'start':{},'now':{}};this.bound={'start':this.start.bindWithEvent(this),'check':this.check.bindWithEvent(this),'drag':this.drag.bindWithEvent(this),'stop':this.stop.bind(this)};this.attach();if(this.options.initialize)this.options.initialize.call(this);},attach:function(){this.handle.addEvent('mousedown',this.bound.start);return this;},detach:function(){this.handle.removeEvent('mousedown',this.bound.start);return this;},start:function(event){this.fireEvent('onBeforeStart',this.element);this.mouse.start=event.page;var limit=this.options.limit;this.limit={'x':[],'y':[]};for(var z in this.options.modifiers){if(!this.options.modifiers[z])continue;this.value.now[z]=this.element.getStyle(this.options.modifiers[z]).toInt();this.mouse.pos[z]=event.page[z]-this.value.now[z];if(limit&&limit[z]){for(var i=0;i<2;i++){if($chk(limit[z][i]))this.limit[z][i]=($type(limit[z][i])=='function')?limit[z][i]():limit[z][i];}}}
if($type(this.options.grid)=='number')this.options.grid={'x':this.options.grid,'y':this.options.grid};document.addListener('mousemove',this.bound.check);document.addListener('mouseup',this.bound.stop);this.fireEvent('onStart',this.element);event.stop();},check:function(event){var distance=Math.round(Math.sqrt(Math.pow(event.page.x-this.mouse.start.x,2)+Math.pow(event.page.y-this.mouse.start.y,2)));if(distance>this.options.snap){document.removeListener('mousemove',this.bound.check);document.addListener('mousemove',this.bound.drag);this.drag(event);this.fireEvent('onSnap',this.element);}
event.stop();},drag:function(event){this.out=false;this.mouse.now=event.page;for(var z in this.options.modifiers){if(!this.options.modifiers[z])continue;this.value.now[z]=this.mouse.now[z]-this.mouse.pos[z];if(this.limit[z]){if($chk(this.limit[z][1])&&(this.value.now[z]>this.limit[z][1])){this.value.now[z]=this.limit[z][1];this.out=true;}else if($chk(this.limit[z][0])&&(this.value.now[z]<this.limit[z][0])){this.value.now[z]=this.limit[z][0];this.out=true;}}
if(this.options.grid[z])this.value.now[z]-=(this.value.now[z]%this.options.grid[z]);this.element.setStyle(this.options.modifiers[z],this.value.now[z]+this.options.unit);}
this.fireEvent('onDrag',this.element);event.stop();},stop:function(){document.removeListener('mousemove',this.bound.check);document.removeListener('mousemove',this.bound.drag);document.removeListener('mouseup',this.bound.stop);this.fireEvent('onComplete',this.element);}});Drag.Base.implement(new Events,new Options);Element.extend({makeResizable:function(options){return new Drag.Base(this,$merge({modifiers:{x:'width',y:'height'}},options));}});Drag.Move=Drag.Base.extend({options:{droppables:[],container:false,overflown:[]},initialize:function(el,options){this.setOptions(options);this.element=$(el);this.droppables=$$(this.options.droppables);this.container=$(this.options.container);this.position={'element':this.element.getStyle('position'),'container':false};if(this.container)this.position.container=this.container.getStyle('position');if(!['relative','absolute','fixed'].contains(this.position.element))this.position.element='absolute';var top=this.element.getStyle('top').toInt();var left=this.element.getStyle('left').toInt();if(this.position.element=='absolute'&&!['relative','absolute','fixed'].contains(this.position.container)){top=$chk(top)?top:this.element.getTop(this.options.overflown);left=$chk(left)?left:this.element.getLeft(this.options.overflown);}else{top=$chk(top)?top:0;left=$chk(left)?left:0;}
this.element.setStyles({'top':top,'left':left,'position':this.position.element});this.parent(this.element);},start:function(event){this.overed=null;if(this.container){var cont=this.container.getCoordinates();var el=this.element.getCoordinates();if(this.position.element=='absolute'&&!['relative','absolute','fixed'].contains(this.position.container)){this.options.limit={'x':[cont.left,cont.right-el.width],'y':[cont.top,cont.bottom-el.height]};}else{this.options.limit={'y':[0,cont.height-el.height],'x':[0,cont.width-el.width]};}}
this.parent(event);},drag:function(event){this.parent(event);var overed=this.out?false:this.droppables.filter(this.checkAgainst,this).getLast();if(this.overed!=overed){if(this.overed)this.overed.fireEvent('leave',[this.element,this]);this.overed=overed?overed.fireEvent('over',[this.element,this]):null;}
return this;},checkAgainst:function(el){el=el.getCoordinates(this.options.overflown);var now=this.mouse.now;return(now.x>el.left&&now.x<el.right&&now.y<el.bottom&&now.y>el.top);},stop:function(){if(this.overed&&!this.out)this.overed.fireEvent('drop',[this.element,this]);else this.element.fireEvent('emptydrop',this);this.parent();return this;}});Element.extend({makeDraggable:function(options){return new Drag.Move(this,options);}});var XHR=new Class({options:{method:'post',async:true,onRequest:Class.empty,onSuccess:Class.empty,onFailure:Class.empty,urlEncoded:true,encoding:'utf-8',autoCancel:false,headers:{}},setTransport:function(){this.transport=(window.XMLHttpRequest)?new XMLHttpRequest():(window.ie?new ActiveXObject('Microsoft.XMLHTTP'):false);return this;},initialize:function(options){this.setTransport().setOptions(options);this.options.isSuccess=this.options.isSuccess||this.isSuccess;this.headers={};if(this.options.urlEncoded&&this.options.method=='post'){var encoding=(this.options.encoding)?'; charset='+this.options.encoding:'';this.setHeader('Content-type','application/x-www-form-urlencoded'+encoding);}
if(this.options.initialize)this.options.initialize.call(this);},onStateChange:function(){if(this.transport.readyState!=4||!this.running)return;this.running=false;var status=0;try{status=this.transport.status;}catch(e){};if(this.options.isSuccess.call(this,status))this.onSuccess();else this.onFailure();this.transport.onreadystatechange=Class.empty;},isSuccess:function(status){return((status>=200)&&(status<300));},onSuccess:function(){this.response={'text':this.transport.responseText,'xml':this.transport.responseXML};this.fireEvent('onSuccess',[this.response.text,this.response.xml]);this.callChain();},onFailure:function(){this.fireEvent('onFailure',this.transport);},setHeader:function(name,value){this.headers[name]=value;return this;},send:function(url,data){if(this.options.autoCancel)this.cancel();else if(this.running)return this;this.running=true;if(data&&this.options.method=='get'){url=url+(url.contains('?')?'&':'?')+data;data=null;}
this.transport.open(this.options.method.toUpperCase(),url,this.options.async);this.transport.onreadystatechange=this.onStateChange.bind(this);if((this.options.method=='post')&&this.transport.overrideMimeType)this.setHeader('Connection','close');$extend(this.headers,this.options.headers);for(var type in this.headers)try{this.transport.setRequestHeader(type,this.headers[type]);}catch(e){};this.fireEvent('onRequest');this.transport.send($pick(data,null));return this;},cancel:function(){if(!this.running)return this;this.running=false;this.transport.abort();this.transport.onreadystatechange=Class.empty;this.setTransport();this.fireEvent('onCancel');return this;}});XHR.implement(new Chain,new Events,new Options);var Ajax=XHR.extend({options:{data:null,update:null,onComplete:Class.empty,evalScripts:false,evalResponse:false},initialize:function(url,options){this.addEvent('onSuccess',this.onComplete);this.setOptions(options);this.options.data=this.options.data||this.options.postBody;if(!['post','get'].contains(this.options.method)){this._method='_method='+this.options.method;this.options.method='post';}
this.parent();this.setHeader('X-Requested-With','XMLHttpRequest');this.setHeader('Accept','text/javascript, text/html, application/xml, text/xml, */*');this.url=url;},onComplete:function(){if(this.options.update)$(this.options.update).empty().setHTML(this.response.text);if(this.options.evalScripts||this.options.evalResponse)this.evalScripts();this.fireEvent('onComplete',[this.response.text,this.response.xml],20);},request:function(data){data=data||this.options.data;switch($type(data)){case'element':data=$(data).toQueryString();break;case'object':data=Object.toQueryString(data);}
if(this._method)data=(data)?[this._method,data].join('&'):this._method;return this.send(this.url,data);},evalScripts:function(){var script,scripts;if(this.options.evalResponse||(/(ecma|java)script/).test(this.getHeader('Content-type')))scripts=this.response.text;else{scripts=[];var regexp=/<script[^>]*>([\s\S]*?)<\/script>/gi;while((script=regexp.exec(this.response.text)))scripts.push(script[1]);scripts=scripts.join('\n');}
if(scripts)(window.execScript)?window.execScript(scripts):window.setTimeout(scripts,0);},getHeader:function(name){try{return this.transport.getResponseHeader(name);}catch(e){};return null;}});Object.toQueryString=function(source){var queryString=[];for(var property in source)queryString.push(encodeURIComponent(property)+'='+encodeURIComponent(source[property]));return queryString.join('&');};Element.extend({send:function(options){return new Ajax(this.getProperty('action'),$merge({data:this.toQueryString()},options,{method:'post'})).request();}});var Cookie=new Abstract({options:{domain:false,path:false,duration:false,secure:false},set:function(key,value,options){options=$merge(this.options,options);value=encodeURIComponent(value);if(options.domain)value+='; domain='+options.domain;if(options.path)value+='; path='+options.path;if(options.duration){var date=new Date();date.setTime(date.getTime()+options.duration*24*60*60*1000);value+='; expires='+date.toGMTString();}
if(options.secure)value+='; secure';document.cookie=key+'='+value;return $extend(options,{'key':key,'value':value});},get:function(key){var value=document.cookie.match('(?:^|;)\\s*'+key.escapeRegExp()+'=([^;]*)');return value?decodeURIComponent(value[1]):false;},remove:function(cookie,options){if($type(cookie)=='object')this.set(cookie.key,'',$merge(cookie,{duration:-1}));else this.set(cookie,'',$merge(options,{duration:-1}));}});var Json={toString:function(obj){switch($type(obj)){case'string':return'"'+obj.replace(/(["\\])/g,'\\$1')+'"';case'array':return'['+obj.map(Json.toString).join(',')+']';case'object':var string=[];for(var property in obj)string.push(Json.toString(property)+':'+Json.toString(obj[property]));return'{'+string.join(',')+'}';case'number':if(isFinite(obj))break;case false:return'null';}
return String(obj);},evaluate:function(str,secure){return(($type(str)!='string')||(secure&&!str.test(/^("(\\.|[^"\\\n\r])*?"|[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t])+?$/)))?null:eval('('+str+')');}};Json.Remote=XHR.extend({initialize:function(url,options){this.url=url;this.addEvent('onSuccess',this.onComplete);this.parent(options);this.setHeader('X-Request','JSON');},send:function(obj){return this.parent(this.url,'json='+Json.toString(obj));},onComplete:function(){this.fireEvent('onComplete',[Json.evaluate(this.response.text,this.options.secure)]);}});var Asset=new Abstract({javascript:function(source,properties){properties=$merge({'onload':Class.empty},properties);var script=new Element('script',{'src':source}).addEvents({'load':properties.onload,'readystatechange':function(){if(this.readyState=='complete')this.fireEvent('load');}});delete properties.onload;return script.setProperties(properties).inject(document.head);},css:function(source,properties){return new Element('link',$merge({'rel':'stylesheet','media':'screen','type':'text/css','href':source},properties)).inject(document.head);},image:function(source,properties){properties=$merge({'onload':Class.empty,'onabort':Class.empty,'onerror':Class.empty},properties);var image=new Image();image.src=source;var element=new Element('img',{'src':source});['load','abort','error'].each(function(type){var event=properties['on'+type];delete properties['on'+type];element.addEvent(type,function(){this.removeEvent(type,arguments.callee);event.call(this);});});if(image.width&&image.height)element.fireEvent('load',element,1);return element.setProperties(properties);},images:function(sources,options){options=$merge({onComplete:Class.empty,onProgress:Class.empty},options);if(!sources.push)sources=[sources];var images=[];var counter=0;sources.each(function(source){var img=new Asset.image(source,{'onload':function(){options.onProgress.call(this,counter);counter++;if(counter==sources.length)options.onComplete();}});images.push(img);});return new Elements(images);}});var Hash=new Class({length:0,initialize:function(object){this.obj=object||{};this.setLength();},get:function(key){return(this.hasKey(key))?this.obj[key]:null;},hasKey:function(key){return(key in this.obj);},set:function(key,value){if(!this.hasKey(key))this.length++;this.obj[key]=value;return this;},setLength:function(){this.length=0;for(var p in this.obj)this.length++;return this;},remove:function(key){if(this.hasKey(key)){delete this.obj[key];this.length--;}
return this;},each:function(fn,bind){$each(this.obj,fn,bind);},extend:function(obj){$extend(this.obj,obj);return this.setLength();},merge:function(){this.obj=$merge.apply(null,[this.obj].extend(arguments));return this.setLength();},empty:function(){this.obj={};this.length=0;return this;},keys:function(){var keys=[];for(var property in this.obj)keys.push(property);return keys;},values:function(){var values=[];for(var property in this.obj)values.push(this.obj[property]);return values;}});function $H(obj){return new Hash(obj);};Hash.Cookie=Hash.extend({initialize:function(name,options){this.name=name;this.options=$extend({'autoSave':true},options||{});this.load();},save:function(){if(this.length==0){Cookie.remove(this.name,this.options);return true;}
var str=Json.toString(this.obj);if(str.length>4096)return false;Cookie.set(this.name,str,this.options);return true;},load:function(){this.obj=Json.evaluate(Cookie.get(this.name),true)||{};this.setLength();}});Hash.Cookie.Methods={};['extend','set','merge','empty','remove'].each(function(method){Hash.Cookie.Methods[method]=function(){Hash.prototype[method].apply(this,arguments);if(this.options.autoSave)this.save();return this;};});Hash.Cookie.implement(Hash.Cookie.Methods);var Color=new Class({initialize:function(color,type){type=type||(color.push?'rgb':'hex');var rgb,hsb;switch(type){case'rgb':rgb=color;hsb=rgb.rgbToHsb();break;case'hsb':rgb=color.hsbToRgb();hsb=color;break;default:rgb=color.hexToRgb(true);hsb=rgb.rgbToHsb();}
rgb.hsb=hsb;rgb.hex=rgb.rgbToHex();return $extend(rgb,Color.prototype);},mix:function(){var colors=$A(arguments);var alpha=($type(colors[colors.length-1])=='number')?colors.pop():50;var rgb=this.copy();colors.each(function(color){color=new Color(color);for(var i=0;i<3;i++)rgb[i]=Math.round((rgb[i]/100*(100-alpha))+(color[i]/100*alpha));});return new Color(rgb,'rgb');},invert:function(){return new Color(this.map(function(value){return 255-value;}));},setHue:function(value){return new Color([value,this.hsb[1],this.hsb[2]],'hsb');},setSaturation:function(percent){return new Color([this.hsb[0],percent,this.hsb[2]],'hsb');},setBrightness:function(percent){return new Color([this.hsb[0],this.hsb[1],percent],'hsb');}});function $RGB(r,g,b){return new Color([r,g,b],'rgb');};function $HSB(h,s,b){return new Color([h,s,b],'hsb');};Array.extend({rgbToHsb:function(){var red=this[0],green=this[1],blue=this[2];var hue,saturation,brightness;var max=Math.max(red,green,blue),min=Math.min(red,green,blue);var delta=max-min;brightness=max/255;saturation=(max!=0)?delta/max:0;if(saturation==0){hue=0;}else{var rr=(max-red)/delta;var gr=(max-green)/delta;var br=(max-blue)/delta;if(red==max)hue=br-gr;else if(green==max)hue=2+rr-br;else hue=4+gr-rr;hue/=6;if(hue<0)hue++;}
return[Math.round(hue*360),Math.round(saturation*100),Math.round(brightness*100)];},hsbToRgb:function(){var br=Math.round(this[2]/100*255);if(this[1]==0){return[br,br,br];}else{var hue=this[0]%360;var f=hue%60;var p=Math.round((this[2]*(100-this[1]))/10000*255);var q=Math.round((this[2]*(6000-this[1]*f))/600000*255);var t=Math.round((this[2]*(6000-this[1]*(60-f)))/600000*255);switch(Math.floor(hue/60)){case 0:return[br,t,p];case 1:return[q,br,p];case 2:return[p,br,t];case 3:return[p,q,br];case 4:return[t,p,br];case 5:return[br,p,q];}}
return false;}});var Scroller=new Class({options:{area:20,velocity:1,onChange:function(x,y){this.element.scrollTo(x,y);}},initialize:function(element,options){this.setOptions(options);this.element=$(element);this.mousemover=([window,document].contains(element))?$(document.body):this.element;},start:function(){this.coord=this.getCoords.bindWithEvent(this);this.mousemover.addListener('mousemove',this.coord);},stop:function(){this.mousemover.removeListener('mousemove',this.coord);this.timer=$clear(this.timer);},getCoords:function(event){this.page=(this.element==window)?event.client:event.page;if(!this.timer)this.timer=this.scroll.periodical(50,this);},scroll:function(){var el=this.element.getSize();var pos=this.element.getPosition();var change={'x':0,'y':0};for(var z in this.page){if(this.page[z]<(this.options.area+pos[z])&&el.scroll[z]!=0)
change[z]=(this.page[z]-this.options.area-pos[z])*this.options.velocity;else if(this.page[z]+this.options.area>(el.size[z]+pos[z])&&el.scroll[z]+el.size[z]!=el.scrollSize[z])
change[z]=(this.page[z]-el.size[z]+this.options.area-pos[z])*this.options.velocity;}
if(change.y||change.x)this.fireEvent('onChange',[el.scroll.x+change.x,el.scroll.y+change.y]);}});Scroller.implement(new Events,new Options);var Slider=new Class({options:{onChange:Class.empty,onComplete:Class.empty,onTick:function(pos){this.knob.setStyle(this.p,pos);},mode:'horizontal',steps:100,offset:0},initialize:function(el,knob,options){this.element=$(el);this.knob=$(knob);this.setOptions(options);this.previousChange=-1;this.previousEnd=-1;this.step=-1;this.element.addEvent('mousedown',this.clickedElement.bindWithEvent(this));var mod,offset;switch(this.options.mode){case'horizontal':this.z='x';this.p='left';mod={'x':'left','y':false};offset='offsetWidth';break;case'vertical':this.z='y';this.p='top';mod={'x':false,'y':'top'};offset='offsetHeight';}
this.max=this.element[offset]-this.knob[offset]+(this.options.offset*2);this.half=this.knob[offset]/2;this.getPos=this.element['get'+this.p.capitalize()].bind(this.element);this.knob.setStyle('position','relative').setStyle(this.p,-this.options.offset);var lim={};lim[this.z]=[-this.options.offset,this.max-this.options.offset];this.drag=new Drag.Base(this.knob,{limit:lim,modifiers:mod,snap:0,onStart:function(){this.draggedKnob();}.bind(this),onDrag:function(){this.draggedKnob();}.bind(this),onComplete:function(){this.draggedKnob();this.end();}.bind(this)});if(this.options.initialize)this.options.initialize.call(this);},set:function(step){this.step=step.limit(0,this.options.steps);this.checkStep();this.end();this.fireEvent('onTick',this.toPosition(this.step));return this;},clickedElement:function(event){var position=event.page[this.z]-this.getPos()-this.half;position=position.limit(-this.options.offset,this.max-this.options.offset);this.step=this.toStep(position);this.checkStep();this.end();this.fireEvent('onTick',position);},draggedKnob:function(){this.step=this.toStep(this.drag.value.now[this.z]);this.checkStep();},checkStep:function(){if(this.previousChange!=this.step){this.previousChange=this.step;this.fireEvent('onChange',this.step);}},end:function(){if(this.previousEnd!==this.step){this.previousEnd=this.step;this.fireEvent('onComplete',this.step+'');}},toStep:function(position){return Math.round((position+this.options.offset)/this.max*this.options.steps);},toPosition:function(step){return this.max*step/this.options.steps;}});Slider.implement(new Events);Slider.implement(new Options);var SmoothScroll=Fx.Scroll.extend({initialize:function(options){this.parent(window,options);this.links=(this.options.links)?$$(this.options.links):$$(document.links);var location=window.location.href.match(/^[^#]*/)[0]+'#';this.links.each(function(link){if(link.href.indexOf(location)!=0)return;var anchor=link.href.substr(location.length);if(anchor&&$(anchor))this.useLink(link,anchor);},this);if(!window.webkit419)this.addEvent('onComplete',function(){window.location.hash=this.anchor;});},useLink:function(link,anchor){link.addEvent('click',function(event){this.anchor=anchor;this.toElement(anchor);event.stop();}.bindWithEvent(this));}});var Sortables=new Class({options:{handles:false,onStart:Class.empty,onComplete:Class.empty,ghost:true,snap:3,onDragStart:function(element,ghost){ghost.setStyle('opacity',0.7);element.setStyle('opacity',0.7);},onDragComplete:function(element,ghost){element.setStyle('opacity',1);ghost.remove();this.trash.remove();}},initialize:function(list,options){this.setOptions(options);this.list=$(list);this.elements=this.list.getChildren();this.handles=(this.options.handles)?$$(this.options.handles):this.elements;this.bound={'start':[],'moveGhost':this.moveGhost.bindWithEvent(this)};for(var i=0,l=this.handles.length;i<l;i++){this.bound.start[i]=this.start.bindWithEvent(this,this.elements[i]);}
this.attach();if(this.options.initialize)this.options.initialize.call(this);this.bound.move=this.move.bindWithEvent(this);this.bound.end=this.end.bind(this);},attach:function(){this.handles.each(function(handle,i){handle.addEvent('mousedown',this.bound.start[i]);},this);},detach:function(){this.handles.each(function(handle,i){handle.removeEvent('mousedown',this.bound.start[i]);},this);},start:function(event,el){this.active=el;this.coordinates=this.list.getCoordinates();if(this.options.ghost){var position=el.getPosition();this.offset=event.page.y-position.y;this.trash=new Element('div').inject(document.body);this.ghost=el.clone().inject(this.trash).setStyles({'position':'absolute','left':position.x,'top':event.page.y-this.offset});document.addListener('mousemove',this.bound.moveGhost);this.fireEvent('onDragStart',[el,this.ghost]);}
document.addListener('mousemove',this.bound.move);document.addListener('mouseup',this.bound.end);this.fireEvent('onStart',el);event.stop();},moveGhost:function(event){var value=event.page.y-this.offset;value=value.limit(this.coordinates.top,this.coordinates.bottom-this.ghost.offsetHeight);this.ghost.setStyle('top',value);event.stop();},move:function(event){var now=event.page.y;this.previous=this.previous||now;var up=((this.previous-now)>0);var prev=this.active.getPrevious();var next=this.active.getNext();if(prev&&up&&now<prev.getCoordinates().bottom)this.active.injectBefore(prev);if(next&&!up&&now>next.getCoordinates().top)this.active.injectAfter(next);this.previous=now;},serialize:function(converter){return this.list.getChildren().map(converter||function(el){return this.elements.indexOf(el);},this);},end:function(){this.previous=null;document.removeListener('mousemove',this.bound.move);document.removeListener('mouseup',this.bound.end);if(this.options.ghost){document.removeListener('mousemove',this.bound.moveGhost);this.fireEvent('onDragComplete',[this.active,this.ghost]);}
this.fireEvent('onComplete',this.active);}});Sortables.implement(new Events,new Options);var Tips=new Class({options:{onShow:function(tip){tip.setStyle('visibility','visible');},onHide:function(tip){tip.setStyle('visibility','hidden');},maxTitleChars:30,showDelay:100,hideDelay:100,className:'tool',offsets:{'x':16,'y':16},fixed:false},initialize:function(elements,options){this.setOptions(options);this.toolTip=new Element('div',{'class':this.options.className+'-tip','styles':{'position':'absolute','top':'0','left':'0','visibility':'hidden'}}).inject(document.body);this.wrapper=new Element('div').inject(this.toolTip);$$(elements).each(this.build,this);if(this.options.initialize)this.options.initialize.call(this);},build:function(el){el.$tmp.myTitle=(el.href&&el.getTag()=='a')?el.href.replace('http://',''):(el.rel||false);if(el.title){var dual=el.title.split('::');if(dual.length>1){el.$tmp.myTitle=dual[0].trim();el.$tmp.myText=dual[1].trim();}else{el.$tmp.myText=el.title;}
el.removeAttribute('title');}else{el.$tmp.myText=false;}
if(el.$tmp.myTitle&&el.$tmp.myTitle.length>this.options.maxTitleChars)el.$tmp.myTitle=el.$tmp.myTitle.substr(0,this.options.maxTitleChars-1)+"&hellip;";el.addEvent('mouseenter',function(event){this.start(el);if(!this.options.fixed)this.locate(event);else this.position(el);}.bind(this));if(!this.options.fixed)el.addEvent('mousemove',this.locate.bindWithEvent(this));var end=this.end.bind(this);el.addEvent('mouseleave',end);el.addEvent('trash',end);},start:function(el){this.wrapper.empty();if(el.$tmp.myTitle){this.title=new Element('span').inject(new Element('div',{'class':this.options.className+'-title'}).inject(this.wrapper)).setHTML(el.$tmp.myTitle);}
if(el.$tmp.myText){this.text=new Element('span').inject(new Element('div',{'class':this.options.className+'-text'}).inject(this.wrapper)).setHTML(el.$tmp.myText);}
$clear(this.timer);this.timer=this.show.delay(this.options.showDelay,this);},end:function(event){$clear(this.timer);this.timer=this.hide.delay(this.options.hideDelay,this);},position:function(element){var pos=element.getPosition();this.toolTip.setStyles({'left':pos.x+this.options.offsets.x,'top':pos.y+this.options.offsets.y});},locate:function(event){var win={'x':window.getWidth(),'y':window.getHeight()};var scroll={'x':window.getScrollLeft(),'y':window.getScrollTop()};var tip={'x':this.toolTip.offsetWidth,'y':this.toolTip.offsetHeight};var prop={'x':'left','y':'top'};for(var z in prop){var pos=event.page[z]+this.options.offsets[z];if((pos+tip[z]-scroll[z])>win[z])pos=event.page[z]-this.options.offsets[z]-tip[z];this.toolTip.setStyle(prop[z],pos);};},show:function(){if(this.options.timeout)this.timer=this.hide.delay(this.options.timeout,this);this.fireEvent('onShow',[this.toolTip]);},hide:function(){this.fireEvent('onHide',[this.toolTip]);}});Tips.implement(new Events,new Options);var Group=new Class({initialize:function(){this.instances=$A(arguments);this.events={};this.checker={};},addEvent:function(type,fn){this.checker[type]=this.checker[type]||{};this.events[type]=this.events[type]||[];if(this.events[type].contains(fn))return false;else this.events[type].push(fn);this.instances.each(function(instance,i){instance.addEvent(type,this.check.bind(this,[type,instance,i]));},this);return this;},check:function(type,instance,i){this.checker[type][i]=true;var every=this.instances.every(function(current,j){return this.checker[type][j]||false;},this);if(!every)return;this.checker[type]={};this.events[type].each(function(event){event.call(this,this.instances,instance);},this);}});var Accordion=Fx.Elements.extend({options:{onActive:Class.empty,onBackground:Class.empty,display:0,show:false,height:true,width:false,opacity:true,fixedHeight:false,fixedWidth:false,wait:false,alwaysHide:false},initialize:function(){var options,togglers,elements,container;$each(arguments,function(argument,i){switch($type(argument)){case'object':options=argument;break;case'element':container=$(argument);break;default:var temp=$$(argument);if(!togglers)togglers=temp;else elements=temp;}});this.togglers=togglers||[];this.elements=elements||[];this.container=$(container);this.setOptions(options);this.previous=-1;if(this.options.alwaysHide)this.options.wait=true;if($chk(this.options.show)){this.options.display=false;this.previous=this.options.show;}
if(this.options.start){this.options.display=false;this.options.show=false;}
this.effects={};if(this.options.opacity)this.effects.opacity='fullOpacity';if(this.options.width)this.effects.width=this.options.fixedWidth?'fullWidth':'offsetWidth';if(this.options.height)this.effects.height=this.options.fixedHeight?'fullHeight':'scrollHeight';for(var i=0,l=this.togglers.length;i<l;i++)this.addSection(this.togglers[i],this.elements[i]);this.elements.each(function(el,i){if(this.options.show===i){this.fireEvent('onActive',[this.togglers[i],el]);}else{for(var fx in this.effects)el.setStyle(fx,0);}},this);this.parent(this.elements);if($chk(this.options.display))this.display(this.options.display);},addSection:function(toggler,element,pos){toggler=$(toggler);element=$(element);var test=this.togglers.contains(toggler);var len=this.togglers.length;this.togglers.include(toggler);this.elements.include(element);if(len&&(!test||pos)){pos=$pick(pos,len-1);toggler.injectBefore(this.togglers[pos]);element.injectAfter(toggler);}else if(this.container&&!test){toggler.inject(this.container);element.inject(this.container);}
var idx=this.togglers.indexOf(toggler);toggler.addEvent('click',this.display.bind(this,idx));if(this.options.height)element.setStyles({'padding-top':0,'border-top':'none','padding-bottom':0,'border-bottom':'none'});if(this.options.width)element.setStyles({'padding-left':0,'border-left':'none','padding-right':0,'border-right':'none'});element.fullOpacity=1;if(this.options.fixedWidth)element.fullWidth=this.options.fixedWidth;if(this.options.fixedHeight)element.fullHeight=this.options.fixedHeight;element.setStyle('overflow','hidden');if(!test){for(var fx in this.effects)element.setStyle(fx,0);}
return this;},display:function(index){index=($type(index)=='element')?this.elements.indexOf(index):index;if((this.timer&&this.options.wait)||(index===this.previous&&!this.options.alwaysHide))return this;this.previous=index;var obj={};this.elements.each(function(el,i){obj[i]={};var hide=(i!=index)||(this.options.alwaysHide&&(el.offsetHeight>0));this.fireEvent(hide?'onBackground':'onActive',[this.togglers[i],el]);for(var fx in this.effects)obj[i][fx]=hide?0:el[this.effects[fx]];},this);return this.start(obj);},showThisHideOpen:function(index){return this.display(index);}});Fx.Accordion=Accordion;/**
* @version		$Id: caption.js 5263 2006-10-02 01:25:24Z webImagery $
* @copyright	Copyright (C) 2005 - 2009 Open Source Matters. All rights reserved.
* @license		GNU/GPL, see LICENSE.php
* Joomla! is free software. This version may have been modified pursuant
* to the GNU General Public License, and as distributed it includes or
* is derivative of works licensed under the GNU General Public License or
* other free or open source software licenses.
* See COPYRIGHT.php for copyright notices and details.
*/

/**
* JCaption javascript behavior
*
* Used for displaying image captions
*
* @package	Joomla
* @since	1.5
* @version	1.0
*/
var JCaption = new Class({
	initialize: function(selector)
	{
		this.selector = selector;

		var images = $$(selector);
		images.each(function(image){ this.createCaption(image); }, this);
	},

	createCaption: function(element)
	{
		var caption   = document.createTextNode(element.title);
		var container = document.createElement("div");
		var text      = document.createElement("p");
		var width     = element.getAttribute("width");
		var align     = element.getAttribute("align");
		var docMode = document.documentMode;

		//Windows fix
		if (!align)
			align = element.getStyle("float");  // Rest of the world fix
		if (!align) // IE DOM Fix
			align = element.style.styleFloat;

		text.appendChild(caption);
		text.className = this.selector.replace('.', '_');

		if (align=="none") {
			if (element.title != "") {
				element.parentNode.replaceChild(text, element);
				text.parentNode.insertBefore(element, text);
			}
		} else {
			element.parentNode.insertBefore(container, element);
			container.appendChild(element);
			if ( element.title != "" ) {
				container.appendChild(text);
			}
			container.className   = this.selector.replace('.', '_');
			container.className   = container.className + " " + align;
			container.setAttribute("style","float:"+align);

			//IE8 fix
			if (!docMode|| docMode < 8) {
				container.style.width = width + "px";
			}
		}

	}
});

document.caption = null;
window.addEvent('load', function() {
	var caption = new JCaption('img.caption')
	document.caption = caption
});
//\/////
//\  overLIB 4.21 - You may not remove or change this notice.
//\  Copyright Erik Bosrup 1998-2004. All rights reserved.
//\
//\  Contributors are listed on the homepage.
//\  This file might be old, always check for the latest version at:
//\  http://www.bosrup.com/web/overlib/
//\
//\  Please read the license agreement (available through the link above)
//\  before using overLIB. Direct any licensing questions to erik@bosrup.com.
//\
//\  Do not sell this as your own work or remove this copyright notice.
//\  For full details on copying or changing this script please read the
//\  license agreement at the link above. Please give credit on sites that
//\  use overLIB and submit changes of the script so other people can use
//\  them as well.
//\/////
//\  THIS IS A VERY MODIFIED VERSION. DO NOT EDIT OR PUBLISH. GET THE ORIGINAL!
var olLoaded=0,pmStart=10000000,pmUpper=10001000,pmCount=pmStart+1,pmt='',pms=new Array(),olInfo=new Info('4.21',1),FREPLACE=0,FBEFORE=1,FAFTER=2,FALTERNATE=3,FCHAIN=4,olHideForm=0,olHautoFlag=0,olVautoFlag=0,hookPts=new Array(),postParse=new Array(),cmdLine=new Array(),runTime=new Array();
registerCommands('donothing,inarray,caparray,sticky,background,noclose,caption,left,right,center,offsetx,offsety,fgcolor,bgcolor,textcolor,capcolor,closecolor,width,border,cellpad,status,autostatus,autostatuscap,height,closetext,snapx,snapy,fixx,fixy,relx,rely,fgbackground,bgbackground,padx,pady,fullhtml,above,below,capicon,textfont,captionfont,closefont,textsize,captionsize,closesize,timeout,function,delay,hauto,vauto,closeclick,wrap,followmouse,mouseoff,closetitle,cssoff,compatmode,cssclass,fgclass,bgclass,textfontclass,captionfontclass,closefontclass');
if(typeof ol_fgcolor=='undefined')var ol_fgcolor="#F1E8E6";if(typeof ol_bgcolor=='undefined')var ol_bgcolor="#C64934";if(typeof ol_textcolor=='undefined')var ol_textcolor="#000000";if(typeof ol_capcolor=='undefined')var ol_capcolor="#FFFFFF";if(typeof ol_closecolor=='undefined')var ol_closecolor="#9999FF";if(typeof ol_textfont=='undefined')var ol_textfont="Verdana,Arial,Helvetica";if(typeof ol_captionfont=='undefined')var ol_captionfont="Verdana,Arial,Helvetica";if(typeof ol_closefont=='undefined')var ol_closefont="Verdana,Arial,Helvetica";if(typeof ol_textsize=='undefined')var ol_textsize="1";if(typeof ol_captionsize=='undefined')var ol_captionsize="1";if(typeof ol_closesize=='undefined')var ol_closesize="1";if(typeof ol_width=='undefined')var ol_width="200";if(typeof ol_border=='undefined')var ol_border="1";if(typeof ol_cellpad=='undefined')var ol_cellpad=2;if(typeof ol_offsetx=='undefined')var ol_offsetx=10;if(typeof ol_offsety=='undefined')var ol_offsety=10;if(typeof ol_text=='undefined')var ol_text="Default Text";if(typeof ol_cap=='undefined')var ol_cap="";if(typeof ol_sticky=='undefined')var ol_sticky=0;if(typeof ol_background=='undefined')var ol_background="";if(typeof ol_close=='undefined')var ol_close="Close";if(typeof ol_hpos=='undefined')var ol_hpos=RIGHT;if(typeof ol_status=='undefined')var ol_status="";if(typeof ol_autostatus=='undefined')var ol_autostatus=0;if(typeof ol_height=='undefined')var ol_height=-1;if(typeof ol_snapx=='undefined')var ol_snapx=0;if(typeof ol_snapy=='undefined')var ol_snapy=0;if(typeof ol_fixx=='undefined')var ol_fixx=-1;if(typeof ol_fixy=='undefined')var ol_fixy=-1;if(typeof ol_relx=='undefined')var ol_relx=null;if(typeof ol_rely=='undefined')var ol_rely=null;if(typeof ol_fgbackground=='undefined')var ol_fgbackground="";if(typeof ol_bgbackground=='undefined')var ol_bgbackground="";if(typeof ol_padxl=='undefined')var ol_padxl=1;if(typeof ol_padxr=='undefined')var ol_padxr=1;if(typeof ol_padyt=='undefined')var ol_padyt=1;if(typeof ol_padyb=='undefined')var ol_padyb=1;if(typeof ol_fullhtml=='undefined')var ol_fullhtml=0;if(typeof ol_vpos=='undefined')var ol_vpos=BELOW;if(typeof ol_aboveheight=='undefined')var ol_aboveheight=0;if(typeof ol_capicon=='undefined')var ol_capicon="";if(typeof ol_frame=='undefined')var ol_frame=self;if(typeof ol_timeout=='undefined')var ol_timeout=0;if(typeof ol_function=='undefined')var ol_function=null;if(typeof ol_delay=='undefined')var ol_delay=0;if(typeof ol_hauto=='undefined')var ol_hauto=0;if(typeof ol_vauto=='undefined')var ol_vauto=0;if(typeof ol_closeclick=='undefined')var ol_closeclick=0;if(typeof ol_wrap=='undefined')var ol_wrap=0;if(typeof ol_followmouse=='undefined')var ol_followmouse=1;if(typeof ol_mouseoff=='undefined')var ol_mouseoff=0;if(typeof ol_closetitle=='undefined')var ol_closetitle='Close';if(typeof ol_compatmode=='undefined')var ol_compatmode=0;if(typeof ol_css=='undefined')var ol_css=CSSOFF;if(typeof ol_fgclass=='undefined')var ol_fgclass="";if(typeof ol_bgclass=='undefined')var ol_bgclass="";if(typeof ol_textfontclass=='undefined')var ol_textfontclass="";if(typeof ol_captionfontclass=='undefined')var ol_captionfontclass="";if(typeof ol_closefontclass=='undefined')var ol_closefontclass="";
if(typeof ol_texts=='undefined')var ol_texts=new Array("Text 0","Text 1");if(typeof ol_caps=='undefined')var ol_caps=new Array("Caption 0","Caption 1");
var o3_text="",o3_cap="",o3_sticky=0,o3_background="",o3_close="Close",o3_hpos=RIGHT,o3_offsetx=2,o3_offsety=2,o3_fgcolor="",o3_bgcolor="",o3_textcolor="",o3_capcolor="",o3_closecolor="",o3_width=100,o3_border=1,o3_cellpad=2,o3_status="",o3_autostatus=0,o3_height=-1,o3_snapx=0,o3_snapy=0,o3_fixx=-1,o3_fixy=-1,o3_relx=null,o3_rely=null,o3_fgbackground="",o3_bgbackground="",o3_padxl=0,o3_padxr=0,o3_padyt=0,o3_padyb=0,o3_fullhtml=0,o3_vpos=BELOW,o3_aboveheight=0,o3_capicon="",o3_textfont="Verdana,Arial,Helvetica",o3_captionfont="Verdana,Arial,Helvetica",o3_closefont="Verdana,Arial,Helvetica",o3_textsize="1",o3_captionsize="1",o3_closesize="1",o3_frame=self,o3_timeout=0,o3_timerid=0,o3_allowmove=0,o3_function=null,o3_delay=0,o3_delayid=0,o3_hauto=0,o3_vauto=0,o3_closeclick=0,o3_wrap=0,o3_followmouse=1,o3_mouseoff=0,o3_closetitle='',o3_compatmode=0,o3_css=CSSOFF,o3_fgclass="",o3_bgclass="",o3_textfontclass="",o3_captionfontclass="",o3_closefontclass="";
var o3_x=0,o3_y=0,o3_showingsticky=0,o3_removecounter=0;
var over=null,fnRef,hoveringSwitch=false,olHideDelay;
var isMac=(navigator.userAgent.indexOf("Mac")!=-1),olOp=(navigator.userAgent.toLowerCase().indexOf('opera')>-1&&document.createTextNode),olNs4=(navigator.appName=='Netscape'&&parseInt(navigator.appVersion)==4),olNs6=(document.getElementById)?true:false,olKq=(olNs6&&/konqueror/i.test(navigator.userAgent)),olIe4=(document.all)?true:false,olIe5=false,olIe55=false,docRoot='document.body';
if(olNs4){var oW=window.innerWidth;var oH=window.innerHeight;window.onresize=function(){if(oW!=window.innerWidth||oH!=window.innerHeight)location.reload();}}
if(olIe4){var agent=navigator.userAgent;if(/MSIE/.test(agent)){var versNum=parseFloat(agent.match(/MSIE[ ](\d\.\d+)\.*/i)[1]);if(versNum>=5){olIe5=true;olIe55=(versNum>=5.5&&!olOp)?true:false;if(olNs6)olNs6=false;}}
if(olNs6)olIe4=false;}
if(document.compatMode&&document.compatMode=='CSS1Compat'){docRoot=((olIe4&&!olOp)?'document.documentElement':docRoot);}
if(window.addEventListener)window.addEventListener("load",OLonLoad_handler,false);else if(window.attachEvent)window.attachEvent("onload",OLonLoad_handler);
var capExtent;
function overlib(){if(!olLoaded||isExclusive(overlib.arguments))return true;if(olCheckMouseCapture)olMouseCapture();if(over){over=(typeof over.id!='string')?o3_frame.document.all['overDiv']:over;cClick();}
olHideDelay=0;o3_text=ol_text;o3_cap=ol_cap;o3_sticky=ol_sticky;o3_background=ol_background;o3_close=ol_close;o3_hpos=ol_hpos;o3_offsetx=ol_offsetx;o3_offsety=ol_offsety;o3_fgcolor=ol_fgcolor;o3_bgcolor=ol_bgcolor;o3_textcolor=ol_textcolor;o3_capcolor=ol_capcolor;o3_closecolor=ol_closecolor;o3_width=ol_width;o3_border=ol_border;o3_cellpad=ol_cellpad;o3_status=ol_status;o3_autostatus=ol_autostatus;o3_height=ol_height;o3_snapx=ol_snapx;o3_snapy=ol_snapy;o3_fixx=ol_fixx;o3_fixy=ol_fixy;o3_relx=ol_relx;o3_rely=ol_rely;o3_fgbackground=ol_fgbackground;o3_bgbackground=ol_bgbackground;o3_padxl=ol_padxl;o3_padxr=ol_padxr;o3_padyt=ol_padyt;o3_padyb=ol_padyb;o3_fullhtml=ol_fullhtml;o3_vpos=ol_vpos;o3_aboveheight=ol_aboveheight;o3_capicon=ol_capicon;o3_textfont=ol_textfont;o3_captionfont=ol_captionfont;o3_closefont=ol_closefont;o3_textsize=ol_textsize;o3_captionsize=ol_captionsize;o3_closesize=ol_closesize;o3_timeout=ol_timeout;o3_function=ol_function;o3_delay=ol_delay;o3_hauto=ol_hauto;o3_vauto=ol_vauto;o3_closeclick=ol_closeclick;o3_wrap=ol_wrap;o3_followmouse=ol_followmouse;o3_mouseoff=ol_mouseoff;o3_closetitle=ol_closetitle;o3_css=ol_css;o3_compatmode=ol_compatmode;o3_fgclass=ol_fgclass;o3_bgclass=ol_bgclass;o3_textfontclass=ol_textfontclass;o3_captionfontclass=ol_captionfontclass;o3_closefontclass=ol_closefontclass;
setRunTimeVariables();
fnRef='';
o3_frame=ol_frame;
if(!(over=createDivContainer()))return false;
parseTokens('o3_',overlib.arguments);if(!postParseChecks())return false;
if(o3_delay==0){return runHook("olMain",FREPLACE);}else{o3_delayid=setTimeout("runHook('olMain',FREPLACE)",o3_delay);return false;}}
function nd(time){if(olLoaded&&!isExclusive()){hideDelay(time);
if(o3_removecounter>=1){o3_showingsticky=0 };
if(o3_showingsticky==0){o3_allowmove=0;if(over!=null&&o3_timerid==0)runHook("hideObject",FREPLACE,over);}else{o3_removecounter++;}}
return true;}
function cClick(){if(olLoaded){runHook("hideObject",FREPLACE,over);o3_showingsticky=0;}
return false;}
function overlib_pagedefaults(){parseTokens('ol_',overlib_pagedefaults.arguments);}
function olMain(){var layerhtml,styleType;runHook("olMain",FBEFORE);
if(o3_background!=""||o3_fullhtml){
layerhtml=runHook('ol_content_background',FALTERNATE,o3_css,o3_text,o3_background,o3_fullhtml);}else{
styleType=(pms[o3_css-1-pmStart]=="cssoff"||pms[o3_css-1-pmStart]=="cssclass");
if(o3_fgbackground!="")o3_fgbackground="background=\""+o3_fgbackground+"\"";if(o3_bgbackground!="")o3_bgbackground=(styleType?"background=\""+o3_bgbackground+"\"":o3_bgbackground);
if(o3_fgcolor!="")o3_fgcolor=(styleType?"bgcolor=\""+o3_fgcolor+"\"":o3_fgcolor);if(o3_bgcolor!="")o3_bgcolor=(styleType?"bgcolor=\""+o3_bgcolor+"\"":o3_bgcolor);
if(o3_height>0)o3_height=(styleType?"height=\""+o3_height+"\"":o3_height);else o3_height="";
if(o3_cap==""){
layerhtml=runHook('ol_content_simple',FALTERNATE,o3_css,o3_text);}else{
if(o3_sticky){
layerhtml=runHook('ol_content_caption',FALTERNATE,o3_css,o3_text,o3_cap,o3_close);}else{
layerhtml=runHook('ol_content_caption',FALTERNATE,o3_css,o3_text,o3_cap,"");}}}
if(o3_sticky){if(o3_timerid>0){clearTimeout(o3_timerid);o3_timerid=0;}
o3_showingsticky=1;o3_removecounter=0;}
if(!runHook("createPopup",FREPLACE,layerhtml))return false;
if(o3_autostatus>0){o3_status=o3_text;if(o3_autostatus>1)o3_status=o3_cap;}
o3_allowmove=0;
if(o3_timeout>0){if(o3_timerid>0)clearTimeout(o3_timerid);o3_timerid=setTimeout("cClick()",o3_timeout);}
runHook("disp",FREPLACE,o3_status);runHook("olMain",FAFTER);
return(olOp&&event&&event.type=='mouseover'&&!o3_status)?'':(o3_status!='');}
function ol_content_simple(text){var cpIsMultiple=/,/.test(o3_cellpad);var txt='<table width="'+o3_width+'" border="0" cellpadding="'+o3_border+'" cellspacing="0" '+(o3_bgclass?'class="'+o3_bgclass+'"':o3_bgcolor+' '+o3_height)+'><tr><td><table width="100%" border="0" '+((olNs4||!cpIsMultiple)?'cellpadding="'+o3_cellpad+'" ':'')+'cellspacing="0" '+(o3_fgclass?'class="'+o3_fgclass+'"':o3_fgcolor+' '+o3_fgbackground+' '+o3_height)+'><tr><td valign="TOP"'+(o3_textfontclass?' class="'+o3_textfontclass+'">':((!olNs4&&cpIsMultiple)?' style="'+setCellPadStr(o3_cellpad)+'">':'>'))+(o3_textfontclass?'':wrapStr(0,o3_textsize,'text'))+text+(o3_textfontclass?'':wrapStr(1,o3_textsize))+'</td></tr></table></td></tr></table>';
set_background("");return txt;}
function ol_content_caption(text,title,close){var nameId,txt,cpIsMultiple=/,/.test(o3_cellpad);var closing,closeevent;
closing="";closeevent="onmouseover";if(o3_closeclick==1)closeevent=(o3_closetitle?"title='"+o3_closetitle+"'":"")+" onclick";if(o3_capicon!=""){nameId=' hspace=\"5\"'+' align=\"middle\" alt=\"\"';if(typeof o3_dragimg!='undefined'&&o3_dragimg)nameId=' hspace=\"5\"'+' name=\"'+o3_dragimg+'\" id=\"'+o3_dragimg+'\" align=\"middle\" alt=\"Drag Enabled\" title=\"Drag Enabled\"';o3_capicon='<img src=\"'+o3_capicon+'\"'+nameId+' />';}
if(close!="")
closing='<td '+(!o3_compatmode&&o3_closefontclass?'class="'+o3_closefontclass:'align="RIGHT')+'"><a href="javascript:return '+fnRef+'cClick();"'+((o3_compatmode&&o3_closefontclass)?' class="'+o3_closefontclass+'" ':' ')+closeevent+'="return '+fnRef+'cClick();">'+(o3_closefontclass?'':wrapStr(0,o3_closesize,'close'))+close+(o3_closefontclass?'':wrapStr(1,o3_closesize,'close'))+'</a></td>';txt='<table width="'+o3_width+'" border="0" cellpadding="'+o3_border+'" cellspacing="0" '+(o3_bgclass?'class="'+o3_bgclass+'"':o3_bgcolor+' '+o3_bgbackground+' '+o3_height)+'><tr><td><table width="100%" border="0" cellpadding="2" cellspacing="0"><tr><td'+(o3_captionfontclass?' class="'+o3_captionfontclass+'">':'>')+(o3_captionfontclass?'':'<b>'+wrapStr(0,o3_captionsize,'caption'))+o3_capicon+title+(o3_captionfontclass?'':wrapStr(1,o3_captionsize)+'</b>')+'</td>'+closing+'</tr></table><table width="100%" border="0" '+((olNs4||!cpIsMultiple)?'cellpadding="'+o3_cellpad+'" ':'')+'cellspacing="0" '+(o3_fgclass?'class="'+o3_fgclass+'"':o3_fgcolor+' '+o3_fgbackground+' '+o3_height)+'><tr><td valign="TOP"'+(o3_textfontclass?' class="'+o3_textfontclass+'">' :((!olNs4&&cpIsMultiple)?' style="'+setCellPadStr(o3_cellpad)+'">':'>'))+(o3_textfontclass?'':wrapStr(0,o3_textsize,'text'))+text+(o3_textfontclass?'':wrapStr(1,o3_textsize))+'</td></tr></table></td></tr></table>';
set_background("");return txt;}
function ol_content_background(text,picture,hasfullhtml){if(hasfullhtml){txt=text;}else{txt='<table width="'+o3_width+'" border="0" cellpadding="0" cellspacing="0" height="'+o3_height+'"><tr><td colspan="3" height="'+o3_padyt+'"></td></tr><tr><td width="'+o3_padxl+'"></td><td valign="TOP" width="'+(o3_width-o3_padxl-o3_padxr)+(o3_textfontclass?'" class="'+o3_textfontclass:'')+'">'+(o3_textfontclass?'':wrapStr(0,o3_textsize,'text'))+text+(o3_textfontclass?'':wrapStr(1,o3_textsize))+'</td><td width="'+o3_padxr+'"></td></tr><tr><td colspan="3" height="'+o3_padyb+'"></td></tr></table>';}
set_background(picture);return txt;}
function set_background(pic){if(pic==""){if(olNs4){over.background.src=null;}else if(over.style){over.style.backgroundImage="none";}
}else{if(olNs4){over.background.src=pic;}else if(over.style){over.style.width=o3_width+'px';over.style.backgroundImage="url("+pic+")";}}}
var olShowId=-1;
function disp(statustext){runHook("disp",FBEFORE);
if(o3_allowmove==0){runHook("placeLayer",FREPLACE);(olNs6&&olShowId<0)?olShowId=setTimeout("runHook('showObject',FREPLACE,over)",1):runHook("showObject",FREPLACE,over);o3_allowmove=(o3_sticky||o3_followmouse==0)?0:1;}
runHook("disp",FAFTER);
if(statustext!="")self.status=statustext;}
function createPopup(lyrContent){runHook("createPopup",FBEFORE);
if(o3_wrap){var wd,ww,theObj=(olNs4?over:over.style);theObj.top=theObj.left=((olIe4&&!olOp)?0:-10000)+(!olNs4?'px':0);layerWrite(lyrContent);wd=(olNs4?over.clip.width:over.offsetWidth);if(wd>(ww=windowWidth())){lyrContent=lyrContent.replace(/\&nbsp;/g,' ');o3_width=ww;o3_wrap=0;}}
layerWrite(lyrContent);
if(o3_wrap)o3_width=(olNs4?over.clip.width:over.offsetWidth);
runHook("createPopup",FAFTER,lyrContent);
return true;}
function placeLayer(){var placeX,placeY,widthFix=0;
if(o3_frame.innerWidth)widthFix=18;iwidth=windowWidth();
winoffset=(olIe4)?eval('o3_frame.'+docRoot+'.scrollLeft'):o3_frame.pageXOffset;
placeX=runHook('horizontalPlacement',FCHAIN,iwidth,winoffset,widthFix);
if(o3_frame.innerHeight){iheight=o3_frame.innerHeight;}else if(eval('o3_frame.'+docRoot)&&eval("typeof o3_frame."+docRoot+".clientHeight=='number'")&&eval('o3_frame.'+docRoot+'.clientHeight')){iheight=eval('o3_frame.'+docRoot+'.clientHeight');}
scrolloffset=(olIe4)?eval('o3_frame.'+docRoot+'.scrollTop'):o3_frame.pageYOffset;placeY=runHook('verticalPlacement',FCHAIN,iheight,scrolloffset);
repositionTo(over,placeX,placeY);}
function olMouseMove(e){var e=(e)?e:event;
if(e.pageX){o3_x=e.pageX;o3_y=e.pageY;}else if(e.clientX){o3_x=eval('e.clientX+o3_frame.'+docRoot+'.scrollLeft');o3_y=eval('e.clientY+o3_frame.'+docRoot+'.scrollTop');}
if(o3_allowmove==1)runHook("placeLayer",FREPLACE);
if(hoveringSwitch&&!olNs4&&runHook("cursorOff",FREPLACE)){(olHideDelay?hideDelay(olHideDelay):cClick());hoveringSwitch=!hoveringSwitch;}}
function no_overlib(){return ver3fix;}
function olMouseCapture(){capExtent=document;var fN,str='',l,k,f,wMv,sS,mseHandler=olMouseMove;var re=/function[ ]*(\w*)\(/;
wMv=(!olIe4&&window.onmousemove);if(document.onmousemove||wMv){if(wMv)capExtent=window;f=capExtent.onmousemove.toString();fN=f.match(re);if(fN==null){str=f+'(e);';}else if(fN[1]=='anonymous'||fN[1]=='olMouseMove'||(wMv&&fN[1]=='onmousemove')){if(!olOp&&wMv){l=f.indexOf('{')+1;k=f.lastIndexOf('}');sS=f.substring(l,k);if((l=sS.indexOf('('))!=-1){sS=sS.substring(0,l).replace(/^\s+/,'').replace(/\s+$/,'');if(eval("typeof "+sS+"=='undefined'"))window.onmousemove=null;else str=sS+'(e);';}}
if(!str){olCheckMouseCapture=false;return;}
}else{if(fN[1])str=fN[1]+'(e);';else{l=f.indexOf('{')+1;k=f.lastIndexOf('}');str=f.substring(l,k)+'\n';}}
str+='olMouseMove(e);';mseHandler=new Function('e',str);}
capExtent.onmousemove=mseHandler;if(olNs4)capExtent.captureEvents(Event.MOUSEMOVE);}
function parseTokens(pf,ar){
var v,i,mode=-1,par=(pf!='ol_'),fnMark=(par&&!ar.length?1:0);
for(i=0;i<ar.length;i++){if(mode<0){
if(typeof ar[i]=='number'&&ar[i]>pmStart&&ar[i]<pmUpper){fnMark=(par?1:0);i--;}else{switch(pf){case 'ol_':
ol_text=ar[i].toString();break;default:
o3_text=ar[i].toString();}}
mode=0;}else{
if(ar[i]>=pmCount||ar[i]==DONOTHING){continue;}
if(ar[i]==INARRAY){fnMark=0;eval(pf+'text=ol_texts['+ar[++i]+'].toString()');continue;}
if(ar[i]==CAPARRAY){eval(pf+'cap=ol_caps['+ar[++i]+'].toString()');continue;}
if(ar[i]==STICKY){if(pf!='ol_')eval(pf+'sticky=1');continue;}
if(ar[i]==BACKGROUND){eval(pf+'background="'+ar[++i]+'"');continue;}
if(ar[i]==NOCLOSE){if(pf!='ol_')opt_NOCLOSE();continue;}
if(ar[i]==CAPTION){eval(pf+"cap='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==CENTER||ar[i]==LEFT||ar[i]==RIGHT){eval(pf+'hpos='+ar[i]);if(pf!='ol_')olHautoFlag=1;continue;}
if(ar[i]==OFFSETX){eval(pf+'offsetx='+ar[++i]);continue;}
if(ar[i]==OFFSETY){eval(pf+'offsety='+ar[++i]);continue;}
if(ar[i]==FGCOLOR){eval(pf+'fgcolor="'+ar[++i]+'"');continue;}
if(ar[i]==BGCOLOR){eval(pf+'bgcolor="'+ar[++i]+'"');continue;}
if(ar[i]==TEXTCOLOR){eval(pf+'textcolor="'+ar[++i]+'"');continue;}
if(ar[i]==CAPCOLOR){eval(pf+'capcolor="'+ar[++i]+'"');continue;}
if(ar[i]==CLOSECOLOR){eval(pf+'closecolor="'+ar[++i]+'"');continue;}
if(ar[i]==WIDTH){eval(pf+'width='+ar[++i]);continue;}
if(ar[i]==BORDER){eval(pf+'border='+ar[++i]);continue;}
if(ar[i]==CELLPAD){i=opt_MULTIPLEARGS(++i,ar,(pf+'cellpad'));continue;}
if(ar[i]==STATUS){eval(pf+"status='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==AUTOSTATUS){eval(pf+'autostatus=('+pf+'autostatus==1)?0:1');continue;}
if(ar[i]==AUTOSTATUSCAP){eval(pf+'autostatus=('+pf+'autostatus==2)?0:2');continue;}
if(ar[i]==HEIGHT){eval(pf+'height='+pf+'aboveheight='+ar[++i]);continue;}
if(ar[i]==CLOSETEXT){eval(pf+"close='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==SNAPX){eval(pf+'snapx='+ar[++i]);continue;}
if(ar[i]==SNAPY){eval(pf+'snapy='+ar[++i]);continue;}
if(ar[i]==FIXX){eval(pf+'fixx='+ar[++i]);continue;}
if(ar[i]==FIXY){eval(pf+'fixy='+ar[++i]);continue;}
if(ar[i]==RELX){eval(pf+'relx='+ar[++i]);continue;}
if(ar[i]==RELY){eval(pf+'rely='+ar[++i]);continue;}
if(ar[i]==FGBACKGROUND){eval(pf+'fgbackground="'+ar[++i]+'"');continue;}
if(ar[i]==BGBACKGROUND){eval(pf+'bgbackground="'+ar[++i]+'"');continue;}
if(ar[i]==PADX){eval(pf+'padxl='+ar[++i]);eval(pf+'padxr='+ar[++i]);continue;}
if(ar[i]==PADY){eval(pf+'padyt='+ar[++i]);eval(pf+'padyb='+ar[++i]);continue;}
if(ar[i]==FULLHTML){if(pf!='ol_')eval(pf+'fullhtml=1');continue;}
if(ar[i]==BELOW||ar[i]==ABOVE){eval(pf+'vpos='+ar[i]);if(pf!='ol_')olVautoFlag=1;continue;}
if(ar[i]==CAPICON){eval(pf+'capicon="'+ar[++i]+'"');continue;}
if(ar[i]==TEXTFONT){eval(pf+"textfont='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==CAPTIONFONT){eval(pf+"captionfont='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==CLOSEFONT){eval(pf+"closefont='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==TEXTSIZE){eval(pf+'textsize="'+ar[++i]+'"');continue;}
if(ar[i]==CAPTIONSIZE){eval(pf+'captionsize="'+ar[++i]+'"');continue;}
if(ar[i]==CLOSESIZE){eval(pf+'closesize="'+ar[++i]+'"');continue;}
if(ar[i]==TIMEOUT){eval(pf+'timeout='+ar[++i]);continue;}
if(ar[i]==FUNCTION){if(pf=='ol_'){if(typeof ar[i+1]!='number'){v=ar[++i];ol_function=(typeof v=='function'?v:null);}}else{fnMark=0;v=null;if(typeof ar[i+1]!='number')v=ar[++i]; opt_FUNCTION(v);} continue;}
if(ar[i]==DELAY){eval(pf+'delay='+ar[++i]);continue;}
if(ar[i]==HAUTO){eval(pf+'hauto=('+pf+'hauto==0)?1:0');continue;}
if(ar[i]==VAUTO){eval(pf+'vauto=('+pf+'vauto==0)?1:0');continue;}
if(ar[i]==CLOSECLICK){eval(pf+'closeclick=('+pf+'closeclick==0)?1:0');continue;}
if(ar[i]==WRAP){eval(pf+'wrap=('+pf+'wrap==0)?1:0');continue;}
if(ar[i]==FOLLOWMOUSE){eval(pf+'followmouse=('+pf+'followmouse==1)?0:1');continue;}
if(ar[i]==MOUSEOFF){eval(pf+'mouseoff=('+pf+'mouseoff==0)?1:0');v=ar[i+1];if(pf!='ol_'&&eval(pf+'mouseoff')&&typeof v=='number'&&(v<pmStart||v>pmUpper))olHideDelay=ar[++i];continue;}
if(ar[i]==CLOSETITLE){eval(pf+"closetitle='"+escSglQuote(ar[++i])+"'");continue;}
if(ar[i]==CSSOFF||ar[i]==CSSCLASS){eval(pf+'css='+ar[i]);continue;}
if(ar[i]==COMPATMODE){eval(pf+'compatmode=('+pf+'compatmode==0)?1:0');continue;}
if(ar[i]==FGCLASS){eval(pf+'fgclass="'+ar[++i]+'"');continue;}
if(ar[i]==BGCLASS){eval(pf+'bgclass="'+ar[++i]+'"');continue;}
if(ar[i]==TEXTFONTCLASS){eval(pf+'textfontclass="'+ar[++i]+'"');continue;}
if(ar[i]==CAPTIONFONTCLASS){eval(pf+'captionfontclass="'+ar[++i]+'"');continue;}
if(ar[i]==CLOSEFONTCLASS){eval(pf+'closefontclass="'+ar[++i]+'"');continue;}
i=parseCmdLine(pf,i,ar);}}
if(fnMark&&o3_function)o3_text=o3_function();
if((pf=='o3_')&&o3_wrap){o3_width=0;
var tReg=/<.*\n*>/ig;if(!tReg.test(o3_text))o3_text=o3_text.replace(/[ ]+/g,'&nbsp;');if(!tReg.test(o3_cap))o3_cap=o3_cap.replace(/[ ]+/g,'&nbsp;');}
if((pf=='o3_')&&o3_sticky){if(!o3_close&&(o3_frame!=ol_frame))o3_close=ol_close;if(o3_mouseoff&&(o3_frame==ol_frame))opt_NOCLOSE(' ');}}
function layerWrite(txt){txt+="\n";if(olNs4){var lyr=o3_frame.document.layers['overDiv'].document
lyr.write(txt)
lyr.close()
}else if(typeof over.innerHTML!='undefined'){if(olIe5&&isMac)over.innerHTML='';over.innerHTML=txt;}else{range=o3_frame.document.createRange();range.setStartAfter(over);domfrag=range.createContextualFragment(txt);
while(over.hasChildNodes()){over.removeChild(over.lastChild);}
over.appendChild(domfrag);}}
function showObject(obj){runHook("showObject",FBEFORE);
var theObj=(olNs4?obj:obj.style);theObj.visibility='visible';
runHook("showObject",FAFTER);}
function hideObject(obj){runHook("hideObject",FBEFORE);
var theObj=(olNs4?obj:obj.style);if(olNs6&&olShowId>0){clearTimeout(olShowId);olShowId=0;}
theObj.visibility='hidden';theObj.top=theObj.left=((olIe4&&!olOp)?0:-10000)+(!olNs4?'px':0);
if(o3_timerid>0)clearTimeout(o3_timerid);if(o3_delayid>0)clearTimeout(o3_delayid);
o3_timerid=0;o3_delayid=0;self.status="";
if(obj.onmouseout||obj.onmouseover){if(olNs4)obj.releaseEvents(Event.MOUSEOUT||Event.MOUSEOVER);obj.onmouseout=obj.onmouseover=null;}
runHook("hideObject",FAFTER);}
function repositionTo(obj,xL,yL){var theObj=(olNs4?obj:obj.style);theObj.left=xL+(!olNs4?'px':0);theObj.top=yL+(!olNs4?'px':0);}
function cursorOff(){var left=parseInt(over.style.left);var top=parseInt(over.style.top);var right=left+(over.offsetWidth>=parseInt(o3_width)?over.offsetWidth:parseInt(o3_width));var bottom=top+(over.offsetHeight>=o3_aboveheight?over.offsetHeight:o3_aboveheight);
if(o3_x<left||o3_x>right||o3_y<top||o3_y>bottom)return true;
return false;}
function opt_FUNCTION(callme){o3_text=(callme?(typeof callme=='string'?(/.+\(.*\)/.test(callme)?eval(callme):callme):callme()):(o3_function?o3_function():'No Function'));
return 0;}
function opt_NOCLOSE(unused){if(!unused)o3_close="";
if(olNs4){over.captureEvents(Event.MOUSEOUT||Event.MOUSEOVER);over.onmouseover=function(){if(o3_timerid>0){clearTimeout(o3_timerid);o3_timerid=0;} }
over.onmouseout=function(e){if(olHideDelay)hideDelay(olHideDelay);else cClick(e);}
}else{over.onmouseover=function(){hoveringSwitch=true;if(o3_timerid>0){clearTimeout(o3_timerid);o3_timerid=0;} }}
return 0;}
function opt_MULTIPLEARGS(i,args,parameter){var k=i,re,pV,str='';
for(k=i;k<args.length;k++){if(typeof args[k]=='number'&&args[k]>pmStart)break;str+=args[k]+',';}
if(str)str=str.substring(0,--str.length);
k--;pV=(olNs4&&/cellpad/i.test(parameter))?str.split(',')[0]:str;eval(parameter+'="'+pV+'"');
return k;}
function nbspCleanup(){if(o3_wrap){o3_text=o3_text.replace(/\&nbsp;/g,' ');o3_cap=o3_cap.replace(/\&nbsp;/g,' ');}}
function escSglQuote(str){return str.toString().replace(/'/g,"\\'");}
function OLonLoad_handler(e){var re=/\w+\(.*\)[;\s]+/g,olre=/overlib\(|nd\(|cClick\(/,fn,l,i;
if(!olLoaded)olLoaded=1;
if(window.removeEventListener&&e.eventPhase==3)window.removeEventListener("load",OLonLoad_handler,false);else if(window.detachEvent){window.detachEvent("onload",OLonLoad_handler);var fN=document.body.getAttribute('onload');if(fN){fN=fN.toString().match(re);if(fN&&fN.length){for(i=0;i<fN.length;i++){if(/anonymous/.test(fN[i]))continue;while((l=fN[i].search(/\)[;\s]+/))!=-1){fn=fN[i].substring(0,l+1);fN[i]=fN[i].substring(l+2);if(olre.test(fn))eval(fn);}}}}}}
function wrapStr(endWrap,fontSizeStr,whichString){var fontStr,fontColor,isClose=((whichString=='close')?1:0),hasDims=/[%\-a-z]+$/.test(fontSizeStr);fontSizeStr=(olNs4)?(!hasDims?fontSizeStr:'1'):fontSizeStr;if(endWrap)return(hasDims&&!olNs4)?(isClose?'</span>':'</div>'):'</font>';else{fontStr='o3_'+whichString+'font';fontColor='o3_'+((whichString=='caption')? 'cap':whichString)+'color';return(hasDims&&!olNs4)?(isClose?'<span style="font-family: '+quoteMultiNameFonts(eval(fontStr))+';color: '+eval(fontColor)+';font-size: '+fontSizeStr+';">':'<div style="font-family: '+quoteMultiNameFonts(eval(fontStr))+';color: '+eval(fontColor)+';font-size: '+fontSizeStr+';">'):'<font face="'+eval(fontStr)+'" color="'+eval(fontColor)+'" size="'+(parseInt(fontSizeStr)>7?'7':fontSizeStr)+'">';}}
function quoteMultiNameFonts(theFont){var v,pM=theFont.split(',');for(var i=0;i<pM.length;i++){v=pM[i];v=v.replace(/^\s+/,'').replace(/\s+$/,'');if(/\s/.test(v)&&!/['"]/.test(v)){v="\'"+v+"\'";pM[i]=v;}}
return pM.join();}
function isExclusive(args){return false;}
function setCellPadStr(parameter){var Str='',j=0,ary=new Array(),top,bottom,left,right;
Str+='padding: ';ary=parameter.replace(/\s+/g,'').split(',');
switch(ary.length){case 2:
top=bottom=ary[j];left=right=ary[++j];break;case 3:
top=ary[j];left=right=ary[++j];bottom=ary[++j];break;case 4:
top=ary[j];right=ary[++j];bottom=ary[++j];left=ary[++j];break;}
Str+=((ary.length==1)?ary[0]+'px;':top+'px '+right+'px '+bottom+'px '+left+'px;');
return Str;}
function hideDelay(time){if(time&&!o3_delay){if(o3_timerid>0)clearTimeout(o3_timerid);
o3_timerid=setTimeout("cClick()",(o3_timeout=time));}}
function horizontalPlacement(browserWidth,horizontalScrollAmount,widthFix){var placeX,iwidth=browserWidth,winoffset=horizontalScrollAmount;var parsedWidth=parseInt(o3_width);
if(o3_fixx>-1||o3_relx!=null){
placeX=(o3_relx!=null?( o3_relx<0?winoffset+o3_relx+iwidth-parsedWidth-widthFix:winoffset+o3_relx):o3_fixx);}else{
if(o3_hauto==1){if((o3_x-winoffset)>(iwidth/2)){o3_hpos=LEFT;}else{o3_hpos=RIGHT;}}
if(o3_hpos==CENTER){placeX=o3_x+o3_offsetx-(parsedWidth/2);
if(placeX<winoffset)placeX=winoffset;}
if(o3_hpos==RIGHT){placeX=o3_x+o3_offsetx;
if((placeX+parsedWidth)>(winoffset+iwidth-widthFix)){placeX=iwidth+winoffset-parsedWidth-widthFix;if(placeX<0)placeX=0;}}
if(o3_hpos==LEFT){placeX=o3_x-o3_offsetx-parsedWidth;if(placeX<winoffset)placeX=winoffset;}
if(o3_snapx>1){var snapping=placeX % o3_snapx;
if(o3_hpos==LEFT){placeX=placeX-(o3_snapx+snapping);}else{
placeX=placeX+(o3_snapx-snapping);}
if(placeX<winoffset)placeX=winoffset;}}
return placeX;}
function verticalPlacement(browserHeight,verticalScrollAmount){var placeY,iheight=browserHeight,scrolloffset=verticalScrollAmount;var parsedHeight=(o3_aboveheight?parseInt(o3_aboveheight):(olNs4?over.clip.height:over.offsetHeight));
if(o3_fixy>-1||o3_rely!=null){
placeY=(o3_rely!=null?(o3_rely<0?scrolloffset+o3_rely+iheight-parsedHeight:scrolloffset+o3_rely):o3_fixy);}else{
if(o3_vauto==1){if((o3_y-scrolloffset)>(iheight/2)&&o3_vpos==BELOW&&(o3_y+parsedHeight+o3_offsety-(scrolloffset+iheight)>0)){o3_vpos=ABOVE;}else if(o3_vpos==ABOVE&&(o3_y-(parsedHeight+o3_offsety)-scrolloffset<0)){o3_vpos=BELOW;}}
if(o3_vpos==ABOVE){if(o3_aboveheight==0)o3_aboveheight=parsedHeight;
placeY=o3_y-(o3_aboveheight+o3_offsety);if(placeY<scrolloffset)placeY=scrolloffset;}else{
placeY=o3_y+o3_offsety;}
if(o3_snapy>1){var snapping=placeY % o3_snapy;
if(o3_aboveheight>0&&o3_vpos==ABOVE){placeY=placeY-(o3_snapy+snapping);}else{placeY=placeY+(o3_snapy-snapping);}
if(placeY<scrolloffset)placeY=scrolloffset;}}
return placeY;}
function checkPositionFlags(){if(olHautoFlag)olHautoFlag=o3_hauto=0;if(olVautoFlag)olVautoFlag=o3_vauto=0;return true;}
function windowWidth(){var w;if(o3_frame.innerWidth)w=o3_frame.innerWidth;else if(eval('o3_frame.'+docRoot)&&eval("typeof o3_frame."+docRoot+".clientWidth=='number'")&&eval('o3_frame.'+docRoot+'.clientWidth'))
w=eval('o3_frame.'+docRoot+'.clientWidth');return w;}
function createDivContainer(id,frm,zValue){id=(id||'overDiv'),frm=(frm||o3_frame),zValue=(zValue||1000);var objRef,divContainer=layerReference(id);
if(divContainer==null){if(olNs4){divContainer=frm.document.layers[id]=new Layer(window.innerWidth,frm);objRef=divContainer;}else{var body=(olIe4?frm.document.all.tags('BODY')[0]:frm.document.getElementsByTagName("BODY")[0]);if(olIe4&&!document.getElementById){body.insertAdjacentHTML("beforeEnd",'<div id="'+id+'"></div>');divContainer=layerReference(id);}else{divContainer=frm.document.createElement("DIV");divContainer.id=id;body.appendChild(divContainer);}
objRef=divContainer.style;}
objRef.position='absolute';objRef.visibility='hidden';objRef.zIndex=zValue;if(olIe4&&!olOp)objRef.left=objRef.top='0px';else objRef.left=objRef.top=-10000+(!olNs4?'px':0);}
return divContainer;}
function layerReference(id){return(olNs4?o3_frame.document.layers[id]:(document.all?o3_frame.document.all[id]:o3_frame.document.getElementById(id)));}
function isFunction(fnRef){var rtn=true;
if(typeof fnRef=='object'){for(var i=0;i<fnRef.length;i++){if(typeof fnRef[i]=='function')continue;rtn=false;break;}
}else if(typeof fnRef!='function'){rtn=false;}
return rtn;}
function argToString(array,strtInd,argName){var jS=strtInd,aS='',ar=array;argName=(argName?argName:'ar');
if(ar.length>jS){for(var k=jS;k<ar.length;k++)aS+=argName+'['+k+'], ';aS=aS.substring(0,aS.length-2);}
return aS;}
function reOrder(hookPt,fnRef,order){var newPt=new Array(),match,i,j;
if(!order||typeof order=='undefined'||typeof order=='number')return hookPt;
if(typeof order=='function'){if(typeof fnRef=='object'){newPt=newPt.concat(fnRef);}else{newPt[newPt.length++]=fnRef;}
for(i=0;i<hookPt.length;i++){match=false;if(typeof fnRef=='function'&&hookPt[i]==fnRef){continue;}else{for(j=0;j<fnRef.length;j++)if(hookPt[i]==fnRef[j]){match=true;break;}}
if(!match)newPt[newPt.length++]=hookPt[i];}
newPt[newPt.length++]=order;
}else if(typeof order=='object'){if(typeof fnRef=='object'){newPt=newPt.concat(fnRef);}else{newPt[newPt.length++]=fnRef;}
for(j=0;j<hookPt.length;j++){match=false;if(typeof fnRef=='function'&&hookPt[j]==fnRef){continue;}else{for(i=0;i<fnRef.length;i++)if(hookPt[j]==fnRef[i]){match=true;break;}}
if(!match)newPt[newPt.length++]=hookPt[j];}
for(i=0;i<newPt.length;i++)hookPt[i]=newPt[i];newPt.length=0;
for(j=0;j<hookPt.length;j++){match=false;for(i=0;i<order.length;i++){if(hookPt[j]==order[i]){match=true;break;}}
if(!match)newPt[newPt.length++]=hookPt[j];}
newPt=newPt.concat(order);}
hookPt=newPt;
return hookPt;}
function setRunTimeVariables(){if(typeof runTime!='undefined'&&runTime.length){for(var k=0;k<runTime.length;k++){runTime[k]();}}}
function parseCmdLine(pf,i,args){if(typeof cmdLine!='undefined'&&cmdLine.length){for(var k=0;k<cmdLine.length;k++){var j=cmdLine[k](pf,i,args);if(j >-1){i=j;break;}}}
return i;}
function postParseChecks(pf,args){if(typeof postParse!='undefined'&&postParse.length){for(var k=0;k<postParse.length;k++){if(postParse[k](pf,args))continue;return false;}}
return true;}
function registerCommands(cmdStr){if(typeof cmdStr!='string')return;
var pM=cmdStr.split(',');pms=pms.concat(pM);
for(var i=0;i< pM.length;i++){eval(pM[i].toUpperCase()+'='+pmCount++);}}
function registerNoParameterCommands(cmdStr){if(!cmdStr&&typeof cmdStr!='string')return;pmt=(!pmt)?cmdStr:pmt+','+cmdStr;}
function registerHook(fnHookTo,fnRef,hookType,optPm){var hookPt,last=typeof optPm;
if(fnHookTo=='plgIn'||fnHookTo=='postParse')return;if(typeof hookPts[fnHookTo]=='undefined')hookPts[fnHookTo]=new FunctionReference();
hookPt=hookPts[fnHookTo];
if(hookType!=null){if(hookType==FREPLACE){hookPt.ovload=fnRef;if(fnHookTo.indexOf('ol_content_')>-1)hookPt.alt[pms[CSSOFF-1-pmStart]]=fnRef;
}else if(hookType==FBEFORE||hookType==FAFTER){var hookPt=(hookType==1?hookPt.before:hookPt.after);
if(typeof fnRef=='object'){hookPt=hookPt.concat(fnRef);}else{hookPt[hookPt.length++]=fnRef;}
if(optPm)hookPt=reOrder(hookPt,fnRef,optPm);
}else if(hookType==FALTERNATE){if(last=='number')hookPt.alt[pms[optPm-1-pmStart]]=fnRef;}else if(hookType==FCHAIN){hookPt=hookPt.chain;if(typeof fnRef=='object')hookPt=hookPt.concat(fnRef);else hookPt[hookPt.length++]=fnRef;}
return;}}
function registerRunTimeFunction(fn){if(isFunction(fn)){if(typeof fn=='object'){runTime=runTime.concat(fn);}else{runTime[runTime.length++]=fn;}}}
function registerCmdLineFunction(fn){if(isFunction(fn)){if(typeof fn=='object'){cmdLine=cmdLine.concat(fn);}else{cmdLine[cmdLine.length++]=fn;}}}
function registerPostParseFunction(fn){if(isFunction(fn)){if(typeof fn=='object'){postParse=postParse.concat(fn);}else{postParse[postParse.length++]=fn;}}}
function runHook(fnHookTo,hookType){var l=hookPts[fnHookTo],k,rtnVal=null,optPm,arS,ar=runHook.arguments;
if(hookType==FREPLACE){arS=argToString(ar,2);
if(typeof l=='undefined'||!(l=l.ovload))rtnVal=eval(fnHookTo+'('+arS+')');else rtnVal=eval('l('+arS+')');
}else if(hookType==FBEFORE||hookType==FAFTER){if(typeof l!='undefined'){l=(hookType==1?l.before:l.after);
if(l.length){arS=argToString(ar,2);for(var k=0;k<l.length;k++)eval('l[k]('+arS+')');}}
}else if(hookType==FALTERNATE){optPm=ar[2];arS=argToString(ar,3);
if(typeof l=='undefined'||(l=l.alt[pms[optPm-1-pmStart]])=='undefined'){rtnVal=eval(fnHookTo+'('+arS+')');}else{rtnVal=eval('l('+arS+')');}
}else if(hookType==FCHAIN){arS=argToString(ar,2);l=l.chain;
for(k=l.length;k>0;k--)if((rtnVal=eval('l[k-1]('+arS+')'))!=void(0))break;}
return rtnVal;}
function FunctionReference(){this.ovload=null;this.before=new Array();this.after=new Array();this.alt=new Array();this.chain=new Array();}
function Info(version,prerelease){this.version=version;this.prerelease=prerelease;
this.simpleversion=Math.round(this.version*100);this.major=parseInt(this.simpleversion/100);this.minor=parseInt(this.simpleversion/10)-this.major * 10;this.revision=parseInt(this.simpleversion)-this.major * 100-this.minor * 10;this.meets=meets;}
function meets(reqdVersion){return(!reqdVersion)?false:this.simpleversion>=Math.round(100*parseFloat(reqdVersion));}
registerHook("ol_content_simple",ol_content_simple,FALTERNATE,CSSOFF);registerHook("ol_content_caption",ol_content_caption,FALTERNATE,CSSOFF);registerHook("ol_content_background",ol_content_background,FALTERNATE,CSSOFF);registerHook("ol_content_simple",ol_content_simple,FALTERNATE,CSSCLASS);registerHook("ol_content_caption",ol_content_caption,FALTERNATE,CSSCLASS);registerHook("ol_content_background",ol_content_background,FALTERNATE,CSSCLASS);registerPostParseFunction(checkPositionFlags);registerHook("hideObject",nbspCleanup,FAFTER);registerHook("horizontalPlacement",horizontalPlacement,FCHAIN);registerHook("verticalPlacement",verticalPlacement,FCHAIN);if(olNs4||(olIe5&&isMac)||olKq)olLoaded=1;registerNoParameterCommands('sticky,autostatus,autostatuscap,fullhtml,hauto,vauto,closeclick,wrap,followmouse,mouseoff,compatmode');
var olCheckMouseCapture=true;if((olNs4||olNs6||olIe4)){olMouseCapture();}else{overlib=no_overlib;nd=no_overlib;ver3fix=true;}
//\/////
//\  overLIB Hide Form Plugin
//\
//\  Uses an iframe shim to mask system controls for IE v5.5 or higher as suggested in
//\  http://dotnetjunkies.com/weblog/jking/posts/488.aspx
//\  This file requires overLIB 4.10 or later.
//\
//\  overLIB 4.05 - You may not remove or change this notice.
//\  Copyright Erik Bosrup 1998-2004. All rights reserved.
//\  Contributors are listed on the homepage.
//\  See http://www.bosrup.com/web/overlib/ for details.
//\/////
//\  THIS IS A VERY MODIFIED VERSION. DO NOT EDIT OR PUBLISH. GET THE ORIGINAL!
if(typeof olInfo=='undefined'||typeof olInfo.meets=='undefined'||!olInfo.meets(4.10))alert('overLIB 4.10 or later is required for the HideForm Plugin.');else{
function generatePopUp(content){if(!olIe4||olOp||!olIe55||(typeof o3_shadow!='undefined'&&o3_shadow)||(typeof o3_bubble!='undefined'&&o3_bubble))return;
var wd,ht,txt,zIdx=0;
wd=parseInt(o3_width);ht=over.offsetHeight;txt=backDropSource(wd,ht,zIdx++);txt+='<div style="position: absolute;top: 0;left: 0;width: '+wd+'px;z-index: '+zIdx+';">'+content+'</div>';layerWrite(txt);}
function backDropSource(width,height,Z){return '<iframe frameborder="0" scrolling="no" src="javascript:false;" width="'+width+'" height="'+height+'" style="z-index: '+Z+';filter: Beta(Style=0,Opacity=0);"></iframe>';}
function hideSelectBox(){if(olNs4||olOp||olIe55)return;var px,py,pw,ph,sx,sw,sy,sh,selEl,v;
if(olIe4)v=0;else{v=navigator.userAgent.match(/Gecko\/(\d{8})/i);if(!v)return;v=parseInt(v[1]);}
if(v<20030624){px=parseInt(over.style.left);py=parseInt(over.style.top);pw=o3_width;ph=(o3_aboveheight?parseInt(o3_aboveheight):over.offsetHeight);selEl=(olIe4)?o3_frame.document.all.tags("SELECT"):o3_frame.document.getElementsByTagName("SELECT");for(var i=0;i<selEl.length;i++){if(!olIe4&&selEl[i].size<2)continue;sx=pageLocation(selEl[i],'Left');sy=pageLocation(selEl[i],'Top');sw=selEl[i].offsetWidth;sh=selEl[i].offsetHeight;if((px+pw)<sx||px>(sx+sw)||(py+ph)<sy||py>(sy+sh))continue;selEl[i].isHidden=1;selEl[i].style.visibility='hidden';}}}
function showSelectBox(){if(olNs4||olOp||olIe55)return;var selEl,v;
if(olIe4)v=0;else{v=navigator.userAgent.match(/Gecko\/(\d{8})/i);if(!v)return;v=parseInt(v[1]);}
if(v<20030624){selEl=(olIe4)?o3_frame.document.all.tags("SELECT"):o3_frame.document.getElementsByTagName("SELECT");for(var i=0;i<selEl.length;i++){if(typeof selEl[i].isHidden!='undefined'&&selEl[i].isHidden){selEl[i].isHidden=0;selEl[i].style.visibility='visible';}}}}
function pageLocation(o,t){var x=0
while(o.offsetParent){x+=o['offset'+t]
o=o.offsetParent}
x+=o['offset'+t]
return x}
if(!(olNs4||olOp||olIe55||navigator.userAgent.indexOf('Netscape6')!=-1)){var MMStr=olMouseMove.toString();var strRe=/(if\s*\(o3_allowmove\s*==\s*1.*\)\s*)/;var f=MMStr.match(strRe);
if(f){var ls=MMStr.search(strRe);ls+=f[1].length;var le=MMStr.substring(ls).search(/[;|}]\n/);MMStr=MMStr.substring(0,ls)+' {runHook("placeLayer",FREPLACE);if(olHideForm)hideSelectBox();'+MMStr.substring(ls+(le!=-1?le+3:0));document.writeln('<script type="text/javascript">\n<!--\n'+MMStr+'\n//-->\n</'+'script>');}
f=capExtent.onmousemove.toString().match(/function[ ]+(\w*)\(/);if(f&&f[1]!='anonymous')capExtent.onmousemove=olMouseMove;}
registerHook("createPopup",generatePopUp,FAFTER);registerHook("hideObject",showSelectBox,FAFTER);olHideForm=1;}
var JOSC_http = (window.XMLHttpRequest ? new XMLHttpRequest : (window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : false));
var JOSC_operaBrowser = (navigator.userAgent.toLowerCase().indexOf("opera") != -1);
var JOSC_rsearchphrase_selection="any";
/* in case of modify */
var JOSC_userName = ''; 
var JOSC_userEmail = ''; 
var JOSC_userWebsite = '';
var JOSC_userNotify = '';
/* ***************** */
var JOSC_XmlErrorAlert = false; /* will be redefined by setting */
var JOSC_AjaxDebug = false; /* will be redefined by setting */
var JOSC_AjaxDebugLevel = 2; /* will be redefined by setting */

var JOSC_postREFRESH=false;

var JOSC_clientPC = navigator.userAgent.toLowerCase();
var JOSC_clientVer = parseInt(navigator.appVersion);

var JOSC_is_ie = ((JOSC_clientPC.indexOf("msie") != -1) && (JOSC_clientPC.indexOf("opera") == -1));
var JOSC_is_nav = ((JOSC_clientPC.indexOf('mozilla')!=-1) && (JOSC_clientPC.indexOf('spoofer')==-1)
                && (JOSC_clientPC.indexOf('compatible') == -1) && (JOSC_clientPC.indexOf('opera')==-1)
                && (JOSC_clientPC.indexOf('webtv')==-1) && (JOSC_clientPC.indexOf('hotjava')==-1));
var JOSC_is_moz = 0;

var JOSC_is_win = ((JOSC_clientPC.indexOf("win")!=-1) || (JOSC_clientPC.indexOf("16bit") != -1));
var JOSC_is_mac = (JOSC_clientPC.indexOf("mac")!=-1);

var JOSC_scrollTopPos = 0;
var JOSC_scrollLeftPos = 0;

function JOSC_insertAdjacentElement( object, where, parsedNode ) {
        if (!object.JOSCinsertAdjacentElement)
				object.insertAdjacentElement(where, parsedNode);
        else
                object.JOSCinsertAdjacentElement(where, parsedNode);
}

function JOSC_insertAdjacentHTML( object, where, htmlStr ) {
        if (!object.JOSCinsertAdjacentHTML)
				object.insertAdjacentHTML(where, htmlStr);
        else
                object.JOSCinsertAdjacentHTML(where, htmlStr);
}

if (typeof HTMLElement != "undefined" && !
    HTMLElement.prototype.JOSCinsertAdjacentElement) {
    HTMLElement.prototype.JOSCinsertAdjacentElement = function
    (where, parsedNode)
    {
        switch (where) {
            case 'beforeBegin':
                this.parentNode.insertBefore(parsedNode, this)
                break;
            case 'afterBegin':
                this.insertBefore(parsedNode, this.firstChild);
                break;
            case 'beforeEnd':
                this.appendChild(parsedNode);
                break;
            case 'afterEnd':
                if (this.nextSibling)
                    this.parentNode.insertBefore(parsedNode, this.nextSibling);
                else this.parentNode.appendChild(parsedNode);
                break;
        }
    }

    HTMLElement.prototype.JOSCinsertAdjacentHTML = function
    (where, htmlStr)
    {
        var r = this.ownerDocument.createRange();
        r.setStartBefore(this);
        var parsedHTML = r.createContextualFragment(htmlStr);
        this.JOSCinsertAdjacentElement(where, parsedHTML)
    }

/*    HTMLElement.prototype.JOSCinsertAdjacentText = function
    (where, txtStr)
    {
        var parsedText = document.createTextNode(txtStr)
        this.JOSCinsertAdjacentElement(where, parsedText)
    }
    */
}

/***************************
 * F U N C T I O N S
 ***************************/
 
function JOSC_HTTPParam()
{
}

JOSC_HTTPParam.prototype.create = function(josctask, id)
{
    this.result = 'option=com_comment';
    this.insert('no_html', 1);
    var form = document.joomlacommentform;
    this.insert('component', form.component.value);
    this.insert('joscsectionid', form.joscsectionid.value);
    this.insert('josctask', josctask);
    this.insert('comment_id', id);
    return this.result;
}

JOSC_HTTPParam.prototype.insert = function(name, value)
{
    this.result += '&' + name + '=' + value;
    return this.result;
}

JOSC_HTTPParam.prototype.encode = function(name, value)
{
    return this.insert(name, encodeURIComponent(value));
}

function JOSC_BusyImage()
{
}

JOSC_BusyImage.prototype.create = function(id)
{
//	var form = document.joomlacommentform;
    var image = document.createElement('img');
    image.setAttribute('src', JOSC_template + '/images/busy.gif');
    image.setAttribute('id', id+"Image");
    var element = document.getElementById(id);
    if (!element.innerHTML) element.appendChild(image);
    JOSC_ajaxNotActive = false;
}

JOSC_BusyImage.prototype.destroy = function(id)
{
    var image = document.getElementById(id+"Image");
    image.parentNode.removeChild(image);
    JOSC_ajaxNotActive = true;
}

var JOSC_ajaxNotActive = true; /* will be set in create/destroy BusyImage */
var JOSC_busyImage = new JOSC_BusyImage();

function JOSC_ajaxSend(data, onReadyStateChange)
{
    document.joomlacommentform.bsend.disabled = true;
    JOSC_busyImage.create('JOSC_busypage');
    JOSC_busyImage.create('JOSC_busy');
    var URL = JOSC_ConfigLiveSite+'index.php';
    JOSC_http.open("POST", URL , true);
    JOSC_http.onreadystatechange = onReadyStateChange;
    JOSC_http.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    if (JOSC_AjaxDebug) alert('###AJAXSEND:\n##URL=' + URL + ' ?' + data  + '\n##onReadyStateChange=' + onReadyStateChange);
    JOSC_http.send(data);
}

function JOSC_ajaxReady()
{
    if (JOSC_http.readyState == 4) {
    	/* received */
        JOSC_busyImage.destroy('JOSC_busy');
        JOSC_busyImage.destroy('JOSC_busypage');
        document.joomlacommentform.bsend.disabled = false;
	JOSC_addNew();
        if (JOSC_http.status == 200) {
        	/* response is ok */
          	if (JOSC_AjaxDebug) alert('AJAXREADY: OK !' );
            return true;
        } else {
          	if (JOSC_AjaxDebug) alert('AJAXREADY: KO ! Status=' + JOSC_http.status );
		    return false;
        }	
    }
    return false;
}

function JOSC_goToAnchor(name)
{
    clearTimeout(self.timer);
    action = function()
    {
		var url = window.location.toString();
		var index = url.indexOf('#');
		if (index == -1) { window.location = url + '#' + name; }
		else { window.location = url.substring(0, index) + '#' + name; }
        if (JOSC_operaBrowser) window.location = '##';
    }
    if (JOSC_operaBrowser) self.timer = setTimeout(action, 50);
    else action();
}

function JOSC_refreshPage(msg, id) 
{
	if (msg) alert(msg);

    clearTimeout(self.timer);
    action = function()
    {
		var url = window.location.toString();
		var index = url.indexOf('?option=');
		if (index == -1) { var sep = '?'; } /* SEF */
		else			 { var sep = '&'; } /* normal */
		window.location = JOSC_linkToContent + sep + 'comment_id=' + id + '#josc' + id;
        //if (JOSC_operaBrowser) window.location = '##';
    }
    if (JOSC_operaBrowser) self.timer = setTimeout(action, 50);
    else action();
}

function JOSC_getXmlResponse(withalert) {
/* return DOM (W3C) if no parsing xml error else null  (alert will show a javascript alert) */
  if (JOSC_http.responseXML && JOSC_http.responseXML.parseError &&(JOSC_http.responseXML.parseError.errorCode !=0)) {
    error = JOSC_getXmlError(withalert);
    return null; 
  } else {
  	if (JOSC_AjaxDebug) alert('###GETXMLRESPONSE:\n' + JOSC_http.responseText );
/*    if (JOSC_operaBrowser && JOSC_AjaxDebug && JOSC_AjaxDebugLevel>1) {
         txt = '';
         for (prop in JOSC_http.responseXML)
         {
             txt = txt + '\n' + prop + '=' + JOSC_http.responseXML[prop];
         }
         alert('JOSC_getXmlResponse:http.responseXML='+txt);
    }*/
    return JOSC_http.responseXML;
  }
}

function JOSC_getXmlError(withalert) {
  if (JOSC_http.responseXML.parseError.errorCode !=0 ) {
     line = JOSC_http.responseXML.parseError.line;
     pos = JOSC_http.responseXML.parseError.linepos;
     error = JOSC_http.responseXML.parseError.reason;
     error = error + "Contact the support ! and send the following informations:\n error is line " + line + " position " + pos;
	 error = error + " >>" + JOSC_http.responseXML.parseError.srcText.substring(pos);
         error = error + "\nGLOBAL:" + JOSC_http.responseText;
     if (withalert)
       alert(error);
     return error;
   } else {
     return "";
   }
}

/*
 * Form type function
 */
function JOSC_modifyForm(formTitle, buttonValue, onClick)
{
    document.getElementById('CommentFormTitle').innerHTML = formTitle;
    button = document.joomlacommentform.bsend;
    button.value = buttonValue;
    button.onclick = onClick;
}

function JOSC_xmlValue(xmlDocument, tagName)
{
    try {
        var result = xmlDocument.getElementsByTagName(tagName).item(0).firstChild.data;
    }
    catch(e) {
        var result = '';
    }
    return result;
}

function JOSC_removePost(post)
{
    document.getElementById('Comments').removeChild(post);
}

/********************* 
 * ajax call functions
 */
function JOSC_deleteComment(id)
{
    if (window.confirm(_JOOMLACOMMENT_MSG_DELETE)) {
        var data = new JOSC_HTTPParam().create('ajax_delete', id);
        JOSC_ajaxSend(data, function()
            {
                if (JOSC_ajaxReady()) {
                    if (JOSC_http.responseText != '') alert(JOSC_http.responseText);
                    else JOSC_removePost(document.getElementById('post' + id));
                }
            }
            );
    }
}

function JOSC_deleteAll()
{
	if (window.confirm(_JOOMLACOMMENT_MSG_DELETEALL)) {
        var form = document.joomlacommentform;
		var param = new JOSC_HTTPParam();
		param.create('ajax_delete_all', -1);
        JOSC_ajaxSend(param.insert('content_id',form.content_id.value), function()
            {
                if (JOSC_ajaxReady()) {
                    if (JOSC_http.responseText != '') alert(JOSC_http.responseText);
                    else {
                    	/* JOSC_addNew();  why ? */
                    	document.getElementById('Comments').innerHTML='';
					}
                }
            }
            );
    }
}


function JOSC_editComment(id)
{
    JOSC_modifyForm(_JOOMLACOMMENT_EDITCOMMENT, _JOOMLACOMMENT_EDIT,
        function(event)
        {
            JOSC_editPost(id, -1);}
        );
    JOSC_goToAnchor('CommentForm');
    var data = new JOSC_HTTPParam().create('ajax_modify', id);
    JOSC_ajaxSend(data, JOSC_editResponse);
}

function JOSC_quote(id)
{
    var data = new JOSC_HTTPParam().create('ajax_quote', id);
    JOSC_goToAnchor('CommentForm');
    JOSC_ajaxSend(data, JOSC_quoteResponse);
}

function JOSC_voting(id, yes_no)
{
    var data = new JOSC_HTTPParam().create('ajax_voting_' + yes_no, id);
    JOSC_ajaxSend(data, JOSC_votingResponse);
}

function JOSC_reloadCaptcha()
{
    var data = new JOSC_HTTPParam().create('ajax_reload_captcha', 0);
    JOSC_ajaxSend(data, JOSC_editPostResponse);
}

function JOSC_searchForm()
{
	JOSC_removeSearchResults();
	var searchform = document.joomlacommentsearch;
	var form = document.joomlacommentform;
    if (searchform) {
        searchform.parentNode.removeChild(searchform);
        if (!JOSC_operaBrowser) document.joomlacommentsearch = null;
    } else {
        var param = new JOSC_HTTPParam();
        param.create('ajax_insert_search', 0);
        JOSC_ajaxSend(param.insert('content_id', form.content_id.value), JOSC_searchFormResponse);
    }
}

function JOSC_search()
{
	JOSC_removeSearchResults();
	var keyword = document.joomlacommentsearch.tsearch.value;
	if (keyword=='') return 0;
	var param = new JOSC_HTTPParam();
	param.create('ajax_search', 0);
	param.encode('search_keyword', keyword)
	JOSC_ajaxSend(param.insert('search_phrase',JOSC_rsearchphrase_selection), JOSC_searchResponse);
}

//function editPost(id, parentid) {
//	/* for backward compatibility with templates */
//	return JOSC_editPost(id, parentid);
//}

function JOSC_editPost(id, parentid)
{
	var form = document.joomlacommentform;
    if (form.tcomment.value == '') 
    {
        alert(_JOOMLACOMMENT_FORMVALIDATE);
        return 0;
    }
    if  ( document.getElementsByName('tnotify')[0]  && document.getElementsByName('temail')[0] )
    {   if ( form.tnotify.selectedIndex && form.temail.value == '') {
            alert(_JOOMLACOMMENT_FORMVALIDATE_EMAIL);
            return 0;
        }
    }
    if (JOSC_captchaEnabled && form.security_try.value == '')
    {
        alert(_JOOMLACOMMENT_FORMVALIDATE_CAPTCHA);
        return 0;
    }
  
    
    if (JOSC_ajaxEnabled)
    {
        var param = new JOSC_HTTPParam();
        param.create(id == -1 ? 'ajax_insert' : 'ajax_edit', id);
        param.insert('content_id', form.content_id.value);
        if (JOSC_captchaEnabled) 
        {
            param.insert('security_try', form.security_try.value);
            param.insert('security_refid', form.security_refid.value);
        }
        if (parentid != -1) param.insert('parent_id', parentid);
        param.encode('tname', form.tname.value);
	    /* optional */
        if (document.getElementsByName('tnotify')[0])  { if (form.tnotify.selectedIndex) param.encode('tnotify', '1'); else param.encode('tnotify', '0'); };
        if (document.getElementsByName('temail')[0])    param.encode('temail', form.temail.value);
        if (document.getElementsByName('twebsite')[0])  param.encode('twebsite', form.twebsite.value);
        /************/
        param.encode('ttitle', form.ttitle.value);
		JOSC_ajaxSend(param.encode('tcomment', form.tcomment.value), JOSC_editPostResponse);
    } 
    else 
    {
    	/* should we use JOSC_ConfigLiveSite ? */
        form.action = JOSC_ConfigLiveSite+'/index.php?option=com_comment&josctask=noajax';
        form.submit();
    }
}

function JOSC_getComments(id, limitstart) 
{
    
	var form = document.joomlacommentform;
	if (JOSC_ajaxEnabled && JOSC_ajaxNotActive) 
    {
	    JOSC_ShowHide('', 'joscPageNavNoLink', 'joscPageNavLink');
        var param = new JOSC_HTTPParam();
        param.create('ajax_getcomments', id);
        param.insert('content_id',form.content_id.value);
    	JOSC_ajaxSend(param.insert('josclimitstart', limitstart), JOSC_getCommentsResponse);
    }
}

/*
 * END of ajax call functions
 */
 
/********************
 * response functions
 */
function JOSC_editResponse()
{
    if (JOSC_ajaxReady()) {
        if (JOSC_http.responseText.indexOf('invalid') == -1) {
            var form = document.joomlacommentform;
            var xmlDocument = JOSC_getXmlResponse(JOSC_XmlErrorAlert);; /*JOSC_http.responseXML;*/
            if (xmlDocument) {

    	        JOSC_userName = form.tname.value;
    	        form.tname.value = JOSC_xmlValue(xmlDocument, 'name');

          		form.ttitle.value = JOSC_xmlValue(xmlDocument, 'title');
          	  	form.tcomment.value = JOSC_xmlValue(xmlDocument, 'comment');

           		/* optional values of the templates ! */
            	if (document.getElementsByName('tnotify')[0]) {
            	   JOSC_userNotify = form.tnotify.selectedIndex; 
            	   form.tnotify.selectedIndex = new Boolean(JOSC_xmlValue(xmlDocument, 'notify')*1);
            	}
            	if (document.getElementsByName('temail')[0]) {
            	  JOSC_userEmail = form.temail.value; 
            	  form.temail.value = JOSC_xmlValue(xmlDocument, 'email');
            	}
            	if (document.getElementsByName('twebsite')[0]) {
            		JOSC_userWebsite = form.twebsite.value;
            	    form.twebsite.value = JOSC_xmlValue(xmlDocument, 'website');
            	}
            	/* ********************** */
            } else {
            	form.tcomment.value = 'failed to retrieve datas';
            }
            if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_edit');
        }
    }
}

function JOSC_quoteResponse()
{
    if (JOSC_ajaxReady()) {
        if (JOSC_http.responseText.indexOf('invalid') == -1) {
            var form = document.joomlacommentform;
            var xmlDocument = JOSC_getXmlResponse(true);
            if (xmlDocument) {
	            name = JOSC_xmlValue(xmlDocument, 'name');
    	        if (name == '') name = _JOOMLACOMMENT_ANONYMOUS;
        	    if (form.ttitle.value == '') form.ttitle.value = 're: ' +
            	    JOSC_xmlValue(xmlDocument, 'title');
	            form.tcomment.value += '[quote=' + name + ']' +
    	        JOSC_xmlValue(xmlDocument, 'comment') + '[/quote]';
        	} else {
            	form.tcomment.value = 'failed to retrieve datas';
            }
            if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_quote');
        }
    }
}

function JOSC_votingResponse()
{
    if (JOSC_ajaxReady()) {
        if (JOSC_http.responseText.indexOf('invalid') == -1) {
            var form = document.joomlacommentform;
            var xmlDocument = JOSC_getXmlResponse(JOSC_XmlErrorAlert); /*JOSC_http.responseXML;*/
            var id = JOSC_xmlValue(xmlDocument, 'id');
            var yes = JOSC_xmlValue(xmlDocument, 'yes');
            var no = JOSC_xmlValue(xmlDocument, 'no');
            document.getElementById('yes' + id).innerHTML = yes;
            document.getElementById('no' + id).innerHTML = no;
			if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_voting');
        }
    }
}

function JOSC_editPostResponse()
{
    if (JOSC_ajaxReady()) {
        if (JOSC_http.responseText.indexOf('invalid') == -1) {
            var form = document.joomlacommentform;
            var element = document.getElementById('Comments');
			var xmlDocument = JOSC_getXmlResponse(true); /*JOSC_http.responseXML;*/
			if (!xmlDocument) {
                return 0;
            }
            var id = JOSC_xmlValue(xmlDocument, 'id');
            var captcha = JOSC_xmlValue(xmlDocument, 'captcha');
            if (captcha) {
                JOSC_refreshCaptcha(captcha);
                if (id == 'captchaalert') {
                	alert(_JOOMLACOMMENT_FORMVALIDATE_CAPTCHA_FAILED);
                 	return 0;
                }
                if (id == 'captcha') {
                	return 0;
                }
            }
            anchor = 'josc' + id;
            var idsave = id;
            id = 'post' + id;
            var body = JOSC_xmlValue(xmlDocument, 'body');
			var post = document.getElementById(id);
            var after = JOSC_xmlValue(xmlDocument, 'after');
            JOSC_clearInputbox();
            var noerror = JOSC_xmlValue(xmlDocument, 'noerror');
			if (noerror==0) {
				alert(_JOOMLACOMMENT_REQUEST_ERROR);
				form.tcomment.value=JOSC_http.responseText;
				return 0;
            }
            var published = JOSC_xmlValue(xmlDocument, 'published');
			if (published==0) {
				alert(_JOOMLACOMMENT_BEFORE_APPROVAL);
				form.tcomment.value="";
				if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_approval');
				return 0;
            }
            if (post) {
				var className = JOSC_getPostClass(post);
                var indent = post.style.paddingLeft;
                JOSC_insertAdjacentHTML(post, 'beforeBegin', body);
                JOSC_removePost(post);
                newPost = document.getElementById(id);
                JOSC_setPostClass(newPost, className);
                newPost.style.paddingLeft = indent;
                JOSC_modifyForm(_JOOMLACOMMENT_WRITECOMMENT, _JOOMLACOMMENT_SENDFORM,
                    function(event)
                    {
                        JOSC_editPost(-1, -1);
                    });
                form.tname.value = JOSC_userName;
            	if (document.getElementsByName('temail')[0])   form.temail.value = JOSC_userEmail;
            	if (document.getElementsByName('website')[0])   form.website.value = JOSC_userWebsite;
		if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_editpost');

            } else {
                if (!after || after == -1)
                	if (JOSC_sortDownward != 0) {
                		if (JOSC_postREFRESH)
    	            		JOSC_refreshPage(_JOOMLACOMMENT_MSG_NEEDREFRESH, idsave);
	                	else
	                		JOSC_insertAdjacentHTML(element, 'afterBegin', body);
               		} else {
                		if (JOSC_postREFRESH)
    	            		JOSC_refreshPage(_JOOMLACOMMENT_MSG_NEEDREFRESH, idsave);
	                	else
                			JOSC_insertAdjacentHTML(element, 'beforeEnd', body);
               		}
                else {
                	if (document.getElementById('post' + after))
                		JOSC_insertAdjacentHTML(document.getElementById('post' + after), 'afterEnd', body);
                	else
                		/* pagination or post has been deleted or new one from another users...=> refresh */
                		JOSC_refreshPage(_JOOMLACOMMENT_MSG_NEEDREFRESH, idsave);
                }

                JOSC_setPostClass(document.getElementById(id), 'sectiontableentry' + JOSC_postCSS);
                JOSC_postCSS == 1 ? JOSC_postCSS = 2 : JOSC_postCSS = 1;
		if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_posted');
            }
            JOSC_goToAnchor(anchor);
       		//JOSC_refreshPage('', idsave);
        }
	}
}

function JOSC_getCommentsResponse() {

    //JOSC_ShowHide('', 'joscPageNavLink', 'joscPageNavNoLink');
    
    if (JOSC_ajaxReady()) {

        if (JOSC_http.responseText.indexOf('invalid') == -1) {

			JOSC_resetFormPos(); /* if reply... */
			
            var element = document.getElementById('Comments');
            var elementPN = document.getElementById('joscPageNav');

			var xmlDocument = JOSC_getXmlResponse(true); /*JOSC_http.responseXML;*/
			if (!xmlDocument) {
                return 0;
            }

            element.innerHTML='';
            elementPN.innerHTML='';

            var body 	= JOSC_xmlValue(xmlDocument, 'body');
            var pagenav	= JOSC_xmlValue(xmlDocument, 'pagenav');

            if (JOSC_sortDownward != 0)
				JOSC_insertAdjacentHTML(element, 'afterBegin', body);
            else {
                JOSC_insertAdjacentHTML(element, 'beforeEnd', body);
            }
			JOSC_insertAdjacentHTML(elementPN, 'afterBegin', pagenav);

			if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_getcomments');
		}
	}
}

function JOSC_searchFormResponse()
{
	if (JOSC_ajaxReady()) {
        form = JOSC_http.responseText;
        if (form != '') {
            JOSC_insertAdjacentHTML(document.getElementById('CommentMenu'), 'afterEnd', form);
			if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_searchform');
		}
    }
}

function JOSC_searchResponse()
{
    if (JOSC_ajaxReady()) {
        form = JOSC_http.responseText;
		if (form != '') {
            JOSC_insertAdjacentHTML(document.joomlacommentsearch, 'afterEnd', form);
			if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_search');
		}
    }
}

/*
 * END of response functions
 */

/*
 * Template functions
 */
//function JOSC_goToPost(contentid, id)
//{
//	var form = document.joomlacommentform;
//	if (form.content_id.value==contentid) JOSC_goToAnchor('josc'+id); /* not correct in case of pagination. use JOSC_viewPost */
//	else window.location = 'index.php?option=' + form.component + '&task=view&id=' + contentid + '#josc' + id;
//	if (JOSC_operaBrowser) window.location = '##';
//}
//
//function JOSC_viewPost(contentid, id, itemid)
//{
//	var form = document.joomlacommentform;
//	window.location = 'index.php?option=' + form.component + '&task=view&id=' + contentid + (itemid ? ('&Itemid='+itemid) : '') + '&comment_id=' + id + '#josc' + id;
//	if (navigator.userAgent.toLowerCase().indexOf("opera") != -1) window.location = '##';
//}

function JOSC_reply(id)
{
    var form = document.joomlacommentform;
    var post = document.getElementById('post' + id);
    var postPadding = post.style.paddingLeft.replace('px','')*1;
    form.style.paddingLeft = ( postPadding + 20 ) + 'px';
    JOSC_modifyForm(_JOOMLACOMMENT_WRITECOMMENT, _JOOMLACOMMENT_SENDFORM,
    function(event)
    {
        JOSC_editPost(-1, id);
	});
    JOSC_insertAdjacentElement(post, 'afterEnd', form);
    if (self.JOSC_afterAjaxResponse) JOSC_afterAjaxResponse('response_reply');
}

function JOSC_resetFormPos() {
    var form = document.joomlacommentform;   
    var formpos = document.getElementById('JOSC_formpos');
    if (form.parentNode.id != 'comment' || (formpos && form.parentNode.id != 'JOSC_formpos'))
    {
	    form.style.paddingLeft = '0px';
    	form.bsend.onclick = function(event)
    	{
	        JOSC_editPost(-1, -1);
	};
	if (!formpos) {
		JOSC_insertAdjacentElement(document.getElementById('Comments'), 'afterEnd', form);
	} else {
	    JOSC_insertAdjacentElement(formpos, 'afterEnd', form);
	}

    }
}
		    
function JOSC_insertUBBTag(tag)
{
    JOSC_insertTags('[' + tag + ']', '[/' + tag + ']');
}

function JOSC_fontColor(){
  var color = document.joomlacommentform.menuColor.selectedIndex;
  switch (color){
    case 0: color=''; break;
    case 1: color='aqua'; break;
    case 2: color='black'; break;
    case 3: color='blue'; break;
    case 4: color='fuchsia'; break;
    case 5: color='gray'; break;
    case 6: color='green'; break;
    case 7: color='lime'; break;
    case 8: color='maroon'; break;
    case 9: color='navy'; break;
    case 10: color='olive'; break;
    case 11: color='purple'; break;
    case 12: color='red'; break;
    case 13: color='silver'; break;
    case 14: color='teal'; break;
    case 15: color='white'; break;
    case 16: color='yellow'; break;
  }
  if (color!='') JOSC_insertTags('[color='+color+']','[/color]');
}

function JOSC_fontSize()
{
    var size = document.joomlacommentform.menuSize.selectedIndex;
    switch (size) {
        case 0: size = '';
            break;
        case 1: size = 'x-small';
            break;
        case 2: size = 'small';
            break;
        case 3: size = 'medium';
            break;
        case 4: size = 'large';
            break;
        case 5: size = 'x-large';
            break;
    }
    if (size != '') JOSC_insertTags('[size=' + size + ']', '[/size]');
}

function JOSC_emoticon(icon)
{
  var txtarea = document.joomlacommentform.tcomment;
  JOSC_scrollToCursor(txtarea, 0);
  txtarea.focus();
  JOSC_pasteAtCursor(txtarea, ' ' + icon + ' ');
  JOSC_scrollToCursor(txtarea, 1);
}
/*
 * END of template function
 */
 
/*
 * ALL OTHERS UTILS FUNCTION
 */
function JOSC_insertTags(bbStart, bbEnd) {
  var txtarea = document.joomlacommentform.tcomment;
  JOSC_scrollToCursor(txtarea, 0);
  txtarea.focus();

  if ((JOSC_clientVer >= 4) && JOSC_is_ie && JOSC_is_win) {
    theSelection = document.selection.createRange().text;
    if (theSelection) {
      document.selection.createRange().text = bbStart + theSelection + bbEnd;
      theSelection = '';
      return;
    } else {
      JOSC_pasteAtCursor(txtarea, bbStart + bbEnd);
	}
  } else if (txtarea.selectionEnd && (txtarea.selectionEnd - txtarea.selectionStart > 0)) {
    var selLength = txtarea.textLength;
    var selStart = txtarea.selectionStart;
    var selEnd = txtarea.selectionEnd;
    var s1 = (txtarea.value).substring(0,selStart);
    var s2 = (txtarea.value).substring(selStart, selEnd)
    var s3 = (txtarea.value).substring(selEnd, selLength);
    txtarea.value = s1 + bbStart + s2 + bbEnd + s3;
    txtarea.selectionStart = selStart + (bbStart.length + s2.length + bbEnd.length);
    txtarea.selectionEnd = txtarea.selectionStart;
    JOSC_scrollToCursor(txtarea, 1);
    return;
  } else {
    JOSC_pasteAtCursor(txtarea, bbStart + bbEnd);
	JOSC_scrollToCursor(txtarea, 1);
  }
}

function JOSC_scrollToCursor(txtarea, action) {
  if (JOSC_is_nav) {
    if (action == 0) {
      JOSC_scrollTopPos = txtarea.scrollTop;
      JOSC_scrollLeftPos = txtarea.scrollLeft;
    } else {
      txtarea.scrollTop = JOSC_scrollTopPos;
      txtarea.scrollLeft = JOSC_scrollLeftPos;
    }
  }
}

function JOSC_pasteAtCursor(txtarea, txtvalue) {
  if (document.selection) {
    var sluss;
    txtarea.focus();
    sel = document.selection.createRange();
    sluss = sel.text.length;
    sel.text = txtvalue;
    if (txtvalue.length > 0) {
      sel.moveStart('character', -txtvalue.length + sluss);
    }
  } else if (txtarea.selectionStart || txtarea.selectionStart == '0') {
    var startPos = txtarea.selectionStart;
    var endPos = txtarea.selectionEnd;
    txtarea.value = txtarea.value.substring(0, startPos) + txtvalue + txtarea.value.substring(endPos, txtarea.value.length);
    txtarea.selectionStart = startPos + txtvalue.length;
    txtarea.selectionEnd = startPos + txtvalue.length;
  } else {
    txtarea.value += txtvalue;
  }
}

function JOSC_clearInputbox()
{
    var form = document.joomlacommentform;
    form.ttitle.value = '';
    form.tcomment.value = '';
}

function JOSC_getPostClass(post)
{
    return post.getElementsByTagName('ul')[0].getElementsByTagName('li')[0].className;
}

function JOSC_setPostClass(post, value)
{
    post.getElementsByTagName('ul')[0].getElementsByTagName('li')[0].className = value;
}

function JOSC_refreshCaptcha(captcha)
{
    document.getElementById('captcha').innerHTML = captcha;
    document.joomlacommentform.security_try.value = '';
}

function JOSC_removeSearchResults()
{
    var searchResults = document.getElementById('SearchResults');
    if (searchResults) searchResults.parentNode.removeChild(searchResults);
}

function JOSC_addNew()
{
    JOSC_resetFormPos();
    JOSC_goToAnchor('CommentForm');
}

function JOSC_ShowHide(emptyvalue, showId, hideId) {

	if (showId && showId!=emptyvalue) {
		document.getElementById(showId).style.visibility='visible';
		document.getElementById(showId).style.display = '';
	}
	if (hideId && hideId!=emptyvalue) {    
		document.getElementById(hideId).style.visibility = 'hidden';
		document.getElementById(hideId).style.display = 'none';
	}
	return(showId);    
}

function JOSC_toogle(ElementId) {
     		    
	if (ElementId) {
		if (document.getElementById(ElementId).style.visibility=='hidden') {
			document.getElementById(ElementId).style.visibility='visible';
			document.getElementById(ElementId).style.display = '';
		} else {
			document.getElementById(ElementId).style.visibility = 'hidden';
			document.getElementById(ElementId).style.display = 'none';
		}
	}
}

/*
 * return 0 if nothing done
 * return 1 if hidden->visible
 * return 2 if visible->hidden
 */
function JOSC_toogleR(ElementId) {
     		    
	if (ElementId) {
		if (document.getElementById(ElementId).style.visibility=='hidden') {
			document.getElementById(ElementId).style.visibility='visible';
			document.getElementById(ElementId).style.display = '';
			return 1;
		} else {
			document.getElementById(ElementId).style.visibility = 'hidden';
			document.getElementById(ElementId).style.display = 'none';
			return 2;
		}
	} else return 0;
} /*
#------------------------------------------------------------------------
  JA Purity II for Joomla 1.5
#------------------------------------------------------------------------
#Copyright (C) 2004-2009 J.O.O.M Solutions Co., Ltd. All Rights Reserved.
#@license - GNU/GPL, http://www.gnu.org/copyleft/gpl.html
#Author: J.O.O.M Solutions Co., Ltd
#Websites: http://www.joomlart.com - http://www.joomlancers.com
#------------------------------------------------------------------------
*/


var src_collap_1 = tmplurl + "/images/icon-min.gif";	
var src_collap_2 = tmplurl + "/images/icon-max.gif";
new Asset.images ([src_collap_1, src_collap_2]);

var JADDModules = new Class({

	options: {
		handles: false,
		containers: false,
		onStart: Class.empty,
		onComplete: Class.empty,
		ghost: true,
		snap: 3,
		title: 'h3',
		src_collap_1:'',
		src_collap_2:'',
		cookieprefix: '',
		
		onDragStart: function(element, ghost){
			ghost.setStyles({'opacity':0.7, 'z-index':100});
			element.getChildren().setStyles({'opacity':0.3, 'z-index':1});
			element.addClass('move');
			this.lists.addClass ('move-wrap');
		},
		onDragComplete: function(element, ghost){
			element.getChildren().setStyle('opacity', 1);
			element.removeClass('move');
			this.lists.removeClass ('move-wrap');
			ghost.remove();
			this.trash.remove();
		}
	},

	initialize: function(lists, options){			
			//console.log(encodeURIComponent("h%E1%BB%93ng%20c%C3%B4ng"));
		this.setOptions(options);
		this.lists = lists;
		if (window.loaded) {
			this._load();
		} else {
			window.addEvent ('domready', this._load.bind(this));
		}
	},

	_load: function () {
		this.lists = $$(this.lists);
		this.lists.sort(function(a,b){return a.getCoordinates().left - b.getCoordinates().left;});
		this.elements = [];
		this.handles = [];				
		
		/*	Get cookies	*/
		this.hc = '';
		if((this.hc=Cookie.get(this.options.cookieprefix+'ja-ordercolumn'))){
			if (this.hc == '-') {
				this.hc = '';
				Cookie.set(this.options.cookieprefix+"ja-ordercolumn", '',{path:'/'});				
			} else {
				this.hc = this.hc.split(',');
				if(this.hc!=''){
					this.hc.each(function(cc,k){
						this.hc[k] = this.hc[k].split("_");
					},this);
				}
			}
		}
		
		this.lists.each(function(list){
			var elements = list.getChildren();
			elements.each(function(el,i){
				el._p = list;	
				if(this.options.title){
					el._h = el.getElement(this.options.title);
					if (!el._h) return;
					tmp = el._h.getParent();
					el._h.remove();
					
					//add wrap div
					/*
					var tmpwrap = new Element('div', {'class':'ja-mod-content'});
					var tmpwrap2 = new Element('div', {'class':'ja-mod-inner'}).inject (tmpwrap);
					tmp.getChildren().each (function(elc){
						elc.remove().inject(tmpwrap2);
					});
					tmpwrap.inject (tmp);
					*/
					tmp.innerHTML = "<div class=\"ja-mod-content\"><div class=\"ja-mod-inner\">"+tmp.innerHTML+"</div></div>";
					el._h.injectTop (tmp);										
					//el._h._el = el;	
					
					el._pos = i;
					
					if(this.hc){
						//element property: position, container, ...
						this.hc.each(function(val){
							if (val[1] == el._h.getText().trim().substr(0,20)) {
								el._p 			= $(val[0]);
								el._pos 		= parseInt(val[2]);
								el._h.addClass (val[3]);				
							}
						},this);
					}					
					
					if(el._h.className.test("hide")){						
						src_collap = this.options.src_collap_1;
					}
					else{
						if (!el._h.className.test('show')) el._h.addClass ('show');
						src_collap = this.options.src_collap_2;
					}
					
					//create handler for moveable and collapsible hotspot	
					divmd = new Element('span',{'class':'ja-mdtool'});
					divmd.inject(el._h);	
					chdl = new Element('img',{'src':src_collap});
					chdl.setStyle('cursor','pointer');
					chdl.inject (divmd);
					el._h._chdl = chdl;
					var handle = new Element('span', {'class':'ja-mdmover'}).inject (el._h);
					handle.innerHTML = 'Move';								
					this.handles.push(handle);
				}
			},this);

			this.elements.merge(elements);
			
			this.lists.setStyle('visibility','visible');
			
		},this);
		
		
		
		this.elements.each (function (el){
			
			el.remove();
			p = $(el._p);
			if(!p) return ;
			tmp = p.getChildren().length > el._pos ? p.getChildren()[el._pos]:null;
			if (tmp) {
				if (tmp._pos > el._pos) el.injectBefore(tmp);
				else el.injectAfter(tmp);
			}
			else el.inject (p);
			
		});
		
		//this.elements = $$(list);
		this.handles = (this.options.handles) ? $$(this.options.handles) : (this.handles.length?this.handles:this.elements);
		//this.handles.setStyle('cursor', 'move');
		this.bound = {
			'start': [],
			'moveGhost': this.moveGhost.bindWithEvent(this)
		};
		for (var i = 0, l = this.handles.length; i < l; i++){
			this.bound.start[i] = this.start.bindWithEvent(this, this.elements[i]);
		}	
									
		this.attach();
		this.collap();
		
		if (this.options.initialize) this.options.initialize.call(this);
		this.bound.move = this.move.bindWithEvent(this);
		this.bound.end = this.end.bind(this);			
									
		//if (window.opera) window.addEvent("unload", this.saveCookies.bind(this));
		//else window.addEvent("beforeunload", this.saveCookies.bind(this));

	},

	collap: function(){
		this.lists.each(function(list){
			var elements = list.getChildren();
			elements.each(function(el,i){
				/*	For collap		*/
						
				el.elmain = el.getElement('.ja-mod-inner');				
				if(!el._h) return;

				el.maxH = el.elmain.getStyle('height').toInt();
//console.log (el.elmain.getStyle('height').toInt() + ' ' + el.maxH);
				el.elmain.setStyles ({
					'overflow':'hidden',
					'padding':'0',
					'margin':'0'
					});
						
				el._h._chdl.addEvent('mousedown', function(e){
					e = new Event(e).stop();
				});
				el._h._chdl.addEvent('click', function(e){
					e = new Event(e).stop();
					this.toggle(el);
				}.bind(this));	
											
				if(el._h.className.test('hide')) {
					this.hide(el);
				}
				else{
					this.show(el);
				}
				
			}, this);
		}, this);
	},
	
	toggle: function(el){
		if (el._h.className.test('hide')){
			this.show(el);
		}
		else this.hide(el);
	},	
	
	show: function(el) {
		el._h.removeClass('hide');
		if (!el._h.className.test('show')) el._h.addClass('show');
		el._h._chdl.src = src_collap_2;					
		new Fx.Style(el.elmain,'height',{onComplete:this.toggleStatus.bind(this,el)}).start(el.elmain.offsetHeight,el.elmain.scrollHeight);
	},	
	hide: function(el) {
		el._h.removeClass('show');
		if (!el._h.className.test('hide')) el._h.addClass('hide');
		el._h._chdl.src = src_collap_1;
		new Fx.Style(el.elmain,'height',{onComplete:this.toggleStatus.bind(this,el)}).start(el.elmain.offsetHeight,0);				
	},
	toggleStatus: function (el) {					
		el._status=(el._status=='hide')?'show':'hide';
		//this.fireEvent('onComplete', this.active);
		this.saveCookies();
	},				
	
	
	attach: function(){
		this.handles.each(function(handle, i){
			//handle.addEvent('mousedown', this.bound.start[i]);
			//handle.getElements('a').addEvent('mousedown', function (e) {e = new Event(e).stop();});
			handle.addEvent('mousedown', this.bound.start[i]);
			handle.setStyle('cursor','move');
		}, this);
	},

	detach: function(){
		this.handles.each(function(handle, i){
			handle.removeEvent('mousedown', this.bound.start[i]);
		}, this);
	},

	start: function(event, el){
		this.active = el;
		//this.coordinates = this.list.getCoordinates();
		if (this.options.ghost){
			this.previous = 0;
			var position = el.getPosition();
			this.offsetX = event.page.x - position.x;
			this.offsetY = event.page.y - position.y;
			this.trash = new Element('div', {'class':'ja-ghost'}).inject(document.body);
			this.ghost = el.clone().inject(this.trash).setStyles({
				'position': 'absolute',
				'left': event.page.x - this.offsetX,
				'top': event.page.y - this.offsetY,
				'width': el.offsetWidth
			});			

			document.addListener('mousemove', this.bound.moveGhost);
			this.fireEvent('onDragStart', [el, this.ghost]);
		}
		document.addListener('mousemove', this.bound.move);
		document.addListener('mouseup', this.bound.end);
		this.fireEvent('onStart', el);
		event.stop();
	},

	moveGhost: function(event){
		this.ghost.setStyles({'left': event.page.x-this.offsetX,
													'top': event.page.y-this.offsetY
													});
		event.stop();
	},

	move: function(event){
		var cor = this.active.getCoordinates();
		if(cor.left < event.page.x && event.page.x < cor.right && event.page.y > cor.top && event.page.y < cor.bottom) return;
		/*Find out the hover element*/
		var now = event.page.x;
		var clist = this.lists[0];
		this.lists.each(function(list){
			if (now > list.getCoordinates().left) clist = list;
		}, this);
		
		if(clist == this.active._p) {
			var now = event.page.y;
			this.previous = this.previous || now;
			var up = ((this.previous - now) > 0);
			var prev = this.active.getPrevious();
			var next = this.active.getNext();
			if (prev && up && now < prev.getCoordinates().bottom) this.active.injectBefore(prev);
			if (next && !up && now > next.getCoordinates().top) this.active.injectAfter(next);
			this.previous = now;
		}else{
			var now = event.page.y;
			
			//Get correct position
			var els = clist.getChildren();
			if(els.length) {
				var cel = els[0];
				els.each(function(el, idx){
					if (now > el._h.getCoordinates().bottom)
					{
						if(idx < els.length - 1) cel = els[idx+1];
						else cel = null;
					}
				},this);

				if(cel) this.active.injectBefore(cel);
				else this.active.inject(clist);
			} else {
				this.active.inject(clist);
			}
			this.active._p = clist;
			this.previous = now;
		}

	},

	serialize: function(converter){
		return this.list.getChildren().map(converter || function(el){
			return this.elements.indexOf(el);
		}, this);
	},

	end: function(){
		this.previous = null;
		document.removeListener('mousemove', this.bound.move);
		document.removeListener('mouseup', this.bound.end);
		if (this.options.ghost){
			document.removeListener('mousemove', this.bound.moveGhost);
			this.fireEvent('onDragComplete', [this.active, this.ghost]);
		}
		this.fireEvent('onComplete', this.active);
		this.saveCookies();
	},
	
	saveCookies: function() {
		if ((this.hc=Cookie.get(this.options.cookieprefix+"ja-ordercolumn")) == '-') {
			return;
		}
		if (this.hc) {
			this.hc = this.hc.split(',');
			if(this.hc){
				this.hc.each(function(cc,k){
					this.hc[k] = this.hc[k].split("_");
				},this);
			}
		}
		
		c = '';
		this.lists.each(function(list){			
			var elements = list.getChildren();			
			if (!elements){
				return;
			}
			elements.each(function(el,i){
				c += el._p.id + "_" + el._h.getText().trim().substr(0,20) + "_" + i + "_" + (el._h.className.test('hide')?'hide':'show')+",";
			},this);
		},this);
		
		if (this.hc) {
			this.hc.each(function(value, k){
				if (!c.test ('_' + value[1] + '_')) {
					c += value[0] + "_" + value[1] + "_" + value[2] + "_" + value[3]+",";
				}
			},this);
		}	
		c = c.substr(0, (c.length-1));
		Cookie.set(this.options.cookieprefix+"ja-ordercolumn", c, {duration: 365,path:'/'});
	}
});

document.write('<style type="text/css">.ja-movable-container{visibility: hidden;}</style>');
/*
window.addEvent('load', function(){	
	new JADDModules($$("#ja-zinwrap .ja-movable-container"), {src_collap_1:src_collap_1, src_collap_2:src_collap_2, 'cookieprefix':'', title: '.ja-zinsec'});
	new JADDModules($$("#ja-cols .ja-movable-container"), {src_collap_1:src_collap_1, src_collap_2:src_collap_2, 'cookieprefix':''});
});
*/
JADDModules.implement(new Events, new Options);

JAResizer = new Class({
	initialize: function(els, options){
		this.options = Object.extend({
			min: 100,
			max: 0
		}, options || {});
		$$(els).each(function(el){
			el.onmouseover = function(){
				this.addClass('ja-colresizehover');
			};
			
			resizemouseout = function(){
				//console.log('call mouse out event for ' + this);
				this.removeClass('ja-colresizehover');
			}
			el.onmouseout = resizemouseout;

			var prev = el.getPrevious();
			var next = el.getNext();
			prev.makeResizableNew ({handle: el, modifiers:{y:false}, limit:{width:[100]}});
			next.makeResizableNew ({handle: el, modifiers:{y:false}, dir: -1, limit:{width:[100]}});
			var eld = el.makeDraggable({modifiers:{y:false}});

			eld.addEvent('onStart', function (el) {
				//console.log('Remove mouse out for ' + eld.element);
				el.onmouseout = null;
				this._next = el.getNext();
				this._prev = el.getPrevious();
				this._w = this._prev.getStyle('width').toFloat() + this._next.getStyle('width').toFloat();
			});

			eld.addEvent('onComplete', function (el) {
				el.onmouseout = resizemouseout;

				var w1 = this._prev.offsetWidth;
				var w2 = this._next.offsetWidth;
				var w1p = w1/(w1+w2)*this._w;
				var w2p = w2/(w1+w2)*this._w;
				var elwp = el.offsetLeft * this._w / (w1+w2);
				this._prev.setStyle('width', w1p + '%');
				this._next.setStyle('width', w2p + '%');
				el.setStyle ('left', elwp + '%');

				el = el.getCoordinates(this.options.overflown);
				var now = this.mouse.now;
				if (!(now.x > el.left && now.x < el.right && now.y < el.bottom && now.y > el.top)) resizemouseout.call(this.element);

			});
		}.bind( this));
	}
});


Drag.Resize = Drag.Base.extend({

	options: {
		dir: 1
	},

	initialize: function(el, options){
		this.setOptions(options);
		this.parent(el);
	},


	start: function(event){
		this.fireEvent('onBeforeStart', this.element);
		this.mouse.start = event.page;
		var limit = this.options.limit;
		this.limit = {'x': [], 'y': []};
		for (var z in this.options.modifiers){
			if (!this.options.modifiers[z]) continue;
			this.value.now[z] = this.element.getCoordinates()[this.options.modifiers[z]].toInt();
			this.mouse.pos[z] = event.page[z] - this.value.now[z]*this.options.dir;
			if (limit && limit[z]){
				for (var i = 0; i < 2; i++){
					if ($chk(limit[z][i])) this.limit[z][i] = ($type(limit[z][i]) == 'function') ? limit[z][i]() : limit[z][i];
				}
			}
		}
		if ($type(this.options.grid) == 'number') this.options.grid = {'x': this.options.grid, 'y': this.options.grid};
		document.addListener('mousemove', this.bound.check);
		document.addListener('mouseup', this.bound.stop);
		this.fireEvent('onStart', this.element);
		event.stop();
	},

	drag: function(event){
		this.out = false;
		this.mouse.now = event.page;
		for (var z in this.options.modifiers){
			if (!this.options.modifiers[z]) continue;
			//this.value.now[z] = this.mouse.now[z] - this.mouse.pos[z];
			this.value.now[z] = (this.mouse.now[z] - this.mouse.pos[z])*this.options.dir;
			if (this.limit[z]){
				if ($chk(this.limit[z][1]) && (this.value.now[z] > this.limit[z][1])){
					this.value.now[z] = this.limit[z][1];
					this.out = true;
				} else if ($chk(this.limit[z][0]) && (this.value.now[z] < this.limit[z][0])){
					this.value.now[z] = this.limit[z][0];
					this.out = true;
				}
			}
			if (this.options.grid[z]) this.value.now[z] -= (this.value.now[z] % this.options.grid[z]);
			this.element.setStyle(this.options.modifiers[z], this.value.now[z] + this.options.unit);
		}
		this.fireEvent('onDrag', this.element);
		event.stop();
	}

});

/*
Class: Element
	Custom class to allow all of its methods to be used with any DOM element via the dollar function <$>.
*/

Element.extend({

	/*
	Property: makeDraggable
		Makes an element draggable with the supplied options.

	Arguments:
		options - see <Drag.Move> and <Drag.Base> for acceptable options.
	*/

	makeResizableNew: function(options){
		return new Drag.Resize(this, $merge({modifiers: {x: 'width', y: 'height'}}, options));
	}

});
/*
#------------------------------------------------------------------------
  JA Purity II for Joomla 1.5
#------------------------------------------------------------------------
#Copyright (C) 2004-2009 J.O.O.M Solutions Co., Ltd. All Rights Reserved.
#@license - GNU/GPL, http://www.gnu.org/copyleft/gpl.html
#Author: J.O.O.M Solutions Co., Ltd
#Websites: http://www.joomlart.com - http://www.joomlancers.com
#------------------------------------------------------------------------
*/


if (typeof(MooTools) != 'undefined'){

		var subnav = new Array();

		Element.extend(
		{
			hide: function(timeout) 
			{
				this.status = 'hide';
				clearTimeout (this.timeout);
				if (timeout)
				{
					this.timeout = setTimeout (this.anim.bind(this), timeout);
				}else{
					this.anim();
				}
			},
					
			show: function(timeout) 
			{
				this.status = 'show';
				clearTimeout (this.timeout);
				if (timeout)
				{
					this.timeout = setTimeout (this.anim.bind(this), timeout);
				}else{
					this.anim();
				}
			},

			setActive: function () {
				//this.addClass(classname);
				this.className+=' sfhover'; 
				/*
				for(var i=0;i<this.childNodes.length; i++) {
					if(this.childNodes[i].nodeName.toLowerCase() == 'a') {
						//$(this.childNodes[i]).addClass(classname);
						$(this.childNodes[i]).setActive();
						return;
					}
				}
				*/
			},

			setDeactive: function () {
				//this.removeClass(classname);
				this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
				/*
				for(var i=0;i<this.childNodes.length; i++) {
					if(this.childNodes[i].nodeName.toLowerCase() == 'a') {
						$(this.childNodes[i]).setDeactive();
						return;
					}
				}
				*/
			},

			anim: function() {
				if ((this.status == 'hide' && this.style.left != 'auto') || (this.status == 'show' && this.style.left == 'auto' && !this.hidding)) return;
				this.setStyle('overflow', 'hidden');
				if (this.status == 'show') {
					this.hidding = 0;
					this.hideAll();
					//this.parentNode.setActive();
				} else {
					//this.parentNode.setDeactive();
				}

				if (this.status == 'hide')
				{
					this.hidding = 1;
					//this.myFx1.stop();
					this.myFx2.stop();
					//this.myFx1.start(1,0);
					if (this.parent._id) this.myFx2.start(this.offsetWidth,0);
					else this.myFx2.start(this.offsetHeight,0);
				} else {
					this.setStyle('left', 'auto');
					//this.myFx1.stop();
					this.myFx2.stop();
					//this.myFx1.start(0,1);
					if (this.parent._id) this.myFx2.start(0,this.mw);
					else this.myFx2.start(0,this.mh);
				}
			},

			init: function() {
				this.mw = this.clientWidth;
				this.mh = this.clientHeight;
				//this.myFx1 = new Fx.Style(this, 'opacity');
				//this.myFx1.set(0);
				if (this.parent._id)
				{
					this.myFx2 = new Fx.Style(this, 'width', {duration: 300});
					this.myFx2.set(0);
				}else{
					this.myFx2 = new Fx.Style(this, 'height', {duration: 300});
					this.myFx2.set(0);
				}
				this.setStyle('left', '-999em');
				animComp = function(){
					if (this.status == 'hide')
					{
						this.setStyle('left', '-999em');
						this.hidding = 0;
					}
					this.setStyle('overflow', '');
				}
				this.myFx2.addEvent ('onComplete', animComp.bind(this));
			},

			hideAll: function() {
				for(var i=0;i<subnav.length; i++) {
					if (!this.isChild(subnav[i]))
					{
						subnav[i].hide(0);
					}
				}
			},

			isChild: function(_obj) {
				obj = this;
				while (obj.parent)
				{
					if (obj._id == _obj._id)
					{
						//alert(_obj._id);
						return true;
					}
					obj = obj.parent;
				}
				return false;
			}


		});
		

		var DropdownMenu = new Class({	
			initialize: function(element)
			{
				//$(element).mh = 0;
				$A($(element).childNodes).each(function(el)
				{
					if(el.nodeName.toLowerCase() == 'li')
					{
						//if($(element)._id) $(element).mh += 30;
						$A($(el).childNodes).each(function(el2)
						{
							if(el2.nodeName.toLowerCase() == 'ul')
							{
								$(el2)._id = subnav.length+1;
								$(el2).parent = $(element);
								subnav.push ($(el2));
								el2.init();
								el.addEvent('mouseover', function()
								{
									el.setActive();
									el2.show(0);
									return false;
								});
		
								el.addEvent('mouseout', function()
								{
									el.setDeactive();
									el2.hide(20);
								});
								new DropdownMenu(el2);
								el.hasSub = 1;
							}
						});
						if (!el.hasSub)
						{
							el.addEvent('mouseover', function()
							{
								el.setActive();
								return false;
							});

							el.addEvent('mouseout', function()
							{
								el.setDeactive();
							});
						}
					}
				});
				return this;
			}
		});
		
		window.addEvent('domready',function() {new DropdownMenu($('ja-cssmenu'))});
	
	}else {
	
		sfHover = function() {
		var sfEls = document.getElementById("ja-cssmenu").getElementsByTagName("li");
		for (var i=0; i<sfEls.length; ++i) {
			sfEls[i].onmouseover=function() {
				this.className+=" sfhover";
			}
			sfEls[i].onmouseout=function() {
				this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
			}
		}
	}
	if (window.attachEvent) window.attachEvent("onload", sfHover);
}
/*
#------------------------------------------------------------------------
  JA Purity II for Joomla 1.5
#------------------------------------------------------------------------
#Copyright (C) 2004-2009 J.O.O.M Solutions Co., Ltd. All Rights Reserved.
#@license - GNU/GPL, http://www.gnu.org/copyleft/gpl.html
#Author: J.O.O.M Solutions Co., Ltd
#Websites: http://www.joomlart.com - http://www.joomlancers.com
#------------------------------------------------------------------------
*/


var JA_Collapse_Mod = new Class({

	initialize: function(myElements) {
		options = Object.extend({
			transition: Fx.Transitions.quadOut
		}, {});
		this.myElements = myElements;
		var exModules = excludeModules.split(',');
		exModules.each(function(el,i){exModules[i]='Mod'+el});
		myElements.each(function(el, i){
			el.elmain = $E('.jamod-content',el);
			el.titleEl = $E('h3',el);
			if(!el.titleEl) return;

			if (exModules.contains(el.id)) {
				el.titleEl.className = '';
				return;
			}

			el.titleEl.className = rightCollapseDefault;
			el.status = rightCollapseDefault;
			el.openH = el.elmain.getStyle('height').toInt();
			el.elmain.setStyle ('overflow','hidden');

			el.titleEl.addEvent('click', function(e){
				e = new Event(e).stop();
				el.toggle();
			});

			el.toggle = function(){
				if (el.status=='hide') el.show();
				else el.hide();
			}

			el.show = function() {
				el.titleEl.className='show';
				var ch = el.elmain.getStyle('height').toInt();
				new Fx.Style(el.elmain,'height',{onComplete:el.toggleStatus}).start(ch,el.openH);
			}
			el.hide = function() {
				el.titleEl.className='hide';
				var ch = (rightCollapseDefault=='hide')?0:el.elmain.getStyle('height').toInt();
				new Fx.Style(el.elmain,'height',{onComplete:el.toggleStatus}).start(ch,0);
			}
			el.toggleStatus = function () {
				el.status=(el.status=='hide')?'show':'hide';
				Cookie.set(el.id,el.status,{duration:365});
			}

			if(!el.titleEl.className) el.titleEl.className=rightCollapseDefault;
			if(el.titleEl.className=='hide') el.hide();
		});
	}
});

window.addEvent ('load', function(e){
	var jamod = new JA_Collapse_Mod ($$('.ja-module'));
});
