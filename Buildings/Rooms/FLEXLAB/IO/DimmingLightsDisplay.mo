within Buildings.Rooms.FLEXLAB.IO;
model DimmingLightsDisplay
  extends Modelica.Icons.Example;

//   Real InitialLight = pyt.yR[1]
//     "Measure of the light level before the dimmer change";
//   Real InitialDim = pyt.yR[2] "Dimmer setpoint before the change";
//   Real SetDim = pyt.yR[3] "New setpoint for the dimmer";
//   Real NewLight = pyt.yR[4]
//     "Measure of the light level after the dimmer control change";
//   Real NewDim = pyt.yR[5] "Dimmer setpoint after the change";
//   Real SetLight = combiTimeTable.y[1] "Light setpoint";
//   Real PerDiff = pyt.yR[6] "Percent difference";
//   Real Adjustement = pyt.yR[7] "Adjustment";

  Modelica.Blocks.Sources.CombiTimeTable SetPoint(tableOnFile=false, table=[0,
        12; 119,12; 119,6; 239,6; 239,8; 359,8; 359,9; 479,9; 479,10; 599,10;
        599,12])
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
block controller "Block for control law"
  extends Modelica.Blocks.Interfaces.MISO;
    Modelica.Blocks.Math.Gain gain(k=10)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMax=100, uMin=1)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-12,6},{8,26}})));
    Modelica.Blocks.Interfaces.RealInput u1
      annotation (Placement(transformation(extent={{-140,12},{-100,52}})));
equation
  connect(limiter.y, y) annotation (Line(
      points={{61,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(u[1], gain.u) annotation (Line(
        points={{-120,0},{-62,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(gain.y, add.u2) annotation (Line(
        points={{-39,0},{-26,0},{-26,10},{-14,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.y, limiter.u) annotation (Line(
        points={{9,16},{26,16},{26,0},{38,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(u1, add.u1) annotation (Line(
        points={{-120,32},{-26,32},{-26,22},{-14,22}},
        color={0,0,127},
        smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                               graphics));
end controller;
  Modelica.Blocks.Continuous.PI PI
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  connect(SetPoint.y[1], feedback.u1) annotation (Line(
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
            -100},{100,100}}), graphics));
end DimmingLightsDisplay;
