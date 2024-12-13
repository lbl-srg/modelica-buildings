within Buildings.Occupants.Office.Occupancy;
model Wang2005Occupancy
  "A model to predict Occupancy of a single person office"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  parameter Modelica.Units.SI.Time one_mu(displayUnit="min") = 4368
    "Mean occupancy duration";
  parameter Modelica.Units.SI.Time zero_mu(displayUnit="min") = 2556
    "Mean vacancy duration";
  parameter Integer localSeed = 2005
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";

  Modelica.Blocks.Interfaces.BooleanOutput occ(start=true, fixed=true)
    "The State of occupancy, true for occupied"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Real mu;
  discrete Modelica.Units.SI.Time tNext;
  discrete Modelica.Units.SI.Time hold_time;
  discrete Real r(min=0, max=1) "Generated random number";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";

initial equation
  (r, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(
    Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed));
  mu = zero_mu;
  hold_time = -mu*Modelica.Math.log(1 - r);
  // Use max of 1 second to avoid cornercase of very tiny sampling
  tNext = time + max(1, hold_time);
equation
  when time >= pre(tNext) then
    (r, state) = Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
    occ = not pre(occ);
    mu = if occ then one_mu else zero_mu;
    hold_time = -mu*Modelica.Math.log(1 - r);
    tNext = pre(tNext) + max(1, hold_time);
  end when;

  annotation (Icon(graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            textColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Occupancy")}),
defaultComponentName="occ",
Documentation(info="<html>
<p>
Model predicting the occupancy of a single person office.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Wang, D., Federspiel, C.C. and
Rubinstein, F., 2005. Modeling occupancy in single person offices. Energy
and buildings, 37(2), pp.121-126.&quot;
</p>
<p>
The model parameters are regressed from a field study in California with 35
single person offices at a large office building from 12/29/1998 to 12/20/1999.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 6, 2024, by Michael Wetter:<br/>
Refactored implementation of random number calculations, transfering the local state of
the random number generator from one call to the next.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4069\">#4069</a>.
</li>
<li>
August 16, 2021, by Michael Wetter:<br/>
Reformulated model so it works also if the simulation does not start at <i>0</i>.<br/>
To improve efficiency, this reformulation also changes the event triggering function so that
it leads to time events rather than state events.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2590\">#2590</a>.
</li>
<li>
August 1, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Wang2005Occupancy;
