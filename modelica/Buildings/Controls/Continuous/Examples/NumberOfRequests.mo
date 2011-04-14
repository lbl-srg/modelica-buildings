within Buildings.Controls.Continuous.Examples;
model NumberOfRequests "Example model"
  extends Modelica.Icons.Example;
  Buildings.Controls.Continuous.NumberOfRequests numReq(
    nin=2,
    threShold=0,
    kind=0) annotation (Placement(transformation(extent={{0,20},{20,40}},
          rotation=0)));
  Modelica.Blocks.Sources.Sine sine(freqHz=2)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
  Modelica.Blocks.Sources.Pulse pulse(period=0.25)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}},rotation=0)));
equation
  connect(sine.y, numReq.u[1]) annotation (Line(points={{-39,-10},{-19.5,-10},{
          -19.5,29},{-2,29}}, color={0,0,127}));
  connect(pulse.y, numReq.u[2]) annotation (Line(points={{-39,30},{-20,30},{-20,
          31},{-2,31}}, color={0,0,127}));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="NumberOfRequests.mos" "run"),
              Diagram);
end NumberOfRequests;
