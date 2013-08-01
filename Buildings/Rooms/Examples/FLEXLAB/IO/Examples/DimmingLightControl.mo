within Buildings.Rooms.Examples.FLEXLAB.IO.Examples;
model DimmingLightControl
  "Model which communicates with CalBay adapter to control light level in 4126F"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(tableOnFile=false,
      table=[0,12; 120,12; 120,6; 240,6; 240,8; 360,8; 360,9; 480,9; 480,10;
        600,10; 600,12])
    annotation (Placement(transformation(extent={{-94,32},{-74,52}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-2,0},{18,20}})));
  CalBayDimmingSetDAQ pyt1(    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    Login="P Grant",
    Password="pgrant213",
    nDblRea=1,
    Channel="SETDAQ:WattStopper.HS1--4126F--Dimmer Level-2",
    samplePeriod=1)
    annotation (Placement(transformation(extent={{60,-6},{80,14}})));
  DimmingLevel dimmingLevel
    annotation (Placement(transformation(extent={{30,-6},{50,14}})));
  CalBayGetDAQ pyt(
    Login="P Grant",
    Password="pgrant213",
    Command="GetDAQ:WattStopper.HS1--4126F--Light Level-1",
    nDblRea=1,
    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    samplePeriod=1)
    annotation (Placement(transformation(extent={{-84,-30},{-64,-10}})));
  CalBayGetDAQ pyt2(
    Login="P Grant",
    Password="pgrant213",
    Command="GetDAQ:WattStopper.HS1--4126F--Dimmer Level-2",
    nDblRea=1,
    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    samplePeriod=1)
    annotation (Placement(transformation(extent={{-84,-60},{-64,-40}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{-42,-6},{-22,14}})));
  Modelica.Blocks.Sources.Constant const(k=0.01)
    annotation (Placement(transformation(extent={{-84,0},{-64,20}})));
equation
  connect(combiTimeTable.y[1], division.u1) annotation (Line(
      points={{-73,42},{-18,42},{-18,16},{-4,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(division.y, dimmingLevel.perDes) annotation (Line(
      points={{19,10},{28,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dimmingLevel.newDim, pyt1.uR) annotation (Line(
      points={{51,4},{58,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pyt2.yR[1], dimmingLevel.oldDim) annotation (Line(
      points={{-63,-50},{24,-50},{24,-2},{28,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max1.y, division.u2) annotation (Line(
      points={{-21,4},{-4,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pyt.yR[1], max1.u2) annotation (Line(
      points={{-63,-20},{-52,-20},{-52,-2},{-44,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, max1.u1) annotation (Line(
      points={{-63,10},{-44,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DimmingLightControl;
