within Buildings.Fluid.Storage.Ice_ntu.BaseClasses_save;
model StateOfCharge "Mass of ice remaining in the tank"
  extends Modelica.Blocks.Icons.Block;

  parameter Real SOC_start(min=0, max=1, final unit="1")
   "Start value for state of charge";

  parameter Modelica.Units.SI.Energy E_nominal "Storage capacity";

  Modelica.Blocks.Interfaces.RealInput Q_flow(final unit="W")
    "Heat transfer rate: positive for charging, negative for discharging"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput QEff_flow(final unit="W")
    "Actual heat flow rate, taking into account 0 &le; SOC &le; 1"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
                       iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput SOC(
    final min=0,
    final max=1,
    final unit="1")
    "State of charge"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Boolean charged "True if tank is fully charged";
  Boolean discharged "True if tank is fully discharged";
  Boolean suspend "True if either fully charged or fully discharged";

initial equation
  SOC = SOC_start;
  charged = SOC_start >= 1;
  discharged = SOC_start <= 0;

equation
  der(SOC) = if suspend then 0 else Q_flow/E_nominal;
  suspend = charged or discharged;
  QEff_flow = if suspend then 0 else Q_flow;

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

  annotation (defaultComponentName="soc",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(textColor = {0, 0, 88}, extent = {{-42, 48}, {48, -48}}, textString = "SOC")}),
    Diagram(
      coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block calculates the state of charge using
</p>
<p align=\"center\" style=\"font-style:italic;\">
d SOC/dt = Q&#775;<sub>eff</sub>/(H<sub>f</sub> &nbsp; m<sub>ice,max</sub>)
</p>
<p>
where <i>SOC</i> is the state of charge,
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
end StateOfCharge;
