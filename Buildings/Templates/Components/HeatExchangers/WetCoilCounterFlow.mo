within Buildings.Templates.Components.HeatExchangers;
model WetCoilCounterFlow "Discretized wet heat exchanger model"
  extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialCoilWater(
    final typ=Buildings.Templates.Components.Types.HeatExchanger.WetCoilCounterFlow);

  parameter Modelica.Units.SI.ThermalConductance UA_nominal=
    dat.getReal(varName=id + ".mechanical.coil" + funStr + ".UA_nominal.value")
    "Thermal conductance at nominal flow"
    annotation(Evaluate=true);
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient";
  parameter Integer nEle=4
    "Number of pipe segments used for discretization";

  Fluid.HeatExchangers.WetCoilCounterFlow hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final UA_nominal=UA_nominal,
    final r_nominal=r_nominal,
    final nEle=nEle,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
          -6},{-10,-6}}, color={0,127,255}));
  connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
          {-100,60}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
          100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
          {100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WetCoilCounterFlow;
