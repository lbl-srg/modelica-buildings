within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples;
model ApparatusDryPoint "Test model for ApparatusDryPoint"
  extends Modelica.Icons.Example;
  parameter Integer nSta=4;
  package Medium =
      Buildings.Media.Air;
  parameter Real minSpeRat(min=0,max=1) = 0.2 "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Sources.Constant p(
    k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
  Modelica.Blocks.Sources.Constant hEvaIn(k=Medium.specificEnthalpy(
        Medium.setState_pTX(
        p=101325,
        T=30 + 273.15,
        X={0.015}))) "Air enthalpy at inlet"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDryPoint appDryPt(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    variableSpeedCoil=true) "Dry point condition"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
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
    annotation (Placement(transformation(extent={{-6,76},{6,88}})));
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{20,76},{32,88}})));
public
  Modelica.Blocks.Sources.Ramp XEvaIn(
    duration=600,
    height=0.004,
    startTime=1800,
    offset=0.011) "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(p.y, appDryPt.p) annotation (Line(
      points={{-59,-18},{-30,-18},{-30,-2},{59,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn.y, appDryPt.hEvaIn) annotation (Line(
      points={{-59,-80},{-24,-80},{-24,-8},{59,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, appDryPt.m_flow) annotation (Line(
      points={{-59,14},{-30,14},{-30,1},{59,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.y, appDryPt.Q_flow) annotation (Line(
      points={{-59,48},{-24,48},{-24,3.9},{59,3.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, appDryPt.speRat)    annotation (Line(
      points={{-59,82},{-16,82},{-16,7},{59,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y,deaBan. u) annotation (Line(
      points={{-59,82},{-7.2,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y,onSwi. u) annotation (Line(
      points={{6.6,82},{18.8,82}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, appDryPt.stage) annotation (Line(
      points={{32.6,82},{46,82},{46,10},{59,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(XEvaIn.y, appDryPt.XEvaIn) annotation (Line(
      points={{-59,-50},{-28,-50},{-28,-5},{59,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/BaseClasses/Examples/ApparatusDryPoint.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of ApparatusDryPoint block
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDryPoint\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDryPoint</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
April 10, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end ApparatusDryPoint;
