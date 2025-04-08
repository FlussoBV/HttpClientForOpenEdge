
 /*------------------------------------------------------------------------
    File        : Factory
    Purpose     : 
    Syntax      : 
    Author(s)   : bronco / Flusso B.V.
    Created     : Mon Feb 10 09:21:11 +01:00 2025
    Notes       : Copyright (c) 2025 Flusso B.V. (MIT license, see attached LICENSE file)
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using flusso.factory.Factory.
using flusso.factory.IConfigurable.
using flusso.factory.IFactory.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.

class flusso.factory.Factory implements IFactory:
  	
  define private temp-table ttdefintion no-undo
    field indentifier as char
    field classname as char
    field singleton as logical
    field config as Progress.Lang.Object
    .

  define private temp-table ttinstance no-undo
    field objtype as char
    field obj as Progress.Lang.Object
    .

  /*------------------------------------------------------------------------------
    Purpose: Constructor
    Notes:
  ------------------------------------------------------------------------------*/
  constructor public Factory():
    // noop
  end constructor.

  /*------------------------------------------------------------------------------
    Purpose: Constructor
    Notes:
    @param jsonDefinitionFile Definition file
  ------------------------------------------------------------------------------*/
  constructor public Factory(jsonDefinitionFile as char):
    LoadDefinitions(jsonDefinitionFile).  
  end constructor.

  /*------------------------------------------------------------------------------
    Purpose: GetInstance
    Notes:
    @param instanceName The logical name of the requested object
    @return The requested object instance
  ------------------------------------------------------------------------------*/
  method public Progress.Lang.Object GetInstance(instanceName as char):
        
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
    
    if not valid-object(instanceRef) then do:
      instanceRef = dynamic-new(ttdefintion.classname)() no-error.

      if     not error-status:error
         and type-of(instanceRef, IConfigurable)
         and valid-object(ttdefintion.config) then
        cast(instanceRef, IConfigurable):Configure(cast(ttdefintion.config, JsonObject)).
    end.

    if not valid-object(instanceRef) then 
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

  /*------------------------------------------------------------------------------
    Purpose: DeleteInstance
    Notes:
    @param instanceName The logical name of the requested object to delete
  ------------------------------------------------------------------------------*/
  method public void DeleteInstance(instanceName as char):
    // tbd
  end method.  // DeleteInstance

  /*------------------------------------------------------------------------------
    Purpose: Has instance
    Notes:
    @param instanceName The logical name of the requested object to delete
  ------------------------------------------------------------------------------*/
  method public logical Has(instanceName as char):
    return can-find(first ttdefintion where ttdefintion.indentifier = instanceName).
  end method.  // Has

  /*------------------------------------------------------------------------------
    Purpose: Load definitions
    Notes:
    @param jsonDefinitionFile Definition file
  ------------------------------------------------------------------------------*/
  method public Factory LoadDefinitions(jsonDefinitionFile as char):
        
    var JsonObject jsonDefinitions.
    var ObjectModelParser parser.
    
    do on error undo, throw:
      
      if search(jsonDefinitionFile) = ? then 
        undo, throw new AppError(substitute("factory definition file (&1) not found", jsonDefinitionFile), -1).

      parser = new ObjectModelParser().
          
      jsonDefinitions = cast(parser:ParseFile(search(jsonDefinitionFile)), JsonObject).

      this-object:ProcessDefinitions(jsonDefinitions).

      catch err as Progress.Lang.Error :
        undo, throw new AppError(substitute("Invalid data: &1", err:GetMessage(1)), -1).  
      end catch.
      
    end.  // do on error...
    
    return this-object.
    
  end method.  // LoadDefinitions
  
  /*------------------------------------------------------------------------------
    Purpose: Process definitions
    Notes:
    @param jsonDefintions Definition as json
  ------------------------------------------------------------------------------*/
  method private void ProcessDefinitions(jsonDefintions as JsonObject):

    var int i, propertyType.
    var char[] names.
    var JsonObject defintionObject, config.
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
          if defintionObject:Has("config") then
            config = defintionObject:GetJsonObject("config").
        end.
                
        otherwise do:
          // nothing 
        end.
             
      end case.
      
      AddDefinition(identifier, classname, singleton, config).
        
    end.  // do i = 1 to extent(names)...

  end method.  // ProcessDefinitions

  /*------------------------------------------------------------------------------
    Purpose: Add definition
    Notes:
    @param identifier
    @param classname
    @param singleton
    @param config
  ------------------------------------------------------------------------------*/
  method private void AddDefinition(identifier as char, classname as char, singleton as logical, config as JsonObject):
    
    find ttdefintion where ttdefintion.indentifier = identifier no-error.
    if not available(ttdefintion) then do:
      create ttdefintion.
      ttdefintion.indentifier = identifier.
    end.
    
    ttdefintion.classname = classname.
    ttdefintion.singleton = singleton. 
    ttdefintion.config = config.

  end method.  // AddDefinitions

end class.  // Factory
