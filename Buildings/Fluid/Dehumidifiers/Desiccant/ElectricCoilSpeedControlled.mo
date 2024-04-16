within Buildings.Fluid.Dehumidifiers.Desiccant;
model ElectricCoilSpeedControlled
  "Desiccant dehumidifier with an electric heating coil and a variable speed wheel"
  extends BaseClasses.PartialDesiccant(
    vol(nPorts=2));
  parameter Real etaHea(
    final min=0,
    final max=1)
    "Heater efficiency"
    annotation (Dialog(group="Efficiency"));
  parameter Real c[:] = {1}
    "Coefficients for power consumption curve for the rotor"
    annotation (Dialog(group="Efficiency"));

  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(
    extent={{-280,-20},{-240,20}}), iconTransformation(extent={{-140,-20},
    {-100,20}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=QReg_flow_nominal)
    "Heating coil for the regeneration air"
    annotation (Placement(transformation(extent={{16,56},{-4,76}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter PEleHea(
    final k=1/etaHea)
    "Calculate the heater power consumption"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow fan(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2_nominal)
    "Regeneration fan"
    annotation (Placement(transformation(extent={{80,56},{60,76}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(final threshold=dehPer.uSpe_min)
    "Convert real input to boolean output "
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Modelica.Blocks.Sources.RealExpression X_w_ProEnt(final y(final unit="1")=
    res.port_b.Xi_outflow[i1_w])
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-110,-72},{-90,-52}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dp1_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
protected
  Modelica.Blocks.Sources.RealExpression PEle(final y=PMot_nominal*
    Buildings.Utilities.Math.Functions.polynomial(a=c, x=uSpe))
    "Electric power consumption"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Modelica.Blocks.Sources.RealExpression mReg_flow(
    final y(final unit="kg/s")=
    dehPer.VReg_flow*Medium2.density(state=Medium2.setState_phX(
    p=port_a2.p,
    h=port_a2.h_outflow,
    X=port_a2.Xi_outflow)))
    "Regeneration air mass flow rate"
    annotation (Placement(transformation(extent={{20,76},{40,96}})));
  Modelica.Blocks.Math.Add3 add3
    "Sum of the three inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

initial equation
  assert(abs(sum(c)-1) < Modelica.Constants.eps,
    "In " + getInstanceName() + ": Power efficiency curve is wrong. 
    The sum of the coefficients for power efficiency curve should equal to 1.",
    level=AssertionLevel.error);

equation
  connect(add3.y, P)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(dehPer.yQReg, hea.u)
    annotation (Line(points={{-37,-92},{30,-92},{30,72},
    {18,72}}, color={0,0,127}));
  connect(hea.port_b, vol.ports[2])
    annotation (Line(points={{-4,66},{-95,66}}, color={0,127,255}));
  connect(fan.port_a, port_a2)
    annotation (Line(points={{80,66},{84,66},{84,80},{100,80}},
    color={0,127,255}));
  connect(fan.port_b, hea.port_a)
    annotation (Line(points={{60,66},{16,66}}, color={0,127,255}));
  connect(mReg_flow.y,fan. m_flow_in)
    annotation (Line(points={{41,86},{70,86},{70,78}}, color={0,0,127}));
  connect(add3.u1,fan. P)
    annotation (Line(points={{58,8},{34,8},{34,75},{59,75}}, color={0,0,127}));
  connect(PEleHea.y, add3.u3)
    annotation (Line(points={{2,-60},{46,-60},{46,-8},{58,-8}},
    color={0,0,127}));
  connect(hea.Q_flow, PEleHea.u)
    annotation (Line(points={{-5,72},{-48,72},{-48,-60},{-22,-60}},
    color={0,0,127}));
  connect(dehPer.uSpe, uSpe)
    annotation (Line(points={{-56.2,-73},{-56.2,0},
    {-260,0}}, color={0,0,127}));
  connect(realToBoolean.u, uSpe)
    annotation (Line(points={{-182,-40},{-200,-40},
    {-200,0},{-260,0}}, color={0,0,127}));
  connect(realToBoolean.y, dehPer.uRot) annotation (Line(points={{-159,-40},{-126,-40},
    {-126,-75.8},{-59,-75.8}}, color={255,0,255}));
  connect(PEle.y, add3.u2)
    annotation (Line(points={{1,-30},{26,-30},{26,0},{58,0}},
    color={0,0,127}));
  connect(res.port_a, port_a1)
    annotation (Line(points={{-200,-100},{-240,-100}}, color={0,127,255}));
  connect(res.port_b, outCon.port_a)
    annotation (Line(points={{-180,-100},{-120,-100},
    {-120,-126},{-20,-126},{-20,-100},{-6,-100}}, color={0,127,255}));
  connect(X_w_ProEnt.y, dehPer.X_w_ProEnt)
    annotation (Line(points={{-89,-62},{-78,-62},
    {-78,-88},{-59,-88}}, color={0,0,127}));
  annotation (
  defaultComponentName="deh",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{76,94},{50,74},{76,58},{76,94}},
          lineColor={28,108,200},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{48,98},{86,54}}, lineColor={28,108,200}),
        Rectangle(
          extent={{16,94},{36,52}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Line(points={{36,94},{16,52}}, color={28,108,200}),
        Text(
          extent={{26,20},{82,-34}},
          textColor={28,108,200},
          textString="V")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model considers a desiccant dehumidifier system with an electric coil, a variable-speed regeneration fan, and a
variable-speed motor, as shown below.
<p align=\"left\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/Dehumidifiers/Desiccant/BaseClasses/system_schematic_VFD.png\"
alt=\"System_Schematic.png\" border=\"1\"/>
</p>
<p>
The system configuration of the dehumidifier device is described in 
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PartialDesiccant\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PartialDesiccant</a>.
</p>
<p>
Note that the operation of the coil and the fan is assumed to be ideal, i.e., they can
provide the required regeneration heating power and the regeneration flow rate, which
are calculated by 
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>, 
when their capacities permit.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricCoilSpeedControlled;
