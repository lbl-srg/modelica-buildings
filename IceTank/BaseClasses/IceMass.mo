within IceTank.BaseClasses;
model IceMass "Mass of ice remaining in the tank"

  parameter Modelica.SIunits.Mass mIce_max;
  parameter Modelica.SIunits.Mass mIce_start;
  parameter Modelica.SIunits.SpecificEnergy Hf "Fusion of heat of ice";

  Modelica.Blocks.Interfaces.RealInput q
    "Heat transfer rate: postive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput mIce "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "state of charge"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
      iconTransformation(extent={{100,30},{120,50}})));

protected
  Boolean underCharged "Flag, true if battery is undercharged";
  Boolean overCharged "Flag, true if battery is overcharged";

initial equation
  pre(underCharged) = SOC < 0;
  pre(overCharged)  = SOC > 1;
  mIce = mIce_start;

equation

  der(SOC)=q/(Hf*mIce_max);

  mIce = SOC*mIce_max;

  // Equations to warn if state of charge exceeds 0 and 1
  underCharged = SOC < 0;
  overCharged = SOC > 1;
  when change(underCharged) or change(overCharged) then
    assert(SOC >= 0, "Warning: Battery is below minimum charge.",
    level=AssertionLevel.warning);
    assert(SOC <= 1, "Warning: Battery is above maximum charge.",
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
        coordinateSystem(preserveAspectRatio=false)));
end IceMass;
