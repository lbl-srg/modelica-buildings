within Buildings.Fluid.Storage.Ice.BaseClasses;
model IceMass "Mass of ice remaining in the tank"

  parameter Modelica.SIunits.Mass mIce_max;
  parameter Modelica.SIunits.Mass mIce_start;
  parameter Modelica.SIunits.SpecificEnergy Hf=333550 "Fusion of heat of ice";

  Modelica.Blocks.Interfaces.RealInput q
    "Heat transfer rate: postive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput mIce "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput fraCha "state of charge"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
      iconTransformation(extent={{100,30},{120,50}})));

protected
  Boolean underCharged "Flag, true if battery is undercharged";
  Boolean overCharged "Flag, true if battery is overcharged";

initial equation
  pre(underCharged) = fraCha < 0;
  pre(overCharged)  = fraCha > 1;
  mIce = mIce_start;

equation

  der(fraCha)=q/(Hf*mIce_max);

  mIce = fraCha*mIce_max;

  // Equations to warn if state of charge exceeds 0 and 1
  underCharged = fraCha < 0;
  overCharged = fraCha > 1;
  when change(underCharged) or change(overCharged) then
    assert(fraCha >= 0, "Warning: Battery is below minimum charge.",
    level=AssertionLevel.warning);
    assert(fraCha <= 1, "Warning: Battery is above maximum charge.",
    level=AssertionLevel.warning);
  end when;

  annotation (defaultComponentName="iceMas",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block calculates the remaining mass of the ice in the storage <code>m<sub>ice</sub></code> following the below equations:
</p>

<p align=\"center\" style=\"font-style:italic;\">
    dx/dt = q/(H<sub>f</sub>*m<sub>ice,max</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
 m<sub>ice</sub> = x*m<sub>ice,max
</p>

where <code>x</code> is the fraction of charge, or the state of charge, 
<code>q</code> is the heat transfer rate of the ice tank, positive for charging and negative for discharging,
<code>Hf</code> is the fusion of heat of ice,
<code>m<sub>ice,max</sub></code> is the nominal mass of ice in the storage tank.

</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IceMass;
