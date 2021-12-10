within Buildings.HeatTransfer.Windows.BaseClasses;
model InteriorConvectionCoefficient
  "Model for the heat transfer coefficient at the inside of the window"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Area A "Heat transfer area";

  Modelica.Blocks.Interfaces.RealOutput GCon(unit="W/K")
    "Convective thermal conductance"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  GCon = 4*A;
  annotation ( Icon(graphics={
        Text(
          extent={{40,26},{92,-20}},
          textColor={0,0,127},
          textString="GCon")}),
           Documentation(info="<html>
Model for the convective heat transfer coefficient at the room-facing surface of a window.
The computation is according to TARCOG 2006, which specifies the convection
coefficient as
<p align=\"center\" style=\"font-style:italic;\">
  h = 4 W &frasl; (m<sup>2</sup> K).
</p>
<h4>References</h4>
<p>
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
end InteriorConvectionCoefficient;
