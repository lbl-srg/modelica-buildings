within Buildings.Templates.BaseClasses.Dampers;
model TwoPosition
  extends Buildings.Templates.Interfaces.Damper(
    final typ=Types.Damper.TwoPosition);

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
  Modelica.Blocks.Routing.BooleanPassThrough yDamOutMin if
    braStr=="Minimum outdoor air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,70})));
  Modelica.Blocks.Routing.BooleanPassThrough yDamRel if
    braStr=="Relief air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Signal conversion" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  .Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=0.99, h=0.5E-2)
    "Evaluate damper status" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.Blocks.Routing.BooleanPassThrough yDamOutMin_actual if
    braStr=="Minimum outdoor air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-70})));
  Modelica.Blocks.Routing.BooleanPassThrough yDamRel_actual if
    braStr=="Relief air"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-70})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(booToRea.y, damExp.y)
    annotation (Line(points={{0,18},{0,12}}, color={0,0,127}));
  connect(yDamOutMin.y, booToRea.u) annotation (Line(points={{-40,59},{-40,50},
          {0,50},{0,42}}, color={255,0,255}));
  connect(yDamRel.y, booToRea.u) annotation (Line(points={{40,59},{40,50},{0,
          50},{0,42}}, color={255,0,255}));
  connect(damExp.y_actual, evaSta.u) annotation (Line(points={{5,7},{20,7},{
          20,-10},{0,-10},{0,-18}}, color={0,0,127}));
  connect(evaSta.y, yDamOutMin_actual.u) annotation (Line(points={{0,-42},{0,
          -50},{-40,-50},{-40,-58}}, color={255,0,255}));
  connect(evaSta.y, yDamRel_actual.u) annotation (Line(points={{0,-42},{0,-50},
          {40,-50},{40,-58}}, color={255,0,255}));
  connect(yDamOutMin_actual.y, busCon.inp.yDamOutMin_actual) annotation (Line(
        points={{-40,-81},{-40,-90},{-60,-90},{-60,88},{0.1,88},{0.1,100.1}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yDamRel_actual.y, busCon.inp.yDamRel_actual) annotation (Line(
        points={{40,-81},{40,-90},{80,-90},{80,88},{0.1,88},{0.1,100.1}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yDamOutMin, yDamOutMin.u) annotation (Line(
      points={{0.1,100.1},{0.1,96},{-40,96},{-40,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yDamRel, yDamRel.u) annotation (Line(
      points={{0.1,100.1},{2,100.1},{2,100},{4,100},{4,96},{40,96},{40,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end TwoPosition;
