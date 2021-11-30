within Buildings.Templates.Components.Valves;
model TwoWay "Two-way valve"
  extends Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWay);

  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil valve.Pressure drop.value")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0)=dpWat_nominal
    "Nominal pressure drop of pipes and other equipment in flow leg"
    annotation(Dialog(group="Nominal condition"));

  replaceable Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=mWat_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=dpFixed_nominal)
    "Valve"
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,0})));
equation
  connect(port_aRet, val.port_a)
    annotation (Line(points={{-40,100},{-40,10}},
                                                color={0,127,255}));
  connect(y, val.y)
    annotation (Line(points={{-120,0},{-52,2.10942e-15}},
                                               color={0,0,127}));
  connect(val.port_b, port_bRet)
    annotation (Line(points={{-40,-10},{-40,-100}},
                                                  color={0,127,255}));

  connect(port_aSup, port_bSup)
    annotation (Line(points={{40,-100},{40,100}}, color={0,127,255}));
end TwoWay;
