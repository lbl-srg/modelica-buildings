within Buildings.HeatTransfer.Conduction.BaseClasses;
partial model PartialConductor "Partial model for heat conductor"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.Units.SI.Area A "Heat transfer area";
  final parameter Modelica.Units.SI.CoefficientOfHeatTransfer U=UA/A
    "U-value (without surface heat transfer coefficients)";
  final parameter Modelica.Units.SI.ThermalConductance UA=1/R
    "Thermal conductance of construction (without surface heat transfer coefficients)";
  parameter Modelica.Units.SI.ThermalResistance R
    "Thermal resistance of construction";

  Modelica.Units.SI.TemperatureDifference dT "port_a.T - port_b.T";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Heat port at surface a" annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    "Heat port at surface b" annotation (Placement(transformation(extent={{90,-10},{
            110,10}})));
equation
  dT = port_a.T - port_b.T;
  annotation (    Documentation(info="<html>
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
