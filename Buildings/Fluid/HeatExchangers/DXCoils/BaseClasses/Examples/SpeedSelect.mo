within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model SpeedSelect "Test model for speed select"
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedSelect speSel(
    nSta=datCoi.nSta,
    speSet=datCoi.sta.spe) "Normalizes the input speed"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  parameter Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil
                datCoi(nSta=4, sta={
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-12000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.9),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=1200/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.2),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_II()),
        Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-30000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.8),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples.PerformanceCurves.Curve_III())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.IntegerTable sta(table=[0,0; 10,1; 20,2; 30,3; 40,4;
        50,0]) "Stage of compressor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation

  connect(sta.y, speSel.stage) annotation (Line(
      points={{-19,6.10623e-16},{0,-3.36456e-22},{0,6.10623e-16},{19,
          6.10623e-16}},
      color={255,127,0},
      smooth=Smooth.None));
annotation (experiment(StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/SpeedSelect.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of SpeedSelect block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedSelect\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedSelect</a>.
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
August 29, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedSelect;
