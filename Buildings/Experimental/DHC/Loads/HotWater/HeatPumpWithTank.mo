within Buildings.Experimental.DHC.Loads.HotWater;
model HeatPumpWithTank
  "A model for generating hot water using a heat pump water heater and local storage tank"
  extends
    Buildings.Experimental.DHC.Loads.HotWater.BaseClasses.PartialFourPortDHW(
      final have_PEle=true, mDis_flow_nominal=heaPum.QEva_flow_nominal/
        cp2_default/heaPum.dTEva_nominal);
  constant Modelica.Units.SI.SpecificHeatCapacity cp2_default=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(p=Medium.p_default,
      T=Medium.T_default)) "Specific heat capacity of the fluid";
  parameter
    Buildings.Experimental.DHC.Loads.HotWater.Data.GenericHeatPumpWaterHeater
    datWatHea "Performance data"
    annotation (Placement(transformation(extent={{-96,-96},{-84,-84}})));
  parameter Real COP_nominal(final unit="1") "Heat pump COP at nominal conditions";
  parameter Modelica.Units.SI.Temperature TCon_nominal "Condenser outlet temperature used to compute COP_nominal";
  parameter Modelica.Units.SI.Temperature TEva_nominal "Evaporator outlet temperature used to compute COP_nominal";
  parameter Real k=0.1 "Proportioanl gain of circulation pump controller";
  parameter Real Ti=60 "Integrator time constant of circulation pump controller";
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHotSou(redeclare package
      Medium = Medium, m_flow_nominal=mHotSou_flow_nominal)
    "Temperature sensor for hot water source supply"
    annotation (Placement(transformation(extent={{-20,44},{0,64}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=datWatHea.mHex_flow_nominal,
    m2_flow_nominal=mDis_flow_nominal,
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
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemHeaPumOut(redeclare package Medium =
        Medium, m_flow_nominal=datWatHea.mHex_flow_nominal)
    "Temperature of water leaving heat pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,6})));
  Fluid.Movers.FlowControlled_m_flow pumHex(
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    redeclare package Medium = Medium,
    m_flow_nominal=datWatHea.mHex_flow_nominal,
    riseTime=10,
    massFlowRates={0,0.5,1}*datWatHea.mHex_flow_nominal)
    "Pump with m_flow input"
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  Fluid.Storage.StratifiedEnhancedInternalHex
    tanSte(
    T_start=datWatHea.TTan_nominal,
           energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium,
    redeclare package MediumHex = Medium,
    hTan=datWatHea.hTan,
    dIns=datWatHea.dIns,
    VTan=datWatHea.VTan,
    nSeg=datWatHea.nSeg,
    hHex_a=datWatHea.hHex_a,
    hHex_b=datWatHea.hHex_b,
    Q_flow_nominal=datWatHea.QTan_flow_nominal,
    TTan_nominal=datWatHea.TTan_nominal,
    THex_nominal=datWatHea.THex_nominal,
    mHex_flow_nominal=datWatHea.mHex_flow_nominal,
    show_T=true,
    m_flow_nominal=mHotSou_flow_nominal)
    "Tank with steady-state heat exchanger balance"
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemTan
    "Temperature of the hot water tank"
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter
                                   dTTanHex2(k=datWatHea.mHex_flow_nominal)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Controls.OBC.CDL.Reals.PID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Ti=Ti)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electric power required for pumping equipment"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow
    "Actual heat pump heating heat flow rate added to fluid"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Controls.OBC.CDL.Reals.AddParameter addPar(p=datWatHea.dTTanHex)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(heaPum.port_b1, senTemHeaPumOut.port_a)
    annotation (Line(points={{10,6},{40,6}}, color={0,127,255}));
  connect(senTemHotSou.port_b, port_b1) annotation (Line(points={{0,54},{20,54},
          {20,60},{100,60}}, color={0,127,255}));
  connect(port_b2, heaPum.port_b2) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,-6},{-10,-6}},          color={0,127,255}));
  connect(heaPum.P,PHea)  annotation (Line(points={{11,0},{24,0},{24,-14},{82,-14},
          {82,0},{110,0}},          color={0,0,127}));
  connect(pumHex.port_a, senTemHeaPumOut.port_b) annotation (Line(points={{60,40},
          {70,40},{70,6},{60,6}}, color={0,127,255}));
  connect(pumHex.port_b, tanSte.portHex_a) annotation (Line(points={{40,40},{-30,
          40},{-30,46.2},{-40,46.2}}, color={0,127,255}));
  connect(tanSte.portHex_b, heaPum.port_a1) annotation (Line(points={{-40,42},{-40,
          20},{-10,20},{-10,6}}, color={0,127,255}));
  connect(tanSte.port_a, senTemHotSou.port_a) annotation (Line(points={{-40,50},
          {-30,50},{-30,54},{-20,54}}, color={0,127,255}));
  connect(tanSte.port_b, port_a1) annotation (Line(points={{-60,50},{-80,50},{-80,
          60},{-100,60}}, color={0,127,255}));
  connect(bou.ports[1], senTemHeaPumOut.port_b) annotation (Line(points={{80,40},
          {70,40},{70,6},{60,6}}, color={0,127,255}));
  connect(dTTanHex2.y, pumHex.m_flow_in)
    annotation (Line(points={{42,90},{50,90},{50,52}}, color={0,0,127}));
  connect(heaPum.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,
          -60},{100,-60}}, color={0,127,255}));
  connect(conPI.y, dTTanHex2.u)
    annotation (Line(points={{12,90},{18,90}}, color={0,0,127}));
  connect(TSetHotSou, conPI.u_s) annotation (Line(points={{-110,0},{-88,0},{-88,
          90},{-12,90}}, color={0,0,127}));
  connect(senTemTan.T, conPI.u_m) annotation (Line(points={{-19,72},{-8,72},{-8,
          70},{0,70},{0,78}}, color={0,0,127}));
  connect(pumHex.P, PPum) annotation (Line(points={{39,49},{30,49},{30,-40},{110,
          -40}}, color={0,0,127}));
  connect(heaPum.QCon_flow, QCon_flow) annotation (Line(points={{11,9},{11,4},{26,
          4},{26,-20},{110,-20}},
                            color={0,0,127}));
  connect(senTemTan.port, tanSte.heaPorVol[4])
    annotation (Line(points={{-40,72},{-50,72},{-50,50}}, color={191,0,0}));
  connect(addPar.y, heaPum.TSet) annotation (Line(points={{-38,0},{-28,0},{-28,
          9},{-12,9}}, color={0,0,127}));
  connect(addPar.u, TSetHotSou)
    annotation (Line(points={{-62,0},{-110,0}}, color={0,0,127}));
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
<a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.Data.GenericHeatPumpWaterHeater\">
Buildings.Experimental.DHC.Loads.HotWater.Data.GenericHeatPumpWaterHeater</a>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Loads/HotWater/HeatPumpWithTank.png\"/>
</p>
<p>
It is based on Fig. 3 in <i>Evaluations of different domestic hot water 
preparing methods with ultra-low-temperature district heating</i> by X. Yang, 
H. Li, and S. Svendsen at <a href=https:/doi.org/10.1016/j.energy.2016.04.109> 
doi.org/10.1016/j.energy.2016.04.109</a>, as well as the
<i>Advanced Energy Design Guide for Multifamily Buildings-Achieving Zero Energy</i>
published by ASHRAE in 2022 at <a href=https://www.ashrae.org/technical-resources/aedgs/zero-energy-aedg-free-download>
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
