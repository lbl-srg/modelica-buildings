within Buildings.Occupants.Office.Blinds;
model Zhang2012BlindsSolarIntensity
    "A model to predict occupants' blinds behavior with solar intensity"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real AUp = 0.003 "Slope of solar intensity for blinds up";
    parameter Real ADown = 0.002 "Slope of solar intensity for blinds down";
    parameter Real BUp = -3.33 "Intercept for blinds up";
    parameter Real BDown = -3.17 "Intercept for blinds down";
    parameter Integer seed = 10 "Seed for the random number generator";
  parameter Modelica.Units.SI.Time samplePeriod=120 "Sample period";

    Modelica.Blocks.Interfaces.RealInput H(
      unit="W/m2") "Solar intensity" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
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

    Real pUp(
      final unit="1",
      final min=0,
      final max=1) "The probability of blinds up";
    Real pDown(
      final unit="1",
      final min=0,
      final max=1) "The probability of blinds down";

protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
    output Boolean sampleTrigger "True, if sample time instant";
    Boolean isOpen "Blind state as a boolean";
    Real curSeed "Current value for seed as a real-valued variable";
initial equation
    t0 = time;
    curSeed = t0*seed;

    isOpen = false "Initial state of blinds is deployed";
    blindState = if isOpen then 0.0 else 1.0;

    pUp = 0;
    pDown = 0;

equation
    sampleTrigger = sample(t0,samplePeriod);
    when sampleTrigger then
      curSeed = seed*time;
      if occ then
        if pre(isOpen) == false then
          pUp = 0;
          pDown = Modelica.Math.exp(ADown*H+BDown)/(Modelica.Math.exp(ADown*H+BDown)+1);
          isOpen = Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pDown,globalSeed=integer(curSeed));
        else
          pUp = Modelica.Math.exp(AUp*H+BUp)/(Modelica.Math.exp(AUp*H+BUp)+1);
          pDown = 0;
          isOpen = not Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pUp,globalSeed=integer(curSeed));
        end if;
      else
        pUp = 0;
        pDown = 0;
        isOpen = false;
      end if;
      blindState = if isOpen then 0.0 else 1.0;
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
The model is documented in the paper &quot;Zhang, Y. and Barrett, P., 2012.
Factors influencing occupants’ blind-control behaviour in a naturally
ventilated office building. Building and Environment, 54, pp.137-147.&quot;
</p>
<p>
The model parameters are regressed from the field study in an office building
in Sheffield, England.
</p>
</html>",
  revisions="<html>
<ul>
<li>
November 30, 2018, by Michael Wetter:<br/>
Removed equality test on <code>Real</code> which is not allowed
in Modelica.
Removed wrong annotation.
</li>
<li>
August 31, 2018, by Zhe Wang:<br/>
First revision.
</li>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Zhang2012BlindsSolarIntensity;
