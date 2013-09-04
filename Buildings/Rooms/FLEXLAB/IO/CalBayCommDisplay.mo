within Buildings.Rooms.FLEXLAB.IO;
model CalBayCommDisplay
  "Simplified model demonstrating communication with the CalBay adapter"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable SetPoint(tableOnFile=false, table=[0,
        12; 119,12; 119,6; 239,6; 239,8; 359,8; 359,9; 479,9; 479,10; 599,10;
        599,12]) "Setpoint for lights"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Utilities.IO.Python27.Real_Real calBay(
    samplePeriod=30,
    functionName="CalBayComm",
    nDblWri=1,
    moduleName="Test",
    nDblRea=2) "Interface to CalBay communication"
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Continuous.PI PI "Controller"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  connect(setPoint.y[1], feedback.u1) annotation (Line(
      points={{-45,0},{-38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calBay.yR[1], feedback.u2) annotation (Line(
      points={{37,-0.5},{40,-0.5},{40,-16},{-30,-16},{-30,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.y, PI.u) annotation (Line(
      points={{-21,0},{-14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI.y, calBay.uR[1]) annotation (Line(
      points={{9,0},{14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(
      info = "<html>
      <p>
      This model has not been tested, and is intended for display purposes only.
      </p>
      </html>"));
end CalBayCommDisplay;
