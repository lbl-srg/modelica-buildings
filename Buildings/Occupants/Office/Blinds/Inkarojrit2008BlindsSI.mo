within Buildings.Occupants.Office.Blinds;
model Inkarojrit2008BlindsSI
  "A model to predict occupants' blinds behavior with Solar Intensity (and self-reported brightness sensitivity)"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real A1 = 3.22 "Slope of Solar Intensity at Window";
  parameter Real A2 = 1.22 "Slope of Occupants' brightness sensitivity";
  parameter Real B = -8.94 "Intercept";
  parameter Real LSen  = 4 "Self-reported sensitivity to brightness,
  seven-point scale, 1 for least sensitive, 7 for most sensitive" annotation(Dialog(enable = true,
                     tab = "Advanced"));
  parameter Integer seed = 10 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput SI(
    unit="W/m2") "Solar Intensity" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput BlindState
    "The State of Blinds, 1 for 100% on, 0 for 100% off"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real p(
    unit="1",
    min=0,
    max=1) "The probability of keeping the blinds on";

protected
  parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    p = 1-Modelica.Math.exp(A1*Modelica.Math.log10(SI)+A2*LSen +B)/(Modelica.Math.exp(A1*Modelica.Math.log10(SI)+A2*LSen +B)+1);
    if occ then
      if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p, globalSeed=seed) then
        BlindState = 1;
      else
        BlindState = 0;
      end if;
    else
      BlindState = 1;
    end if;
  end when;

  annotation (graphics={
            Rectangle(extent={{-60,40},{60,-40}}, lineColor={28,108,200}), Text(
            extent={{-40,20},{40,-20}},
            lineColor={28,108,200},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="Blinds_SI")},
defaultComponentName="bli",
Documentation(info="<html>
<p>
Model predicting the state of the blinds with the solar intensity at the window
and occupancy.
</p>
<h4>Inputs</h4>
<p>
SI: solar intensity at the window, should be input with the unit of W/m2.
</p>
<p>
Occupancy: a boolean variable, true indicates the space is occupied,
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of blinds: a real variable, 1 indicates the blind
is 100% on, 0 indicates the blind is 100% off.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds is always on. When the
space is occupied, the lower the SI is, the higher
the chance that the blind is on.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Inkarojrit, V., 2008. Monitoring and
modelling of manually-controlled Venetian blinds in private offices: a pilot
study. Journal of Building Performance Simulation, 1(2), pp.75-89.&quot;.
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
</ul>
</html>"));
end Inkarojrit2008BlindsSI;
