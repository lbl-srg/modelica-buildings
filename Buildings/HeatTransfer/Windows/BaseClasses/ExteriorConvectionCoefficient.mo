within Buildings.HeatTransfer.Windows.BaseClasses;
model ExteriorConvectionCoefficient
  "Model for the heat transfer coefficient at the outside of the window"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Area A "Heat transfer area";

  Modelica.Blocks.Interfaces.RealOutput GCon(unit="W/K")
    "Convective thermal conductance"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput v(unit="m/s") "Wind speed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  GCon = A*(4+4*Buildings.Utilities.Math.Functions.smoothMax(v, -v, 0.1));
  annotation ( Icon(graphics={
        Text(
          extent={{-92,22},{-50,-22}},
          textColor={0,0,127},
          textString="v"),
        Text(
          extent={{40,26},{92,-20}},
          textColor={0,0,127},
          textString="GCon")}),
           Documentation(info="<html>
Model for the convective heat transfer coefficient at the outside of a window.
The computation is according to TARCOG 2006, which specifies the convection
coefficient as
<p align=\"center\" style=\"font-style:italic;\">
  h = 4+4 v
</p>
where <i>v</i> is the wind speed in <i>m/s</i> and
<i>h</i> is the convective heat transfer coefficient in <i>W/(m2*K)</i>.
<br/>
<h4>References</h4>

TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</html>", revisions="<html>
<ul>
<li>
August 19 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExteriorConvectionCoefficient;
