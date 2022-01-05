within Buildings.ThermalZones.Detailed.Validation.TestConditionalConstructions.BaseClasses;
partial model PartialTestModel
  "Partial model that is used to build the test cases"
  package MediumA = Buildings.Media.Air "Medium model";
  parameter Integer nConExt
    "Number of exterior constructions that do not have a window";
  parameter Integer nConExtWin
    "Number of exterior constructions that do have a window";
  parameter Integer nConPar "Number of partition constructions";
  parameter Integer nConBou
    "Number of surface that are connected to constructions that are modeled inside the room";
  parameter Integer nSurBou
    "Number of surface that are connected to the room air volume";
  MixedAir roo(
    redeclare package Medium = MediumA,
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    AFlo=20,
    hRoo=2.7,
    linearizeRadiation = true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room model"
    annotation (Placement(transformation(extent={{44,-36},{84,4}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Brick120 matLayPar
    "Construction material for partition walls"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,-16},{-60,4}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-20,-16},{0,4}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
equation
  connect(qRadGai_flow.y, multiplex3_1.u1[1])  annotation (Line(
      points={{-59,30},{-40,30},{-40,1},{-22,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-59,-6},{-49.75,-6},{-49.75,-6},{-40.5,-6},{-40.5,-6},{-22,-6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(qLatGai_flow.y, multiplex3_1.u3[1])  annotation (Line(
      points={{-59,-40},{-40,-40},{-40,-13},{-22,-13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{1,-6},{22,-6},{22,-8},{42.4,-8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{80,70},{90,70},{90,1.9},{81.9,1.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,160}}),
                      graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,160}})),
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
June 30, 2014, by Michael Wetter:<br/>
Set equations to be used to compute the initial conditions.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
</ul>
</html>"));
end PartialTestModel;
