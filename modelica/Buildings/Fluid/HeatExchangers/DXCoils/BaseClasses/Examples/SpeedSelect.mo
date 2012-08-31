within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model SpeedSelect "Test model for speed select"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedSelect speSel[3](each
      nSpe=datCoi.nSpe, each speSet=datCoi.per.spe)
    "Selects lower value of standard speed"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Ramp speRat1(
    startTime=0,
    offset=0,
    height=1.1,
    duration=60) "Speed ratio"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Sine speRat2(freqHz=0.004) "Speed ratio"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Sine speRat3(freqHz=0.004, phase=1.5707963267949)
    "Speed ratio"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
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

  connect(speRat1.y, speSel[1].speRatIn) annotation (Line(
      points={{-19,50},{0,50},{0,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat2.y, speSel[2].speRatIn) annotation (Line(
      points={{-19,6.10623e-16},{-0.5,6.10623e-16},{-0.5,6.66134e-16},{18,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(speRat3.y, speSel[3].speRatIn) annotation (Line(
      points={{-19,-50},{0,-50},{0,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/SpeedSelect.mos"
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
August 29, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end SpeedSelect;
