/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	
	public class IObserver
	{
		public var observedEvent:String;
		public var callback:Function;
		
		public function IObserver(observedEvent:String, callback:Function)
		{
			this.observedEvent = observedEvent;
			this.callback = callback;
		}
	}
}