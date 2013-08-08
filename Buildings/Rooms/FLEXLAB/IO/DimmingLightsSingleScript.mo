within Buildings.Rooms.FLEXLAB.IO;
model DimmingLightsSingleScript
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
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Utilities.IO.Python27.Real_Real calBay(
    samplePeriod=30,
    functionName="CalBayComm",
    nDblWri=1,
    nDblRea=2,
    moduleName="CalBayComm") "Interface to CalBay communication"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  controller con(nin=1) "Controller for light level"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
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
equation
  connect(con.y, calBay.uR[1]) annotation (Line(
      points={{21,4.44089e-16},{33.5,4.44089e-16},{33.5,8.88178e-16},{38,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SetPoint.y[1], feedback.u1) annotation (Line(
      points={{-59,0},{-38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.y, con.u[1]) annotation (Line(
      points={{-21,0},{-2,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calBay.yR[1], feedback.u2) annotation (Line(
      points={{61,-0.5},{68,-0.5},{68,-16},{-30,-16},{-30,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calBay.yR[2], con.u1) annotation (Line(
      points={{61,0.5},{68,0.5},{68,18},{-8,18},{-8,3.2},{-2,3.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DimmingLightsSingleScript;
