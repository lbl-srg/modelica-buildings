within Buildings.Templates.Components.HeatExchangers;
model DryCoilEffectivenessNTU "Effectiveness-NTU dry heat exchanger model"
  extends Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerWater(
    final typ=Buildings.Templates.Components.Types.HeatExchanger.DryCoilEffectivenessNTU);

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Capacity.value")
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering liquid temperature.value")
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Entering air temperature.value")
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration"
    annotation (Evaluate=true);

  Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final use_Q_flow_nominal=true,
    final configuration=configuration,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal)
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
end DryCoilEffectivenessNTU;
