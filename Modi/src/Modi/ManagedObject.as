/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    public class ManagedObject extends EventDispatcher implements ISerializableObject
    {
        private var _registeredAttributes:Array;
        private var _registeredAttributeTypes:Array;
        private var _contextId:ManagedObjectId;
        private var _contextReference:ManagedObjectContext;
        private var _requiresInitialization:Boolean

        public function ManagedObject()
        {

        }

        protected function registerAttributes(attributes:Array, attributeTypes:Array):void
        {
            _registeredAttributes = !_registeredAttributes ? attributes : _registeredAttributes.concat(attributes);
            _registeredAttributeTypes = !_registeredAttributeTypes ? attributeTypes : _registeredAttributeTypes.concat(attributeTypes);
        }

        public function set contextId(contextId:ManagedObjectId):void { _contextId = contextId; }
        public function get contextId():ManagedObjectId { return _contextId; }

        protected function dispatchChangeEvent(type:String, oldValue:*, newValue:*):void
        {
            var event:ManagedObjectEvent = new ManagedObjectEvent(type);
            event.owner = this;
            event.oldValue = oldValue;
            event.newValue = newValue;
            dispatchEvent(event);
        }

        public function equalsById(other:ManagedObject):Boolean
        {
            if      (!_contextId)      return false;
            else if (!other)           return false;
            else if (!other.contextId) return false;
            else                       return _contextId.equals(other.contextId);
        }

        public function serialize(serializator:ISerializator):void
        {
            for (var i: int = 0; i < _registeredAttributes.length; i++)
            {
                var attributeName:String = this._registeredAttributes[i];
                var attributeType:String = this._registeredAttributeTypes[i];

                writeUnindentified(attributeName, this[attributeName], attributeType, serializator);
            }

            if (contextId) writeUnindentified("id", contextId.objectId, "String", serializator);
        }

        public function deserialize(deserializator:IDeserializator):void
        {
            if (!deserializator.ready)
            {
                throw new Error("Deserializator was not initialized with data, " +
                        "you should call the deserializeData prior to deserializing data into the ManagedObject");
            }

            for (var i: int = 0; i < _registeredAttributes.length; i++)
            {
                var attributeName:String = _registeredAttributes[i];
                var attributeType:String = _registeredAttributeTypes[i];

                if (deserializator.exists(attributeName))
                {
                    readUnindentified(attributeName, this, attributeType, deserializator);
                }
            }

            var id:String = deserializator.readString("id");
            if (id) contextId = new ManagedObjectId(id);
        }

        public function deserializeVariable(deserializator:IDeserializator, variableName:String):void
        {
            if (!deserializator.ready)
            {
                throw new Error("Deserializator was not initialized with data, " +
                        "you should call the deserializeData prior to deserializing data into the ManagedObject");
            }

            for (var i: int = 0; i < _registeredAttributes.length; i++)
            {
                var attributeName:String = _registeredAttributes[i];
                var attributeType:String = _registeredAttributeTypes[i];

                if (deserializator.exists(attributeName) && variableName == attributeName)
                {
                    readUnindentified(attributeName, this, attributeType, deserializator);
                }
            }
        }

        public static function readUnindentified(name:String, object:*, type:String, deserializator:IDeserializator):Boolean
        {
            var pass: Boolean = true;

            if (type == "String")             object[name] = deserializator.readString(name);
            else if (type == "int")           object[name] = deserializator.readInt(name);
            else if (type == "uint")          object[name] = deserializator.readUInt(name);
            else if (type == "Number")        object[name] = deserializator.readNumber(name);
            else if (type == "Boolean")       object[name] = deserializator.readBoolean(name);
            else if (type == "Dictionary")    object[name] = deserializator.readDictionary(name);
            else if (type == "Array")         object[name] = deserializator.readArray(name);
            else if (type == "ManagedValue")
            {
                var managedValue:String = deserializator.readString(name);
                object[name] = new ManagedValue(managedValue);
            }
            else if (type == "ManagedObjectId")
            {
                var objectIdValue:String = deserializator.readString(name);
                object[name] = new ManagedObjectId(objectIdValue);
            }
            else if (type == "ManagedPoint")
            {
                deserializator.pushArray(name);
                (object[name] as ManagedPoint).deserialize(deserializator);
                deserializator.popArray();
            }
            else if (type == "ManagedArray")
            {
                deserializator.pushArray(name);
                (object[name] as ManagedArray).deserialize(deserializator);
                deserializator.popArray();
            }
            else if (type == "ManagedMap")
            {
                throw new Error("ManagedMap is currently not supported in deserialization.");
            }
            else /// object
            {
                var objectClass:Class = Class(getDefinitionByName(type));
                var newObject:ManagedObject = new objectClass();

                if (newObject is ManagedObject)
                {
                    deserializator.pushObject(name);
                    newObject.deserialize(deserializator);
                    object[name] = newObject;
                    deserializator.popObject();
                }
                else
                {
                    // don't throw, ignore
                    pass = false;
                }
            }

            return pass;
        }

        public static function writeUnindentified(name:String, object:*, type:String, serializator:ISerializator):Boolean
        {
            var pass: Boolean = true;

            if (type == "String")
            {
                serializator.writeString(name, object as String);
            }
            else if (type == "int")
            {
                serializator.writeInt(name, object as int);
            }
            else if (type == "uint")
            {
                serializator.writeUInt(name, object as int);
            }
            else if (type == "Number")
            {
                serializator.writeNumber(name, object as Number);
            }
            else if (type == "Boolean")
            {
                serializator.writeBoolean(name, object as Boolean);
            }
            else if (type == "Dictionary")
            {
                serializator.writeDictionary(name, object as Dictionary);
            }
            else if (type == "Array")
            {
                serializator.writeArray(name, object as Array);
            }
            else if (type == "ManagedObjectId")
            {
                serializator.writeString(name, (object as ManagedObjectId).objectId);
            }
            else if (type == "ManagedValue")
            {
                serializator.writeString(name, (object as ManagedValue).stringValue);
            }
            else if (type == "ManagedPoint")
            {
                serializator.pushArray(name);
                if (object) (object as ISerializableObject).serialize(serializator);
                serializator.popArray();
            }
            else if (type == "ManagedArray")
            {
                serializator.pushArray(name);
                if (object) (object as ISerializableObject).serialize(serializator);
                serializator.popArray();
            }
            else if (type == "ManagedMap")
            {
                throw new Error("ManagedMap is currently not supported in serialization.");
            }
            else
            {
                if (type == "ManagedObject" || object is ManagedObject)
                {
                    serializator.pushObject(name);
                    if (object) (object as ISerializableObject).serialize(serializator);
                    serializator.popObject();
                }
                else
                {
                    // don't throw, ignore
                    pass = false;
                }
            }

            return pass;
        }

        public function get registeredAttributes():Array { return _registeredAttributes; }

        public function get contextReference():ManagedObjectContext { return _contextReference; }
        public function set contextReference(value:ManagedObjectContext):void { _contextReference = value; }

        public function removeSelfFromContext():void
        {
            if (_contextReference != null) _contextReference.removeFromContext(_contextId);
        }

        public function get requiresInitialization():Boolean { return _requiresInitialization; }
        public function set requiresInitialization(value:Boolean):void { _requiresInitialization = value; }

        public static function deserializeObject(data:*, Type:Class, Deserializator:Class):*
        {
            var object:ManagedObject = new Type;
            var deserializator:IDeserializator = new Deserializator();
            deserializator.deserializeData(data);
            object.deserialize(deserializator);
            return object;
        }

        public static function serializeObject(object:ManagedObject, Serializator:Class):*
        {
            var serializator:ISerializator = new Serializator();
            object.serialize(serializator);
            return serializator.serializeData();
        }
    }
}