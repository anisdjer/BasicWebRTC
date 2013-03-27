using System;
using System.Diagnostics;
using XSockets.Core.Common.Configuration;
using XSockets.Core.Common.Socket;
using XSockets.Plugin.Framework.Core.Attributes;
using XSockets.Plugin.Framework.Core.Exceptions;
using XSockets.Plugin.Framework.Helpers;

namespace BasicWebRTC.XSockets
{
    public class DebugInstance
    {
        [ImportOne(typeof(IXBaseServerContainer))]
        public IXBaseServerContainer wss { get; set; }

        public DebugInstance(IConfigurationLoader configurationLoader = null)
        {
            try
            {
                Debug.AutoFlush = true;
                this.ComposeMe();

                wss.OnServersStarted += wss_OnServersStarted;

                if (configurationLoader != null)
                    wss.SetConfigurationSettings(configurationLoader.ConfigurationSettings);

                wss.StartServers();
            }
            catch (CompositionException ex)
            {
                Debug.WriteLine("CompositionException while starting server");
                Debug.WriteLine(ex.CustomMessage);
                Debug.WriteLine(ex.StackTrace);
                Debug.WriteLine("Press enter to quit");
                throw;
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Exception while starting server");
                Debug.WriteLine(ex.Message);
                Debug.WriteLine(ex.StackTrace);
                Debug.WriteLine("Press enter to quit");
                throw;
            }
        }

        void wss_OnServersStarted(object sender, EventArgs e)
        {
            Debug.WriteLine("[XSockets Development Server]");
            Debug.WriteLine("[Servers Started]");

            Debug.WriteLine("_______________________XSOCKET HANDLERS_________________________________");
            foreach (var plugin in wss.XSocketFactory.Plugins)
            {
                Debug.WriteLine("Alias:\t\t" + plugin.Alias);
                Debug.WriteLine("BufferSize:\t" + plugin.BufferSize);
                Debug.WriteLine("PluginRange:\t" + plugin.PluginRange);
                Debug.WriteLine("Custom Events:");
                if (plugin.CustomEvents == null)
                    Debug.WriteLine("\tNone...");
                else
                    foreach (var customEventList in plugin.CustomEvents)
                        foreach (var customEvent in customEventList.Value)
                        {
                            Debug.WriteLine("\tMethodName:\t" + customEvent.MethodInfo.Name);
                            Debug.WriteLine("\tHandlerEvent:\t" + customEventList.Key);
                        }
                Debug.WriteLine("");
            }
            Debug.WriteLine("________________________________________________________________________");
            Debug.WriteLine("");
            Debug.WriteLine("_______________________XSOCKET PROTOCOLS________________________________");
            foreach (var plugin in wss.XSocketProtocolFactory.Protocols)
            {
                Debug.WriteLine("Identifier: " + plugin.ProtocolIdentifier);
            }
            Debug.WriteLine("________________________________________________________________________");
            Debug.WriteLine("");
            Debug.WriteLine("_______________________XSOCKET INTERCEPTORS_____________________________");
            foreach (var plugin in wss.MessageInterceptors)
            {
                Debug.WriteLine("Type: " + plugin.GetType().Name);
            }
            foreach (var plugin in wss.ConnectionInterceptors)
            {
                Debug.WriteLine("Type: " + plugin.GetType().Name);
            }
            foreach (var plugin in wss.HandshakeInterceptors)
            {
                Debug.WriteLine("Type: " + plugin.GetType().Name);
            }
            foreach (var plugin in wss.ErrorInterceptors)
            {
                Debug.WriteLine("Type: " + plugin.GetType().Name);
            }
            Debug.WriteLine("________________________________________________________________________");
        }
    }
}