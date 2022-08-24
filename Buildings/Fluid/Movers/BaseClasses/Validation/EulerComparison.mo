within Buildings.Fluid.Movers.BaseClasses.Validation;
model EulerComparison
  "Validates the Euler number method at nominal mover speed"
  extends Modelica.Icons.Example;

  parameter Integer nOri(min=1)=size(per1.power.V_flow,1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Density rhoCon=1.2
    "Constant density";

  parameter Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13 per1
    "Mover performance curves with flow rate, pressure rise, and power";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per=per1,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power characteristic"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Buildings.Fluid.Movers.Data.Generic per2(
    final powerOrEfficiencyIsHydraulic=per1.powerOrEfficiencyIsHydraulic,
    final etaHydMet=
           Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
    final etaMotMet=
           Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided,
    pressure=per1.pressure,
    power=per1.power)
    "Peak condition";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per=per2,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power Euler correlation"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));

  Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant rho(k=rhoCon) "Density"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Units.SI.VolumeFlowRate V_flow = m_flow.y/rhoCon "Volumetric flow rate";
  Modelica.Units.SI.Power P1(displayUnit="W")=
    if per1.powerOrEfficiencyIsHydraulic
    then eff1.WHyd
    else eff1.PEle
    "Power from interpolation (total or hydraulic depending on data)";
  Modelica.Units.SI.Power P2(displayUnit="W")=
    if per1.powerOrEfficiencyIsHydraulic
    then eff2.WHyd
    else eff2.PEle
    "Power from Euler number (total or hydraulic depending on data)";
  Modelica.Units.SI.Efficiency eta1=
    if per1.powerOrEfficiencyIsHydraulic
    then eff1.etaHyd
    else eff1.eta
    "Efficiency from interpolation (total or hydraulic depending on data)";
  Modelica.Units.SI.Efficiency eta2=
    if per1.powerOrEfficiencyIsHydraulic
    then eff2.etaHyd
    else eff2.eta
    "Efficiency from Euler number (total or hydraulic depending on data)";

  Modelica.Blocks.Sources.Ramp m_flow(
    height=eff1.V_flow_max*rhoCon,
    duration=1)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(eff1.rho, rho.y)
    annotation (Line(points={{-12,-6},{-26,-6},{-26,10},{-39,10}},
                                               color={0,0,127}));
  connect(y.y, eff1.y_in)
    annotation (Line(points={{-39,50},{-4,50},{-4,12}},   color={0,0,127}));
  connect(m_flow.y, eff1.m_flow) annotation (Line(points={{-39,-30},{-18,-30},{-18,
          4},{-12,4}}, color={0,0,127}));
  connect(y.y, eff2.y_in) annotation (Line(points={{-39,50},{-4,50},{-4,18},{18,
          18},{18,-14},{-4,-14},{-4,-22}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{-39,10},{-26,10},{-26,-40},
          {-12,-40}},               color={0,0,127}));
  connect(m_flow.y, eff2.m_flow) annotation (Line(points={{-39,-30},{-12,-30}},
                           color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/EulerComparison.mos"
 "Simulate and plot"),
Documentation(
info="<html>
<p>
This model validates the power and efficiency computation using the Euler number
and its correlation as implemented in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler\">
Buildings.Fluid.Movers.BaseClasses.Euler</a>.
Its results of calculated efficiency and power are compared with those obtained
using power curves.
</p>
<p>
Note that full performance curves are needed in this validation model
because otherwise
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
would not know the pressure of the mover.
See <a href=\"modelica://Buildings.Fluid.Movers.Validation.PowerEuler\">
Buildings.Fluid.Movers.Validation.PowerEuler</a>
for a more typical use case where only the peak point itself is supplied.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end EulerComparison;
