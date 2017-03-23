within Buildings.HeatTransfer.Conduction.BaseClasses;
partial model PartialConductor "Partial model for heat conductor"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.SIunits.Area A "Heat transfer area";
  final parameter Modelica.SIunits.CoefficientOfHeatTransfer U = UA/A
    "U-value (without surface heat transfer coefficients)";
  final parameter Modelica.SIunits.ThermalConductance UA = 1/R
    "Thermal conductance of construction (without surface heat transfer coefficients)";
  parameter Modelica.SIunits.ThermalResistance R
    "Thermal resistance of construction";
  Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Heat port at surface a" annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    "Heat port at surface b" annotation (Placement(transformation(extent={{90,-10},{
            110,10}}, rotation=0)));
equation
  dT = port_a.T - port_b.T;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
Partial model for single layer and multi layer heat conductors.
The heat conductor can be steady-state or transient.
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialConductor;
