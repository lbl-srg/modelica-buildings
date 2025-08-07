within Buildings.Fluid.Dehumidifiers.Desiccant;
model SpeedControlled "Desiccant dehumidifier with a variable speed drive"
  extends Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PartialDesiccant;

  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(
    extent={{-220,90},{-180,130}}), iconTransformation(extent={{-140,-20},
    {-100,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop resPro(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    final from_dp=from_dp,
    final dp_nominal=per.dpPro_nominal,
    final linearized=linearizeFlowResistance)
    "Flow resistance in the process air stream"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  BaseClasses.PerformanceCorrection dehPer(per=per)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
initial equation
  assert(per.have_varSpe,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the variable speed flag must be true",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";
equation
  assert(senRegMasFlo.m_flow >= dehPer.mReg_flow,
  "In " + getInstanceName() + ": insufficient regeneration air",
   level=AssertionLevel.warning)
   "Check if the mass flow rate of the regeneration air aligns with
   the performance calculation.";
  connect(dehPer.uSpe, uSpe) annotation (Line(points={{-101,-21.8},{-140,-21.8},
          {-140,110},{-200,110}}, color={0,0,127}));
  connect(dehPer.TProEnt, senTemProEnt.T) annotation (Line(points={{-101,-25.8},
          {-140,-25.8},{-140,-80},{-50,-80},{-50,-89}}, color={0,0,127}));
  connect(senTemRegEnt.T, dehPer.TRegEnt) annotation (Line(points={{30,91},{30,100},
          {-134,100},{-134,-30},{-101,-30}}, color={0,0,127}));
  connect(dehPer.mPro_flow, senProMasFlo.m_flow) annotation (Line(points={{-101,
          -38.2},{-128,-38.2},{-128,-76},{150,-76},{150,-89}}, color={0,0,127}));
  connect(dehPer.X_w_ProEnt, senMasFraProEnt.X) annotation (Line(points={{-101,-33.8},
          {-134,-33.8},{-134,-60},{-20,-60},{-20,-89}}, color={0,0,127}));
  connect(dehPer.P, P) annotation (Line(points={{-79,-22},{160,-22},{160,0},{190,
          0}}, color={0,0,127}));
  connect(dehPer.TProLea, outCon.TSet) annotation (Line(points={{-79,-26},{60,-26},
          {60,-92},{69,-92}}, color={0,0,127}));
  connect(dehPer.X_w_ProLea, outCon.X_wSet) annotation (Line(points={{-79,-30},{
          54,-30},{54,-96},{69,-96}}, color={0,0,127}));
  connect(senHea.X_w_ProLea, dehPer.X_w_ProLea) annotation (Line(points={{19,-64},
          {6,-64},{6,-30},{-79,-30}},  color={0,0,127}));
  connect(dehPer.hReg, senHea.hReg) annotation (Line(points={{-79,-38},{0,-38},{
          0,-68},{19,-68}},  color={0,0,127}));
  connect(resPro.port_a, port_a1)
    annotation (Line(points={{-140,-100},{-180,-100}}, color={0,127,255}));
  connect(resPro.port_b, senTemProEnt.port_a)
    annotation (Line(points={{-120,-100},{-60,-100}}, color={0,127,255}));
  annotation (
  defaultComponentName="deh",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{26,20},{82,-34}},
          textColor={28,108,200},
          textString="V")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
An empirical model of a desiccant dehumidifier, which has the
wheel speed as the input to control the dehumidification.
</p>
<p>
This model does not require geometric data. Instead, its performance is defined by
a set of characteristic curves, as specified in
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>.
</p>
<p>
The operation of the dehumidifier is adjustable by modulating the wheel speed.
See details about the impacts of the wheel speed in
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SpeedCorrection\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SpeedCorrection</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;
