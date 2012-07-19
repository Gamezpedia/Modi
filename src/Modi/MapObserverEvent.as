/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	public class MapObserverEvent 
	{
		public var oldObject:ManagedObject;
		public var newObject:ManagedObject;
		public var event:String;
		public var x:int;
		public var y:int;
		
		public function MapObserverEvent(oldObject:ManagedObject, newObject:ManagedObject, event:String, x:int, y:int) 
		{
			this.oldObject = oldObject;
			this.newObject = newObject;
			this.event = event;
			this.x = x;
			this.y = y;
		}
	}
}