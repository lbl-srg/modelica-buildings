within Buildings.Templates.AHUs.BaseClasses.Dampers;
model Modulated
  extends Buildings.Templates.Interfaces.Damper(
    final typ=Templates.AHUs.Types.Damper.Modulated);

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
  Modelica.Blocks.Routing.RealPassThrough damOut if
    braStr=="Outdoor air"
    "Outdoor air damper control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,50})));
  Modelica.Blocks.Routing.RealPassThrough damOutMin if
    braStr=="Minimum outdoor air"
    "Minimum outdoor air damper control signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,50})));
  Modelica.Blocks.Routing.RealPassThrough damRet if
    braStr=="Return air"
    "Return air damper control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,50})));
  Modelica.Blocks.Routing.RealPassThrough damRel if
    braStr=="Relief air"
    "Relief air damper control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,50})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(damOut.y, damExp.y) annotation (Line(points={{-60,39},{-60,20},{0,20},
          {0,12}}, color={0,0,127}));
  connect(damOutMin.y, damExp.y) annotation (Line(points={{-20,39},{-20,26},{0,26},
          {0,12}}, color={0,0,127}));
  connect(damRet.y, damExp.y)
    annotation (Line(points={{20,39},{20,26},{0,26},{0,12}}, color={0,0,127}));
  connect(damRel.y, damExp.y)
    annotation (Line(points={{60,39},{60,20},{0,20},{0,12}}, color={0,0,127}));
  connect(busCon.out.yDamOut, damOut.u) annotation (Line(
      points={{0.1,100.1},{-60,100.1},{-60,62}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon.out.yDamOutMin, damOutMin.u) annotation (Line(
      points={{0.1,100.1},{-10,100.1},{-10,100},{-20,100},{-20,62}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon.out.yDamRet, damRet.u) annotation (Line(
      points={{0.1,100.1},{18,100.1},{18,100},{20,100},{20,62}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon.out.yDamRel, damRel.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,100},{60,100},{60,62}},
      color={255,204,51},
      thickness=0.5));
end Modulated;
