within Buildings.Occupants.Office.Occupancy;
model Wang2005Occupancy
  "A model to predict Occupancy of a single person office"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  parameter Modelica.Units.SI.Time one_mu(displayUnit="min") = 4368
    "Mean occupancy duration";
  parameter Modelica.Units.SI.Time zero_mu(displayUnit="min") = 2556
    "Mean vacancy duration";
  parameter Integer localSeed = 10
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";

  Modelica.Blocks.Interfaces.BooleanOutput occ(start=true, fixed=true)
    "The State of occupancy, true for occupied"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  discrete Real mu;
  discrete Real tNext(start=0, fixed=true);
  discrete Real hold_time;
  Real r(min=0, max=1) "Generated random number";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState](
    each start=0,
    each fixed=true);

initial equation
  state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);

algorithm
  when initial() then
    (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
    occ :=false;
    mu :=if occ then one_mu else zero_mu;
    hold_time :=-mu*Modelica.Math.log(1 - r);
    tNext :=time + hold_time;
   elsewhen time >= pre(tNext) then
    (r, state) :=Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state));
    occ :=not pre(occ);
    mu :=if occ then one_mu else zero_mu;
    hold_time :=-mu*Modelica.Math.log(1 - r);
    tNext :=time + hold_time;
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
