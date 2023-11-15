within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses;
model Effectiveness
  "Model for calculating the heat exchange effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Efficiency epsSenCoo_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCoo_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenCoo_ParLoa(final max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCoo_ParLoa(final max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenHea_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHea_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsSenHea_ParLoa(final max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHea_ParLoa(final max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the heating mode";
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
    "Volumetric flow rate of the supply air"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput VExh_flow( final unit="m3/s")
    "Volumetric flow rate of the exhaust air"
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
   Real epsSen_ParLoa
   "The partial load (75%) sensible heat exchanger effectiveness used for calculation";
   Real epsSen_nominal
   "The nominal sensible heat exchanger effectiveness used for calculation";
   Real epsLat_ParLoa
   "The partial load (75%) latent heat exchanger effectiveness used for calculation";
   Real epsLat_nominal
   "The nominal latent heat exchanger effectiveness used for calculation";

equation
  // check if the air flow is too unbalanced.
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
  epsSen_ParLoa = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsSenCoo_ParLoa, epsSenHea_ParLoa, 1e-5);
  epsSen_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsSenCoo_nominal, epsSenHea_nominal, 1e-5);
  epsLat_ParLoa = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsLatCoo_ParLoa, epsLatHea_ParLoa, 1e-5);
  epsLat_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsLatCoo_nominal, epsLatHea_nominal, 1e-5);
  // calculate effectiveness.
    epsSen =wheSpe*(epsSen_ParLoa + (epsSen_nominal - epsSen_ParLoa)*(rat -
    0.75)/0.25);
    epsLat =wheSpe*(epsLat_ParLoa + (epsLat_nominal - epsLat_ParLoa)*(rat -
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
for heating and cooling conditions at different air flow rates of the supply
air stream and the exhaust air stream.
</p>
<p>
It first calculates the average volumetric air flow rate through the heat exchanger by:
</p>
<pre>
  rat = (VSup_flow + VExh_flow)/(2*VSup_flow_nominal),
</pre>
<p>
where <code>VSup_flow</code> is the flow rate of the supply air stream,
<code>VExh_flow</code> is the flow rate of the exhaust air stream,
<code>VSup_flow_nominal</code> is the nominal flow rate of the supply air stream and 
<code>rat</code> is the flow ratio.
</p>
<p>
It then calculates the sensible and latent effectiveness by:
</p>
<pre>
  epsSen = wheSpe * (epsSen_ParLoa + (epsSen_nominal - epsSen_ParLoa) * (rat - 0.75)/0.25),
  epsLat = wheSpe * (epsLat_ParLoa + (epsLat_nominal - epsLat_ParLoa) * (rat - 0.75)/0.25),
</pre>
where <code>epsSen</code> and <code>epsLat</code> are the effectiveness
for the sensible and latent heat transfer, respectively.
<code>epsSen_nominal</code> and <code>epsSen_ParLoa</code> are the effectiveness 
for the sensible heat transfer when <code>rat</code> is 1 and 0.75, respectively.
<code>epsLat_nominal</code> and <code>epsLat_ParLoa</code> are the effectiveness 
for the latent heat transfer when <code>vRat</code> is 1 and 0.75, respectively.
<code>wheSpe</code> is the speed of a rotary wheel.
<p>
<code>epsSen_nominal</code>, <code>epsSen_ParLoa</code>, <code>epsLat_nominal</code>, and 
<code>epsLat_ParLoa</code> are parameters.
Depending on the cooling or heating mode, their values are different.
In this model, if the supply air temperature is larger than the exhaust air 
temperature, the exchanger is considered to operate under
the cooling mode;
Otherwise, it is considered to operate under a heating mode.
</p>
<P>
<b>Note:</b> 
The <code>rat</code> should be between <i>0.5</i> and <i>1.3</i> to ensure reasonable extrapolation.
Likewise, an unbalanced air flow ratio greater than 2,  i.e., <code>VSup_flow/VExh_flow</code> &#62; <i>2</i> 
or <code>VSup_flow/VExh_flow</code> &#60; <i>0.5</i>, is not recommended.
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
