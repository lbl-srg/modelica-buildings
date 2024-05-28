within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
partial model PartialInternalResistances
  "Partial model to implement borehole segment internal resistance models"
  parameter Modelica.Units.SI.Length hSeg
    "Length of the internal heat exchanger";
  parameter Modelica.Units.SI.Temperature T_start
    "Initial temperature of the filling material";
  parameter Data.Borefield.Template borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Modelica.Units.SI.ThermalResistance Rgb_val
    "Thermal resistance between grout zone and borehole wall";
  parameter Modelica.Units.SI.ThermalResistance RCondGro_val
    "Thermal resistance between: pipe wall to capacity in grout";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Boolean dynFil=true
      "Set to false to remove the dynamics of the filling material."
      annotation (Dialog(tab="Dynamics"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_1
    "Thermal connection for pipe 1"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    "Thermal connection for pipe 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_2
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,0},{0,10},{-10,20},{10,40},{-10,60},{10,80},{0,90},{0,
              100}},
            color={0,0,0},
          thickness=0.5),
        Line(
          points={{0,-70.7107},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,
              40},{-7.10543e-015,70.7107}},
          color={0,0,0},
          origin={50,50},
          rotation=45,
          thickness=0.5),
        Line(
          points={{0,-50},{0,-40},{-10,-30},{10,-10},{-10,10},{10,30},{0,40},{0,
              50}},
          color={0,0,0},
          origin={50,0},
          rotation=-90,
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
Partial model to implement the inner resistance network of a borehole segment.
</p>
<p>
The partial model uses a thermal port representing a uniform borehole wall for
that segment, and at least two other thermal ports (one for each tube going through the borehole
segment).
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation of partial class.
</li>
<li>
June, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInternalResistances;
