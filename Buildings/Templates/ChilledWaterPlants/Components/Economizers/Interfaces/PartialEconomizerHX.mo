within Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces;
model PartialEconomizerHX "Partial model of WSE with plate heat exchanger"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizer;

  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1=MediumConWat,
    redeclare final package Medium2=MediumChiWat,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final dp1_nominal=dpConWat_nominal,
    final dp2_nominal=dpChiWat_nominal,
    final m1_flow_nominal=mConWat_flow_nominal,
    final m2_flow_nominal=mChiWat_flow_nominal,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=dat.TConWatEnt_nominal,
    final T_a2_nominal=dat.TChiWatEnt_nominal)
    "Heat exchanger (fluid ports with index 1 for CW and 2 for CHW)"
    annotation (Placement(
        transformation(extent={{-10,10},{10,-10}}, rotation=180,
        origin={0,6})));

  Buildings.Templates.Components.Valves.TwoWayTwoPosition valConWatIso(
    redeclare final package Medium=MediumConWat,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValConWatIso,
    final text_flip=true)
    "WSE CW isolation valve"
    annotation (Placement(transformation(extent={{-50,70},{-70,90}})));
equation
  /* Control point connection - start */
  connect(bus.valConWatEcoIso, valConWatIso.bus);
  /* Control point connection - stop */

  connect(hex.port_a1, port_aConWat) annotation (Line(points={{10,12},{20,12},{20,
          80},{100,80}}, color={0,127,255}));
  connect(hex.port_b2, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(valConWatIso.port_a, hex.port_b1) annotation (Line(points={{-50,80},{-20,
          80},{-20,12},{-10,12}}, color={0,127,255}));
  connect(valConWatIso.port_b, port_bConWat)
    annotation (Line(points={{-70,80},{-100,80}}, color={0,127,255}));
end PartialEconomizerHX;
