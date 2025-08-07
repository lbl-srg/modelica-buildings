within Buildings.Fluid.Dehumidifiers.Desiccant;
model BypassDampers "Desiccant dehumidifier with bypass dampers"
  extends Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PartialDesiccant;
  parameter Modelica.Units.SI.PressureDifference dpDamper_nominal(
    displayUnit="Pa") = 20
    "Nominal pressure drop of dampers";
  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close valve using strokeTime"
    annotation (Dialog(tab="Dynamics", group="Actuator position"));
  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to fully open or close actuator"
    annotation (Dialog(tab="Dynamics", group="Actuator position", enable=use_strokeTime));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization of dampers (no init, steady state, initial state, or initial output)"
    annotation (Dialog(tab="Dynamics", group="Actuator position", enable=use_strokeTime));
  parameter Real yByp_start=1 "Initial position of bypass actuators"
    annotation (Dialog(tab="Dynamics", group="Actuator position", enable=use_strokeTime));
  Modelica.Blocks.Interfaces.BooleanInput uRot
    "True when the wheel is operating"
    annotation (Placement(transformation(extent={{-220,110},{-180,150}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput uBypDamPos(
    final unit="1",
    final min=0,
    final max=1)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamPro(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=yByp_start,
    final dpDamper_nominal=dpDamper_nominal,
    final dpFixed_nominal=per.dpPro_nominal)
    "Process air bypass damper"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damPro(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=1 - yByp_start,
    final dpDamper_nominal=dpDamper_nominal,
    final dpFixed_nominal=per.dpPro_nominal)
    "Process air damper"
    annotation (Placement(transformation(
    extent={{-10,-10},{10,10}},rotation=0,origin={-90,-100})));
  Modelica.Blocks.Sources.Constant uni(
    final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance dehPer(
    final per=per)
    "Dehumidifier performance"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
protected
  Modelica.Blocks.Math.BooleanToReal PEle(
    final realTrue=per.P_nominal,
    final realFalse=0)
    "Electric power consumption for motor"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

initial equation
  assert(not per.have_varSpe,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the variable speed flag must be false",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";
equation
  assert(senRegMasFlo.m_flow >= dehPer.mReg_flow,
         "In " + getInstanceName() + ": insufficient regeneration air",
         level=AssertionLevel.warning)
         "Check if the mass flow rate of the regeneration air aligns with 
         the performance calculation.";

  connect(bypDamPro.port_a, port_a1)
    annotation (Line(points={{-140,-140},{-160,-140},{-160,-100},{-180,-100}},
        color={0,127,255}));
  connect(bypDamPro.port_b, port_b1)
    annotation (Line(points={{-120,-140},{180,-140},{180,-100}}, color={0,127,255}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-139,-60},{-130,-60},{-130,-54},{-122,-54}},
        color={0,0,127}));
  connect(uBypDamPos, bypDamPro.y)
    annotation (Line(points={{-200,-80},{-130,-80},{-130,-128}},
        color={0,0,127}));
  connect(sub.u2, uBypDamPos)
    annotation (Line(points={{-122,-66},{-130,-66},{-130,-80},{-200,-80}},
        color={0,0,127}));
  connect(damPro.y, sub.y)
    annotation (Line(points={{-90,-88},{-90,-60},{-98,-60}}, color={0,0,127}));
  connect(damPro.port_a, port_a1)
    annotation (Line(points={{-100,-100},{-180,-100}}, color={0,127,255}));
  connect(senTemProEnt.port_a, damPro.port_b)
    annotation (Line(points={{-60,-100},{-80,-100}}, color={0,127,255}));
  connect(PEle.y, P) annotation (Line(points={{-79,130},{160,130},{160,0},{190,0}},
          color={0,0,127}));
  connect(PEle.u, uRot) annotation (Line(points={{-102,130},{-200,130}},
          color={255,0,255}));
  connect(dehPer.uRot, uRot) annotation (Line(points={{-101,-1.8},{-140,-1.8},{-140,
          130},{-200,130}},       color={255,0,255}));
  connect(dehPer.TProEnt, senTemProEnt.T) annotation (Line(points={{-101,-5.8},{
          -140,-5.8},{-140,-36},{-50,-36},{-50,-89}},  color={0,0,127}));
  connect(dehPer.TRegEnt, senTemRegEnt.T) annotation (Line(points={{-101,-10},{-130,
          -10},{-130,100},{30,100},{30,91}},   color={0,0,127}));
  connect(dehPer.X_w_ProEnt, senMasFraProEnt.X) annotation (Line(points={{-101,-13.8},
          {-130,-13.8},{-130,-32},{-20,-32},{-20,-89}},color={0,0,127}));
  connect(dehPer.mPro_flow, senProMasFlo.m_flow) annotation (Line(points={{-101,
          -18.2},{-120,-18.2},{-120,-28},{150,-28},{150,-89}}, color={0,0,127}));
  connect(dehPer.hReg, senHea.hReg) annotation (Line(points={{-79,-18},{-4,-18},
          {-4,-68},{19,-68}}, color={0,0,127}));
  connect(dehPer.X_w_ProLea, senHea.X_w_ProLea) annotation (Line(points={{-79,-6},
          {6,-6},{6,-64},{19,-64}}, color={0,0,127}));
  connect(outCon.TSet, dehPer.TProLea) annotation (Line(points={{69,-92},{54,-92},
          {54,-2},{-79,-2}}, color={0,0,127}));
  connect(outCon.X_wSet, dehPer.X_w_ProLea) annotation (Line(points={{69,-96},{6,
          -96},{6,-6},{-79,-6}}, color={0,0,127}));
  annotation (
  defaultComponentName="deh",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{28,22},{84,-32}},
          textColor={28,108,200},
          textString="C")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,160}})),
    Documentation(info="<html>
<p>
An empirical model of a desiccant dehumidifier that utilizes two dampers to bypass
the process air, thereby regulating the dehumidification process.
</p>
<p>
This model does not require geometric data. Instead, its performance is defined by
a set of characteristic curves, as specified in
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>.
This operation of the dehumidifier is configured as follows.
</p>
<ul>
<li>
If the operating signal <code>uRot=true</code>,
<ul>
<li>
The dehumidifier power consumption is constant and equal to the nominal value.
</li>
<li>
Heat exchange within the dehumidifier is modulated by bypassing a portion of the
process air, enabling control over dehumidification.
</li>
<li>
The sensible and latent heat exchanger effectiveness are computed using
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>.
</li>
</ul>
</li>
<li>
Otherwise,
<ul>
<li>
The wheel power consumption is 0.
</li>
<li>
No dehumidification takes place; the process air exits with the same conditions as
it enters.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end BypassDampers;
