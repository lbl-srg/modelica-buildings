within Buildings.Occupants.Office;
package Blinds "Package with models to simulate blinds behaviors in office buildings"
  extends Modelica.Icons.Package;

  model Newsham1994BlindsSIntensity
    "A model to predict occupants' blinds behavior with Solar Intensity"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real H_threshold = 233 "Threshold for turning on/off the blinds";
    parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

    Modelica.Blocks.Interfaces.RealInput H(unit="W/m2") "Solar Intensity at the room-side of the window"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
          iconTransformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanInput occ
      "Indoor occupancy, true for occupied"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealOutput blindState(min=0, max=1, unit="1")
      "State of Blinds, 1 being blinds deployed"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
    parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
    output Boolean sampleTrigger "True, if sample time instant";

  initial equation
    t0 = time;

  equation
    sampleTrigger = sample(t0,samplePeriod);
    when sampleTrigger then
      if occ then
        if H < H_threshold then
          blindState = 1;
        else
          blindState = 0;
        end if;
      else
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
space is occupied, if the Solar intensity is above the threshold, the blinds would be turned off.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Newsham, G.R., 1994. Manual control of window blinds 
and electric lighting: implications for comfort and energy consumption. Indoor Environment, 3, pp.135-144.&quot;.
</p>
<p>
The Solar Intensity threshold was first identified by a field study in 
an office building in Japan, and was utilized by Newsham for a simulation
study in an office building in Toronto.
</p>
</html>",
  revisions="<html>
<ul>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.</li>
<li>
August 31, 2018, by Zhe Wang:<br/>
First Revision.
</li>
</ul>
</html>"),
      Icon(graphics={Text(
            extent={{-98,98},{94,-96}},
            lineColor={28,108,200},
            textString="ob.office
Blind")}));
  end Newsham1994BlindsSIntensity;

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
      p =1 - Modelica.Math.exp(A1*Modelica.Math.log10(H) + A2*LSen + B)/(
        Modelica.Math.exp(A1*Modelica.Math.log10(H) + A2*LSen + B) + 1);
      if occ then
        if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p, globalSeed=integer(seed*1E6*time)) then
          blindState = 1;
        else
          blindState = 0;
        end if;
      else
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

  model Zhang2012BlindsSIntensity
    "A model to predict occupants' blinds behavior with Solar Intensity"
    extends Modelica.Blocks.Icons.DiscreteBlock;
    parameter Real Aup = 0.003 "Slope of Solar Intensity for blinds up";
    parameter Real Adown = 0.002 "Slope of Solar Intensity for blinds down";
    parameter Real Bup = -3.33 "Intercept for blinds up";
    parameter Real Bdown = -3.17 "Intercept for blinds down";
    parameter Integer seed = 10 "Seed for the random number generator";
    parameter Modelica.SIunits.Time samplePeriod = 120 "Sample period";

    Modelica.Blocks.Interfaces.RealInput H(
      unit="W/m2") "Solar Intensity" annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.BooleanInput occ
      "Indoor occupancy, true for occupied"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealOutput blindState
      "The State of Blinds, 1 being blinds deployed"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    Real pup(
      unit="1",
      min=0,
      max=1) "The probability of blinds up";
    Real pdown(
      unit="1",
      min=0,
      max=1) "The probability of blinds down";

protected
    parameter Modelica.SIunits.Time t0(fixed = false) "First sample time instant";
    output Boolean sampleTrigger "True, if sample time instant";

  initial equation
    t0 = time;
    blindState = 1 "Initial state of blinds is 100% on";

  equation
    sampleTrigger = sample(t0,samplePeriod);
    when sampleTrigger then
      pup = Modelica.Math.exp(Aup*H+Bup)/(Modelica.Math.exp(Aup*H+Bup)+1);
      pdown = Modelica.Math.exp(Adown*H+Bdown)/(Modelica.Math.exp(Adown*H+Bdown)+1);
      if occ then
        if pre(blindState) == 1 then
          if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pdown,globalSeed=integer(seed*1E6*time)) then
            blindState = 0;
          else
            blindState = 1;
          end if;
        else
          if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p=pup,globalSeed=integer(seed*1E6*time)) then
            blindState = 1;
          else
            blindState = 0;
          end if;
        end if;
      else
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
<h4>Inputs</h4>
<p>
H: solar intensity outside of the window, should be input with the unit of W/m2. 
</p>
<p>
occupancy: a boolean variable, true indicates the space is occupied, 
false indicates the space is unoccupied.
</p>
<h4>Outputs</h4>
<p>The state of blinds: a real variable, 1 indicates the blind 
is 100% on, 0 indicates the blind is 100% off.
</p>
<h4>Dynamics</h4>
<p>
When the space is unoccupied, the blinds is always on. When the 
space is occupied, the lower the Solar Intensity is, the higher 
the chance that the blind is on.
</p>
<h4>References</h4>
<p>
The model is documented in the paper &quot;Zhang, Y. and Barrett, P., 2012. 
Factors influencing occupants’ blind-control behaviour in a naturally 
ventilated office building. Building and Environment, 54, pp.137-147.&quot;.
</p>
<p>
The model parameters are regressed from the field study in an office building
in Sheffield, England.
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
  end Zhang2012BlindsSIntensity;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models to simulate blinds behaviors in office buildings.
</p>
</html>"),
  Icon(graphics={Text(
        extent={{-98,98},{94,-96}},
        lineColor={28,108,200},
        textString="Office
Blind")}));
end Blinds;
