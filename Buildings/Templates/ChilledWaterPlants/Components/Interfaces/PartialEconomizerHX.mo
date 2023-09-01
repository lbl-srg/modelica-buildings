within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
partial model PartialEconomizerHX "Partial model of WSE with plate and frame heat exchanger"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer;

  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1=MediumConWat,
    redeclare final package Medium2=MediumChiWat,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final dp1_nominal=0,
    final dp2_nominal=dpChiWat_nominal,
    final m1_flow_nominal=mConWat_flow_nominal,
    final m2_flow_nominal=mChiWat_flow_nominal,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=dat.TConWatEnt_nominal,
    final T_a2_nominal=dat.TChiWatEnt_nominal)
    "Heat exchanger (fluid ports with index 1 for CW and 2 for CHW)"
    annotation (Placement(
        transformation(extent={{-10,10},{10,-10}}, rotation=180,
        origin={0,74})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valConWatIso(
    redeclare final package Medium=MediumConWat,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValConWatIso,
    final text_flip=true)
    "WSE CW isolation valve"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatEcoRet(
    redeclare final package Medium = MediumConWat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mConWat_flow_nominal,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "WSE CW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,80})));
equation
  /* Control point connection - start */
  connect(bus.valConWatEcoIso, valConWatIso.bus);
  connect(bus.TConWatEcoRet, TConWatEcoRet.y);
  /* Control point connection - stop */

  connect(hex.port_a1, port_aConWat) annotation (Line(points={{10,80},{100,80}},
                         color={0,127,255}));
  connect(hex.port_b2, port_b)
    annotation (Line(points={{10,68},{20,68},{20,0},{100,0}},
                                              color={0,127,255}));
  connect(valConWatIso.port_b, port_bConWat)
    annotation (Line(points={{-80,80},{-100,80}}, color={0,127,255}));
  connect(hex.port_b1, TConWatEcoRet.port_a)
    annotation (Line(points={{-10,80},{-30,80}}, color={0,127,255}));
  connect(TConWatEcoRet.port_b, valConWatIso.port_a)
    annotation (Line(points={{-50,80},{-60,80}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model serves as the base class to construct the WSE models.
It includes an &epsilon;-NTU heat exchanger model and a 
two-way modulating valve to modulate the CW flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
  Line(   points={{-400,80},{-100,80}},
          color={0,0,0},
          thickness=5),
  Rectangle(
    extent={{100,100},{-100,-102}},
    lineColor={0,0,0},
    lineThickness=1),
  Line(
    points={{-100,100},{100,-100}},
    color={0,0,0},
    thickness=1),
  Line(
    points={{-320,-80},{-320,-140}},
    color={0,0,0}),
  Bitmap(extent={{-360,-220},{-280,-140}},
                                         fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
        Line(
          points={{326,-160}},
          color={0,0,0},
          thickness=0.5),
  Line(   points={{100,80},{400,80},{400,-80},{100,-80}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash),
  Line(   points={{-400,-80},{-100,-80}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash),
    Bitmap(extent={{-280,-40},{-80,-240}}, fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeInWell.svg"),
    Bitmap(extent={{-220,-320},{-140,-240}}, fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
  Bitmap(
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",

          rotation=-90,
          origin={-320,-80})}));
end PartialEconomizerHX;
