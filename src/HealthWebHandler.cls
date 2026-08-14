using OpenEdge.Core.*.
using OpenEdge.Net.HTTP.*.
using OpenEdge.Web.*.
using Progress.Json.ObjectModel.*.

class HealthWebHandler inherits WebHandler:

  method override public integer HandleGet(request as OpenEdge.Web.IWebRequest):

    var logical           isHealthy.
    var JsonObject        oHealth  = new JsonObject().
    var IHttpResponse     response = new WebResponse().
    var WebResponseWriter writer.

    isHealthy = this-object:CheckDb().

    if isHealthy then do:
      oHealth:Add("status", "healthy").
      oHealth:Add("db-connections", num-dbs).
    end.
    else undo, throw new Progress.Lang.AppError("System is unhealthy!", -1).

    response:StatusCode  = 200.
    response:Entity      = oHealth.
    response:ContentType = "application/json".

    log-manager:write-message(substitute("-- HEALTH CHECK: &1", response:StatusCode)).

    return 0.
    
    catch oError as Progress.Lang.Error:
      oHealth:Add("status", "error").
      oHealth:Add("db-connections", num-dbs).
      oHealth:Add("error", oError:GetMessage(1)).

      response:StatusCode  = 500.
      response:Entity      = oHealth.
      response:ContentType = "application/json".

      log-manager:write-message(substitute("Error: &1", oError:GetMessage(1))).
      log-manager:write-message(substitute("-- HEALTH CHECK: &1", response:StatusCode)).
      return 1.
    end catch.

    finally:
      writer = new WebResponseWriter(response).
      writer:Open().
      writer:Close(). 
    end finally.

  end method.  // HandleGet

  method override protected integer HandleNotAllowedMethod(request as OpenEdge.Web.IWebRequest). 
    undo, throw new Progress.Lang.AppError("Method Not Allowed", -1).
  end.

  method override protected integer HandleNotImplemented(request as OpenEdge.Web.IWebRequest). 
    undo, throw new Progress.Lang.AppError("Not Implemented", -1).
  end.


  method private logical CheckDb():
    
    if num-dbs eq 0 then return false.

    //find first Pet.

    return true.

    catch oErr as Progress.Lang.Error:
      return false.
    end catch.

  end method.

end class.  // HealthWebHandler

