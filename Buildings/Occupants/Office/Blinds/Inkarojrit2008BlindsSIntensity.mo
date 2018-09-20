within Buildings.Occupants.Office.Blinds;
model Inkarojrit2008BlindsSIntensity
    "A model to predict occupants' blinds behavior with Solar Intensity (and self-reported brightness sensitivity)"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real A1 = 3.22 "Slope of Solar Intensity at Window";
    parameter Real A2 = 1.22 "Slope of Occupants' brightness sensitivity";
    parameter Real B = -8.94 "Intercept";
    parameter Real LSen =  4 "Self-reported sensitivity to brightness,
  seven-point scale, 1 for least sensitive, 7 for most sensitive"   annotation(Dialog(enable = true,
                       tab = "Advanced"));
    parameter Integer seed = 10 "Seed for the random number generator";
    parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

    Modelica.Blocks.Interfaces.RealInput H(unit="W/m2") "Solar Intensity"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
          iconTransformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanInput occ
      "Indoor occupancy, true for occupied"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealOutput blindState
      "The State of Blinds, 1 being blinds deployed"
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
      if occ then
        p = 1 - Modelica.Math.exp(A1*Modelica.Math.log10(H) + A2*LSen + B)/(
          Modelica.Math.exp(A1*Modelica.Math.log10(H) + A2*LSen + B) + 1);
        if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p, globalSeed=integer(seed*time)) then
          blindState = 1;
        else
          blindState = 0;
        end if;
      else
        p = 0;
        blindState = 1;
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
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds is always on. When the
space is occupied, the lower the solar intensity is, the higher
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
<li>
August 31, 2018, by Zhe Wang:<br/>
First revision.
</li>
</ul>
</html>"),
      Icon(graphics={Text(
            extent={{-98,98},{94,-96}},
            lineColor={28,108,200},
            textString="ob.office
Blind")}));
end Inkarojrit2008BlindsSIntensity;
