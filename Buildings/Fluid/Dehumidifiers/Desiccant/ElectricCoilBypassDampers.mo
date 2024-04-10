within Buildings.Fluid.Dehumidifiers.Desiccant;
model ElectricCoilBypassDampers
  "Desiccant dehumidifier with an electric heating coil and bypass dampers"
  extends BaseClasses.PartialDesiccant(
    vol(nPorts=2));
  parameter Real etaHea(
    final min=0,
    final max=1)
    "Heater efficiency"
    annotation (Dialog(group="Efficiency"));
  Modelica.Blocks.Interfaces.BooleanInput uRot
    "True when the wheel is operating" annotation (Placement(transformation(
    extent={{-280,-140},{-240,-100}}),
          iconTransformation(extent={{-140,-80},
            {-100,-40}})));
   Modelica.Blocks.Interfaces.RealInput uBypDamPos(
    final unit="1",
    final min=0,
    final max=1)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter PEleMot(
    final k= PMot_nominal)
    "Calculate the motor power consumption"
    annotation (Placement(transformation(extent={{-20,-42},{0,-22}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamPro(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal) "Process air bypass damper"
    annotation (Placement(transformation(extent={{-170,-130},{-150,-110}})));
   Buildings.Fluid.Actuators.Dampers.Exponential damPro(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal) "Process air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},rotation=0,origin={-130,-100})));
  Modelica.Blocks.Sources.RealExpression X_w_ProEnt(final y(final unit="1")=
      damPro.port_b.Xi_outflow[i1_w])
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-110,-72},{-90,-52}})));
  Modelica.Blocks.Sources.Constant uni(
    final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-214,-30},{-194,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-166,-36},{-146,-16}})));
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
protected
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
  connect(add3.u2, PEleMot.y)
    annotation (Line(points={{58,0},{34,0},{34,-32},{2,-32}},
    color={0,0,127}));
  connect(PEleHea.y, add3.u3)
    annotation (Line(points={{2,-60},{46,-60},{46,-8},{58,-8}},
    color={0,0,127}));
  connect(hea.Q_flow, PEleHea.u)
    annotation (Line(points={{-5,72},{-40,72},{-40,-60},{-22,-60}},
    color={0,0,127}));
  connect(bypDamPro.port_a, port_a1) annotation (Line(points={{-170,-120},{-180,
          -120},{-180,-100},{-240,-100}}, color={0,127,255}));
  connect(bypDamPro.port_b, port_b1) annotation (Line(points={{-150,-120},{-126,
          -120},{-126,-138},{34,-138},{34,-100},{100,-100}}, color={0,127,255}));
  connect(booleanToReal.y, PEleMot.u) annotation (Line(points={{-179,10},{-50,
          10},{-50,-32},{-22,-32}}, color={0,0,127}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-193,-20},{-168,-20}}, color={0,0,127}));
  connect(uBypDamPos, bypDamPro.y) annotation (Line(points={{-260,0},{-220,0},{
          -220,-80},{-160,-80},{-160,-108}}, color={0,0,127}));
  connect(sub.u2, uBypDamPos) annotation (Line(points={{-168,-32},{-180,-32},{
          -180,-60},{-220,-60},{-220,0},{-260,0}}, color={0,0,127}));
  connect(booleanToReal.u, uRot) annotation (Line(points={{-202,10},{-230,10},{
          -230,-120},{-260,-120}}, color={255,0,255}));
  connect(dehPer.uSpe, uni.y) annotation (Line(points={{-56.2,-73},{-56.2,-6},{
          -180,-6},{-180,-20},{-193,-20}}, color={0,0,127}));
  connect(outCon.port_b, port_b1) annotation (Line(points={{14,-100},{56,-100},{
          56,-100},{100,-100}}, color={0,127,255}));
  connect(damPro.y, sub.y) annotation (Line(points={{-130,-88},{-130,-26},{-144,
          -26}}, color={0,0,127}));
  connect(dehPer.onDeh, uRot) annotation (Line(points={{-59,-75.8},{-144,-75.8},
          {-144,-76},{-230,-76},{-230,-120},{-260,-120}}, color={255,0,255}));
  connect(X_w_ProEnt.y, dehPer.X_w_ProEnt) annotation (Line(points={{-89,-62},{
          -76,-62},{-76,-88},{-59,-88}}, color={0,0,127}));
  connect(damPro.port_a, port_a1)
    annotation (Line(points={{-140,-100},{-240,-100}}, color={0,127,255}));
  connect(damPro.port_b, outCon.port_a) annotation (Line(points={{-120,-100},{
          -114,-100},{-114,-120},{-20,-120},{-20,-100},{-6,-100}}, color={0,127,
          255}));
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
          extent={{28,22},{84,-32}},
          textColor={28,108,200},
          textString="C")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model considers a desiccant dehumidifier system with an electric coil, a variable-speed regeneration fan, and bypass dampers
as shown below.
<p align=\"left\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/Dehumidifiers/Desiccant/BaseClasses/system_schematic_bypass.png\"
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
<li>March 1, 2024, by Sen Huang:<br/>First implementation. </li>
</ul>
</html>"));
end ElectricCoilBypassDampers;
