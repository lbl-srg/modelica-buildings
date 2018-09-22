within Buildings.Occupants.Office.Blinds;
model Zhang2012BlindsSAltitude
  "A model to predict occupants' blinds behavior with solar altitude"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Real AUp = 1.089 "Slope of solar altitude for blinds up";
  parameter Real ADown = 1.031 "Slope of solar altitude for blinds down";
  parameter Real BUp = -3.446 "Intercept for blinds up";
  parameter Real BDown = -3.424 "Intercept for blinds down";
  parameter Integer seed = 10 "Seed for the random number generator";
  parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

  Modelica.Blocks.Interfaces.RealInput solarAltitude(
    unit="rad") "Solar Altitude" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput occ
    "Indoor occupancy, true for occupied"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput blindState(
    final min=0,
    final max=1,
    final unit="1")
    "State of blinds, 1 being up, 0 being down"
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
  parameter Modelica.SIunits.Time t0(final fixed = false) "First sample time instant";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;
  blindState = 1 "Initial state of blinds is deployed";
  pUp = 0;
  pDown = 0;

equation
  sampleTrigger = sample(t0,samplePeriod);
  when sampleTrigger then
    if occ then
      if pre(blindState) == 1 then
        pUp = 0;
        pDown = Modelica.Math.exp(ADown*solarAltitude+BDown)/(Modelica.Math.exp(ADown*solarAltitude+BDown)+1);
        if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pDown,globalSeed=integer(seed*time)) then
          blindState = 0;
        else
          blindState = 1;
        end if;
      else
        pUp = Modelica.Math.exp(AUp*solarAltitude+BUp)/(Modelica.Math.exp(AUp*solarAltitude+BUp)+1);
        pDown = 0;
        if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pUp,globalSeed=integer(seed*time)) then
          blindState = 1;
        else
          blindState = 0;
        end if;
      end if;
    else
      pUp = 0;
      pDown = 0;
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
            textString="Blinds_SA")},
defaultComponentName="bli",
Documentation(info="<html>
<p>
Model predicting the state of the blinds with the solar altitude
and occupancy.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds are always down. When the
space is occupied, the lower the solar altitude is, the higher
the chance that the blind state will be changed, either being turned on or turned off.
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
July 24, 2018, by Zhe Wang:<br/>
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
end Zhang2012BlindsSAltitude;
