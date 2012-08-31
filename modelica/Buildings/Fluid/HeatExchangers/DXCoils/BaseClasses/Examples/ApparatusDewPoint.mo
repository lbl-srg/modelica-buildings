within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model ApparatusDewPoint "Test model for ApparatusDewPoint"
  extends Modelica.Icons.Example;
  parameter Integer nSpe=4 "Number of standard compressor speeds";
  package Medium =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint
                                                              adp(
    redeclare package Medium = Medium,
    nSpe=nSpe,
    datCoi=datCoi) "Calculates air properties at apparatus dew point condition"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    height=1.35,
    startTime=600) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Modelica.Blocks.Sources.Ramp XIn(
    duration=600,
    height=0.004,
    startTime=1800,
    offset=0.014) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Ramp hIn(
    duration=600,
    startTime=1800,
    height=10000,
    offset=65000) "Inlet air enthalpy"
    annotation (Placement(transformation(extent={{-80,-96},{-60,-76}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    duration=600,
    height=-20000,
    startTime=600) "Cooling rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable speRat(
    offset=0,
    startTime=0,
    table=[0.0,0.00; 600,0.25; 1800,0.5; 2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  Data.CoilData datCoi(nSpe=4, per={
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
  connect(Q_flow.y, adp.Q_flow) annotation (Line(
      points={{-59,50},{-46,50},{-46,13.9},{-1,13.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, adp.p) annotation (Line(
      points={{-59,-16},{-50,-16},{-50,8},{-1,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, adp.m_flow) annotation (Line(
      points={{-59,16},{-50,16},{-50,11},{-1,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn.y, adp.XIn) annotation (Line(
      points={{-59,-50},{-46,-50},{-46,5},{-1,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn.y, adp.hIn) annotation (Line(
      points={{-59,-86},{-40,-86},{-40,2},{-1,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, adp.speRat)    annotation (Line(
      points={{-59,82},{-40,82},{-40,17},{-1,17}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/ApparatusDewPoint.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates calculation of air properties at apparatus dew point:  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint</a>. 
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
end ApparatusDewPoint;
