//$Id: drupalchat.js,v 1.14 2010/07/14 10:34:09 darklrd Exp $
if(Drupal.jsEnabled) {

	var drupalchat = {
			page_title: null,
			on_going_conversation: null,
			on_going_conversation_side: {},
			tab_counter: 0,
			current_user_click: null,
			count_current_user_tab: 0,
			send_current_message: null,
			last_timestamp: 0,
			send_current_uid2: 0,
			total_no_of_tabs: 0,
			attach_messages_in_queue: 0,
			last_processed_messages: {},
			tab_blinking: {},
			blink_tab_ids: {},
			smilies: { /*
				    smiley     image_url          title_text              alt_smilies           */
				    ":)":    [ "1.jpg",           "happy",                ":-)"                 ],
				    ":(":    [ "2.gif",           "sad",                  ":-("                 ],
				    ";)":    [ "3.jpg",           "winking",              ";-)"                 ],
				    ":D":    [ "4.jpg",           "big grin",             ":-D"                 ],
				    "^_^":   [ "5.gif",           "happy eyes"                                  ],
				    ">:o":   [ "6.gif",           "laughing eyes"                               ],
				    ":3":    [ "7.jpg",           "laughing eyes"                               ],
				    ">:-(":  [ "8.gif",           "grumpy"                                      ],
				    ":'(":   [ "9.jpg",           "crying"                                      ],
				    ":o":    [ "10.jpeg",         "shocked",              ":-o"                 ],
				    "8)":    [ "11.jpeg",         "glass",                "8-)"                 ],
				    "8-|":   [ "12.gif",          "cool",                 "8-|"                 ],
				    ":p":    [ "13.gif",          "tongue",               ":-p",":P",":-P"      ],
				    "O.o":   [ "14.gif",          "woot?!"                                      ],
				    "-_-":   [ "15.jpg",          "dark emote"                                  ],
				    ":/":    [ "16.jpg",          "duhhh",                ":-/",":\\",":-\\"    ],
				    ":*":    [ "17.jpg",          "kiss",                 ":-*"                 ],
				    "<3":    [ "18.jpg",          "heart",                                      ],
				    "3:)":   [ "19.gif",          "devil smile"                                 ],
				    "O:)":   [ "20.gif",          "angel"                                       ]
				  },
			blink_tab: function(id) {
				drupalchat.tab_blinking[id] = "1";
				this.blink_tab_ids[id] = setInterval ( function() {
					if($('#drupalchat_tab_uid'+id).hasClass('drupalchat_tabs_user_normal')) {
						$('#drupalchat_tab_uid'+id).removeClass('drupalchat_tabs_user_normal').addClass('drupalchat_tabs_user_alert');
						$('#drupalchat_tab_uid'+id+' > div').removeClass('drupalchat_tabs_user_normal_text').addClass('drupalchat_tabs_user_alert_text');
						setTimeout(function(){
							if($('#drupalchat_tab_uid'+id).hasClass('drupalchat_tabs_user_alert')) {
								$('#drupalchat_tab_uid'+id).removeClass('drupalchat_tabs_user_alert').addClass('drupalchat_tabs_user_normal');
								$('#drupalchat_tab_uid'+id+' > div').removeClass('drupalchat_tabs_user_alert_text').addClass('drupalchat_tabs_user_normal_text');
							}
						},1000);
					}
				}, 2000 );
			},
			handle_cookie: function(name, value, options) {
			    if (typeof value != 'undefined') { // name and value given, set cookie
			        options = options || {};
			        if (value === null) {
			            value = '';
			            options.expires = -1;
			        }
			        var expires = '';
			        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
			            var date;
			            if (typeof options.expires == 'number') {
			                date = new Date();
			                date.setTime(date.getTime() + (options.expires * 1000));
			            } else {
			                date = options.expires;
			            }
			            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
			        }
			        // CAUTION: Needed to parenthesize options.path and options.domain
			        // in the following expressions, otherwise they evaluate to undefined
			        // in the packed version for some reason...
			        var path = options.path ? '; path=' + (options.path) : '';
			        var domain = options.domain ? '; domain=' + (options.domain) : '';
			        var secure = options.secure ? '; secure' : '';
			        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
			    } else { // only name given, get cookie
			        var cookieValue = null;
			        if (document.cookie && document.cookie != '') {
			            var cookies = document.cookie.split(';');
			            for (var i = 0; i < cookies.length; i++) {
			                var cookie = jQuery.trim(cookies[i]);
			                // Does this cookie string begin with the name we want?
			                if (cookie.substring(0, name.length + 1) == (name + '=')) {
			                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
			                    break;
			                }
			            }
			        }
			        return cookieValue;
			    }
			},
			drupalchat_send_message: function() {
				$.post(Drupal.settings.drupalchat.process_messages_url, 
					{
						drupalchat_current_message: 'TRUE', 
				   		drupalchat_uid2: drupalchat.send_current_uid2, 
				   		drupalchat_message: drupalchat.send_current_message 
				   	});
				},
			drupalchat_process_messages_interval: function(interval) {
				setInterval(function() {
					$.post(Drupal.settings.drupalchat.process_messages_url, 
					   {
				   			drupalchat_current_message: 'FALSE',  
				   			drupalchat_last_timestamp: drupalchat.last_timestamp
				   		},
					   function(data) {
				   			var drupalchat_messages  = Drupal.parseJson(data);
				   			if((!drupalchat_messages.status || drupalchat_messages.status == 0)) {
				   				$.each(drupalchat_messages.messages, function(index, value) {
				   					//Add div if required.
				   					drupalchat.count_current_user_tab = 0;
				   					$('#drupalchat_tab_receive_text_messages_region > div').each(function() {
				   						if($(this).attr('id') == 'drupalchat_conversation_'+value.uid1) {
				   							drupalchat.count_current_user_tab++;
				   						}
				   					});
				   					if (drupalchat.count_current_user_tab == 0)	{
				   						$('#drupalchat_tab_receive_text_messages_region').append('<div id="drupalchat_conversation_'+value.uid1+'" style="display: none;"></div>');
				   					}
				   					//Insert tab at the bottom bar.
				   					drupalchat.tab_counter = 0;
				   					$('#drupalchat_tabs_block > div').each(function() {
				   						if($(this).attr('id') == 'drupalchat_tab_uid'+value.uid1) {
				   							drupalchat.tab_counter++;
				   						}
				   					});
				   					if(drupalchat.tab_counter==0) {
				   						$('#drupalchat_tabs_block').append('<div id="drupalchat_tab_uid'+value.uid1+'" class="drupalchat_tabs_user_normal"><div class="drupalchat_tabs_user_normal_text">'+value.name+'</div></div>');
				   						drupalchat.total_no_of_tabs++;
				   					}
				   					value.message = value.message.replace(/{{drupalchat_newline}}/g,"<br />");
				   					value.message = emotify(value.message);
				   					//Add message.
				   					if(drupalchat.last_timestamp < value.timestamp) {
				   						if($('#drupalchat_conversation_'+value.uid1+' > div').size()%2==0) {
				   							if(drupalchat.on_going_conversation_side[value.uid1] == 'me' || drupalchat.on_going_conversation_side[value.uid1] == null) {
				   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_even"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_user"><div class="drupalchat_receive_text_messages_user_user_text">'+value.name+'</div><div class="drupalchat_receive_text_messages_user_separator"></div><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
				   							}
				   							else {
				   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_even"><div id="drupalchat_receive_text_messages_user_more"><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
				   							}
				   						}
				   						else {
				   							if(drupalchat.on_going_conversation_side[value.uid1] == 'me' || drupalchat.on_going_conversation_side[value.uid1] == null) {
				   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_odd"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_user"><div class="drupalchat_receive_text_messages_user_user_text">'+value.name+'</div><div class="drupalchat_receive_text_messages_user_separator"></div><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
				   							}
				   							else {
				   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_odd"><div id="drupalchat_receive_text_messages_user_more"><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
				   							}
				   						}
				   						drupalchat.on_going_conversation_side[value.uid1] = 'user';
				   						$("#drupalchat_tab_receive_text_messages").attr({ scrollTop: $("#drupalchat_tab_receive_text_messages").attr("scrollHeight") });
				   					}
				   					//Alert user
				   					if((drupalchat.on_going_conversation != value.uid1) && (drupalchat.tab_blinking[value.uid1]!= "1")) {
				   						drupalchat.blink_tab(value.uid1);
				   					}
				   					//Check timestamp.
					   				/*if(drupalchat.last_timestamp < value.timestamp) {
					   					drupal.last_timestamp = value.timestamp;
					   					//alert(value.timestamp);
					   				}*/
				   				});
				   				
				   				$('#drupalchat_chat_window_users_region').html('');
								  $.each(drupalchat_messages.online, function(key, value) { 
									  if (key!="total") {
										  $('#drupalchat_chat_window_users_region').append('<div id="drupalchat_uid'+key+'" class="drupalchat_chat_window_users_user_normal"><div class="drupalchat_chat_window_users_user_normal_text">'+value+'</div></div>');
									  }
									  else {
										  $('#drupalchat_bar_tab_online_users > div > div').html('Chat ('+drupalchat_messages.online.total+')');
										  //$('#drupalchat_bar_tab_online_users > div > div').html('Chat/Memory Usage ('+drupalchat_messages.online.total+')');
									  }
									});
				   					
				   				//alert(drupalchat_messages.last_timestamp);
								//Update Timestamp.
					   			drupalchat.last_timestamp = drupalchat_messages.last_timestamp;  
				   			}
				  
				   /*var drupalchat_users_list  = Drupal.parseJson(data);
				  $('#drupalchat_chat_window_users_region').html('');
				  $.each(drupalchat_users_list.online, function(key, value) { 
					  if (key!="total") {
						  $('#drupalchat_chat_window_users_region').append('<div id="uid'+key+'" class="drupalchat_chat_window_users_user_normal"><div class="drupalchat_chat_window_users_user_normal_text">'+value+'</div></div>');
					  }
					  else {
						  $('#drupalchat_bar_tab_online_users > div > div').html('Chat ('+drupalchat_users_list.online.total+')');
					  }
					});*/
			   });
		}, interval);
		},
		drupalchat_process_messages_long_interval: function() {
				$.post(Drupal.settings.drupalchat.process_messages_url, 
				   {
			   			drupalchat_current_message: 'FALSE',  
			   			drupalchat_last_timestamp: drupalchat.last_timestamp
			   		},
				   function(data) {
			   			var drupalchat_messages  = Drupal.parseJson(data);
			   			if((!drupalchat_messages.status || drupalchat_messages.status == 0)) {
			   				$.each(drupalchat_messages.messages, function(index, value) {
			   					//Add div if required.
			   					drupalchat.count_current_user_tab = 0;
			   					$('#drupalchat_tab_receive_text_messages_region > div').each(function() {
			   						if($(this).attr('id') == 'drupalchat_conversation_'+value.uid1) {
			   							drupalchat.count_current_user_tab++;
			   						}
			   					});
			   					if (drupalchat.count_current_user_tab == 0)	{
			   						$('#drupalchat_tab_receive_text_messages_region').append('<div id="drupalchat_conversation_'+value.uid1+'" style="display: none;"></div>');
			   					}
			   					//Insert tab at the bottom bar.
			   					drupalchat.tab_counter = 0;
			   					$('#drupalchat_tabs_block > div').each(function() {
			   						if($(this).attr('id') == 'drupalchat_tab_uid'+value.uid1) {
			   							drupalchat.tab_counter++;
			   						}
			   					});
			   					if(drupalchat.tab_counter==0) {
			   						$('#drupalchat_tabs_block').append('<div id="drupalchat_tab_uid'+value.uid1+'" class="drupalchat_tabs_user_normal"><div class="drupalchat_tabs_user_normal_text">'+value.name+'</div></div>');
			   						drupalchat.total_no_of_tabs++;
			   					}
			   					value.message = value.message.replace(/{{drupalchat_newline}}/g,"<br />");
			   					value.message = emotify(value.message);
			   					//Add message.
			   					if(drupalchat.last_timestamp < value.timestamp) {
			   						if($('#drupalchat_conversation_'+value.uid1+' > div').size()%2==0) {
			   							if(drupalchat.on_going_conversation_side[value.uid1] == 'me' || drupalchat.on_going_conversation_side[value.uid1] == null) {
			   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_even"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_user"><div class="drupalchat_receive_text_messages_user_user_text">'+value.name+'</div><div class="drupalchat_receive_text_messages_user_separator"></div><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
			   							}
			   							else {
			   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_even"><div id="drupalchat_receive_text_messages_user_more"><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
			   							}
			   						}
			   						else {
			   							if(drupalchat.on_going_conversation_side[value.uid1] == 'me' || drupalchat.on_going_conversation_side[value.uid1] == null) {
			   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_odd"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_user"><div class="drupalchat_receive_text_messages_user_user_text">'+value.name+'</div><div class="drupalchat_receive_text_messages_user_separator"></div><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
			   							}
			   							else {
			   								$('#drupalchat_conversation_'+value.uid1).append('<div class="drupalchat_receive_text_messages_message_odd"><div id="drupalchat_receive_text_messages_user_more"><div class="drupalchat_receive_text_messages_user_message">'+value.message+'</div></div></div>');
			   							}
			   						}
			   						drupalchat.on_going_conversation_side[value.uid1] = 'user';
			   						$("#drupalchat_tab_receive_text_messages").attr({ scrollTop: $("#drupalchat_tab_receive_text_messages").attr("scrollHeight") });
			   					}
			   					//Alert user
			   					if((drupalchat.on_going_conversation != value.uid1) && (drupalchat.tab_blinking[value.uid1]!= "1")) {
			   						drupalchat.blink_tab(value.uid1);
			   					}
			   					//Check timestamp.
				   				/*if(drupalchat.last_timestamp < value.timestamp) {
				   					drupal.last_timestamp = value.timestamp;
				   					//alert(value.timestamp);
				   				}*/
			   				});
			   				
			   				$('#drupalchat_chat_window_users_region').html('');
							  $.each(drupalchat_messages.online, function(key, value) { 
								  if (key!="total") {
									  $('#drupalchat_chat_window_users_region').append('<div id="drupalchat_uid'+key+'" class="drupalchat_chat_window_users_user_normal"><div class="drupalchat_chat_window_users_user_normal_text">'+value+'</div></div>');
								  }
								  else {
									  $('#drupalchat_bar_tab_online_users > div > div').html('Chat ('+drupalchat_messages.online.total+')');
									  //$('#drupalchat_bar_tab_online_users > div > div').html('Chat/Memory Usage ('+drupalchat_messages.online.total+')');
								  }
								});
			   					
			   				//alert(drupalchat_messages.last_timestamp);
							//Update Timestamp.
				   			drupalchat.last_timestamp = drupalchat_messages.last_timestamp;  
			   			}
			  
			   /*var drupalchat_users_list  = Drupal.parseJson(data);
			  $('#drupalchat_chat_window_users_region').html('');
			  $.each(drupalchat_users_list.online, function(key, value) { 
				  if (key!="total") {
					  $('#drupalchat_chat_window_users_region').append('<div id="uid'+key+'" class="drupalchat_chat_window_users_user_normal"><div class="drupalchat_chat_window_users_user_normal_text">'+value+'</div></div>');
				  }
				  else {
					  $('#drupalchat_bar_tab_online_users > div > div').html('Chat ('+drupalchat_users_list.online.total+')');
				  }
				});*/
			   			drupalchat.drupalchat_process_messages_long_interval();
		   });
	}
};

$(document).ready(function() {
if(Drupal.settings.drupalchat.uid != "0") {
	drupalchat.page_title = $(document).attr('title');
	drupalchat.last_timestamp = Drupal.settings.drupalchat.current_timestamp;
	$('#drupalchat_bar').width($(window).width()-32);
	$('#drupalchat_bar_background').width($(window).width()-32);
	$('#drupalchat_bar_tab_online_users').mouseover(function() {
		$('#drupalchat_bar_tab_online_users > .drupalchat_bar_tab_normal').removeClass("drupalchat_bar_tab_normal").addClass("drupalchat_bar_tab_over");
		$('#drupalchat_bar_tab_online_users > div > .drupalchat_bar_tab_normal_text').removeClass("drupalchat_bar_tab_normal_text").addClass("drupalchat_bar_tab_over_text");
	});
	$('#drupalchat_bar_tab_online_users').mouseout(function() {
		$('#drupalchat_bar_tab_online_users > .drupalchat_bar_tab_over').removeClass("drupalchat_bar_tab_over").addClass("drupalchat_bar_tab_normal");
		$('#drupalchat_bar_tab_online_users > div > .drupalchat_bar_tab_over_text').removeClass("drupalchat_bar_tab_over_text").addClass("drupalchat_bar_tab_normal_text");
	});
	$('#drupalchat_bar_tab_exit').hover(function() {
		$('#drupalchat_bar_tab_exit > div').removeClass("drupalchat_bar_tab_exit_normal").addClass("drupalchat_bar_tab_exit_over");
		$('#drupalchat_bar_tab_exit > div > div').removeClass("drupalchat_bar_tab_exit_normal_text").addClass("drupalchat_bar_tab_exit_over_text");
	}, function() {
		$('#drupalchat_bar_tab_exit > div').removeClass("drupalchat_bar_tab_exit_over").addClass("drupalchat_bar_tab_exit_normal");
		$('#drupalchat_bar_tab_exit > div > div').removeClass("drupalchat_bar_tab_exit_over_text").addClass("drupalchat_bar_tab_exit_normal_text");
	});
	$('#drupalchat_bar_tab_exit').click(function() {
		$('#drupalchat').hide();
		$('#drupalchat_show').show();
	});
	$('#drupalchat_show').hover(function() {
		$('#drupalchat_show > div').removeClass("drupalchat_show_normal").addClass("drupalchat_show_over");
		$('#drupalchat_show > div > div').removeClass("drupalchat_show_normal_text").addClass("drupalchat_show_over_text");
	}, function() {
		$('#drupalchat_show > div').removeClass("drupalchat_show_over").addClass("drupalchat_show_normal");
		$('#drupalchat_show > div > div').removeClass("drupalchat_show_over_text").addClass("drupalchat_show_normal_text");
	});
	$('#drupalchat_show').click(function() {
		$('#drupalchat_show').hide();
		$('#drupalchat').show();
	});
	$('#drupalchat_bar_tab_online_users').click(function() {
		
		if ($('#drupalchat_bar_tab_online_users > div').hasClass("drupalchat_bar_tab_over")) {
			$('#drupalchat_bar_tab_online_users > .drupalchat_bar_tab_over').removeClass("drupalchat_bar_tab_over").addClass("drupalchat_bar_tab_open_over");
			$('#drupalchat_bar_tab_online_users > div > .drupalchat_bar_tab_over_text').removeClass("drupalchat_bar_tab_over_text").addClass("drupalchat_bar_tab_open_over_text");
			$('#drupalchat_chat_window_online_users').css('display', 'block');
		}
		else if ($('#drupalchat_bar_tab_online_users > div').hasClass("drupalchat_bar_tab_open_over")) {
			$('#drupalchat_bar_tab_online_users > .drupalchat_bar_tab_open_over').removeClass("drupalchat_bar_tab_open_over").addClass("drupalchat_bar_tab_over");
			$('#drupalchat_bar_tab_online_users > div > .drupalchat_bar_tab_open_over_text').removeClass("drupalchat_bar_tab_over_open_text").addClass("drupalchat_bar_tab_over_text");
			$('#drupalchat_chat_window_online_users').hide();
		}
	});
	$('#drupalchat_chat_window_users_region > div').live('mouseover',function() {
		if('drupalchat_uid'+Drupal.settings.drupalchat.uid != $(this).attr('id')) {
			$(this).removeClass("drupalchat_chat_window_users_user_normal").addClass("drupalchat_chat_window_users_user_over");
			$(this).find('div').removeClass("drupalchat_chat_window_users_user_normal_text").addClass("drupalchat_chat_window_users_user_over_text");
		}
	});
	$('#drupalchat_chat_window_users_region > div').live('mouseout',function() {
		if('drupalchat_uid'+Drupal.settings.drupalchat.uid != $(this).attr('id')) {
			$(this).removeClass("drupalchat_chat_window_users_user_over").addClass("drupalchat_chat_window_users_user_normal");
			$(this).find('div').removeClass("drupalchat_chat_window_users_user_over_text").addClass("drupalchat_chat_window_users_user_normal_text");
		}
	});
	$('#drupalchat_chat_window_users_region > div').live('click',function() {
		if('drupalchat_uid'+Drupal.settings.drupalchat.uid != $(this).attr('id')) {
		drupalchat.current_user_click = $(this).attr('id');
		//Add tab if required.
		drupalchat.count_current_user_tab = 0;
		$('#drupalchat_tabs_block > div').each(function() {
				if($(this).attr('id') == 'drupalchat_tab_uid'+drupalchat.current_user_click.split('drupalchat_uid')[1]) {
					drupalchat.count_current_user_tab++;
				}	
			});
		//alert(drupalchat.count_current_user_tab+drupalchat.current_user_click);
		if (drupalchat.count_current_user_tab == 0)	{
			$('#drupalchat_tabs_block').append('<div id="drupalchat_tab_uid'+drupalchat.current_user_click.split('drupalchat_uid')[1]+'" class="drupalchat_tabs_user_normal"><div class="drupalchat_tabs_user_normal_text">'+$(this).find('div').html()+'</div></div>');
			drupalchat.total_no_of_tabs++;
		}
		
		$('#drupalchat_tab_uid'+drupalchat.current_user_click.split('drupalchat_uid')[1]).trigger('click');
		/*drupalchat.on_going_conversation = drupalchat.current_user_click[14];
		
		$('#drupalchat_tab_window').css('right','244px');
		$('#drupalchat_tab_window').css('display','block');
		//Add div if needed.
		drupalchat.count_current_user_tab = 0;
		$('#drupalchat_tab_receive_text_messages_region > div').each(function() {
				
				if($(this).attr('id') == 'drupalchat_conversation_'+drupalchat.on_going_conversation) {
					drupalchat.count_current_user_tab++;
				}
			});
			if (drupalchat.count_current_user_tab == 0)	{
				$('#drupalchat_tab_receive_text_messages_region').append('<div id="drupalchat_conversation_'+drupalchat.on_going_conversation+'"></div>');
				$("div[id^=drupalchat_conversation_]").hide(function () {
					$('#drupalchat_conversation_'+drupalchat.on_going_conversation).show();
				});
			}
			drupalchat.count_current_user_tab = 0;
			*/
		}	
	});
	$('#drupalchat_tabs_block > div').live('click', function() {	
		drupalchat.current_user_click=$(this).attr('id');
		drupalchat.count_current_user_tab = 0;
		$('#drupalchat_tab_receive_text_messages_region > div').each(function() {
			if($(this).attr('id') == 'drupalchat_conversation_'+drupalchat.current_user_click.split('drupalchat_tab_uid')[1]) {
				drupalchat.count_current_user_tab++;
			}
		});
		if (drupalchat.count_current_user_tab == 0)	{
			$('#drupalchat_tab_receive_text_messages_region').append('<div id="drupalchat_conversation_'+drupalchat.current_user_click.split('drupalchat_tab_uid')[1]+'" style="display: none;"></div>');
		}
		
		$("div[id^=drupalchat_conversation_]").each(function() {
			$(this).hide();
		});
		$('#drupalchat_conversation_'+drupalchat.current_user_click.split('drupalchat_tab_uid')[1]).show();
		
		//Chat pop-up window placement.
		//(($('#drupalchat_tabs_block > div').index(this))*159+244);
		$('#drupalchat_tab_window').css('right',(($('#drupalchat_tabs_block > div').index(this))*136+244)+'px');
		if($(this).attr('id') == ('drupalchat_tab_uid'+drupalchat.on_going_conversation)) {
			$('#drupalchat_tab_window').toggle();
		}
		else {
			$('#drupalchat_tab_window').show();
			$('#drupalchat_tab_window_head_text').html($(this).find('div').html());
		}
		drupalchat.on_going_conversation = drupalchat.current_user_click.split('drupalchat_tab_uid')[1];
		if(drupalchat.tab_blinking[drupalchat.on_going_conversation] == "1") {
			clearInterval(drupalchat.blink_tab_ids[drupalchat.on_going_conversation]);
			drupalchat.tab_blinking[drupalchat.on_going_conversation] = "0";
		}
		
		if($('#drupalchat_tab_window').css('display') == 'none') {
			drupalchat.on_going_conversation = null;
		}
		
	});
	$('#drupalchat_tab_send_input_text').keypress(function(ev) {
		if(ev.which == 13) {
			ev.preventDefault();
			if(Drupal.settings.drupalchat.polling_method == '0') {
				drupalchat.send_current_uid2 = drupalchat.on_going_conversation;
				if(drupalchat.attach_messages_in_queue == 0) {
					//Send message.
					setTimeout(function() { 
						drupalchat.drupalchat_send_message();
						drupalchat.attach_messages_in_queue = 0;
					}, (Drupal.settings.drupalchat.send_rate)*1000);
			
					drupalchat.send_current_message = ($(this).val());
					drupalchat.attach_messages_in_queue = 1;
				}
				else {
					drupalchat.send_current_message = drupalchat.send_current_message + '{{drupalchat_newline}}' + ($(this).val());
				}
				$(this).val(emotify($(this).val()));
				//Add message.
				if($('#drupalchat_conversation_'+drupalchat.send_current_uid2+' > div').size()%2==0) {
					if(drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == 'user' || drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == null) {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_even"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_me"><div class="drupalchat_receive_text_messages_me_user">'+Drupal.settings.drupalchat.username+'</div><div class="drupalchat_receive_text_messages_me_separator"></div><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
					else {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_even"><div id="drupalchat_receive_text_messages_me_more"><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
				}
				else {
					if(drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == 'user' || drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == null) {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_odd"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_me"><div class="drupalchat_receive_text_messages_me_user">'+Drupal.settings.drupalchat.username+'</div><div class="drupalchat_receive_text_messages_me_separator"></div><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
					else {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_odd"><div id="drupalchat_receive_text_messages_me_more"><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
				}
				drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] = 'me';
				$('#drupalchat_tab_send_input_text').val('');
				$("#drupalchat_tab_receive_text_messages").attr({ scrollTop: $("#drupalchat_tab_receive_text_messages").attr("scrollHeight") });
			
			}
			else {
				
				drupalchat.send_current_uid2 = drupalchat.on_going_conversation;
				drupalchat.send_current_message = ($(this).val());
				//Send message.
				drupalchat.drupalchat_send_message();
				
				$(this).val(emotify($(this).val()));
				//Add message.
				if($('#drupalchat_conversation_'+drupalchat.send_current_uid2+' > div').size()%2==0) {
					if(drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == 'user' || drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == null) {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_even"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_me"><div class="drupalchat_receive_text_messages_me_user">'+Drupal.settings.drupalchat.username+'</div><div class="drupalchat_receive_text_messages_me_separator"></div><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
					else {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_even"><div id="drupalchat_receive_text_messages_me_more"><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
				}
				else {
					if(drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == 'user' || drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] == null) {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_odd"><div class="drupalchat_receive_text_messages_separator"></div><div id="drupalchat_receive_text_messages_me"><div class="drupalchat_receive_text_messages_me_user">'+Drupal.settings.drupalchat.username+'</div><div class="drupalchat_receive_text_messages_me_separator"></div><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
					else {
						$('#drupalchat_conversation_'+drupalchat.send_current_uid2).append('<div class="drupalchat_receive_text_messages_message_odd"><div id="drupalchat_receive_text_messages_me_more"><div class="drupalchat_receive_text_messages_me_message">'+$(this).val()+'</div></div></div>');
					}
				}
				drupalchat.on_going_conversation_side[drupalchat.send_current_uid2] = 'me';
				$('#drupalchat_tab_send_input_text').val('');
				$("#drupalchat_tab_receive_text_messages").attr({ scrollTop: $("#drupalchat_tab_receive_text_messages").attr("scrollHeight") });
			}
		}
	});
	$("div[class^=drupalchat_tab_window_head_buttons_exit_]").hover(function() {
		$(this).removeClass('drupalchat_tab_window_head_buttons_exit_normal').addClass('drupalchat_tab_window_head_buttons_exit_over');
		$(this).find('div').removeClass('drupalchat_tab_window_head_buttons_exit_normal_text').addClass('drupalchat_tab_window_head_buttons_exit_over_text');
	}, function() {
		$(this).removeClass('drupalchat_tab_window_head_buttons_exit_over').addClass('drupalchat_tab_window_head_buttons_exit_normal');
		$(this).find('div').removeClass('drupalchat_tab_window_head_buttons_exit_over_text').addClass('drupalchat_tab_window_head_buttons_exit_normal_text');
	});
	$("div[class^=drupalchat_tab_window_head_buttons_exit_]").hover(function() {
		$(this).removeClass('drupalchat_tab_window_head_buttons_exit_normal').addClass('drupalchat_tab_window_head_buttons_exit_over');
		$(this).find('div').removeClass('drupalchat_tab_window_head_buttons_exit_normal_text').addClass('drupalchat_tab_window_head_buttons_exit_over_text');
	}, function() {
		$(this).removeClass('drupalchat_tab_window_head_buttons_exit_over').addClass('drupalchat_tab_window_head_buttons_exit_normal');
		$(this).find('div').removeClass('drupalchat_tab_window_head_buttons_exit_over_text').addClass('drupalchat_tab_window_head_buttons_exit_normal_text');
	});
	$("div[class^=drupalchat_tab_window_head_buttons_minimize_]").hover(function() {
		$(this).removeClass('drupalchat_tab_window_head_buttons_minimize_normal').addClass('drupalchat_tab_window_head_buttons_minimize_over');
		$(this).find('div').removeClass('drupalchat_tab_window_head_buttons_minimize_normal_text').addClass('drupalchat_tab_window_head_buttons_minimize_over_text');
	}, function() {
		$(this).removeClass('drupalchat_tab_window_head_buttons_minimize_over').addClass('drupalchat_tab_window_head_buttons_minimize_normal');
		$(this).find('div').removeClass('drupalchat_tab_window_head_buttons_minimize_over_text').addClass('drupalchat_tab_window_head_buttons_minimize_normal_text');
	});
	$(".drupalchat_tabs_user_normal").live('mouseover', function() {
		$(this).removeClass('drupalchat_tabs_user_normal').addClass('drupalchat_tabs_user_over');
		$(this).find('div').removeClass('drupalchat_tabs_user_normal_text').addClass('drupalchat_tabs_user_over_text');
	});
	$(".drupalchat_tabs_user_over").live('mouseout', function() {
		$(this).removeClass('drupalchat_tabs_user_over').addClass('drupalchat_tabs_user_normal');
		$(this).find('div').removeClass('drupalchat_tabs_user_over_text').addClass('drupalchat_tabs_user_normal_text');
	});
	$('#drupalchat_tab_window_head_buttons .drupalchat_tab_window_head_buttons_minimize_over').live('click', function() {
		$('#drupalchat_tab_window').hide();
		$('#drupalchat_tab_uid'+drupalchat.on_going_conversation).removeClass('drupalchat_tabs_user_open_normal').addClass('drupalchat_tabs_user_normal');
		$('#drupalchat_tab_uid'+drupalchat.on_going_conversation).find('div').removeClass('drupalchat_tabs_user_open_normal_text').addClass('drupalchat_tabs_user_normal_text');
		drupalchat.on_going_conversation = null;
	});
	
	$('#drupalchat_tab_window_head_buttons .drupalchat_tab_window_head_buttons_exit_over').live('click', function() {
		$('#drupalchat_tab_window').hide();
		$('#drupalchat_conversation_'+drupalchat.on_going_conversation).hide();
		$('#drupalchat_tab_uid'+drupalchat.on_going_conversation).remove();
		drupalchat.on_going_conversation = null;
	});
	
	$("#drupalchat_tabs_block  .drupalchat_tabs_user_over").live('click', function() {
		$("div[class$=drupalchat_tabs_user_open_normal]").removeClass('drupalchat_tabs_user_open_normal').addClass('drupalchat_tabs_user_normal');
		$("div[class$=drupalchat_tabs_user_open_normal_text]").removeClass('drupalchat_tabs_user_open_normal_text').addClass('drupalchat_tabs_user_normal_text');
		$(this).removeClass('drupalchat_tabs_user_over').addClass('drupalchat_tabs_user_open_over');
		$(this).find('div').removeClass('drupalchat_tabs_user_over_text').addClass('drupalchat_tabs_user_open_over_text');
	});
	
	$("#drupalchat_tabs_block  .drupalchat_tabs_user_normal").live('click', function() {
		$("div[class$=drupalchat_tabs_user_open_normal]").removeClass('drupalchat_tabs_user_open_normal').addClass('drupalchat_tabs_user_normal');
		$("div[class$=drupalchat_tabs_user_open_normal_text]").removeClass('drupalchat_tabs_user_open_normal_text').addClass('drupalchat_tabs_user_normal_text');
		$(this).removeClass('drupalchat_tabs_user_normal').addClass('drupalchat_tabs_user_open_normal');
		$(this).find('div').removeClass('drupalchat_tabs_user_normal_text').addClass('drupalchat_tabs_user_open_normal_text');
	});
	
	$("#drupalchat_tabs_block .drupalchat_tabs_user_open_over").live('click', function() {
		$(this).removeClass('drupalchat_tabs_user_open_over').addClass('drupalchat_tabs_user_over');
		$(this).find('div').removeClass('drupalchat_tabs_user_open_over_text').addClass('drupalchat_tabs_user_over_text');
	});
	
	$("#drupalchat_tabs_block .drupalchat_tabs_user_open_normal").live('click', function() {
		$(this).removeClass('drupalchat_tabs_user_open_normal').addClass('drupalchat_tabs_user_normal');
		$(this).find('div').removeClass('drupalchat_tabs_user_open_normal_text').addClass('drupalchat_tabs_user_normal_text');
	});
	
	$("#drupalchat_tabs_block .drupalchat_tabs_user_open_normal").live('mouseover', function() {
		$(this).removeClass('drupalchat_tabs_user_open_normal').addClass('drupalchat_tabs_user_open_over');
		$(this).find('div').removeClass('drupalchat_tabs_user_open_normal_text').addClass('drupalchat_tabs_user_open_over_text');
	});
	
	$("#drupalchat_tabs_block .drupalchat_tabs_user_open_over").live('mouseout', function() {
		$(this).removeClass('drupalchat_tabs_user_open_over').addClass('drupalchat_tabs_user_open_normal');
		$(this).find('div').removeClass('drupalchat_tabs_user_open_over_text').addClass('drupalchat_tabs_user_open_normal_text');
	});
	
	$("#drupalchat_tabs_block .drupalchat_tabs_user_alert").live('mouseover', function() {
		$(this).removeClass('drupalchat_tabs_user_alert').addClass('drupalchat_tabs_user_over');
		$(this).find('div').removeClass('drupalchat_tabs_user_alert_text').addClass('drupalchat_tabs_user_over_text');
	});
	
	$("#drupalchat_tabs_block .drupalchat_tabs_user_alert").live('click', function() {
		$(this).removeClass('drupalchat_tabs_user_alert').addClass('drupalchat_tabs_user_open_normal');
		$(this).find('div').removeClass('drupalchat_tabs_user_alert_text').addClass('drupalchat_tabs_user_open_normal_text');
	});
	
	/*$('#drupalchat_chat_window_users_region > div > div').live('mouseover',function() {
		$(this).removeClass("drupalchat_chat_window_users_user_normal_text").addClass("drupalchat_chat_window_users_user_over_text");
	});
	$('#drupalchat_chat_window_users_region > div > div').live('mouseout',function() {
		$(this).removeClass("drupalchat_chat_window_users_user_over_text").addClass("drupalchat_chat_window_users_user_normal_text");
	});*/
/*if (screen.width>=1280) {
	$('#drupalchat_bar').width(1248);
	$('#drupalchat_bar_background').width(1248);
}
else if(screen.width==1024) {
	
	$('#drupalchat_bar').width(975);
	$('#drupalchat_bar_background').width(975);
}
else if(screen.width==800) {
	//alert($(window).width());
	$('#drupalchat_bar').width(751);
	$('#drupalchat_bar_background').width(751);
}
else {
	alert($(window).width());
	$('#drupalchat_bar').width(1193);
	$('#drupalchat_bar_background').width(1193);
}	
*/
	//Load smileys.
	emotify.emoticons( Drupal.settings.drupalchat.smileys_url, drupalchat.smilies );
	//Load previous state if coming from a previous page.
	$.post(Drupal.settings.drupalchat.load_messages_url,{},function(data) {
		data = data.split("{{drupalchat_break}}");
		if(data[0] && data[0].length > 0) {
			$('#drupalchat_tabs_block').html(data[0]);
			$('#drupalchat_tabs_block .drupalchat_tabs_user_alert').removeClass('drupalchat_tabs_user_alert').addClass('drupalchat_tabs_user_normal');
			$('#drupalchat_tabs_block .drupalchat_tabs_user_alert_text').removeClass('drupalchat_tabs_user_alert_text').addClass('drupalchat_tabs_user_normal_text');
		}
		if(data[1] && data[1].length > 0) {
			$('#drupalchat_tab_receive_text_messages_region').html(data[1]);
		}
		if(drupalchat.handle_cookie("drupalchat_on_going_conversation") != null) {
			drupalchat.on_going_conversation = drupalchat.handle_cookie("drupalchat_on_going_conversation");
			if(($('#drupalchat_tabs_block > div').index($('#drupalchat_tab_uid'+drupalchat.on_going_conversation))) > -1) {
				$('#drupalchat_tab_window').css('right',(($('#drupalchat_tabs_block > div').index($('#drupalchat_tab_uid'+drupalchat.on_going_conversation)))*136+244)+'px');
				$('#drupalchat_tab_window').show();
			}
		}
		if(drupalchat.handle_cookie("drupalchat_tab_window_head_text") != null) {
			$('#drupalchat_tab_window_head_text').html(drupalchat.handle_cookie("drupalchat_tab_window_head_text"));
		}
		if(drupalchat.handle_cookie("drupalchat_chat_window_online_users") != null) {
			$('#drupalchat_chat_window_online_users').css('display',drupalchat.handle_cookie("drupalchat_chat_window_online_users"));
			if (drupalchat.handle_cookie("drupalchat_chat_window_online_users") == 'block') {
				$('#drupalchat_bar_tab_online_users > .drupalchat_bar_tab_normal').removeClass("drupalchat_bar_tab_normal").addClass("drupalchat_bar_tab_open_over");
				$('#drupalchat_bar_tab_online_users > div > .drupalchat_bar_tab_normal_text').removeClass("drupalchat_bar_tab_normal_text").addClass("drupalchat_bar_tab_open_over_text");
				$('#drupalchat_chat_window_online_users').css('display', 'block');
			}
		}
	});
	/*if(drupalchat.handle_cookie("drupalchat_tabs") != null) {
		$('#drupalchat_tabs_block').html(drupalchat.handle_cookie("drupalchat_tabs"));	
		$(this).removeClass('drupalchat_tabs_user_alert').addClass('drupalchat_tabs_user_normal');
		$(this).find('div').removeClass('drupalchat_tabs_user_alert_text').addClass('drupalchat_tabs_user_normal_text');
	
	}
	if(drupalchat.handle_cookie("drupalchat_conversations") != null) {
		$('#drupalchat_tab_receive_text_messages_region').html(drupalchat.handle_cookie("drupalchat_conversations"));
	}*/
	/*if(drupalchat.handle_cookie("drupalchat_on_going_conversation") != null) {
		drupalchat.on_going_conversation = drupalchat.handle_cookie("drupalchat_on_going_conversation");
		if(($('#drupalchat_tabs_block > div').index($('#drupalchat_tab_uid'+drupalchat.on_going_conversation))) > -1) {
			$('#drupalchat_tab_window').css('right',(($('#drupalchat_tabs_block > div').index($('#drupalchat_tab_uid'+drupalchat.on_going_conversation)))*136+244)+'px');
			$('#drupalchat_tab_window').show();
		}
	}
	if(drupalchat.handle_cookie("drupalchat_tab_window_head_text") != null) {
		$('#drupalchat_tab_window_head_text').html(drupalchat.handle_cookie("drupalchat_tab_window_head_text"));
	}*/
	//Get user list and new messages.
	drupalchat.last_processed_messages.messages = {};
	if(Drupal.settings.drupalchat.polling_method == '0') {
		drupalchat.drupalchat_process_messages_interval((Drupal.settings.drupalchat.refresh_rate)*1000);
	}
	else {
		drupalchat.drupalchat_process_messages_long_interval();
	}
	/*if(drupalchat.handle_cookie("drupalchat_chat_window_online_users") != null) {
		$('#drupalchat_chat_window_online_users').css('display',drupalchat.handle_cookie("drupalchat_chat_window_online_users"));
		if (drupalchat.handle_cookie("drupalchat_chat_window_online_users") == 'block') {
			$('#drupalchat_bar_tab_online_users > .drupalchat_bar_tab_normal').removeClass("drupalchat_bar_tab_normal").addClass("drupalchat_bar_tab_open_over");
			$('#drupalchat_bar_tab_online_users > div > .drupalchat_bar_tab_normal_text').removeClass("drupalchat_bar_tab_normal_text").addClass("drupalchat_bar_tab_open_over_text");
			$('#drupalchat_chat_window_online_users').css('display', 'block');
		}
	}*/
	
	$(window).unload(function (){
		/*drupalchat.handle_cookie("drupalchat_tabs", $('#drupalchat_tabs_block').html(),{ path: '/'});
		drupalchat.handle_cookie("drupalchat_conversations",$('#drupalchat_tab_receive_text_messages_region').html(),{ path: '/'});*/
		/*alert(Drupal.settings.drupalchat.store_messages_url);
		$.post(Drupal.settings.drupalchat.store_messages_url, 
				{
					drupalchat_tabs_content: $('#drupalchat_tabs_block').html(), 
					drupalchat_conversations_content: $('#drupalchat_tab_receive_text_messages_region').html() 
			   	},function(data) {alert('done');});*/
		$.ajax({
	        type: "POST",
	        url: Drupal.settings.drupalchat.store_messages_url,
	        data: "drupalchat_tabs_content="+$('#drupalchat_tabs_block').html()+"&drupalchat_conversations_content="+$('#drupalchat_tab_receive_text_messages_region').html(),
	        success: function(data){
				
	        },
	        async: false
		});
		drupalchat.handle_cookie("drupalchat_on_going_conversation",drupalchat.on_going_conversation,{ path: '/', expires: 10});
		drupalchat.handle_cookie("drupalchat_tab_window_head_text", $('#drupalchat_tab_window_head_text').html(),{ path: '/', expires: 10});
		drupalchat.handle_cookie("drupalchat_chat_window_online_users", $('#drupalchat_chat_window_online_users').css('display'),{ path: '/', expires: 10});
	});
  }	   
});
}
