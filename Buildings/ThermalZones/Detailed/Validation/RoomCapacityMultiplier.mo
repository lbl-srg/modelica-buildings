within Buildings.ThermalZones.Detailed.Validation;
model RoomCapacityMultiplier
  "Validation model for room capacity multiplier"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Medium model";

  model Room = Buildings.ThermalZones.Detailed.MixedAir (
    redeclare package Medium = MediumA,
    AFlo=6*4,
    hRoo=2.7,
    nConExt=0,
    nConExtWin=0,
    nConPar=0,
    nConBou=0,
    nSurBou=1,
    surBou(each A=6*2.7,
           each absIR=0.9,
           each absSol=0.9,
           each til=Buildings.Types.Tilt.Wall),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    mSenFac=1,
    T_start=293.15) "Room model";

  Room roo1 "Room model"
    annotation (Placement(transformation(extent={{64,24},{104,64}})));

  Room roo2(mSenFac=2) "Room model"
    annotation (Placement(transformation(extent={{64,-36},{104,4}})));

  Modelica.Blocks.Sources.Constant qConGai_flow(k=1) "Convective heat gain"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1 "Multiplex for internal gain"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{160,140},{180,160}})));

equation
  connect(qRadGai_flow.y, multiplex3_1.u1[1])  annotation (Line(
      points={{-39,90},{-32,90},{-32,57},{-22,57}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(qLatGai_flow.y, multiplex3_1.u3[1])  annotation (Line(
      points={{-39,10},{-32,10},{-32,43},{-22,43}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaDat.weaBus, roo1.weaBus) annotation (Line(
      points={{180,150},{188,150},{188,61.9},{101.9,61.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(roo2.qGai_flow, multiplex3_1.y) annotation (Line(points={{62.4,-8},{20,
          -8},{20,50},{1,50}}, color={0,0,127}));
  connect(roo1.qGai_flow, multiplex3_1.y) annotation (Line(points={{62.4,52},{32,
          52},{32,50},{1,50}}, color={0,0,127}));
  connect(roo2.weaBus, weaDat.weaBus) annotation (Line(
      points={{101.9,1.9},{188,1.9},{188,150},{180,150}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {200,200}})),        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/RoomCapacityMultiplier.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    This model validates the room capacity multipler of
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>.
The rooms are adiabatic, but have different heat capacities.
A small amount of heat is added to test the
different time response.
</html>", revisions="<html>
<ul>
<li>
April 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      Tolerance=1e-06, StopTime=86400));
end RoomCapacityMultiplier;
