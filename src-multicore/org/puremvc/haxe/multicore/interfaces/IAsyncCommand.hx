/*
 PureMVC MultiCore Utility for haXe - AsyncCommand Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright(c) 2008 Duncan Hall <duncan.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.haxe.multicore.interfaces;
	 
/** 
 * Interface for an Asynchronous Command.
 */ 
interface IAsyncCommand implements ICommand 
{
	/**
	 * Registers the callback for a parent [AsyncMacroCommand].  
	 */
	public function setOnComplete( value : Void -> Void ) : Void;
	
}
