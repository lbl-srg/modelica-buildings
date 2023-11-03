within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses;
model EffectivenessCalculation
  "Model for calculating the heat exchange effectiveness of heat exchangers"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Efficiency epsS_cool_nominal(max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsL_cool_nominal(max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsS_cool_partload(max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsL_cool_partload(max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsS_heat_nominal(max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsL_heat_nominal(max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsS_heat_partload(max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsL_heat_partload(max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.VolumeFlowRate vSup_flow_nominal(min = 100*Modelica.Constants.eps)
    "Nominal supply air flow rate";

  Modelica.Blocks.Interfaces.RealInput TSup(
    final min=0,
    final unit="K",
    final displayUnit="degC")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TExh(
    final min=0,
    final unit="K",
    final displayUnit="degC")
    "Exhaust air temperature
    " annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput vSup_flow(final unit="m3/s")
    "Volumetric flow rate of the supply air"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput vExh_flow( final unit="m3/s")
    "Volumetric flow rate of the exhaust air"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput y(final unit="1") "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput epsS(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput epsL(final unit="1")
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

protected
   Real ratV_flow
   "Ratio of the average operating volumetric air flow rate to the nominal supply air flow rate";
   Real epsS_partload
   "The partial load (75%) sensible heat exchanger effectiveness used for calculation";
   Real epsS_nominal
   "The nominal sensible heat exchanger effectiveness used for calculation";
   Real epsL_partload
   "The partial load (75%) latent heat exchanger effectiveness used for calculation";
   Real epsL_nominal
   "The nominal latent heat exchanger effectiveness used for calculation";

equation
  // check if the air flow is too unbalanced.
  assert(vSup_flow - 2*vExh_flow < 0 or vExh_flow - 2*vSup_flow < 0,
    "Unbalanced air flow ratio",
    level=AssertionLevel.warning);
  // calculate the average volumetric air flow and flow rate ratio.
  ratV_flow = (vSup_flow + vExh_flow)/2/vSup_flow_nominal;
  // check if the extrapolation goes too far.
  assert(ratV_flow > 0.5 and ratV_flow < 1.3,
    "Operating flow rate outside full accuracy range",
    level=AssertionLevel.warning);

  epsS_partload = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsS_cool_partload, epsS_heat_partload, 1e-5);
  epsS_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsS_cool_nominal, epsS_heat_nominal, 1e-5);
  epsL_partload = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsL_cool_partload, epsL_heat_partload, 1e-5);
  epsL_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsL_cool_nominal, epsL_heat_nominal, 1e-5);
  // calculate effectiveness
    epsS = y*(epsS_partload + (epsS_partload - epsS_partload)*(
      ratV_flow-0.75)/0.25);
    epsL = y*(epsL_partload + (epsL_nominal - epsL_partload)*(
      ratV_flow-0.75)/0.25);
  assert(epsS > 0 and epsS < 1,
    "Insensed value for the sensible heat exchanger effectivenes",
    level=AssertionLevel.error);
  assert(epsL > 0 and epsL < 1,
    "Insensed value for the latent heat exchanger effectivenes",
    level=AssertionLevel.error);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-54,28},{50,-40}},
          textColor={28,108,200},
          textString="eps")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="EffCal",
    Documentation(info="<html>
<p>
This block calculates the sensible and latent effectiveness of the heat exchanger for heating and cooling conditions
at different air flow rates of the supply air stream and the exhaust air stream.
</p>

<p> It first calculates the average volumetric air flow rate through the heat exchanger by:</p>

<pre>
  v_ave = (v_sup + v_exh)/2,
  vRat = v_ave/v_sup_nom,
</pre>

<p>
where <code>v_ave</code> is the average volumetric air flow rate,
<code>v_sup</code> is the air flow of the supply air stream,
<code>v_exh</code> is the air flow of the exhaust air stream,
<code>v_sup_nom</code> is the nominal air flow of the supply air stream and 
<code>vRat</code> is the flow ratio.
</p>

<p> It then calculates the sensible and latent effectiveness by:</p>

<pre>
  epsS = y * (epsS_75 + (epsS_100 - epsS_75) * (vRat - 0.75)/0.25),
  epsL = y * (epsL_75 + (epsL_100 - epsL_75) * (vRat - 0.75)/0.25),
</pre>
where <code>epsS</code> and <code>epsL</code> are the effectiveness
for the sensible and latent heat transfer, respectively.
<code>epsS_100</code> and <code>epsS_75</code> are the effectiveness 
for the sensible heat transfer when <code>vRat</code> is 1 and 0.75, respectively.
<code>epsL_100</code> and <code>epsL_75</code> are the effectiveness 
for the latent heat transfer when <code>vRat</code> is 1 and 0.75, respectively.
<code>y</code> is an effectiveness associated with the speed of a rotary wheel.

<p>
<code>epsS_100</code>, <code>epsS_75</code>, <code>epsL_100</code>, and <code>epsL_75</code> are parameters.
Depending on the cooling or heating mode, their values are different.
In this model, if the supply air temperature is larger than the exhaust air temperature, the exchanger is considered to operate under
the cooling mode;
Otherwise, it is considered to operate under a heating mode.
</p>

<P>
<b>Note:</b> The average volumetric air flow rate should be between 50% and 130% of the nominal supply air flow rate.
In addition, the ratio of the supply air flow rate to the exhaust air flow rate should be between 0.5 and 2.
</P>

<h4>References</h4>
U.S. Department of Energy 2016.
&quot;EnergyPlus Engineering reference&quot;.
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end EffectivenessCalculation;
