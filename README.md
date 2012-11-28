#Killer Caller

This is the Ruby application designed to run [Kill The Landline](http://killthelandline.com), a Startup Weekend Columbia 2012 Honorable Mention. 

The caller is a Ruby application running on Heroku that interfaces with [Tropo](http://tropo.com).

The caller expects to be invoked as the path number.rb. You can specify multiple numbers by separating them with underscores. E.G.

http://URL/5554567890.rb
http://URL/5554567890_5555678901.rb
http://URL/5554567890_5555678901_5553789012.rb

## Creating applications


For every number one of our customers forwards, we create an application in Tropo. The name of the application should be the ten-digit number they are forwarding. The voice URL of the application should be the caller with a path that includes the number they want to forward to. The messaging URL doesn’t matter for the moment, since we don’t do anything with SMS.

While we’re still testing, the partition of the applications should be staging, when we launch, apps must be production.

### Manual Creation

Login and choose to create a new scripting application.

I’m not sure if we can get the application id from the tropo website.

### Programmatically creation


Send a POST request to https://killthelandline:OURPASSWORD@api.tropo.com/v1/applications with the headers

accept:application/json
content-type:application/json
and a body

{
   "name":"5551111111",
   "voiceUrl":"http://URL/55522222222.rb",
   "messagingUrl":"http://URL/55522222222.rb",
   "platform":"scripting",
   "partition":"staging"
}

Tropo will return a JSON response that includes the id of the application, e.g.

{"href":"https://api.tropo.com/v1/applications/123456"}

For example, with curl -v -H "Content-Type: application/json" -X POST -d '{"name":"555111111","voiceUrl"”:http://killercaller.herokuapp.com/55522222222.rbb","messagingUrl":"http://killercaller.herokuapp.com/55522222222.rb","platform":"scripting","partition":"staging"}' https://killthelandline:OURPASSWORD@api.tropo.com/v1/applications

### Adding the inbound number

Once a customers number has been ported to tropo, we’ll need to add it to their application. This is simple enough for normal numbers you get from tropo, but I don’t know exactly how it will work for numbers we are porting. I have a question in about this,

### Manually Adding

The normal process lets you choose an area code and get a number from it.

### Programmatically Adding

There is a process for just choosing an area code and getting a number from it, but there is also a process for choosing a specific number. Still, I’m not sure if this is what we will do.

We make the POST request to the addresses resoruce of our application, api.tropo.com/v1/applications/123456/addresses

The request body is

{
   "type":"number",
   "number":"55511111111"
}


For example, with curl -v -H "Content-Type: application/json" -X POST -d '{“type”:”number”,"number":"555111111}' https://killthelandline:OURPASSWORD@api.tropo.com/v1/applications/123456/addresses


## Changing the number(s) being forwarded to

If a customer changes the two numbers they want their old number forwarded two, we need to update their application and change the path for the killer caller.

### Manually changing


Log in to tropo, find the application, and edit the two URLs to reflect the new numbers.

### Programmatically changing

The request is made to a specific application resource, e.g. api.tropo.com/v1/applications/123456

The HTTP method is PUT. THe request body is the same as creating an application.

This curl request would change the number being forwarded to for application 123456 from 5552222222 to 5553333333

curl -v -H "Content-Type: application/json" -X PUT -d '{"name":"555111111","voiceUrl":"http://URL/55533333333.rbb","messagingUrl":"http://killercaller.herokuapp.com/55533333333.rb","platform":"scripting","partition":"staging"}' https://killthelandline:OURPASSWORD@api.tropo.com/v1/applications/123456
