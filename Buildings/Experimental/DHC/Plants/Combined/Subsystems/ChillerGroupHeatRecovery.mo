within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroupHeatRecovery
  extends BaseClasses.PartialChillerGroup(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    valCon(final have_mode=true),
    valEva(final have_mode=true),
    com(final have_mode=true));

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Unique common medium for CHW, HW and CW"
    annotation (choices(
    choice(redeclare package Medium = Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
      property_T=293.15,
      X_a=0.40)
      "Propylene glycol water, 40% mass fraction")));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Coo[nChi]
    "Chiller switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
    iconTransformation(extent={{-140,10},{-100,50}})));
  replaceable Fluid.Chillers.ElectricReformulatedEIR chiHea(
    PLR1(start=0),
    final have_switchOver=true,
    final per=dat)
    constrainedby Fluid.Chillers.ElectricReformulatedEIR(
      redeclare final package Medium1 = Medium,
      redeclare final package Medium2 = Medium,
      final dp1_nominal=0,
      final dp2_nominal=0,
      final allowFlowReversal1=allowFlowReversal1,
      final allowFlowReversal2=allowFlowReversal2,
      final energyDynamics=energyDynamics,
      final show_T=show_T)
    "Chiller in heating mode"
    annotation (Placement(transformation(extent={{-10,44},{10,64}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aConWat(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CW inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bConWat(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CW outlet"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaInlHea(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConInlCoo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaOutHea(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConOutCoo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true) "Flow rate multiplier"
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  BaseClasses.MultipleFlowResistances valEvaHea(
    redeclare final package Medium = Medium,
    final nUni=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final have_mode=true,
    final dpFixed_nominal=dpEva_nominal + dpBalEva_nominal,
    final dpValve_nominal=dpValveEva_nominal,
    final typVal=typValEva,
    final allowFlowReversal=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller evaporator isolation valves of chillers in heating mode"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  BaseClasses.MultipleFlowResistances valConCoo(
    redeclare final package Medium = Medium,
    final nUni=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
    final have_mode=true,
    final dpFixed_nominal=dpCon_nominal + dpBalCon_nominal,
    final dpValve_nominal=dpValveCon_nominal,
    final typVal=typValCon,
    final allowFlowReversal=allowFlowReversal1,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller condenser isolation valves of chillers in cooling mode"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
    iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-8,146})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChi]
    "Returns true if heating mode"
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulPHea
    "Scale chiller power for chillers in heating mode"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Compute total chiller power"
    annotation (Placement(transformation(extent={{70,110},{90,130}})));
equation
  connect(mulConInl.port_b, chiHea.port_a1)
    annotation (Line(points={{-30,60},{-10,60}}, color={0,127,255}));
  connect(port_aConWat, mulEvaInlHea.port_a) annotation (Line(points={{-100,0},{
          -80,0},{-80,20},{-50,20}}, color={0,127,255}));
  connect(mulEvaInlHea.port_b, chiHea.port_a2) annotation (Line(points={{-30,20},
          {16,20},{16,48},{10,48}}, color={0,127,255}));
  connect(port_aConWat, mulConInlCoo.port_a) annotation (Line(points={{-100,0},{
          -80,0},{-80,-20},{-50,-20}}, color={0,127,255}));
  connect(mulConInlCoo.port_b, chi.port_a1) annotation (Line(points={{-30,-20},{
          -20,-20},{-20,-48},{-10,-48}}, color={0,127,255}));
  connect(chiHea.port_b2, mulEvaOutHea.port_a) annotation (Line(points={{-10,48},
          {-20,48},{-20,40},{24,40},{24,20},{30,20}}, color={0,127,255}));
  connect(chi.port_b1, mulConOutCoo.port_a) annotation (Line(points={{10,-48},{20,
          -48},{20,-20},{32,-20}}, color={0,127,255}));
  connect(y1Coo, com.y1Mod) annotation (Line(points={{-120,90},{-94,90},{-94,115},
          {-92,115}}, color={255,0,255}));
  connect(mulConOutCoo.port_b, valConCoo.port_a)
    annotation (Line(points={{52,-20},{70,-20}}, color={0,127,255}));
  connect(valConCoo.port_b, port_bConWat) annotation (Line(points={{90,-20},{94,
          -20},{94,0},{100,0}}, color={0,127,255}));
  connect(valEvaHea.port_b, port_bConWat) annotation (Line(points={{90,20},{94,20},
          {94,0},{100,0}}, color={0,127,255}));
  connect(mulEvaOutHea.port_b, valEvaHea.port_a)
    annotation (Line(points={{50,20},{70,20}}, color={0,127,255}));
  connect(com.y1NotModOne, chiHea.on) annotation (Line(points={{-68,120},{-20,120},
          {-20,57},{-12,57}}, color={255,0,255}));
  connect(THeaWatSupSet, chiHea.TSet) annotation (Line(points={{-120,-120},{-16,
          -120},{-16,51},{-12,51}}, color={0,0,127}));
  connect(fal.y, chiHea.coo)
    annotation (Line(points={{-8,134},{-8,68}},          color={255,0,255}));
  connect(y1Coo, hea.u)
    annotation (Line(points={{-120,90},{-92,90}}, color={255,0,255}));
  connect(hea.y, valCon.y1Mod) annotation (Line(points={{-68,90},{56,90},{56,55},
          {68,55}}, color={255,0,255}));
  connect(hea.y, valEvaHea.y1Mod) annotation (Line(points={{-68,90},{56,90},{56,
          15},{68,15}}, color={255,0,255}));
  connect(y1Coo, valConCoo.y1Mod) annotation (Line(points={{-120,90},{-94,90},{-94,
          -6},{58,-6},{58,-25},{68,-25}}, color={255,0,255}));
  connect(y1Coo, valEva.y1Mod) annotation (Line(points={{-120,90},{-94.1935,90},
          {-94.1935,-6},{-66,-6},{-66,-55},{-68,-55}}, color={255,0,255}));
  connect(yValCon, valConCoo.y) annotation (Line(points={{80,180},{80,140},{64,140},
          {64,-16},{68,-16}}, color={0,0,127}));
  connect(y1ValCon, valConCoo.y1) annotation (Line(points={{40,180},{40,140},{62,
          140},{62,-12},{68,-12}}, color={255,0,255}));
  connect(chiHea.P, mulPHea.u2) annotation (Line(points={{11,63},{26,63},{26,114},
          {28,114}}, color={0,0,127}));
  connect(com.nUniOnNotMod, mulPHea.u1) annotation (Line(points={{-68,114},{24,114},
          {24,126},{28,126}}, color={0,0,127}));
  connect(mulPHea.y, add2.u1) annotation (Line(points={{52,120},{56,120},{56,126},
          {68,126}}, color={0,0,127}));
  connect(mulP.y, add2.u2) annotation (Line(points={{52,-100},{60,-100},{60,114},
          {68,114}}, color={0,0,127}));
  connect(add2.y, P)
    annotation (Line(points={{92,120},{120,120}}, color={0,0,127}));
  connect(com.nUniOnNotModBou, mulConOut.u) annotation (Line(points={{-68,117},{
          20,117},{20,66},{28,66}}, color={0,0,127}));
  connect(com.nUniOnNotModBou, mulEvaOutHea.u) annotation (Line(points={{-68,117},
          {20,117},{20,26},{28,26}}, color={0,0,127}));
  connect(mulEvaOutHea.uInv, mulEvaInlHea.u) annotation (Line(points={{52,26},{54,
          26},{54,4},{-54,4},{-54,26},{-52,26}}, color={0,0,127}));
  connect(com.nUniOnBou, mulEvaOut.u) annotation (Line(points={{-68,126},{-68.1579,
          125.789},{-58.1579,125.789},{-58.1579,126},{-58,126},{-58,-48},{-26,-48},
          {-26,-54},{-28,-54}}, color={0,0,127}));
  connect(com.nUniOnBou, mulConOutCoo.u) annotation (Line(points={{-68,126},{-58,
          126},{-58,-4},{20,-4},{20,-14},{30,-14}}, color={0,0,127}));
  connect(mulConOutCoo.uInv, mulConInlCoo.u) annotation (Line(points={{54,-14},{
          56,-14},{56,-8},{-54,-8},{-54,-14},{-52,-14}}, color={0,0,127}));
  connect(yValEva, valEvaHea.y) annotation (Line(points={{-40,-180},{-40,-140},{
          68,-140},{68,24}}, color={0,0,127}));
  connect(y1ValEva, valEvaHea.y1) annotation (Line(points={{-80,-180},{-80,-138},
          {66,-138},{66,28},{68,28}}, color={255,0,255}));
  connect(mulConOut.port_a, chiHea.port_b1)
    annotation (Line(points={{30,60},{10,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerGroupHeatRecovery;
