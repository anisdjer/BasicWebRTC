Showing howto start a XSockets.NET server


//Using needed
using XSockets.Core.Common.Socket;
using XSockets.Plugin.Framework.Core.Attributes;
using XSockets.Plugin.Framework.Helpers;

//Create class for the server instance
public class Instance
{
    [ImportOne(typeof(IXBaseServerContainer))]
    public IXBaseServerContainer wss { get; set; }

    public Instance()
    {
        try
        {
            this.ComposeMe();                

            wss.StartServers();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
            throw;
        }
    }
}


//Call the server from you ConsoleApplication, Global.ASAX or whatever
new Instance();