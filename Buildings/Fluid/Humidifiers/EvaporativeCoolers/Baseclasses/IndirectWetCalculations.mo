within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block IndirectWetCalculations
  "Calculates the heat transfer in an indirect wet evaporative cooler"

  parameter Real maxEff(
    unit="1")
    "Maximum efficiency of heat exchanger coil";

  parameter Real floRat(
    unit="1")
    "Coil flow efficency ratio of actual to maximum heat transfer rate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final unit="m3/s",
    final quantity = "VolumeFlowRate")
    "Primary air volume flow rate"
    annotation (Placement(transformation(origin={-120,-60}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-140,-60}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSec_flow(
    final unit="m3/s",
    final quantity = "VolumeFlowRate")
    "Secondary air volume flow rate"
    annotation (Placement(transformation(origin={-120,-100}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-140,-100}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDryBulPriIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the primary inlet air"
    annotation (Placement(transformation(origin={-120,100}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-140,100}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBulPriIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the primary inlet air"
    annotation (Placement(transformation(origin={-120,60}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-140,60}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDryBulSecIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the secondary inlet air"
    annotation (Placement(transformation(origin={-120,20}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-140,20}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBulSecIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the secondary inlet air"
    annotation (Placement(transformation(origin={-120,-20}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-140,-20}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDryBulPriOut(
    displayUnit="degC",
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the outlet air"
    annotation (Placement(transformation(origin={120,0}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={140,0}, extent={{-20,-20},{20,20}})));

  Real eff(
    unit="1")
    "Actual efficiency of component";

equation
  eff = max((maxEff - floRat*abs(VPri_flow)/abs(VSec_flow)),0);
  TDryBulPriOut = TDryBulPriIn - eff*(TDryBulSecIn - TWetBulSecIn);

annotation (defaultComponentName="indWetCal",
  Documentation(info="<html>
<p>
Block that calculates the water vapor mass flow rate addition in the 
indirect evaporative cooler component. The calculations are based on the indirect 
wet evaporative cooler model in the Engineering Reference document from EnergyPlus 
v23.1.0.
</p>
<p>
The effective efficiency of the heat exchanger <code>eff</code> is calculated using 
the formula
</p>
<p align=\"center\" style=\"font-style:italic;\">
eff = max((maxEff - floRat*abs(VPri_flow)/abs(VSec_flow)), 0)
</p>
<p>
where <code>VPri_flow</code> and <code>VSec_flow</code> are the volume flow 
rates of the primary and secondary fluid media respectively. The maximum 
efficiency of the heat exchanger <code>maxEff</code> and the efficiency-reduction
coil flow ratio <code>floRat</code> are empirically determined for the specific
equipment based on experiments.
</p>
<p>
The outlet primary fluid drybulb temperature <code>TDryBulPriOut</code> is calculated 
using the energy-balance equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
TDryBulPriOut = TDryBulPriIn - eff*(TDryBulSecIn - TWetBulSecIn)
</p>
<p>
where <code>TDryBulPriIn</code> is the inlet primary fluid drybulb temperature, 
<code>TDryBulSecIn</code> is the inlet secondary air drybulb temperature and 
<code>TWetBulSecIn</code> is the inlet secondary air wetbulb temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023 by Karthikeya Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(extent={{-120,-120},{120,120}}),
                graphics={Text(
        extent={{-150,160},{150,120}},
        textString="%name",
        textColor={0,0,255}), Rectangle(extent={{-120,120},{120,-120}},
            lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end IndirectWetCalculations;
