within Buildings.Rooms.Examples.FLEXLAB.IO.Examples;
model CalBayComm "Example for testing CalBayComm"
  import Buildings;
  extends Modelica.Icons.Example;
//fixme - Uncomfortable with including my login and PW in this example. How can I make an example which does not include that info?
  Buildings.Rooms.Examples.FLEXLAB.IO.CalBayGetDAQ
                                             pyt(
    functionName="CalBayComm",
    nDblRea=1,
    moduleName="GeneralCalBayComm",
    Login="P Grant",
    Password="pgrant213",
    Command="GetDAQ:WattStopper.HS1--4126F--Light Level-1",
    samplePeriod=5)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=10)
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Buildings.Rooms.Examples.FLEXLAB.IO.CalBaySetDAQ pyt1
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
equation
  connect(pyt.yR[1], lessThreshold.u) annotation (Line(
      points={{-59,0},{-48,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessThreshold.y, pyt1.u) annotation (Line(
      points={{-25,0},{-6,0}},
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
