within Buildings.Examples.DemandFlexibility.HVAC;
block CustomAirConditioner

          package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

  parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=1
    "Nominal mass flow rate for recirculated air";

          parameter Real heater_thermal_power_nominal(unit="W")=550
    "Nominal heater power";
          parameter Real cooler_thermal_power_nominal(unit="W")=600
    "Nominal cooler power";
      parameter Real COPCoo=2.5
    "Coefficient of performance cooling";
          parameter Real COPHea=3.5
    "Coefficient of performance heating";
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                     fan(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    m_flow_nominal=mRec_flow_nominal)
    "Fan"
    annotation (Placement(transformation(extent={{-72,-52},{-52,-32}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u
                                hea(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=200,
    show_T=true,
    Q_flow_nominal=1)
    "Ideal heater"
    annotation (Placement(transformation(extent={{-34,-52},{-14,-32}})));
  Modelica.Blocks.Sources.Constant const(k=mRec_flow_nominal)
    annotation (Placement(transformation(extent={{-94,-24},{-74,-4}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    kCooCon=0.3,
    TiCooCon=300,
    kHeaCon=0.3,
    TiHeaCon=300)
    annotation (Placement(transformation(extent={{-10,56},{10,76}})));
  Subsequences.SeparateHeatingCoolingThermalEnergy
    separateHeatingCoolingThermalEnergy
    annotation (Placement(transformation(extent={{16,-38},{36,-18}})));
  Modelica.Blocks.Interfaces.RealInput ZAT annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{
            -100,80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir) annotation (Placement(transformation(extent={{-114,-84},{-94,
            -64}}), iconTransformation(extent={{-114,-84},{-94,-64}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir) annotation (Placement(transformation(extent={{256,-78},{276,
            -58}}),
        iconTransformation(extent={{256,-78},{276,-58}})));
  Modelica.Blocks.Interfaces.RealOutput thermalPower annotation (Placement(
        transformation(extent={{258,64},{298,104}}), iconTransformation(extent={{258,34},
            {298,74}})));
  Modelica.Blocks.Interfaces.RealOutput electricPower annotation (Placement(
        transformation(extent={{260,122},{300,162}}),
                                                    iconTransformation(extent={{260,118},
            {300,158}})));
  Modelica.Blocks.Interfaces.RealInput TCooSet annotation (Placement(
        transformation(extent={{-140,-26},{-100,14}}), iconTransformation(
          extent={{-140,-26},{-100,14}})));
  Modelica.Blocks.Interfaces.RealInput THeaSet annotation (Placement(
        transformation(extent={{-140,90},{-100,130}}),iconTransformation(extent={{-140,
            114},{-100,154}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{76,40},{96,60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold
                                           greThr(t=0, h=0)
    annotation (Placement(transformation(extent={{198,16},{218,36}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{230,18},{250,38}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=
        heater_thermal_power_nominal)
    annotation (Placement(transformation(extent={{154,42},{174,62}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=
        cooler_thermal_power_nominal)
    annotation (Placement(transformation(extent={{156,-10},{176,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cop_heating(final k=COPHea)
    "coefficient of performance"
    annotation (Placement(transformation(extent={{-16,118},{4,138}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cop_cooling(final k=COPCoo)
    "coefficient of performance"
    annotation (Placement(transformation(extent={{114,126},{134,146}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Divide              div1
    annotation (Placement(transformation(extent={{80,124},{100,144}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Divide              div2
    annotation (Placement(transformation(extent={{164,170},{184,190}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Add                 add2
    "50% of setpoint"
    annotation (Placement(transformation(extent={{216,132},{236,152}})));
equation
  connect(fan.port_b,hea.port_a)
    annotation (Line(points={{-52,-42},{-34,-42}},
                                                color={0,127,255}));
  connect(const.y,fan. m_flow_in) annotation (Line(points={{-73,-14},{-62,-14},
          {-62,-30}}, color={0,0,127}));
  connect(hea.Q_flow, separateHeatingCoolingThermalEnergy.EffectiveThermalEnergy)
    annotation (Line(points={{-13,-36},{4,-36},{4,-28},{14,-28}},  color={0,0,127}));
  connect(conLoo.TZon, ZAT) annotation (Line(points={{-12,66},{-94,66},{-94,60},
          {-120,60}},color={0,0,127}));
  connect(port_a, fan.port_a) annotation (Line(points={{-104,-74},{-104,-42},{-72,
          -42}},           color={0,127,255}));
  connect(hea.port_b, port_b) annotation (Line(points={{-14,-42},{10,-42},{10,
          -68},{266,-68}},      color={0,127,255}));
  connect(port_b, port_b)
    annotation (Line(points={{266,-68},{266,-68}}, color={0,127,255}));
  connect(hea.Q_flow, thermalPower) annotation (Line(points={{-13,-36},{4,-36},
          {4,-10},{84,-10},{84,84},{278,84}},
                             color={0,0,127}));
  connect(conLoo.TCooSet, TCooSet)
    annotation (Line(points={{-12,72},{-30,72},{-30,-6},{-120,-6}},
                                                           color={0,0,127}));
  connect(conLoo.THeaSet, THeaSet) annotation (Line(points={{-12,60},{-26,60},{
          -26,110},{-120,110}},        color={0,0,127}));
  connect(conLoo.yHea, sub.u1) annotation (Line(points={{12,60},{64,60},{64,56},
          {74,56}}, color={0,0,127}));
  connect(conLoo.yCoo, sub.u2) annotation (Line(points={{12,72},{48,72},{48,44},
          {74,44}}, color={0,0,127}));
  connect(sub.y, greThr.u) annotation (Line(points={{98,50},{144,50},{144,26},{
          196,26}},                        color={0,0,127}));
  connect(greThr.y, swi.u2)
    annotation (Line(points={{220,26},{220,28},{228,28}}, color={255,0,255}));
  connect(sub.y, gai.u) annotation (Line(points={{98,50},{144,50},{144,52},{152,
          52}},                                          color={0,0,127}));
  connect(sub.y, gai1.u) annotation (Line(points={{98,50},{144,50},{144,0},{154,
          0}},           color={0,0,127}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{176,52},{228,52},{228,36}}, color={0,0,127}));
  connect(gai1.y, swi.u3)
    annotation (Line(points={{178,0},{228,0},{228,20}},   color={0,0,127}));
  connect(swi.y, hea.u) annotation (Line(points={{252,28},{260,28},{260,-16},{
          42,-16},{42,-8},{-46,-8},{-46,-36},{-36,-36}},
                           color={0,0,127}));
  connect(cop_heating.y,div1. u2)
    annotation (Line(points={{6,128},{78,128}},           color={0,0,127}));
  connect(separateHeatingCoolingThermalEnergy.HeatingThermalEnergy,div1. u1)
    annotation (Line(points={{38,-24.4},{52,-24.4},{52,140},{78,140}},
                          color={0,0,127}));
  connect(div1.y, add2.u1) annotation (Line(points={{102,134},{102,126},{108,
          126},{108,120},{204,120},{204,148},{214,148}},
                      color={0,0,127}));
  connect(div2.y, add2.u2) annotation (Line(points={{186,180},{200,180},{200,
          142},{206,142},{206,136},{214,136}},
                      color={0,0,127}));
  connect(separateHeatingCoolingThermalEnergy.CoolingThermalEnergy,div2. u1)
    annotation (Line(points={{38,-33.8},{56,-33.8},{56,186},{162,186}}, color={0,
          0,127}));
  connect(cop_cooling.y,div2. u2) annotation (Line(points={{136,136},{152,136},
          {152,174},{162,174}},
                           color={0,0,127}));
  connect(add2.y, electricPower) annotation (Line(points={{238,142},{280,142}},
                         color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{260,200}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{260,
            200}},
        grid={2,2})));
end CustomAirConditioner;
