within Buildings.Rooms.FLEXLAB.IO.Examples;
model CalBayComm "Example for testing CalBayComm"
  import Buildings;
  extends Modelica.Icons.Example;

//fixme - Once real time implemented, change to include dimming. Instead of simple binary control at a single setpoint, use dimming to track a changing setpoint

  Buildings.Rooms.FLEXLAB.IO.CalBayGetDAQ
                                             pyt(
    functionName="CalBayComm",
    nDblRea=1,
    moduleName="GeneralCalBayComm",
    Login="P Grant",
    Password="pgrant213",
    Command="GetDAQ:WattStopper.HS1--4126F--Light Level-1",
    samplePeriod=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=0)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Rooms.FLEXLAB.IO.CalBaySetDAQ pyt1(
    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    Login="P Grant",
    Password="pgrant213",
    nDblRea=1,
    Channel="SETDAQ:WattStopper.HS1--4126F--Relay-2",
    samplePeriod=1)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
//    Server=Buildings.Rooms.FLEXLAB.Types.Server.WattstopperHS1,
//    Signal=Buildings.Rooms.FLEXLAB.Types.Signal.GetDAQ,
equation
  connect(pyt.yR[1], lessThreshold.u) annotation (Line(
      points={{-39,0},{-22,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessThreshold.y, pyt1.u) annotation (Line(
      points={{1,0},{18,0}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            Documentation(info="<html>
            <p>
            This example references a Python script to communicate with the CalBay adapter. It checks the light level in office 4126F.
            </p>
            </html>",
            revisions = "<html>
            <ul>
            <li> July 22, 2013 by Peter Grant:<br/>
            First implementation.</li>
            </ul>
            </html>"));
end CalBayComm;
