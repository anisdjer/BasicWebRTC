using XSockets.Core.Common.Socket;

[assembly: WebActivator.PostApplicationStartMethod(typeof(BasicWebRTC.App_Start.XSocketsBoostrap), "Start")]
[assembly: WebActivator.ApplicationShutdownMethod(typeof(BasicWebRTC.App_Start.XSocketsBoostrap), "Stop")]

namespace BasicWebRTC.App_Start
{
    public static class XSocketsBoostrap
    {
        private static IXBaseServerContainer wss;
        static void Start()
        {
            wss = XSockets.Plugin.Framework.Composable.GetExport<IXBaseServerContainer>();
            wss.StartServers();
        }

        static void Stop()
        {
            wss.StopServers();            
        }        
    }
}