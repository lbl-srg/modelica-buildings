within Buildings.Fluid.Storage.Ice.BaseClasses;
model IceMass "Mass of ice remaining in the tank"

  parameter Modelica.Units.SI.Mass mIce_max;
  parameter Modelica.Units.SI.Mass mIce_start;
  parameter Modelica.Units.SI.SpecificEnergy Hf=333550 "Fusion of heat of ice";

  Modelica.Blocks.Interfaces.RealInput Q_flow(final unit="W")
    "Heat transfer rate: positive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput mIce "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput fraCha "state of charge"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
      iconTransformation(extent={{100,30},{120,50}})));

initial equation
  mIce = mIce_start;

equation

  der(fraCha)=Q_flow/(Hf*mIce_max);

  mIce = fraCha*mIce_max;

  assert(fraCha >= 0, "Warning: Tank is below minimum charge.",
    level=AssertionLevel.warning);
  assert(fraCha <= 1, "Warning: Tank is above maximum charge.",
    level=AssertionLevel.warning);

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
This block calculates the mass of ice in the storage <i>m<sub>ice</sub></i> using
</p>
<p align=\"center\" style=\"font-style:italic;\">
    dx/dt = q/(H<sub>f</sub>*m<sub>ice,max</sub>)
</p>
<p align=\"center\" style=\"font-style:italic;\">
 m<sub>ice</sub> = x*m<sub>ice,max
</p>
<p>
where <i>x</i> is the fraction of charge, or the state of charge,
<i>q</i> is the heat transfer rate of the ice tank, positive for charging and negative for discharging,
<i>Hf</i> is the fusion of heat of ice and
<i>m<sub>ice,max</sub></i> is the nominal mass of ice in the storage tank.
</p>
</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IceMass;
