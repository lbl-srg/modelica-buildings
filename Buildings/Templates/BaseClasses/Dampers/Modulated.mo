within Buildings.Templates.BaseClasses.Dampers;
model Modulated
  extends Buildings.Templates.Interfaces.Damper(final typ=Types.Damper.Modulated);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if braStr=="Outdoor air" then
    dat.getReal(varName=id + ".Supply air mass flow rate")
    elseif braStr=="Minimum outdoor air" then
    dat.getReal(varName=id + ".Economizer.Minimum outdoor air mass flow rate")
    elseif braStr=="Return air" then
    dat.getReal(varName=id + ".Return air mass flow rate")
    elseif braStr=="Relief air" then
    dat.getReal(varName=id + ".Return air mass flow rate")
    else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition"), Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    min=0, displayUnit="Pa")=
    dat.getReal(varName=id + ".Economizer." + braStr + " damper pressure drop")
    "Pressure drop of open damper"
    annotation (Dialog(group="Nominal condition"));

  Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough yDamOut if
    braStr=="Outdoor air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,50})));
  Modelica.Blocks.Routing.RealPassThrough yDamOutMin if
    braStr=="Minimum outdoor air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,50})));
  Modelica.Blocks.Routing.RealPassThrough yDamRet if
    braStr=="Return air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,50})));
  Modelica.Blocks.Routing.RealPassThrough yDamRel if
    braStr=="Relief air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,50})));
  Modelica.Blocks.Routing.RealPassThrough yDamOut_actual if
    braStr=="Outdoor air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-30})));
  Modelica.Blocks.Routing.RealPassThrough yDamOutMin_actual if
    braStr=="Minimum outdoor air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-30})));
  Modelica.Blocks.Routing.RealPassThrough yDamRet_actual if
    braStr=="Return air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-30})));
  Modelica.Blocks.Routing.RealPassThrough yDamRel_actual if
    braStr=="Relief air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-30})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(yDamOut.y, damExp.y) annotation (Line(points={{-60,39},{-60,20},{0,
          20},{0,12}}, color={0,0,127}));
  connect(yDamOutMin.y, damExp.y) annotation (Line(points={{-20,39},{-20,26},
          {0,26},{0,12}}, color={0,0,127}));
  connect(yDamRet.y, damExp.y) annotation (Line(points={{20,39},{20,26},{0,26},
          {0,12}}, color={0,0,127}));
  connect(yDamRel.y, damExp.y) annotation (Line(points={{60,39},{60,20},{0,20},
          {0,12}}, color={0,0,127}));
  connect(busCon.out.yDamOutMin, yDamOutMin.u) annotation (Line(
      points={{0.1,100.1},{0.1,100},{-2,100},{-2,80},{-20,80},{-20,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yDamOut, yDamOut.u) annotation (Line(
      points={{0.1,100.1},{0.1,100},{-6,100},{-6,84},{-60,84},{-60,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yDamRet, yDamRet.u) annotation (Line(
      points={{0.1,100.1},{2,100.1},{2,80},{20,80},{20,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yDamRel, yDamRel.u) annotation (Line(
      points={{0.1,100.1},{6,100.1},{6,84},{60,84},{60,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(damExp.y_actual, yDamRel_actual.u)
    annotation (Line(points={{5,7},{60,7},{60,-18}}, color={0,0,127}));
  connect(damExp.y_actual, yDamRet_actual.u)
    annotation (Line(points={{5,7},{20,7},{20,-18}}, color={0,0,127}));
  connect(damExp.y_actual, yDamOutMin_actual.u) annotation (Line(points={{5,7},
          {20,7},{20,-10},{-20,-10},{-20,-18}}, color={0,0,127}));
  connect(damExp.y_actual, yDamOut_actual.u) annotation (Line(points={{5,7},{
          20,7},{20,-10},{-60,-10},{-60,-18}}, color={0,0,127}));
  connect(yDamOut_actual.y, busCon.inp.yDamOut_actual) annotation (Line(
        points={{-60,-41},{-60,-60},{-80,-60},{-80,88},{0.1,88},{0.1,100.1}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yDamOutMin_actual.y, busCon.inp.yDamOutMin_actual) annotation (Line(
        points={{-20,-41},{-20,-62},{-82,-62},{-82,90},{0.1,90},{0.1,100.1}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yDamRet_actual.y, busCon.inp.yDamRet_actual) annotation (Line(
        points={{20,-41},{20,-62},{82,-62},{82,88},{0.1,88},{0.1,100.1}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yDamRel_actual.y, busCon.inp.yDamRel_actual) annotation (Line(
        points={{60,-41},{60,-60},{80,-60},{80,86},{0.1,86},{0.1,100.1}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
end Modulated;
