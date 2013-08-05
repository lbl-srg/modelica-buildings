within Buildings.Rooms.Examples.FLEXLAB.IO.Examples;
model DimmingLightsSingleScript
  extends Modelica.Icons.Example;

  Real InitialLight = pyt.yR[1]
    "Measure of the light level before the dimmer change";
  Real InitialDim = pyt.yR[2] "Dimmer setpoint before the change";
  Real SetDim = pyt.yR[3] "New setpoint for the dimmer";
  Real NewLight = pyt.yR[4]
    "Measure of the light level after the dimmer control change";
  Real NewDim = pyt.yR[5] "Dimmer setpoint after the change";
  Real LightSet = combiTimeTable.y[1] "Light setpoint";

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(tableOnFile=false, table=[0,
        12; 120,12; 120,6; 240,6; 240,8; 360,8; 360,9; 480,9; 480,10; 600,10; 600,
        12])
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Utilities.IO.Python27.Real_Real pyt(
    samplePeriod=30,
    functionName="CalBayComm",
    nDblWri=1,
    moduleName="Test",
    nDblRea=5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(combiTimeTable.y[1], pyt.uR[1]) annotation (Line(
      points={{-49,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DimmingLightsSingleScript;
