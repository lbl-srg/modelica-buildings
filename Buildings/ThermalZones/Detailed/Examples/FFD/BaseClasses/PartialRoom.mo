within Buildings.ThermalZones.Detailed.Examples.FFD.BaseClasses;
partial model PartialRoom "Partial model for a room"
  package MediumA = Buildings.Media.Air (
        T_default=283.15) "Medium model";
  parameter Integer nConExtWin=0 "Number of constructions with a window";
  parameter Integer nConBou=0
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou=0
    "Number of surface that are connected to the room air volume";
  parameter Integer nConExt=0
    "Number of exterior constructions withour a window";
  parameter Integer nConPar=0 "Number of partition constructions";
  Buildings.ThermalZones.Detailed.CFD roo(
    redeclare package Medium = MediumA,
    nConBou=nConBou,
    nSurBou=nSurBou,
    nConExt=nConExt,
    sensorName={"Occupied zone air temperature","Velocity"},
    useCFD=true,
    nConPar=nConPar,
    nConExtWin=nConExtWin,
    AFlo=1*1,
    hRoo=1,
    linearizeRadiation=true,
    samplePeriod=60,
    cfdFilNam="modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/OnlyWall.ffd",
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room model"
    annotation (Placement(transformation(extent={{46,20},{86,60}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"), TDryBul=
        293.15)
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
equation
  connect(qRadGai_flow.y, multiplex3_1.u1[1]) annotation (Line(
      points={{-39,90},{-32,90},{-32,57},{-22,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y, multiplex3_1.u3[1]) annotation (Line(
      points={{-39,10},{-32,10},{-32,43},{-22,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{1,50},{20,50},{20,48},{44.4,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{180,150},{190,150},{190,57.9},{83.9,57.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,160}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            160}})),
    Documentation(info="<html>
<p>
The partial model describes a room with only interior walls.
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialRoom;
