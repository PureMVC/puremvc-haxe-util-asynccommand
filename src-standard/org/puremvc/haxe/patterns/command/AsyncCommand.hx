/*
 PureMVC Utility for haXe - AsyncCommand Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright(c) 2008 Duncan Hall <duncan.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.haxe.patterns.command;

import org.puremvc.haxe.interfaces.IAsyncCommand;
import org.puremvc.haxe.patterns.command.SimpleCommand;	 

/**
 * A base [IAsyncCommand] implementation.
 * 
 * <p>Your subclass should override the [execute] 
 * method where your business logic will handle the [INotification].</p>
 */
class AsyncCommand extends SimpleCommand, implements IAsyncCommand 
{
	/**
	 * Registers the callback for a parent [AsyncMacroCommand].  
	 */
	public function setOnComplete( value : Void -> Void ) : Void 
	{ 
		onComplete = value; 
	}
	
	
	/**
	 * Notify the parent [AsyncMacroCommand] that this command is complete.
	 *
	 * <p>Call this method from your subclass to signify that your asynchronous command
	 * has finished.</p>
	 */
	function commandComplete() : Void
	{
		onComplete();
	}
		
	var onComplete : Void -> Void;
	
}
