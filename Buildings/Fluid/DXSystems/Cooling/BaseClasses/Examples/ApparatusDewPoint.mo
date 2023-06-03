within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples;
model ApparatusDewPoint "Test model for ApparatusDewPoint"
  extends Modelica.Icons.Example;
  parameter Integer nSta=4 "Number of standard compressor speeds";
  package Medium =
      Buildings.Media.Air;
  parameter Real minSpeRat(min=0,max=1) = 0.2 "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint adp(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    variableSpeedCoil=true)
    "Calculates air properties at apparatus dew point condition"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=600,
    height=1.35,
    startTime=600) "Mass flow rate of air"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Modelica.Blocks.Sources.Ramp XEvaIn(
    duration=600,
    height=0.004,
    startTime=1800,
    offset=0.011) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    duration=600,
    startTime=600,
    height=-20000) "Cooling rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable speRat(
    offset=0,
    startTime=0,
    table=[0.0,0.00; 600,0.25; 1800,0.5; 2700,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  parameter Cooling.AirSource.Data.Generic.Coil datCoi(nSta=4, sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_II_AirCooled()),
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves.Curve_III_AirCooled())})
    "Coil data" annotation (Placement(transformation(extent={{60,60},{80,80}})));
protected
  Modelica.Blocks.Logical.Hysteresis deaBan(
     uLow=minSpeRat - speRatDeaBan/2,
     uHigh=minSpeRat + speRatDeaBan/2) "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-32,76},{-20,88}})));
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{-6,76},{6,88}})));
public
  Modelica.Blocks.Sources.Constant hEvaIn(k=Medium.specificEnthalpy(
        Medium.setState_pTX(
        p=101325,
        T=30 + 273.15,
        X={0.015}))) "Air enthalpy at inlet"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  connect(Q_flow.y, adp.Q_flow) annotation (Line(
      points={{-59,50},{-46,50},{-46,13.9},{39,13.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, adp.p) annotation (Line(
      points={{-59,-16},{-50,-16},{-50,8},{39,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, adp.m_flow) annotation (Line(
      points={{-59,16},{-50,16},{-50,11},{39,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn.y, adp.XEvaIn) annotation (Line(
      points={{-59,-50},{-46,-50},{-46,5},{39,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, adp.speRat)    annotation (Line(
      points={{-59,82},{-40,82},{-40,17},{39,17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, deaBan.u) annotation (Line(
      points={{-59,82},{-33.2,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y, onSwi.u) annotation (Line(
      points={{-19.4,82},{-7.2,82}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, adp.stage) annotation (Line(
      points={{6.6,82},{20,82},{20,20},{39,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(hEvaIn.y, adp.hEvaIn) annotation (Line(
      points={{-59,-90},{-40,-90},{-40,2},{39,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/BaseClasses/Examples/ApparatusDewPoint.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates calculation of air properties at apparatus dew point:
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Xing Lu and Karthik Devaprasad:<br/>
Updated data record class for <code>datCoi</code> from <code>DXCoil</code> to
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.Coil\">
Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.Coil</a>.<br/>
</li>
<li>
April 10, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end ApparatusDewPoint;
