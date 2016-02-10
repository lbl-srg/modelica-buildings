within Buildings.Fluid.MassExchangers;
model ConstantEffectiveness
  "Heat and moisture exchanger with constant effectiveness"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
  redeclare replaceable package Medium1 = Modelica.Media.Interfaces.PartialCondensingGases,
  redeclare replaceable package Medium2 = Modelica.Media.Interfaces.PartialCondensingGases,
  sensibleOnly1=false,
  sensibleOnly2=false,
  Q1_flow = epsS * QMax_flow,
  Q2_flow = -Q1_flow,
  mWat1_flow = +mWat_flow,
  mWat2_flow = -mWat_flow);

  parameter Modelica.SIunits.Efficiency epsS(max=1) = 0.8
    "Sensible heat exchanger effectiveness";
  parameter Modelica.SIunits.Efficiency epsL(max=1) = 0.8
    "Latent heat exchanger effectiveness";

  Medium1.MassFraction X_w_in1 "Inlet water mass fraction of medium 1";
  Medium2.MassFraction X_w_in2 "Inlet water mass fraction of medium 2";

  Modelica.SIunits.MassFlowRate mWat_flow
    "Water flow rate from medium 2 to medium 1";
  Modelica.SIunits.MassFlowRate mMax_flow
    "Maximum water flow rate from medium 2 to medium 1";

protected
  parameter Integer i1_w(min=1, fixed=false) "Index for water substance";
  parameter Integer i2_w(min=1, fixed=false) "Index for water substance";
  Real gai1(min=0, max=1) "Auxiliary variable for smoothing at zero flow";
  Real gai2(min=0, max=1) "Auxiliary variable for smoothing at zero flow";
initial algorithm
  i1_w:= -1;
  i2_w:= -1;
  for i in 1:Medium1.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium1.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then
      i1_w := i;
    end if;
   end for;
  for i in 1:Medium2.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium2.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then
      i2_w := i;
    end if;
   end for;
    assert(i1_w > 0, "Substance 'water' is not present in Medium1 '"
         + Medium1.mediumName + "'.\n"
         + "Check medium model.");
    assert(i2_w > 0, "Substance 'water' is not present in Medium2 '"
         + Medium2.mediumName + "'.\n"
         + "Check medium model.");
equation
  // Definitions for effectiveness model
  X_w_in1 = Modelica.Fluid.Utilities.regStep(m1_flow,
                  state_a1_inflow.X[i1_w],
                  state_b1_inflow.X[i1_w], m1_flow_small);
  X_w_in2 = Modelica.Fluid.Utilities.regStep(m2_flow,
                  state_a2_inflow.X[i2_w],
                  state_b2_inflow.X[i2_w], m2_flow_small);

  // mass exchange
  // Compute a gain that goes to zero near zero flow rate.
  // This is required to smoothen the heat transfer at very small flow rates.
  // Note that gaiK = 1 for abs(mK_flow) > mK_flow_small
  gai1 = Modelica.Fluid.Utilities.regStep(abs(m1_flow) - 0.75*m1_flow_small,
              1, 0, 0.25*m1_flow_small);
  gai2 = Modelica.Fluid.Utilities.regStep(abs(m2_flow) - 0.75*m2_flow_small,
              1, 0, 0.25*m2_flow_small);

  mMax_flow = smooth(1, min(smooth(1, gai1 * abs(m1_flow)),
                            smooth(1, gai2 * abs(m2_flow)))) * (X_w_in2 - X_w_in1);
  mWat_flow = epsL * mMax_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,255},
          textString="u"),
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,50},{48,-10}},
          lineColor={255,255,255},
          textString="epsS=%epsS"),
        Text(
          extent={{-60,4},{50,-56}},
          lineColor={255,255,255},
          textString="epsL=%epsL")}),
          preferredView="info",
defaultComponentName="masExc",
Documentation(info="<html>
<p>
Model for a heat and moisture exchanger with constant effectiveness.
</p>
<p>
This model transfers heat and moisture in the amount of </p>
<pre>
  Q = epsS * Q_max,
  m = epsL * mWat_max,
</pre>
<p>
where <code>epsS</code> and <code>epsL</code> are constant effectiveness
for the sensible and latent heat transfer,
<code>Q_max</code> is the maximum heat that can be transferred and
<code>mWat_max</code> is the maximum moisture that can be transferred.
</p>
<p>
For a sensible heat exchanger, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
<p>
This model can only be used with medium models that define the integer constant
<code>Water</code> which needs to be equal to the index of the water mass fraction
in the species vector.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 14, 2013 by Michael Wetter:<br/>
Replaced access to constant <code>Medium1.Water</code> by introducing
the parameter <code>i1_w</code>, and used a similar construct for
<code>Medium2</code>.
This avoids an error during model check as these constants are not known
in the partial medium model.
</li>
<li>
August 13, 2013 by Michael Wetter:<br/>
Corrected error in the documentation.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Updated model to use new variable <code>mWat_flow</code>
in the base class.
</li>
<li>
January 28, 2010, by Michael Wetter:<br/>
Added regularization near zero flow.
</li>
<li>
October 21, 2008, by Michael Wetter:<br/>
First implementation, based on
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>.
</li>
</ul>
</html>"));
end ConstantEffectiveness;
