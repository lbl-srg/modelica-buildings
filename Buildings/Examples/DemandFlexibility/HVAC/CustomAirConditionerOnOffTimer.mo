within Buildings.Examples.DemandFlexibility.HVAC;
block CustomAirConditionerOnOffTimer

          package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

  parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=1
    "Nominal mass flow rate for recirculated air";
    parameter Real cycling_time( unit="s")=600
    "heater cooler cycling time";
      parameter Real heater_thermal_power_nominal(unit="W")=550
    "Nominal heater power";
          parameter Real cooler_thermal_power_nominal(unit="W")=600
    "Nominal cooler power";
      parameter Real COPCoo=2.5
    "Coefficient of performance cooling";
          parameter Real COPHea=3.5
    "Coefficient of performance heating";
              parameter Real temSetHys=0.5
    "temperature setpoint hysteresis";
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                     fan(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    m_flow_nominal=mRec_flow_nominal)
    "Fan"
    annotation (Placement(transformation(extent={{-38,-52},{-18,-32}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u
                                hea(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=200,
    show_T=true,
    Q_flow_nominal=1)
    "Ideal heater"
    annotation (Placement(transformation(extent={{0,-52},{20,-32}})));
  Modelica.Blocks.Sources.Constant const(k=mRec_flow_nominal)
    annotation (Placement(transformation(extent={{-68,-18},{-48,2}})));
  Subsequences.SeparateHeatingCoolingThermalEnergy
    separateHeatingCoolingThermalEnergy
    annotation (Placement(transformation(extent={{64,-28},{84,-8}})));
  Modelica.Blocks.Interfaces.RealInput ZAT annotation (Placement(transformation(
          extent={{-138,40},{-98,80}}),  iconTransformation(extent={{-138,40},{
            -98,80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir) annotation (Placement(transformation(extent={{-114,-84},{-94,
            -64}}), iconTransformation(extent={{-114,-84},{-94,-64}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir) annotation (Placement(transformation(extent={{256,-82},{276,
            -62}}),
        iconTransformation(extent={{256,-82},{276,-62}})));
  Modelica.Blocks.Interfaces.RealOutput thermalPower annotation (Placement(
        transformation(extent={{260,52},{300,92}}),  iconTransformation(extent={{260,58},
            {300,98}})));
  Modelica.Blocks.Interfaces.RealOutput electricPower annotation (Placement(
        transformation(extent={{262,134},{302,174}}),
                                                    iconTransformation(extent={{260,122},
            {300,162}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cop_heating(final k=COPHea)
    "coefficient of performance"
    annotation (Placement(transformation(extent={{-8,162},{12,182}})));
  Modelica.Blocks.Interfaces.RealInput TCooSet annotation (Placement(
        transformation(extent={{-140,-34},{-100,6}}),  iconTransformation(
          extent={{-140,-32},{-100,8}})));
  Modelica.Blocks.Interfaces.RealInput THeaSet annotation (Placement(
        transformation(extent={{-140,88},{-100,128}}),iconTransformation(extent={{-140,
            112},{-100,152}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(   h=temSetHys)
    annotation (Placement(transformation(extent={{-38,76},{-18,96}})));
  Buildings.Controls.OBC.CDL.Reals.Less les1(  h=temSetHys)
    annotation (Placement(transformation(extent={{-38,44},{-18,64}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{150,64},{170,84}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{210,26},{230,46}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=
        heater_thermal_power_nominal)
    annotation (Placement(transformation(extent={{162,96},{182,116}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=0)
    annotation (Placement(transformation(extent={{12,12},{32,32}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=-1*
        cooler_thermal_power_nominal)
    annotation (Placement(transformation(extent={{14,90},{34,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cop_cooling(final k=COPCoo)
    "coefficient of performance"
    annotation (Placement(transformation(extent={{126,114},{146,134}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=cycling_time)
    annotation (Placement(transformation(extent={{162,28},{182,48}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(delayTime=cycling_time)
    annotation (Placement(transformation(extent={{114,64},{134,84}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Divide              div1
    annotation (Placement(transformation(extent={{160,168},{180,188}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Divide              div2
    annotation (Placement(transformation(extent={{166,140},{186,160}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Add                 add2
    "50% of setpoint"
    annotation (Placement(transformation(extent={{204,142},{224,162}})));
equation
  connect(fan.port_b,hea.port_a)
    annotation (Line(points={{-18,-42},{0,-42}},color={0,127,255}));
  connect(const.y,fan. m_flow_in) annotation (Line(points={{-47,-8},{-28,-8},{
          -28,-30}},  color={0,0,127}));
  connect(hea.Q_flow, separateHeatingCoolingThermalEnergy.EffectiveThermalEnergy)
    annotation (Line(points={{21,-36},{54,-36},{54,-18},{62,-18}}, color={0,0,127}));
  connect(port_a, fan.port_a) annotation (Line(points={{-104,-74},{-104,-42},{
          -38,-42}},       color={0,127,255}));
  connect(hea.port_b, port_b) annotation (Line(points={{20,-42},{32,-42},{32,
          -72},{266,-72}},      color={0,127,255}));
  connect(port_b, port_b)
    annotation (Line(points={{266,-72},{266,-72}}, color={0,127,255}));
  connect(cop_heating.y, div1.u2)
    annotation (Line(points={{14,172},{158,172}},         color={0,0,127}));
  connect(hea.Q_flow, thermalPower) annotation (Line(points={{21,-36},{44,-36},
          {44,-46},{254,-46},{254,72},{280,72}},
                             color={0,0,127}));
  connect(ZAT, gre.u1) annotation (Line(points={{-118,60},{-50,60},{-50,86},{
          -40,86}},      color={0,0,127}));
  connect(TCooSet, gre.u2) annotation (Line(points={{-120,-14},{-74,-14},{-74,
          62},{-48,62},{-48,78},{-40,78}},
                     color={0,0,127}));
  connect(ZAT, les1.u1) annotation (Line(points={{-118,60},{-50,60},{-50,54},{
          -40,54}},
                color={0,0,127}));
  connect(THeaSet, les1.u2)
    annotation (Line(points={{-120,108},{-120,76},{-86,76},{-86,46},{-40,46}},
                                                           color={0,0,127}));
  connect(swi.y, swi1.u3) annotation (Line(points={{172,74},{192,74},{192,28},{
          208,28}},
                color={0,0,127}));
  connect(con.y, swi1.u1) annotation (Line(points={{184,106},{200,106},{200,44},
          {208,44}},color={0,0,127}));
  connect(con2.y, swi.u1) annotation (Line(points={{36,100},{148,100},{148,82}},
                                                                   color={0,0,
          127}));
  connect(con1.y, swi.u3) annotation (Line(points={{34,22},{148,22},{148,66}},
                                                 color={0,0,127}));
  connect(swi1.y, hea.u) annotation (Line(points={{232,36},{240,36},{240,-64},{
          -12,-64},{-12,-36},{-2,-36}},
                      color={0,0,127}));
  connect(cop_cooling.y, div2.u2) annotation (Line(points={{148,124},{158,124},
          {158,136},{156,136},{156,144},{164,144}},
                           color={0,0,127}));
  connect(separateHeatingCoolingThermalEnergy.HeatingThermalEnergy, div1.u1)
    annotation (Line(points={{86,-14.4},{96,-14.4},{96,184},{158,184}},
                          color={0,0,127}));
  connect(separateHeatingCoolingThermalEnergy.CoolingThermalEnergy, div2.u1)
    annotation (Line(points={{86,-23.8},{94,-23.8},{94,156},{164,156}}, color={0,
          0,127}));
  connect(div1.y, add2.u1) annotation (Line(points={{182,178},{192,178},{192,
          158},{202,158}},
                      color={0,0,127}));
  connect(div2.y, add2.u2) annotation (Line(points={{188,150},{192,150},{192,
          146},{202,146}},
                      color={0,0,127}));
  connect(add2.y, electricPower) annotation (Line(points={{226,152},{256,152},{
          256,154},{282,154}},
                         color={0,0,127}));
  connect(les1.y, truDel.u)
    annotation (Line(points={{-16,54},{110,54},{110,-4},{150,-4},{150,38},{160,
          38}},                                 color={255,0,255}));
  connect(truDel.y, swi1.u2) annotation (Line(points={{184,38},{200,38},{200,36},
          {208,36}},
                   color={255,0,255}));
  connect(gre.y, truDel1.u) annotation (Line(points={{-16,86},{8,86},{8,82},{
          102,82},{102,74},{112,74}},
                     color={255,0,255}));
  connect(truDel1.y, swi.u2)
    annotation (Line(points={{136,74},{148,74}},
                                               color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{260,200}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{260,
            200}},
        grid={2,2})));
end CustomAirConditionerOnOffTimer;
