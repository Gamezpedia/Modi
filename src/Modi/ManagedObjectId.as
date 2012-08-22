/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
    import com.chewtinfoil.utils.StringUtils;

    public class ManagedObjectId extends ManagedObject
	{
		private var _objectId:String;
		
		public function ManagedObjectId(objectId:String = "")
		{
			_objectId = objectId;
		}
		
		public function get objectId():String
		{
			return _objectId;
		}

        public function extractIndex():int
        {
            var id: int = -1;

            if (StringUtils.beginsWith(_objectId, "id"))
            {
                id = _objectId.substr(2) as int;
            }
            else
            {
                trace("Id is possibly malformed:", _objectId);
            }

            return id;
        }
	}
}