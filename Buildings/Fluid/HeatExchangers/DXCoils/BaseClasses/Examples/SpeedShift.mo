within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model SpeedShift "Test model for SpeedShift block"
 extends Modelica.Icons.Example;
 parameter Integer nSta=4 "Number of standard compressor speeds";
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedShift speShi(nSta=nSta, speSet=
        datCoi.sta.spe,
    variableSpeedCoil=true)
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  Modelica.Blocks.Sources.Constant u[nSta](k={10,20,30,40}) "Inputs"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.25; 900,0.50; 1800,0.50;
        2700,0.75; 3600,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
  parameter AirSource.Data.Generic.CoolingCoil datCoi(nSta=4, sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I_AirCooled()),
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_II_AirCooled()),
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_III_AirCooled())})
    "Coil data" annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation

  connect(u.y, speShi.u)     annotation (Line(
      points={{-19,-40},{0,-40},{0,-8},{40,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, speShi.speRat)        annotation (Line(
      points={{-71,50},{30.5,50},{30.5,6.66134e-16},{40,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, greaterThreshold.u) annotation (Line(
      points={{-71,50},{-58,50},{-58,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold.y, booleanToInteger.u) annotation (Line(
      points={{-19,10},{-2,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanToInteger.y, speShi.stage) annotation (Line(
      points={{21,10},{32,10},{32,8},{40,8}},
      color={255,127,0},
      smooth=Smooth.None));
annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/SpeedShift.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of SpeedShift block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedShift\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedShift</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023 by Xing Lu:<br/>
Changed class for data record <code>datCoi</code> from <code>DXCoil</code> to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil</a>.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
August 8, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedShift;
