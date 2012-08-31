within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model ApparatusDryPoint "Test model for ApparatusDryPoint"
  extends Modelica.Icons.Example;
  parameter Integer nSpe=4;
  package Medium =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
  Modelica.Blocks.Sources.Constant hIn(
    k=75000) "Air enthalpy at inlet"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Sources.Constant XIn(k=0.015) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint appDryPt(
    redeclare package Medium = Medium,
    nSpe=nSpe,
    datCoi=datCoi) "Dry point condition"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    height=1.35,
    startTime=900) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    duration=600,
    height=-20000,
    offset=-2,
    startTime=900) "Heat extracted from air"
    annotation (Placement(transformation(extent={{-80,38},{-60,58}})));
  Modelica.Blocks.Sources.TimeTable speRat(
    table=[0.0,0.0; 900,0.25; 1800,0.50; 2700,0.75],
    offset=0.25,
    startTime=900) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  Data.CoilData datCoi(
    nSpe=4,
    per={
      Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=900,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_I()),
              Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=1200,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_I()),
              Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_II()),
              Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(
        spe=2400,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.Curve_III())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(XIn.y, appDryPt.XIn) annotation (Line(
      points={{-59,-50},{-28,-50},{-28,-5},{-1,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, appDryPt.p) annotation (Line(
      points={{-59,-18},{-30,-18},{-30,-2},{-1,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn.y, appDryPt.hIn) annotation (Line(
      points={{-59,-80},{-24,-80},{-24,-8},{-1,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, appDryPt.m_flow) annotation (Line(
      points={{-59,14},{-30,14},{-30,1},{-1,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.y, appDryPt.Q_flow) annotation (Line(
      points={{-59,48},{-24,48},{-24,3.9},{-1,3.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, appDryPt.speRat)    annotation (Line(
      points={{-59,82},{-16,82},{-16,7},{-1,7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/ApparatusDryPoint.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of ApparatusDryPoint block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end ApparatusDryPoint;
