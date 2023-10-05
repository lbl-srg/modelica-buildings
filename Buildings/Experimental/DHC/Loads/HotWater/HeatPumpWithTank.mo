within Buildings.Experimental.DHC.Loads.HotWater;
model HeatPumpWithTank
  "A model for generating hot water using a heat pump water heater and local storage tank"
  extends
    Buildings.Experimental.DHC.Loads.HotWater.BaseClasses.PartialFourPortDHW(
      final have_PEle=true,
      mHea_flow_nominal=heaPum.QEva_flow_nominal/cp2_default/heaPum.dTEva_nominal);
  constant Modelica.Units.SI.SpecificHeatCapacity cp2_default=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(p=Medium.p_default,
      T=Medium.T_default)) "Specific heat capacity of the fluid";
  parameter
    Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea "Performance data"
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  parameter Real COP_nominal(final unit="1") "Heat pump COP at nominal conditions";
  parameter Modelica.Units.SI.Temperature TCon_nominal "Condenser outlet temperature used to compute COP_nominal";
  parameter Modelica.Units.SI.Temperature TEva_nominal "Evaporator outlet temperature used to compute COP_nominal";
  parameter Real k=0.1 "Proportioanl gain of circulation pump controller";
  parameter Real Ti=60 "Integrator time constant of circulation pump controller";
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=datWatHea.mCon_flow_nominal,
    m2_flow_nominal=mHea_flow_nominal,
    dTEva_nominal=datWatHea.dTEva_nominal,
    dTCon_nominal=datWatHea.dTCon_nominal,
    use_eta_Carnot_nominal=false,
    etaCarnot_nominal=0.3,
    COP_nominal=COP_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    QCon_flow_max = datWatHea.QCon_flow_max,
    QCon_flow_nominal=datWatHea.QCon_flow_nominal,
    dp1_nominal=datWatHea.dp1_nominal,
    dp2_nominal=datWatHea.dp2_nominal)
              "Domestic hot water heater"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow
                                     pumHex(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Medium,
    m_flow_nominal=datWatHea.mHex_flow_nominal,
    riseTime=10)
    "Pump with m_flow input"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Fluid.Storage.StratifiedEnhanced tanSte(
    T_start=datWatHea.TTan_nominal,
    redeclare package Medium = Medium,
    hTan=datWatHea.hTan,
    dIns=datWatHea.dIns,
    VTan=datWatHea.VTan,
    nSeg=datWatHea.nSeg,
    show_T=true,
    m_flow_nominal=mDom_flow_nominal)
    "Tank with steady-state heat exchanger balance"
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{16,16},{-4,36}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemTan
    "Temperature of the hot water tank"
    annotation (Placement(transformation(extent={{-42,54},{-22,74}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter
                                   dTTanHex2(k=datWatHea.mHex_flow_nominal)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Controls.OBC.CDL.Reals.PID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electric power required for pumping equipment"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow
    "Actual heat pump heating heat flow rate added to fluid"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Controls.OBC.CDL.Reals.AddParameter TConSet(p=datWatHea.dTTanHex)
    "Set point temperature for condenser"
    annotation (Placement(transformation(extent={{-48,-80},{-28,-60}})));
  Fluid.Sensors.TemperatureTwoPort senTemHot(redeclare package Medium = Medium,
      m_flow_nominal=mDom_flow_nominal)
    "Temperature sensor for hot water supply"
    annotation (Placement(transformation(extent={{20,38},{40,58}})));
  Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing con(
    redeclare package Medium = Medium1,
    use_siz=true,
    m2_flow_nominal=datWatHea.mCon_flow_nominal,
    dp1_nominal=datWatHea.dp1_nominal,
    dp2_nominal=6000,
    typCha=Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage,
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput,
    typPumMod=Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Head,
    typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating)
    annotation (Placement(transformation(extent={{-10,-20},{10,-40}})));

  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mDom_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000)
    annotation (Placement(transformation(extent={{-70,32},{-50,52}})));
  Fluid.FixedResistances.Junction junTop(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal*{1,1,1},
    dp_nominal=zeros(3)) "Flow junction at top of tank"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Fluid.FixedResistances.Junction junBot(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal*{1,1,1},
    dp_nominal=zeros(3)) "Flow junction at bottom of tank" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-20})));
  Controls.OBC.CDL.Reals.Add PPumTot "Total pump electricity"
    annotation (Placement(transformation(extent={{52,-12},{72,8}})));
equation
  connect(port_bHeaWat, heaPum.port_b2) annotation (Line(points={{-100,-60},{-56,
          -60},{-56,-86},{-10,-86}}, color={0,127,255}));
  connect(heaPum.P,PHea)  annotation (Line(points={{11,-80},{82,-80},{82,0},{
          110,0}},                  color={0,0,127}));
  connect(dTTanHex2.y, pumHex.m_flow_in)
    annotation (Line(points={{42,80},{42,-8},{-60,-8}},color={0,0,127}));
  connect(heaPum.port_a2, port_aHeaWat) annotation (Line(points={{10,-86},{56,-86},
          {56,-60},{100,-60}}, color={0,127,255}));
  connect(conPI.y, dTTanHex2.u)
    annotation (Line(points={{12,80},{18,80}}, color={0,0,127}));
  connect(TDomSet, conPI.u_s) annotation (Line(points={{-110,0},{-88,0},{-88,80},
          {-12,80}}, color={0,0,127}));
  connect(senTemTan.T, conPI.u_m) annotation (Line(points={{-21,64},{0,64},{0,
          68}},               color={0,0,127}));
  connect(heaPum.QCon_flow, QCon_flow) annotation (Line(points={{11,-71},{12,
          -71},{12,-70},{80,-70},{80,-20},{110,-20}},
                            color={0,0,127}));
  connect(TConSet.y, heaPum.TSet) annotation (Line(points={{-26,-70},{-28,-70},
          {-28,-71},{-12,-71}}, color={0,0,127}));
  connect(TConSet.u, TDomSet) annotation (Line(points={{-50,-70},{-88,-70},{-88,
          0},{-110,0}}, color={0,0,127}));
  connect(senTemHot.port_b, port_bDomWat) annotation (Line(points={{40,48},{90,
          48},{90,60},{100,60}}, color={0,127,255}));
  connect(con.port_b2, heaPum.port_a1) annotation (Line(points={{-6,-40},{-6,
          -48},{-20,-48},{-20,-74},{-10,-74}}, color={0,127,255}));
  connect(heaPum.port_b1, con.port_a2) annotation (Line(points={{10,-74},{20,
          -74},{20,-48},{6,-48},{6,-40}}, color={0,127,255}));
  connect(port_aDomWat, hex.port_a1) annotation (Line(points={{-100,60},{-80,60},
          {-80,48},{-70,48}}, color={0,127,255}));
  connect(hex.port_b1, senTemHot.port_a)
    annotation (Line(points={{-50,48},{20,48}}, color={0,127,255}));
  connect(tanSte.port_a, junTop.port_3) annotation (Line(points={{-30,20},{-30,
          30}},                   color={0,127,255}));
  connect(junTop.port_1, hex.port_b2) annotation (Line(points={{-40,40},{-46,40},
          {-46,60},{-76,60},{-76,36},{-70,36}},
                              color={0,127,255}));
  connect(pumHex.port_b, junBot.port_2)
    annotation (Line(points={{-50,-20},{-40,-20}}, color={0,127,255}));
  connect(pumHex.port_a, hex.port_a2) annotation (Line(points={{-70,-20},{-80,
          -20},{-80,-2},{-46,-2},{-46,36},{-50,36}}, color={0,127,255}));
  connect(junBot.port_3, tanSte.port_b)
    annotation (Line(points={{-30,-10},{-30,0}}, color={0,127,255}));
  connect(pumHex.P, PPumTot.u1) annotation (Line(points={{-49,-11},{-42,-11},{
          -42,-4},{30,-4},{30,4},{50,4}}, color={0,0,127}));
  connect(con.PPum, PPumTot.u2) annotation (Line(points={{12,-38},{40,-38},{40,
          -8},{50,-8}}, color={0,0,127}));
  connect(PPumTot.y, PPum) annotation (Line(points={{74,-2},{76,-2},{76,-40},{
          110,-40}}, color={0,0,127}));
  connect(junBot.port_1, con.port_a1) annotation (Line(points={{-20,-20},{-14,
          -20},{-14,2},{-6,2},{-6,-20}}, color={0,127,255}));
  connect(con.port_b1, junTop.port_2) annotation (Line(points={{6,-20},{6,10},{
          -16,10},{-16,40},{-20,40}}, color={0,127,255}));
  connect(bou.ports[1], junTop.port_2) annotation (Line(points={{-4,26},{-12,26},
          {-12,40},{-20,40}}, color={0,127,255}));
  annotation (preferredView="info",Documentation(info="<html>
<p>
This model implements a domestic hot water source for a low-temperature
district heating network. It uses a heat pump,
circulation pump, and heat exchanger to draw heat from the district network 
into a hot water storage tank.  
The heat pump model is described in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_TCon\">
Buildings.Fluid.HeatPumps.Carnot_TCon</a>.
The storage tank model is described in 
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a>.
The heat pump and storage tank system should be parameterized altogether using
<a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger\">
Buildings.Experimental.DHC.Loads.HotWater.Data.GenericHeatPumpWaterHeater</a>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Loads/HotWater/HeatPumpWithTank.png\"/>
</p>
<p>
It is based on Fig. 3 in <i>Evaluations of different domestic hot water 
preparing methods with ultra-low-temperature district heating</i> by X. Yang, 
H. Li, and S. Svendsen at <a href=\"https:/doi.org/10.1016/j.energy.2016.04.109\"> 
doi.org/10.1016/j.energy.2016.04.109</a>, as well as the
<i>Advanced Energy Design Guide for Multifamily Buildings-Achieving Zero Energy</i>
published by ASHRAE in 2022 at <a href=\"https://www.ashrae.org/technical-resources/aedgs/zero-energy-aedg-free-download\">
https://www.ashrae.org/technical-resources/aedgs/zero-energy-aedg-free-download</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Updated for release.
</li>
<li>
July 7, 2022 by Dre Helmns:<br/>
Initial Implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,-60},{20,-40}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,22},{20,-48}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,10},{20,30}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,50},{20,20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,40},{20,60}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,50},{-20,-50}},
          color={95,95,95},
          thickness=1),
        Line(
          points={{20,50},{20,-50}},
          color={95,95,95},
          thickness=1),
        Polygon(
          points={{-140,86},{-140,86}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag),
        Polygon(
          points={{20,40},{18,38},{14,36},{8,34},{8,26},{14,28},{18,30},{20,32},
              {20,40}},
          lineColor={95,95,95},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.CrossDiag)}),                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWithTank;
