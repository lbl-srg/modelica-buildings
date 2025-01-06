within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses;
model Effectiveness
  "Model for calculating the heat exchange effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Efficiency epsSen_nominal(final max=1)
    "Nominal sensible heat exchanger effectiveness";
  parameter Modelica.Units.SI.Efficiency epsLat_nominal(final max=1)
    "Nominal latent heat exchanger effectiveness";
  parameter Modelica.Units.SI.Efficiency epsSenPL(final max=1)
    "Part load (75% of the nominal supply flow rate) sensible heat exchanger effectiveness";
  parameter Modelica.Units.SI.Efficiency epsLatPL(final max=1)
    "Part load (75% of the nominal supply flow rate) latent heat exchanger effectiveness";
  parameter Modelica.Units.SI.MassFlowRate mSup_flow_nominal
    "Nominal supply air mass flow rate";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mSup_flow(final unit="kg/s")
    "Supply air mass flow rate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mExh_flow(final unit="kg/s")
    "Exhaust air mass flow rate"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsSen(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsLat(final unit="1")
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}}),
        iconTransformation(extent={{100,-70},{140,-30}})));

protected
  Real rat
    "Ratio of the average operating air flow rate to the nominal supply air flow rate";
  Real ratRes
    "Ratio of the average operating air flow rate to the nominal supply air flow rate, restricted to valid domain";

equation
  // Calculate the average volumetric air flow and flow rate ratio.
  rat = (mSup_flow+mExh_flow)/2/mSup_flow_nominal;
  // Check if the air flows are too unbalanced, unless rat < 0.05, in which case
  // the system is likely off or transitioning to on or off.
  assert(rat < 0.05 or (mSup_flow - 2*mExh_flow <= 1e-5 and mExh_flow - 2*mSup_flow <= 1e-5),
    "In " + getInstanceName() + ": The ratio of the supply flow rate to the exhaust flow rate should be in the range of [0.5, 2] when flow rates are non-zero.",
    level=AssertionLevel.warning);
  // Calculate effectiveness
  ratRes = Buildings.Utilities.Math.Functions.smoothLimit(x=rat, l=0.5, u=1.3, deltaX=0.01);
  epsSen = (epsSenPL + (epsSen_nominal - epsSenPL)*(ratRes - 0.75)/0.25);
  epsLat = (epsLatPL + (epsLat_nominal - epsLatPL)*(ratRes - 0.75)/0.25);
  assert(epsSen >= 0 and epsSen < 1,
    "In " + getInstanceName() + ": The sensible heat exchange effectiveness epsSen = " + String(epsSen) + ". It should be in the range of [0, 1].
    Check if the part load (75% of the nominal supply flow rate) or nominal sensible heat exchanger effectiveness is too high or too low.",
    level=AssertionLevel.error);
  assert(epsLat >= 0 and epsLat < 1,
    "In " + getInstanceName() + ": The latent heat exchange effectiveness epsLat = " + String(epsLat) + ". It should be in the range of [0, 1],
    Check if the part load (75% of the nominal supply flow rate) or nominal latent heat exchanger effectiveness is too high or too low.",
    level=AssertionLevel.error);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-54,28},{50,-40}},
          textColor={28,108,200},
          textString="eps")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="effCal",
Documentation(info="<html>
<p>
This block calculates the sensible and latent effectiveness of the heat exchanger
under heating and cooling modes at different flow rates of the supply
air and the exhaust air.
</p>
<p>
It calculates the ratio of the average operating flow rate to the nominal
supply flow rate as
</p>
<pre>
  rat = max(0.5, min(1.3, (mSup_flow + mExh_flow)/(2*mSup_flow_nominal))),
</pre>
<p>
where <code>mSup_flow</code> is the mass flow rate of the supply air,
<code>mExh_flow</code> is the mass flow rate of the exhaust air,
<code>mSup_flow_nominal</code> is the nominal mass flow rate of the supply air, and
<code>rat</code> is the flow ratio.
</p>
<p>
It then calculates the sensible and latent heat exchanger effectiveness by:
</p>
<pre>
  epsSen = (epsSenPL + (epsSen_nominal - epsSenPL) * (rat - 0.75)/0.25),
  epsLat = (epsLatPL + (epsLat_nominal - epsLatPL) * (rat - 0.75)/0.25),
</pre>
<p>
where <code>epsSen</code> and <code>epsLat</code> are the effectiveness
for the sensible and latent heat transfer, respectively,
<code>epsSen_nominal</code> and <code>epsSenPL</code> are the effectiveness
for the sensible heat transfer when <code>rat</code> is 1 and 0.75, respectively,
<code>epsLat_nominal</code> and <code>epsLatPL</code> are the effectiveness
for the latent heat transfer when <code>Rat</code> is 1 and 0.75, respectively.
</p>
<P>
<b>Note:</b>
The value of the <code>rat</code> is suggested to be between <i>0.5</i> and <i>1.3</i> during normal operation
to ensure reasonable extrapolation.
Likewise, an unbalanced air flow ratio less than 2, i.e., <code>VSup_flow/VExh_flow</code> &#62; <i>0.5</i>
and <code>VSup_flow/VExh_flow</code> &#60; <i>2</i>, is recommended.
</P>
<h4>References</h4>
<p>
U.S. Department of Energy 2016.
&quot;EnergyPlus Engineering Reference&quot;.
</p>
</html>", revisions="<html>
<ul>
<li>
April 24, 2024, by Michael Wetter:<br/>
Restricted flow ratio to valid region.
</li>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Effectiveness;
