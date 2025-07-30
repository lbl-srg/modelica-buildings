within Buildings.Fluid.Dehumidifiers.Desiccant;
model SpeedControlled "Desiccant dehumidifier with a variable speed drive"
  extends Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.PartialDesiccant;

  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(
    extent={{-280,60},{-240,100}}), iconTransformation(extent={{-140,-20},
    {-100,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop resPro(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    final from_dp=from_dp,
    final dp_nominal=per.dpPro_nominal,
    final linearized=linearizeFlowResistance)
    "Flow resistance in the process air stream"
    annotation (Placement(transformation(extent={{-182,-10},{-162,10}})));
  BaseClasses.PerformanceCorrection dehPer(per=per)
    annotation (Placement(transformation(extent={{-80,52},{-60,72}})));
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
  connect(dehPer.uSpe, uSpe) annotation (Line(points={{-81,70.2},{-120,70.2},{-120,
          100},{-200,100},{-200,80},{-260,80}}, color={0,0,127}));
  connect(dehPer.TProEnt, senTemProEnt.T) annotation (Line(points={{-81,66.2},{-134,
          66.2},{-134,16},{-110,16},{-110,11}}, color={0,0,127}));
  connect(senTemRegEnt.T, dehPer.TRegEnt) annotation (Line(points={{-30,191},{
          -30,200},{-200,200},{-200,120},{-142,120},{-142,62},{-81,62}},
          color={0,0,127}));
  connect(dehPer.mPro_flow, senProMasFlo.m_flow) annotation (Line(points={{-81,53.8},
          {-84,53.8},{-84,22},{40,22},{40,11}}, color={0,0,127}));
  connect(dehPer.X_w_ProEnt, senMasFraProEnt.X) annotation (Line(points={{-81,58.2},
          {-90,58.2},{-90,28},{-72,28},{-72,11}}, color={0,0,127}));
  connect(dehPer.P, P) annotation (Line(points={{-59,70},{80,70},{80,100},{110,100}},
        color={0,0,127}));
  connect(dehPer.TProLea, outCon.TSet) annotation (Line(points={{-59,66},{-44,66},
          {-44,8},{-11,8}}, color={0,0,127}));
  connect(dehPer.X_w_ProLea, outCon.X_wSet) annotation (Line(points={{-59,62},{-50,
          62},{-50,4},{-11,4}}, color={0,0,127}));
  connect(senHea.X_w_ProLea, dehPer.X_w_ProLea) annotation (Line(points={{-21,36},
          {-50,36},{-50,62},{-59,62}}, color={0,0,127}));
  connect(dehPer.hReg, senHea.hReg) annotation (Line(points={{-59,54},{-54,54},{
          -54,32},{-21,32}}, color={0,0,127}));
  connect(resPro.port_a, port_a1)
    annotation (Line(points={{-182,0},{-240,0}}, color={0,127,255}));
  connect(resPro.port_b, senTemProEnt.port_a)
    annotation (Line(points={{-162,0},{-120,0}}, color={0,127,255}));
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
This model does not require geometric data. Instead, its performance is defined by a set of characteristic curves,
as specified in
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
See details about the impacts of the wheel speed in
<a href=\"Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SpeedCorrection\">
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
