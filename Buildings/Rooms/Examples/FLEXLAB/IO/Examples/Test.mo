within Buildings.Rooms.Examples.FLEXLAB.IO.Examples;
model Test
  extends Modelica.Icons.Example;
  CalBayDimmingSetDAQ pyt(    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    Login="P Grant",
    Password="pgrant213",
    nDblRea=1,
    Channel="SETDAQ:WattStopper.HS1--4126F--Dimmer Level-2",
    samplePeriod=1,
    startTime=0)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,100; 24,100;
        24,75; 49,75; 49,50; 74,50; 74,25; 99,25; 99,0])
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  CalBayGetDAQ pyt1(
    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    Login="P Grant",
    Password="pgrant213",
    Command="GetDAQ:WattStopper.HS1--4126F--Light Level-1",
    nDblRea=1,
    samplePeriod=1,
    startTime=10)
    annotation (Placement(transformation(extent={{-66,-46},{-46,-26}})));
  CalBayGetDAQ pyt2(
    moduleName="GeneralCalBayComm",
    functionName="CalBayComm",
    Login="P Grant",
    Password="pgrant213",
    nDblRea=1,
    Command="GetDAQ:WattStopper.HS1--4126F--Dimmer Level-2",
    samplePeriod=1,
    startTime=5)
    annotation (Placement(transformation(extent={{-66,-72},{-46,-52}})));
equation
  connect(combiTimeTable.y[1], pyt.uR) annotation (Line(
      points={{-45,0},{-2,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test;
