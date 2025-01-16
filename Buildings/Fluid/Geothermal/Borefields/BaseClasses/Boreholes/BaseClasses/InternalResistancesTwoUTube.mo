within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model InternalResistancesTwoUTube
  "Internal resistance model for double U-tube borehole segments."
  extends
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalResistances;

  parameter Modelica.Units.SI.ThermalResistance Rgg1_val
    "Thermal resistance between two neightbouring grout capacities, as defined by Bauer et al (2010)";
  parameter Modelica.Units.SI.ThermalResistance Rgg2_val
    "Thermal resistance between two  grout capacities opposite to each other, as defined by Bauer et al (2010)";
  parameter Modelica.Units.SI.HeatCapacity Co_fil=
     if borFieDat.filDat.steadyState then 0
     else borFieDat.filDat.dFil*borFieDat.filDat.cFil*hSeg*Modelica.Constants.pi*
          (borFieDat.conDat.rBor^2 - 4*borFieDat.conDat.rTub^2)
    "Heat capacity of the whole filling material";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_3
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_4
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg1(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb1(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg14(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg21(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=270,
        origin={50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg11(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={90,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg2(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={80,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg12(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={50,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb2(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={30,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb3(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgb4(R=Rgb_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-30,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg4(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-80,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg13(R=Rgg2_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rpg3(R=RCondGro_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=90,
        origin={0,-68})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rgg22(R=Rgg1_val)
    "Grout thermal resistance" annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={30,-84})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil1(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if not borFieDat.filDat.steadyState "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{-8,-8},
            {8,8}},
        rotation=90,
        origin={-22,64})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil2(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if not borFieDat.filDat.steadyState "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{58,8},{
            74,24}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil3(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if not borFieDat.filDat.steadyState "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{-8,-8},
            {8,8}},
        rotation=90,
        origin={-26,-62})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor capFil4(T(start=
          T_start, fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
      der_T(fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)),
    C=Co_fil/4)  if not borFieDat.filDat.steadyState "Heat capacity of the filling material"
                                            annotation (Placement(transformation(extent={{-82,20},
            {-66,36}})));
equation
  connect(Rpg1.port_a, port_1)
    annotation (Line(points={{0,88},{0,100},{0,100}}, color={191,0,0}));
  connect(Rpg1.port_b, Rgb1.port_a)
    annotation (Line(points={{0,72},{0,72},{0,38}}, color={191,0,0}));
  connect(Rgb1.port_b, port_wall)
    annotation (Line(points={{0,22},{0,22},{0,0}}, color={191,0,0}));
  connect(port_wall, Rgb3.port_b)
    annotation (Line(points={{0,0},{0,0},{0,-22}}, color={191,0,0}));
  connect(Rpg3.port_a, port_3)
    annotation (Line(points={{0,-76},{0,-100}}, color={191,0,0}));
  connect(Rpg2.port_a, port_2)
    annotation (Line(points={{88,0},{100,0},{100,0}}, color={191,0,0}));
  connect(Rgb2.port_a, Rpg2.port_b)
    annotation (Line(points={{38,0},{56,0},{72,0}}, color={191,0,0}));
  connect(port_wall, Rgb2.port_b)
    annotation (Line(points={{0,0},{11,0},{22,0}}, color={191,0,0}));
  connect(port_wall, Rgb4.port_b)
    annotation (Line(points={{0,0},{-12,0},{-22,0}}, color={191,0,0}));
  connect(Rgb4.port_a, Rpg4.port_b) annotation (Line(points={{-38,8.88178e-016},
          {-56,8.88178e-016},{-56,0},{-72,0}}, color={191,0,0}));
  connect(Rpg4.port_a, port_4)
    annotation (Line(points={{-88,0},{-94,0},{-100,0}}, color={191,0,0}));
  connect(Rgg14.port_b, Rpg4.port_b) annotation (Line(points={{-50,22},{-50,0},{
          -56,8.88178e-016},{-56,0},{-72,0},{-72,-9.99201e-016}}, color={191,0,0}));
  connect(Rgg13.port_a, Rpg4.port_b) annotation (Line(points={{-50,-22},{-50,0},
          {-56,8.88178e-016},{-56,0},{-72,0},{-72,-9.99201e-016}}, color={191,0,
          0}));
  connect(Rgg13.port_b, Rpg3.port_b) annotation (Line(points={{-50,-38},{-50,-50},
          {0,-50},{0,-60},{4.996e-016,-60}}, color={191,0,0}));
  connect(Rgg13.port_b, Rgb3.port_a) annotation (Line(points={{-50,-38},{-50,-38},
          {-50,-50},{0,-50},{0,-38},{-4.44089e-016,-38}}, color={191,0,0}));
  connect(Rgg13.port_b, Rgg11.port_b) annotation (Line(points={{-50,-38},{-50,-38},
          {-50,-50},{0,-50},{90,-50},{90,22}}, color={191,0,0}));
  connect(Rgg13.port_b, Rgg12.port_b) annotation (Line(points={{-50,-38},{-50,-38},
          {-50,-50},{50,-50},{50,-38}}, color={191,0,0}));
  connect(Rgb2.port_a, Rgg12.port_a)
    annotation (Line(points={{38,0},{38,0},{50,0},{50,-22}}, color={191,0,0}));
  connect(Rgg21.port_a, Rpg2.port_b) annotation (Line(points={{50,22},{50,0},{72,
          0},{72,9.99201e-016}}, color={191,0,0}));
  connect(Rpg1.port_b, Rgg11.port_a) annotation (Line(points={{0,72},{0,72},{0,64},
          {90,64},{90,38}}, color={191,0,0}));
  connect(Rpg1.port_b, Rgg21.port_b) annotation (Line(points={{0,72},{0,72},{0,46},
          {50,46},{50,38}}, color={191,0,0}));
  connect(Rgg14.port_a, Rgb1.port_a) annotation (Line(points={{-50,38},{-50,46},
          {0,46},{0,38},{4.996e-016,38}}, color={191,0,0}));
  connect(Rgg22.port_a, Rpg4.port_b) annotation (Line(points={{22,-84},{-66,-84},
          {-66,0},{-72,0},{-72,-9.99201e-016}}, color={191,0,0}));
  connect(Rgg22.port_b, Rpg2.port_b) annotation (Line(points={{38,-84},{66,-84},
          {66,0},{72,0},{72,9.99201e-016}}, color={191,0,0}));
  connect(capFil1.port, Rgb1.port_a) annotation (Line(points={{-14,64},{0,64},{0,
          38},{4.996e-016,38}}, color={191,0,0}));
  connect(capFil2.port, Rpg2.port_b) annotation (Line(points={{66,8},{66,0},{72,
          0},{72,9.99201e-016}}, color={191,0,0}));
  connect(capFil3.port, Rpg3.port_b) annotation (Line(points={{-18,-62},{-12,-62},
          {-12,-50},{0,-50},{0,-60},{4.996e-016,-60}}, color={191,0,0}));
  connect(capFil4.port, Rpg4.port_b) annotation (Line(points={{-74,20},{-74,12},
          {-66,12},{-66,0},{-72,0},{-72,-9.99201e-016}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{0,-50},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,40},{0,
              50}},
          color={0,0,0},
          origin={-50,0},
          rotation=-90,
          thickness=0.5),
        Line(
          points={{0,-50},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,40},{0,
              50}},
          color={0,0,0},
          origin={0,-50},
          rotation=360,
          thickness=0.5),
        Line(
          points={{0,-70.7107},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,
              40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={-50,-50},
          rotation=45,
          thickness=0.5),
        Line(
          points={{7.10543e-015,-70.7107},{0,-40},{-10,-30},{9.99997,-9.99997},
              {-9.99997,9.99997},{10,30},{0,40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={-50,50},
          rotation=135,
          thickness=0.5),
        Line(
          points={{7.10543e-015,-70.7107},{0,-40},{-10,-30},{9.99997,-9.99997},
              {-9.99997,9.99997},{10,30},{0,40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={50,-50},
          rotation=135,
          thickness=0.5),        Text(
          extent={{-100,144},{100,106}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This model simulates the internal thermal resistance network of a borehole segment in
the case of a double U-tube borehole using the method of Bauer et al. (2011)
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
</html>"));
end InternalResistancesTwoUTube;
