within Buildings.Experimental.DHC.Loads.DHW.BaseClasses.DELETE;
model DirectHeatExchangerWaterHeaterWithAuxHeatOLD
  "A model for domestic water heating served by district heat exchanger and supplemental electric resistance"
  extends
    Buildings.Experimental.DHC.Loads.DHW.BaseClasses.DELETE.PartialDHWGeneration;

  parameter Boolean haveER "Flag that specifies whether electric resistance booster is present";

  Buildings.Fluid.HeatExchangers.Heater_T heaDhw(
    redeclare package Medium = Medium,
    m_flow_nominal=mHw_flow_nominal,
    dp_nominal=0) if haveER == true
                  "Supplemental electric resistance domestic hot water heater"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemAuxHeaOut(redeclare package
      Medium =         Medium, m_flow_nominal=mHw_flow_nominal)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mHw_flow_nominal,
    m2_flow_nominal=mDH_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    eps=0.85) "Domestic hot water heater"
    annotation (Placement(transformation(extent={{-70,16},{-50,-4}})));
  Fluid.Sensors.TemperatureTwoPort senTemHXOut(redeclare package Medium =
        Medium, m_flow_nominal=mHw_flow_nominal)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
protected
  Fluid.FixedResistances.LosslessPipe pip(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHw_flow_nominal,
    final show_T=false) if haveER == false "Pipe without electric resistance"
    annotation (Placement(transformation(extent={{10,-38},{30,-18}})));

equation
  connect(senTemAuxHeaOut.port_b, port_hw)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(hex.port_a1, port_cw)
    annotation (Line(points={{-70,0},{-100,0}}, color={0,127,255}));
  connect(port_dhs, hex.port_a2) annotation (Line(points={{-40,100},{-40,
          12},{-50,12}},
                     color={0,127,255}));
  connect(hex.port_b2, port_dhr) annotation (Line(points={{-70,12},{-80,
          12},{-80,60},{-80,60},{-80,100}},
                  color={0,127,255}));
  connect(senTemHXOut.port_a, hex.port_b1)
    annotation (Line(points={{-30,0},{-50,0}}, color={0,127,255}));
  connect(senTemHXOut.port_b, heaDhw.port_a)
    annotation (Line(points={{-10,0},{10,0}},color={0,127,255}));
  connect(senTemHXOut.port_b, pip.port_a) annotation (Line(points={{-10,0},{0,0},
          {0,-28},{10,-28}}, color={0,127,255}));
  connect(heaDhw.port_b, senTemAuxHeaOut.port_a)
    annotation (Line(points={{30,0},{60,0}}, color={0,127,255}));
  connect(pip.port_b, senTemAuxHeaOut.port_a) annotation (Line(points={{30,-28},
          {40,-28},{40,0},{60,0}}, color={0,127,255}));
  connect(conTSetHw.y, heaDhw.TSet)
    annotation (Line(points={{-83.2,32},{0,32},{0,8},{8,8}}, color={0,0,127}));
  connect(heaDhw.Q_flow, PEle) annotation (Line(points={{31,8},{40,8},{40,
          40},{106,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectHeatExchangerWaterHeaterWithAuxHeatOLD;
