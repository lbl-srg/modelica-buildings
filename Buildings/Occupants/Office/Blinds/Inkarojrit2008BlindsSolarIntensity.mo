within Buildings.Occupants.Office.Blinds;
model Inkarojrit2008BlindsSolarIntensity
    "A model to predict occupants' blinds behavior with solar intensity (and self-reported brightness sensitivity)"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real A1 = 3.22 "Slope of solar intensity at window";
    parameter Real A2 = 1.22 "Slope of Occupants' brightness sensitivity";
    parameter Real B = -8.94 "Intercept";
    parameter Real LSen =  4 "Self-reported sensitivity to brightness,
  seven-point scale, 1 for least sensitive, 7 for most sensitive"
  annotation(Dialog(tab = "Advanced"));
    parameter Integer localSeed = 12
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

    Modelica.Blocks.Interfaces.RealInput H(unit="W/m2") "Solar intensity"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
          iconTransformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanInput occ
      "Indoor occupancy, true for occupied"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealOutput blindState(
    final min=0,
    final max=1,
    final unit="1")
      "State of blinds, 1 being blinds down"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    Real p(
      final unit="1",
      final min=0,
      final max=1) "The probability of keeping the blinds on";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
    output Boolean sampleTrigger "True, if sample time instant";
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
    Boolean ran "Random number";

initial equation
    t0 = time;
    state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(
    localSeed = localSeed, 
    globalSeed = globalSeed);

    blindState = 0;
    p = 0;
    ran = false;

equation
    sampleTrigger = sample(t0,samplePeriod);
    when sampleTrigger then
      (ran, state) = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p, stateIn=pre(state));
      if occ then
        p = 1 - Modelica.Math.exp(A1*Modelica.Math.log10(H) + A2*LSen + B)/(
          Modelica.Math.exp(A1*Modelica.Math.log10(H) + A2*LSen + B) + 1);
        if ran then
          blindState = 1;
        else
          blindState = 0;
        end if;
      else
        p = 0;
        blindState = 1;
      end if;
    end when;

    annotation (Icon(graphics={
              Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
              extent={{-40,20},{40,-20}},
              textColor={28,108,200},
              fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              textStyle={TextStyle.Bold},
              textString="Blinds_SI")}),
  defaultComponentName="bli",
  Documentation(info="<html>
<p>
Model predicting the state of the blinds with the solar intensity at the window
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds are always down. When the
space is occupied, the lower the solar intensity, the higher
the chance that the blind is up.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Inkarojrit, V., 2008. Monitoring and
modelling of manually-controlled Venetian blinds in private offices: a pilot
study. Journal of Building Performance Simulation, 1(2), pp.75-89.&quot;
</p>
<p>
The model parameters are regressed from the field study in California in 2008
from 113 naturally ventilated buildings.
</p>
</html>",
  revisions="<html>
<ul>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
<li>
August 31, 2018, by Zhe Wang:<br/>
First revision.
</li>
</ul>
</html>"));
end Inkarojrit2008BlindsSolarIntensity;
