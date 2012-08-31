/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
    import Modi.ManagedObject;

    public class ManagedObjectEvent
	{
		public static var ALLOW_CHANGE:String = "AllowChange";
		public static var WILL_CHANGE:String = "WillChange";
		public static var WAS_CHANGED:String = "WasChanged";

        public var owner:ManagedObject;
		public var attribute:String;
		public var event:String;
		public var oldState:*;
		public var newState:*;
		
		public function ManagedObjectEvent(owner:ManagedObject, attribute:String, event:String, oldState:*, newState:*)
		{
            this.owner = owner;
			this.attribute = attribute;
			this.event = event;
			this.oldState = oldState;
			this.newState = newState;
		}
	}
}