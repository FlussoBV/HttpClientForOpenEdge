
/**
MIT License

Copyright (c) 2025 Flusso B.V.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**/

 /*------------------------------------------------------------------------
    File        : Factory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Mon Feb 10 09:21:11 +01:00 2025
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using flusso.factory.IFactory.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.

class flusso.factory.Factory implements IFactory:
  	
  define private temp-table ttdefintion no-undo
    field indentifier as character
    field classname   as character
    field singleton   as logical
    .

  define private temp-table ttinstance no-undo
    field objtype as character
    field obj as Progress.Lang.Object
    .

    constructor public Factory():
    LoadDefinitions("factory.json").  
  end constructor.

  /**
  * @param instanceName   the logical name of the requested object
  * @return               the requested object instance
  */  
  method public Progress.Lang.Object GetInstance(instanceName as character):
        
    var Progress.Lang.Object instanceRef.
    var logical singleInstanceFound.
    
    find ttdefintion where ttdefintion.indentifier = instanceName no-error.
    if not available(ttdefintion) then 
      undo, throw new AppError(substitute("no definition found for '&1'", instanceName), -1).
            
    singleInstanceFound = false.
    if ttdefintion.singleton then do:
      for first ttinstance where ttinstance.objtype = instanceName:
        instanceRef = ttinstance.obj.
        singleInstanceFound = true.
      end.    
    end. 
    
    if not valid-object(instanceRef) then
      instanceRef = dynamic-new(ttdefintion.classname)() no-error.
                  
    if (not valid-object(instanceRef)) then 
      undo, throw new AppError(substitute("class not found: &1", ttdefintion.classname), -1).
            
    if ttdefintion.singleton and not singleInstanceFound then do:
      create ttinstance.
      assign
        ttinstance.objtype = ttdefintion.indentifier 
        ttinstance.obj = instanceRef
        .
    end. 
                                
    return instanceRef.
              
  end method.  // GetInstance

  method public Progress.Lang.Object DeleteInstance(instanceName as char):
    
  end method.  // DeleteInstance

  method public logical Has(instanceName as char):
    return can-find(first ttdefintion where ttdefintion.indentifier = instanceName).
  end method.  // Has

  method public void LoadDefinitions(jsonDefinitionFile as character):
        
    var JsonObject jsonDefinitions.
    var ObjectModelParser parser.
    
    do on error undo, throw:
      
      jsonDefinitionFile = search(jsonDefinitionFile).
      if jsonDefinitionFile = ? then 
        undo, throw new AppError(substitute("factory definition file (&1) not found", jsonDefinitionFile), -1).

      parser = new ObjectModelParser().
          
      jsonDefinitions = cast(parser:ParseFile(jsonDefinitionFile), JsonObject).

      this-object:ProcessDefinitions(jsonDefinitions).

      catch err1 as Progress.Lang.Error :
        undo, throw new AppError(substitute("Invalid data: &1", err1:GetMessage(1)), -1).  
      end catch.
      
    end.  // do on error...
                   
  end method.  // LoadDefinitions
  
  
  method private void ProcessDefinitions(jsonDefintions as JsonObject):

    var int i, propertyType.
    var char[] names.
    var JsonObject defintionObject.
    var char identifier, classname.
    var logical singleton.
        
            
    names = jsonDefintions:GetNames().
    do i = 1 to extent(names):
            
      identifier = names[i].
      propertyType = jsonDefintions:GetType(identifier).

      case (propertyType):
                
        when 1 then do:
          classname = jsonDefintions:GetCharacter(identifier).
          singleton = false.   
        end.
                
        when 4 then do:
          defintionObject = jsonDefintions:GetJsonObject(identifier).
          classname = defintionObject:GetCharacter("class").
          singleton = (defintionObject:Has("singleton") and defintionObject:GetLogical("singleton")).  
        end.
                
        otherwise do:
          // nothing 
        end.
             
      end case.
      
      AddDefinition(identifier, classname, singleton).
        
    end.  // do i = 1 to extent(names)...

  end method.  // LoadDefinitions

  method private void AddDefinition(identifier as char, classname as char, singleton as logical):
    
    find ttdefintion where ttdefintion.indentifier = identifier no-error.
    if (not available(ttdefintion)) then do:
      create ttdefintion.
      ttdefintion.indentifier = identifier.
    end.
    
    ttdefintion.classname = classname.
    ttdefintion.singleton = singleton.  

  end method.  // AddDefinitions

end class.  // Factory
