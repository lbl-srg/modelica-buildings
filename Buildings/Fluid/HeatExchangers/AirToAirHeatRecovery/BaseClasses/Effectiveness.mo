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
  parameter Modelica.Units.SI.VolumeFlowRate VSup_flow_nominal
    "Nominal supply air flow rate";

  Modelica.Blocks.Interfaces.RealInput TSup(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TExh(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Exhaust air temperature
    " annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput VSup_flow(final unit="m3/s")
    "Supply air volumetric flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput VExh_flow( final unit="m3/s")
    "Exhaust air volumetric flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
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
  // Check if the air flows are too unbalanced
  assert(noEvent(VSup_flow - 2*VExh_flow < 0) or noEvent(VExh_flow - 2*VSup_flow < 0),
    "*** Warning in " + getInstanceName() + ": The ratio of the supply flow rate to the exhaust flow rate should be in the range of [0.5, 2].",
    level=AssertionLevel.warning);
  // Calculate the average volumetric air flow and flow rate ratio.
  rat = (VSup_flow + VExh_flow)/2/VSup_flow_nominal;
  // Check if the extrapolation goes too far
  assert(noEvent(rat > 0.5) and noEvent(rat < 1.3),
    "*** Warning in " + getInstanceName() + ": The ratio of the operating flow rate to the nominal supply flow rate should be in the range of [0.5, 1.3].",
    level=AssertionLevel.warning);
  // Switch between cooling and heating modes based on the difference between the supply air temperature and the exhaust air temperature
  epsSenPL = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsSenCooPL, epsSenHeaPL, 1e-5);
  epsSen_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsSenCoo_nominal, epsSenHea_nominal, 1e-5);
  epsLatPL = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsLatCooPL, epsLatHeaPL, 1e-5);
  epsLat_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsLatCoo_nominal, epsLatHea_nominal, 1e-5);
  // Calculate effectiveness
  epsSen =uSpe*(epsSenPL + (epsSen_nominal - epsSenPL)*(rat - 0.75)/0.25);
  epsLat =uSpe*(epsLatPL + (epsLat_nominal - epsLatPL)*(rat - 0.75)/0.25);
  assert(noEvent(epsSen >= 0) and noEvent(epsSen < 1),
    "*** Error in " + getInstanceName() + ": The sensible heat exchange effectiveness epsSen = " + String(epsSen) + ". It should be in the range of [0, 1].
    Check if the part load (75%) or nominal sensible heat exchanger effectiveness is too high or too low.",
    level=AssertionLevel.error);
  assert(noEvent(epsLat >= 0) and noEvent(epsLat < 1),
    "*** Error in " + getInstanceName() + ": The latent heat exchange effectiveness epsLat = " + String(epsLat) + ". It should be in the range of [0, 1], 
    Check if the part load (75%) or nominal latent heat exchanger effectiveness is too high or too low.",
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
It firstly calculates the ratio of the average volumetric flow rate to the nominal
supply flow rate by:
</p>
<pre>
  rat = (VSup_flow + VExh_flow)/(2*VSup_flow_nominal),
</pre>
<p>
where <code>VSup_flow</code> is the flow rate of the supply air;
<code>VExh_flow</code> is the flow rate of the exhaust air;
<code>VSup_flow_nominal</code> is the nominal flow rate of the supply air; and 
<code>rat</code> is the flow ratio.
</p>
<p>
It then calculates the sensible and latent effectiveness by:
</p>
<pre>
  epsSen = uSpe * (epsSenPL + (epsSen_nominal - epsSenPL) * (rat - 0.75)/0.25),
  epsLat = uSpe * (epsLatPL + (epsLat_nominal - epsLatPL) * (rat - 0.75)/0.25),
</pre>
where <code>epsSen</code> and <code>epsLat</code> are the effectiveness
for the sensible and latent heat transfer, respectively;
<code>epsSen_nominal</code> and <code>epsSenPL</code> are the effectiveness 
for the sensible heat transfer when <code>rat</code> is 1 and 0.75, respectively;
<code>epsLat_nominal</code> and <code>epsLatPL</code> are the effectiveness 
for the latent heat transfer when <code>Rat</code> is 1 and 0.75, respectively;
<code>uSpe</code> is the speed ratio of a rotary wheel.
<p>
The parameters <code>epsSen_nominal</code>, <code>epsSenPL</code>, <code>epsLat_nominal</code>, and 
<code>epsLatPL</code> have different values depending on if the wheel is in
the cooling or heating mode.
If the supply air temperature is greater than the exhaust air 
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
