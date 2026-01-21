using System.Net.Sockets;
using System.Timers;
using System.Xml.Serialization;
using CoreOSC;
using CoreOSC.IO;
using Terminal.Gui;
using VRC.OSCQuery;
using System.Diagnostics;
using System.Net;

namespace ConfigXML;

public class Osc
{
    private List<UdpClient> _oscClients = new();
    private List<OSCQueryServiceProfile> _profiles = new();
    public OSCQueryService oscQuery;

    private ProgramConfig config;

    private const int RefreshServicesInterval = 2;

    //constructor
    public Osc(ProgramConfig conf)
    {
        config = conf ?? throw new ArgumentNullException(nameof(conf));

        //if set to use a custom port, ignore all discovery stuff since it doesnt matter anymore
        if (config.Osc.UseCustomPort)
        {
            //custom port path (not recommended)
            AddReceiver(IPAddress.Loopback, config.Osc.OscSendPort);
        }
        else
        {
            //OSCQuery path
            StartService();
            ExecuteOnTimer(RefreshServices, RefreshServicesInterval * 1000);
        }


        ExecuteOnTimer(UpdateOSC, config.Osc.UpdateRate);

        //heartbeat timer is seperate since it should always be running at a set rate
        ExecuteOnTimer(UpdateHeartbeat, 500);
    }

    private void ExecuteOnTimer(ElapsedEventHandler handler, double interval)
    {
        System.Timers.Timer timer = new System.Timers.Timer();
        timer.Elapsed += handler;
        timer.Interval = interval;
        timer.Start();
    }

    private async void UpdateHeartbeat(object? source, ElapsedEventArgs e)
    {
        config.Osc.parameters.Heartbeat.Value = !config.Osc.parameters.Heartbeat.Value;
        await SendOSC(config.Osc.parameters.Heartbeat, BoolToValue(config.Osc.parameters.Heartbeat.Value));

        ProgramWindow.InvokeApplicationRefresh();
    }

    private async void UpdateOSC(object? source, ElapsedEventArgs e)
    {
        //send all the parameters
        await SendOSC(config.Osc.parameters.Preview, BoolToValue(config.Osc.parameters.Preview.Value));
        await SendOSC(config.Osc.parameters.Program, BoolToValue(config.Osc.parameters.Program.Value));
        await SendOSC(config.Osc.parameters.Standby, BoolToValue(config.Osc.parameters.Standby.Value));
        await SendOSC(config.Osc.parameters.Error, BoolToValue(config.Osc.parameters.Error.Value));

        ProgramWindow.InvokeApplicationRefresh();
    }

    private void StartService()
    {
        IDiscovery discovery = new MeaModDiscovery();

        // Create a new OSCQueryService for the discovery
        oscQuery = new OSCQueryServiceBuilder()
            .WithServiceName("VRCTally")
            //.WithTcpPort(Extensions.GetAvailableTcpPort())
            //.WithUdpPort(Extensions.GetAvailableUdpPort())
            .WithDiscovery(discovery)
            .Build();

        // Listen for other services
        oscQuery.OnOscQueryServiceAdded += OnOscQueryServiceFound;

        var services = oscQuery.GetOSCQueryServices();
        
        // Trigger event for any existing OSCQueryServices
        foreach (var profile in services)
        {
            OnOscQueryServiceFound(profile);
        }
    }

    private async void RefreshServices(object? source, ElapsedEventArgs e)
    {
        oscQuery.RefreshServices();
        //invoke a UI update
        ProgramWindow.InvokeApplicationRefresh();
    }

    private async Task<bool> ServiceSupported(OSCQueryServiceProfile profile)
    {
        var tree = await VRC.OSCQuery.Extensions.GetOSCTree(profile.address, profile.port);
        return tree.GetNodeWithPath("/chatbox") != null;
    }

    // Creates a new OSCClient for each new capable receiver found
    private async void OnOscQueryServiceFound(OSCQueryServiceProfile profile)
    {
        if(_profiles.Contains(profile))
            return;
        
        if (await ServiceSupported(profile))
        {
            var hostInfo = await VRC.OSCQuery.Extensions.GetHostInfo(profile.address, profile.port);
            // HeaderText.text =
            //     $"Sending to {profile.name} at {profile.address}:{hostInfo.oscPort}";
            AddReceiver(profile.address, hostInfo.oscPort);
            _profiles.Add(profile);
        }
        else
        {
            // Debug.Log($"{profile.name} NOT compatible!");
        }
    }

    private void AddReceiver(IPAddress address, int port)
    {
        var client = new UdpClient();
        client.Connect(address, port);
        _oscClients.Add(client);
    }

    private async Task SendOSC<T>(ProgramConfig.OscConfig.Parameters.Parameter<T> parameter, params object[] value)
    {
        try
        {
            foreach (var addr in parameter.Addresses)
            {
                var message = new OscMessage(addr, value);
                foreach (var oscClient in _oscClients)
                {
                    await oscClient.SendMessageAsync(message);
                }
            }
        }
        catch
        {
            //do nothing for now
        }
    }

    /// <summary>
    /// Convert a boolean to a OSC value
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static object BoolToValue(bool value)
    {
        return value ? OscTrue.True : OscFalse.False;
    }

    public FrameView GetWindow(Pos x, Pos y, Dim width, Dim height)
    {
        //setup two subviews, one for OSC and one for VMix
        FrameView oscView =
            new("OSC")
            {
                X = x,
                Y = y,
                Width = width,
                Height = height,
            };

        var oscQueryInfo = new Label("Hello, world!") { X = 0, Y = 0, };
        oscQueryInfo.DrawContent += (e) =>
        {
            oscQueryInfo.Text =
                $"OSCQuery Service running at TCP {oscQuery.TcpPort} and UDP {oscQuery.TcpPort}";
        };
        oscView.Add(oscQueryInfo);

        var oscConnectionInfo = new Label("Hello, world!") { Y = Pos.Bottom(oscQueryInfo), };
        oscConnectionInfo.DrawContent += (e) =>
        {
            List<string> lines = new();
            foreach (var oscClient in _oscClients)
            {
                if (oscClient.Client.Connected)
                {
                    lines.Add($"OSC Sending to {oscClient.Client.RemoteEndPoint}");
                }
            }

            if (_oscClients.Count == 0)
            {
                lines.Add("No OSC Receivers connected!");
            }

            oscConnectionInfo.Text = string.Join("\n", lines);
        };
        oscView.Add(oscConnectionInfo);

        //we want to add a sub view that shows all the parameters
        oscView.Add(
            config.Osc.parameters.GetWindow(
                0,
                Pos.Bottom(oscConnectionInfo),
                Dim.Fill(),
                Dim.Fill()
            )
        );

        return oscView;
    }
}
