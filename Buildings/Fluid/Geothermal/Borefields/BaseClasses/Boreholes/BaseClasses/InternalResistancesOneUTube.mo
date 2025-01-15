within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalResistancesOneUTube
  "Internal resistance model for single U-tube borehole segments."
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalResistances;

  parameter Modelica.Units.SI.ThermalResistance Rgg_val
    "Thermal resistance between the two grout zones";
  parameter Modelica.Units.SI.HeatCapacity Co_fil=borFieDat.filDat.dFil*
      borFieDat.filDat.cFil*hSeg*Modelica.Constants.pi*(borFieDat.conDat.rBor^2
       - 2*borFieDat.conDat.rTub^2)
    "Heat capacity of the whole filling material";

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,70})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(
    C=Co_fil/2,
    T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    if not borFieDat.filDat.steadyState
    "Heat capacity of the filling material" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,50})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(
    C=Co_fil/2,
    T(start=T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
    der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)))
    if not borFieDat.filDat.steadyState
    "Heat capacity of the filling material" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={70,50})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg(R=Rgg_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,50})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,0})));

equation
  connect(port_1, Rpg1.port_a)
    annotation (Line(points={{0,100},{0,100},{0,80}}, color={191,0,0}));
  connect(Rpg1.port_b, Rgb1.port_a) annotation (Line(points={{0,60},{0,60},{0,50},
          {-30,50},{-30,40}}, color={191,0,0}));
  connect(Rgb1.port_b, port_wall) annotation (Line(points={{-30,20},{-30,20},{-30,
          0},{0,0}}, color={191,0,0}));
  connect(capFil1.port, Rgb1.port_a)
    annotation (Line(points={{-60,50},{-30,50},{-30,40}}, color={191,0,0}));
  connect(Rgg.port_a, Rgb1.port_a)
    annotation (Line(points={{20,50},{-30,50},{-30,40}}, color={191,0,0}));
  connect(port_2, Rpg2.port_b)
    annotation (Line(points={{100,0},{90,0},{80,0}}, color={191,0,0}));
  connect(Rgg.port_b, Rpg2.port_a) annotation (Line(points={{40,50},{46,50},{50,
          50},{50,0},{60,0}}, color={191,0,0}));
  connect(Rgb2.port_b, Rpg2.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={191,0,0}));
  connect(Rgb2.port_a, port_wall)
    annotation (Line(points={{20,0},{0,0},{0,0}}, color={191,0,0}));
  connect(capFil2.port, Rgg.port_b)
    annotation (Line(points={{60,50},{50,50},{40,50}}, color={191,0,0}));

    annotation (
    Documentation(info="<html>
<p>
This model simulates the internal thermal resistance network of a borehole segment in
the case of a single U-tube borehole using the method of Bauer et al. (2011)
and computing explicitely the fluid-to-ground thermal resistance
<i>R<sub>b</sub></i> and the
grout-to-grout resistance
<i>R<sub>a</sub></i> as defined by Claesson and Hellstrom (2011)
using the multipole method.
</p>
<h4>References</h4>
<p>J. Claesson and G. Hellstrom.
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger.
</i>
HVAC&amp;R Research,
17(6): 895-911, 2011.</p>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
Thermal resistance and capacity models for borehole heat exchangers
</i>.
International Journal Of Energy Research, 35:312-320, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2024, by Michael Wetter:<br/>
Updated model due to removal of parameter <code>dynFil</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
</li>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
Extended the model from a partial class.
</li>
<li>
June, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Line(
          points={{-2,100}},
          color={0,0,0},
          thickness=1),          Text(
          extent={{-100,144},{100,106}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}));
end InternalResistancesOneUTube;
