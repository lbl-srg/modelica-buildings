within Buildings.Templates.Components.Dampers;
model TwoPosition "Two-position damper"
  extends Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
    final typ=Types.Damper.TwoPosition);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if loc==Types.Location.OutdoorAir           then
      dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
    elseif loc==Types.Location.MinimumOutdoorAir            then
      dat.getReal(varName=id + ".Mechanical.Economizer.Minimum outdoor air mass flow rate.value")
    elseif loc==Types.Location.Return           then
      dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
    elseif loc==Types.Location.Relief           then
      dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
    else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition"), Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    min=0, displayUnit="Pa")=
    if loc==Types.Location.OutdoorAir then
      dat.getReal(varName=id + ".Mechanical.Economizer.Outdoor air damper pressure drop.value")
    elseif loc==Types.Location.MinimumOutdoorAir            then
      dat.getReal(varName=id + ".Mechanical.Economizer.Minimum outdoor air damper pressure drop.value")
    elseif loc==Types.Location.Return           then
      dat.getReal(varName=id + ".Mechanical.Economizer.Return air damper pressure drop.value")
    elseif loc==Types.Location.Relief           then
      dat.getReal(varName=id + ".Mechanical.Economizer.Relief air damper pressure drop.value")
    else 0
    "Pressure drop of open damper"
    annotation (Dialog(group="Nominal condition"));

  Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Signal conversion" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
  .Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=0.99, h=0.5E-2)
    "Evaluate damper status" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(damExp.y_actual, evaSta.u) annotation (Line(points={{5,7},{5,6},{20,6},
          {20,-20},{2.22045e-15,-20},{2.22045e-15,-38}},
                                    color={0,0,127}));
  connect(bus.y, booToRea.u) annotation (Line(
      points={{0.1,100.1},{2.22045e-15,62}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y, damExp.y)
    annotation (Line(points={{-2.22045e-15,38},{0,12}}, color={0,0,127}));
  connect(evaSta.y, bus.y_actual) annotation (Line(points={{-2.22045e-15,-62},
          {0,-62},{0,-80},{40,-80},{40,100.1},{0.1,100.1}}, color={255,0,255}));
end TwoPosition;
