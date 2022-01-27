within Buildings.Fluid.Storage.Ice.BaseClasses;
model IceMass "Mass of ice remaining in the tank"

  parameter Modelica.Units.SI.Mass mIce_max;
  parameter Real SOC_start(min=0, max=1, final unit="1")
   "Start value for state of charge";

  parameter Modelica.Units.SI.SpecificEnergy Hf=333550 "Fusion of heat of ice";

  Modelica.Blocks.Interfaces.RealInput Q_flow(final unit="W")
    "Heat transfer rate: positive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput QEff_flow(final unit="W")
    "Actual heat flow rate, taking into account 0 &le; SOC &le; 1"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
                       iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mIce "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
                       iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "State of charge"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Boolean charged "True if tank is fully charged";
  Boolean discharged "True if tank is fully discharged";
  Boolean suspend "True if either fully charged or fully discharged";

initial equation
  mIce = mIce_max*SOC_start;
  charged = SOC_start >= 1;
  discharged = SOC_start <= 0;

equation

  der(SOC) = if suspend then 0 else Q_flow/(Hf*mIce_max);
  suspend = charged or discharged;
  QEff_flow = if suspend then 0 else Q_flow;
  mIce =SOC*mIce_max;

  when SOC < 0 then
    discharged = true;
    charged = pre(charged);
  elsewhen SOC > 1 then
    charged = true;
    discharged = pre(discharged);
  elsewhen (pre(discharged) and Q_flow > 1) then
    charged = pre(charged);
    discharged = false;
  elsewhen (pre(charged) and Q_flow < -1) then
    charged = false;
    discharged = pre(discharged);
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
This block calculates the mass of ice in the storage <i>m<sub>ice</sub></i> using
</p>
<p align=\"center\" style=\"font-style:italic;\">
dx/dt = Q&#775;<sub>eff</sub>/(H<sub>f</sub> &nbsp; m<sub>ice,max</sub>)
</p>
<p align=\"center\" style=\"font-style:italic;\">
m<sub>ice</sub> = x &nbsp; m<sub>ice,max
</p>
<p>
where <i>x</i> is the fraction of charge, or the state of charge,
<i>Q&#775;</i> is the heat transfer rate of the ice tank, positive for charging and negative for discharging,
<i>Hf</i> is the fusion of heat of ice and
<i>m<sub>ice,max</sub></i> is the nominal mass of ice in the storage tank.
</p>
<p>
The model sets <i>Q&#775;<sub>eff</sub> = Q&#775;</i>, unless the state of charge is 0 or 1,
in which case <i>Q&#775;<sub>eff</sub></i> is set to zero if it were to lead to
over- or under-charging.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2022, by Michael Wetter:<br/>
Rewrote model to avoid state of charge to be outside of <i>[0, 1]</i>.
</li>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IceMass;
