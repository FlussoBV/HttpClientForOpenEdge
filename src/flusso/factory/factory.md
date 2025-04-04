# Factory
A factory is a way of making it possible to make it configurable which class is used as implementation for a certain interface.

So, lets assume we have an interface like:

```
interface IHttpClient:
  method public HttpResponse Get(url as char).
end interface.
```

If we want an instance of an HTTPClient we can use:
```
var Factory factory = new Factory("factory.json").
var IHttpClient client = factory("IHttpClient").

client:Get("http://www.flusso.nl").
```

Now in `factory.json` we have the following:
```
{
  "IHttpClient": "flusso.http.AblHttpClient"
}
```

Suppose we have a .NET implementation as well, we can alter `factory.json` as follows:
```
{
  "IHttpClient": "flusso.http.DotnetHttpClient"
}
```

The enables to to switch of implmentaion without modifying a single line of code.

## LoadDefinitions
The Factory class has a parameter-less constructor as well. The `LoadDefintion` method can be used to populate the factory:
```
var IFactory factory = new Factory().

factory:LoadDefintions("another-factory.json").
```

Note: `LoadDefintions` can be called multiple times. Already existing identifier will be overwritten. In other words, if one loads two json factory JSON files with a defintion for `IHttpClient`, the last one wins.

## singletons
It's possible to define a factory as a singletion, so that max 1 instance ins created and that one is re-used in subsequent `GetInstance` calls. In this case the JSON definition line should look like:
```
{ "session-manager": "{ "class": "lib.core.SessionManager", "singleton": true}
```

## inject configuration
It is possible to inject configuration into the instantiated object. For this the target class needs to implement the `flusso.factory.IConfigurable` interface. The object defined in the `config` property is passed in its entirety to the `Configure` (as defined in the `IConfigurable` interface).

```
{
  "googleclient": { 
    "class": "my.custom.HttpClient",
    "config": {
      "url": "https://www.google.nl"
    }
  }
}
```

```
class my.custom.HttpClient implements IConfigurable:
  
  var private char urlToCall.
  
  method public void Configure(config as JsonObject):
    if config:Has("url") then
      urlToCall = config:GetCharacter("url").  
  end.

end class.
```




