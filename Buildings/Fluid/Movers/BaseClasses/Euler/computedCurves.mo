within Buildings.Fluid.Movers.BaseClasses.Euler;
record computedCurves
  "Record for efficiency and power curves computed with Euler number"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.VolumeFlowRate V_flow[:](
    each min=0) "Volumetric flow rate";
  parameter Modelica.SIunits.Efficiency eta[size(V_flow,1)](
    each max=1) "Fan or pump efficiency at these flow rates";
  parameter Modelica.SIunits.Power P[size(V_flow,1)](each min=0)
    "Fan or pump electrical power at these flow rates";
  annotation (
Documentation(info="<html>
<p>
Record for both efficiency and power curves computed from the Euler number. 
[complete this part later]
This record differs from 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters</a>
and 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters</a>
in the following ways:
<ul>
<li>
The efficiency curve and the power curve are stored in the same record.
</li>
<li>
The support points for flow rate in this record normally does not match 
the input data, but is instead decided by 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.computeCurves\">
Buildings.Fluid.Movers.BaseClasses.Euler.computeCurves</a>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
October 29, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end computedCurves;
