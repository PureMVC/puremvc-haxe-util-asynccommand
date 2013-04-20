/*
 PureMVC Utility for haXe - AsyncCommand Port by Zjnue Brzavi <zjnue.brzavi@puremvc.org>
 Copyright(c) 2008 Duncan Hall <duncan.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.haxe.patterns.command;

import org.puremvc.haxe.interfaces.IAsyncCommand;
import org.puremvc.haxe.interfaces.ICommand;
import org.puremvc.haxe.interfaces.INotification;
import org.puremvc.haxe.interfaces.INotifier;
import org.puremvc.haxe.patterns.observer.Notifier;	 

/**
 * A base [ICommand] implementation that executes other 
 * [ICommand]s asynchronously.
 *  
 * <p>An [AsyncMacroCommand] maintains a list of
 * [ICommand] Class references called <i>SubCommands</i>.</p>
 * 
 * <p>When [execute] is called, the [AsyncMacroCommand]
 * caches a reference to the [INotification] and calls 
 * [nextCommand].</p>
 * 
 * <p>If there are still <i>SubCommands</i>'s to be executed, 
 * the [nextCommand] method instantiates and calls [execute] 
 * on each of its <i>SubCommands</i> in turn. Each <i>SubCommand</i> will be passed 
 * a reference to the original [INotification] that was passed to the 
 * [AsyncMacroCommand]'s [execute] method. If the
 * <i>SubCommand</i> to execute is an [IAsyncCommand], the 
 * next <i>SubCommand</i> will not be executed until the previous 
 * [IAsyncCommand] has called its <i>commandComplete</i> method.</p>
 * 
 * <p>Unlike [AsyncCommand] and [SimpleCommand], your subclass
 * should not override [execute], but instead, should 
 * override the [initializeAsyncMacroCommand] method, 
 * calling [addSubCommand] once for each <i>SubCommand</i>
 * to be executed.</p>
 */
#if haxe3
class AsyncMacroCommand extends Notifier implements IAsyncCommand implements INotifier
#else
class AsyncMacroCommand	extends Notifier, implements IAsyncCommand, implements INotifier
#end
{
	/**
	 * Constructor. 
	 * 
	 * <p>You should not need to define a constructor, 
	 * instead, override the [initializeAsyncMacroCommand]
	 * method.</p>
	 * 
	 * <p>If your subclass does define a constructor, be 
	 * sure to call [super()].</p>
	 */
	public function new()
	{
		super();
		subCommands = new List();
		initializeAsyncMacroCommand();			
	}
	
	/**
	 * Initialize the [AsyncMacroCommand].
	 * 
	 * <p>In your subclass, override this method to 
	 * initialize the [AsyncMacroCommand]'s <i>SubCommand</i>  
	 * list with [ICommand] class references.</p>
	 * 
	 * [
	 *		// Initialize MyMacroCommand
	 *		override private function initializeAsyncMacroCommand() : Void
	 *		{
	 *			addSubCommand( com.me.myapp.controller.FirstCommand );
	 *			addSubCommand( com.me.myapp.controller.SecondCommand );
	 *			addSubCommand( com.me.myapp.controller.ThirdCommand );
	 *		}
	 * ]
	 * 
	 * <p>Note that <i>SubCommand</i>s may be any [ICommand] implementor,
	 * [AsyncMacroCommand]s, [AsyncCommand]s, 
	 * [MacroCommand]s or [SimpleCommands] are all acceptable.</p>
	 */
	private function initializeAsyncMacroCommand() : Void {}

	/**
	 * Add a <i>SubCommand</i>.
	 *
	 * <p>The <i>SubCommands</i> will be called in First In/First Out (FIFO)
	 * order.</p>
	 */
	private function addSubCommand( commandClassRef : Class<ICommand> ) : Void
	{
		subCommands.add( commandClassRef );
	}		
	
	/**
	 * Registers the callback for a parent [AsyncMacroCommand].  
	 */
	public function setOnComplete( value : Void -> Void ) : Void
	{
		onComplete = value;
	}

	/** 
	 * Starts execution of this [AsyncMacroCommand]'s <i>SubCommands</i>.
	 *
	 * <p>The <i>SubCommands</i> will be called in First In/First Out (FIFO) order.</p> 
	 */
	public function execute( notification : INotification ) : Void
	{
		note = notification;
		nextCommand();
	}

	/** 
	 * Execute this [AsyncMacroCommand]'s next <i>SubCommand</i>.
	 * 
	 * <p>If the next <i>SubCommand</i> is asynchronous, a callback is registered for
	 * the command completion, else the next command is run.</p>  
	 */					
	function nextCommand() : Void
	{
		if( !subCommands.isEmpty() )
		{
			var commandClassRef : Class<ICommand> = subCommands.pop();
			var commandInstance : ICommand = Type.createInstance( commandClassRef, [] );
			var isAsync : Bool = Std.is( commandInstance, IAsyncCommand );
			
			if( isAsync ) cast( commandInstance, IAsyncCommand ).setOnComplete( nextCommand );
			commandInstance.execute( note );
			if( !isAsync ) nextCommand();
		}
		else
		{
			if( onComplete != null ) onComplete();
			note = null;
			onComplete = null;
		}
	}
	
	var subCommands : List<Class<ICommand>>;
	var note : INotification;
	var onComplete : Void -> Void;
	
}
