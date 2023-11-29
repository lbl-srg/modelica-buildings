within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses;
model Effectiveness
  "Model for calculating the heat exchange effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Efficiency epsSenCoo_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCoo_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenCooPL(final max=1) = 0.75
    "Part load (75%) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCooPL(final max=1) = 0.75
    "Part load (75%) latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenHea_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHea_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsSenHeaPL(final max=1) = 0.75
    "Part load (75%) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHeaPL(final max=1) = 0.75
    "Part load (75%) latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.VolumeFlowRate VSup_flow_nominal(final min = 100*Modelica.Constants.eps)
    "Nominal supply air flow rate";

  Modelica.Blocks.Interfaces.RealInput TSup(
    final min=0,
    final unit="K",
    final displayUnit="degC")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TExh(
    final min=0,
    final unit="K",
    final displayUnit="degC")
    "Exhaust air temperature
    " annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput VSup_flow(final unit="m3/s")
    "Supply air volumetric flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput VExh_flow( final unit="m3/s")
    "Exhaust air volumetric flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput wheSpe(final unit="1")
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput epsSen(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput epsLat(final unit="1")
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

protected
   Real rat
   "Ratio of the average operating volumetric air flow rate to the nominal supply air flow rate";
   Real epsSenPL
   "Part load (75%) sensible heat exchanger effectiveness used for calculation";
   Real epsSen_nominal
   "Nominal sensible heat exchanger effectiveness used for calculation";
   Real epsLatPL
   "Part load (75%) latent heat exchanger effectiveness used for calculation";
   Real epsLat_nominal
   "Nominal latent heat exchanger effectiveness used for calculation";

equation
  // check if the air flows are too unbalanced.
  assert(VSup_flow - 2*VExh_flow < 0 or VExh_flow - 2*VSup_flow < 0,
    "Unbalanced air flow ratio",
    level=AssertionLevel.warning);
  // calculate the average volumetric air flow and flow rate ratio.
  rat = (VSup_flow + VExh_flow)/2/VSup_flow_nominal;
  // check if the extrapolation goes too far.
  assert(rat > 0.5 and rat < 1.3,
    "Operating flow rate outside the full accuracy range",
    level=AssertionLevel.warning);
  // switch between cooling and heating modes based on the difference between the supply air temperature and the exhaust air temperature.
  epsSenPL = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsSenCooPL, epsSenHeaPL, 1e-5);
  epsSen_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsSenCoo_nominal, epsSenHea_nominal, 1e-5);
  epsLatPL = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsLatCooPL, epsLatHeaPL, 1e-5);
  epsLat_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsLatCoo_nominal, epsLatHea_nominal, 1e-5);
  // calculate effectiveness.
    epsSen =wheSpe*(epsSenPL + (epsSen_nominal - epsSenPL)*(rat -
    0.75)/0.25);
    epsLat =wheSpe*(epsLatPL + (epsLat_nominal - epsLatPL)*(rat -
    0.75)/0.25);
  assert(epsSen > 0 and epsSen < 1,
    "Insensed value for the sensible heat exchanger effectiveness",
    level=AssertionLevel.error);
  assert(epsLat > 0 and epsLat < 1,
    "Insensed value for the latent heat exchanger effectiveness",
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
for heating and cooling conditions at different flow rates of the supply
air and the exhaust air.
</p>
<p>
It first calculates the average volumetric flow rate through the heat exchanger by:
</p>
<pre>
  rat = (VSup_flow + VExh_flow)/(2*VSup_flow_nominal),
</pre>
<p>
where <code>VSup_flow</code> is the flow rate of the supply air,
<code>VExh_flow</code> is the flow rate of the exhaust air,
<code>VSup_flow_nominal</code> is the nominal flow rate of the supply air, and 
<code>rat</code> is the flow ratio.
</p>
<p>
It then calculates the sensible and latent effectiveness by:
</p>
<pre>
  epsSen = wheSpe * (epsSenPL + (epsSen_nominal - epsSenPL) * (rat - 0.75)/0.25),
  epsLat = wheSpe * (epsLatPL + (epsLat_nominal - epsLatPL) * (rat - 0.75)/0.25),
</pre>
where <code>epsSen</code> and <code>epsLat</code> are the effectiveness
for the sensible and latent heat transfer, respectively.
<code>epsSen_nominal</code> and <code>epsSenPL</code> are the effectiveness 
for the sensible heat transfer when <code>rat</code> is 1 and 0.75, respectively.
<code>epsLat_nominal</code> and <code>epsLatPL</code> are the effectiveness 
for the latent heat transfer when <code>vRat</code> is 1 and 0.75, respectively.
<code>wheSpe</code> is the speed of a rotary wheel.
<p>
<code>epsSen_nominal</code>, <code>epsSenPL</code>, <code>epsLat_nominal</code>, and 
<code>epsLatPL</code> are parameters.
Depending on the cooling or heating mode, their values are different.
In this model, if the supply air temperature is larger than the exhaust air 
temperature, the exchanger is considered to operate under
the cooling mode;
Otherwise, it operates under the heating mode.
</p>
<P>
<b>Note:</b> 
The value of the <code>rat</code> is suggested to be between <i>0.5</i> and <i>1.3</i>, 
to ensure reasonable extrapolation.
Likewise, an unbalanced air flow ratio less than 2,  i.e., <code>VSup_flow/VExh_flow</code> &#62; <i>0.5</i> 
and <code>VSup_flow/VExh_flow</code> &#60; <i>2</i>, is recommended.
</P>
<h4>References</h4>
U.S. Department of Energy 2016.
&quot;EnergyPlus Engineering Reference&quot;.
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Effectiveness;
