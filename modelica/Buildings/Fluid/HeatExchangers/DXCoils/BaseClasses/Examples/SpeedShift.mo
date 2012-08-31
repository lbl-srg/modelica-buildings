within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model SpeedShift "Test model for SpeedShift block"
 extends Modelica.Icons.Example;
 parameter Integer nSpe=4 "Number of standard compressor speeds";
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedShift speShi(nSpe=nSpe, speSet=
        datCoi.per.spe)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant u[nSpe](k={10,20,30,40}) "Inputs"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.25; 900,0.50; 1800,0.50;
        2700,0.75; 3600,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
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

  connect(u.y, speShi.u)     annotation (Line(
      points={{-19,-40},{0,-40},{0,-5},{18,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, speShi.speRat)        annotation (Line(
      points={{-19,40},{0.5,40},{0.5,5},{18,5}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Diagram(graphics),
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
August 8, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end SpeedShift;
