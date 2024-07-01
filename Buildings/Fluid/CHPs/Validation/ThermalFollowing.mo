within Buildings.Fluid.CHPs.Validation;
model ThermalFollowing "Validate model ThermalElectricalFollowing"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  Buildings.Fluid.CHPs.ThermalElectricalFollowing theFol(
    redeclare package Medium = Medium,
    m_flow_nominal=0.4,
    redeclare Data.Senertech5_5kW per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    TEngIni=273.15 + 69.55,
    waitTime=0) "CHP unit with the thermal demand priority"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(
    startValue=true,
    table={172800})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa"),
    nPorts=2)
    "Cooling water sink"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T cooWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Cooling water source"
    annotation (Placement(transformation(extent={{-68,0},{-48,20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dPEleNet
    "Absolute error for electric power generaton"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dQWat
    "Absolute error for heat transfer to water control volume"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTWatOut
    "Absolute error for water outlet temperature"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Modelica.Blocks.Sources.RealExpression PEleNet(
    final y=theFol.PEleNet)
    "Electric power generation"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Sources.RealExpression QWat(
    final y=theFol.QWat_flow)
    "Heat transfer to the water control volume"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.RealExpression TWatOut(final y=theFol.TWatOut.T)
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  HeatTransfer.Sources.PrescribedTemperature preTem
    "Variable temperature boundary condition in Kelvin"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTEng
    "Absolute error for engine temperature"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Modelica.Blocks.Sources.RealExpression TEng(
    final y=theFol.eng.TEng)
    "Engine temperature"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dQLos
    "Absolute error for heat loss to the surroundings"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Modelica.Blocks.Sources.RealExpression QLos(
    final y=theFol.QLos.Q_flow)
    "Heat loss to the surrounding"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dQGen
    "Absolute error for heat generaton"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Modelica.Blocks.Sources.RealExpression QGen(
    final y=theFol.eneCon.QGen_flow)
    "Heat generation"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Sources.CombiTimeTable valDat(
    tableOnFile=true,
    tableName="tab1",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(unit={"W","kg/s","degC","degC","W","W","W","W","W","degC","degC","degC"}),
    offset={0,0,0,0,0,0,0,0,0,0,0,0},
    columns={2,3,4,5,6,7,8,9,10,11,12,13},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/CHPs/Validation/MicroCogeneration.mos"))
    "Validation data from EnergyPlus simulation"
    annotation (Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TRoo
    "Convert zone temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatIn
    "Convert cooling water inlet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatOutSet
    "Convert outlet water setpoint temperature from degC to kelvin "
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TEngVal
    "Convert engine temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,24},{80,44}})));
  Buildings.Controls.OBC.UnitConversions.From_degC TWatOutVal
    "Convert cooling water outplet temperature from degC to kelvin"
    annotation (Placement(transformation(extent={{60,54},{80,74}})));
  Sources.MassFlowSource_T cooWatNeg(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Cooling water source"
    annotation (Placement(transformation(extent={{-68,-90},{-48,-70}})));
  ThermalElectricalFollowing theFolNeg(
    redeclare package Medium = Medium,
    m_flow_nominal=0.4,
    redeclare Data.Senertech5_5kW per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    TEngIni=273.15 + 69.55,
    waitTime=0)
    "CHP unit with the thermal demand priority and negative water mass flow rate"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mWat_flow_negative(
    final k=-1)
    "Negative water mass flow rate for validation only"
    annotation (Placement(transformation(extent={{-170,-90},{-150,-70}})));
  Modelica.Blocks.Routing.RealPassThrough PEleNetVal
    "Validation data for power output"
    annotation (Placement(transformation(extent={{60,-6},{80,14}})));
  Modelica.Blocks.Routing.RealPassThrough QGenVal_flow
    "Validation data for heat generation rate"
    annotation (Placement(transformation(extent={{60,-36},{80,-16}})));
  Modelica.Blocks.Routing.RealPassThrough QWatVal_flow
    "Validation data for heat flow rate to water"
    annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  Modelica.Blocks.Routing.RealPassThrough QLosVal_flow
    "Validation data for heat flow rate to ambient"
    annotation (Placement(transformation(extent={{60,-96},{80,-76}})));
  Modelica.Blocks.Continuous.Integrator EEle(y(unit="J"))
    "Electrical energy generated"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Modelica.Blocks.Continuous.Integrator EThe(y(unit="J"))
    "Thermal energy recovered"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Modelica.Blocks.Continuous.Integrator EEleVal(y(unit="J"))
    "Validation data for electrical energy generated"
    annotation (Placement(transformation(extent={{118,-130},{138,-110}})));
  Modelica.Blocks.Continuous.Integrator ETheVal(y(unit="J"))
    "Validation data for thermal energy recovered"
    annotation (Placement(transformation(extent={{118,-160},{138,-140}})));
protected
  Modelica.Blocks.Sources.BooleanExpression theFolSig(
    final y=true)
    "Signal for thermal following, set to false if electrical following"
    annotation (Placement(transformation(extent={{-70,32},{-50,48}})));
equation
  connect(theFol.port_b, sin.ports[1]) annotation (Line(points={{0,10},{10,10},{
          10,-28},{20,-28}},
          color={0,127,255}));
  connect(avaSig.y,theFol. avaSig) annotation (Line(points={{-99,-20},{-36,-20},
          {-36,19},{-22,19}}, color={255,0,255}));
  connect(cooWat.ports[1],theFol. port_a) annotation (Line(points={{-48,10},{-20,
          10}},      color={0,127,255}));
  connect(PEleNet.y, dPEleNet.u1) annotation (Line(points={{121,10},{128,10},{128,
          16},{138,16}}, color={0,0,127}));
  connect(QWat.y, dQWat.u1) annotation (Line(points={{121,-50},{128,-50},{128,-44},
          {138,-44}}, color={0,0,127}));
  connect(theFolSig.y,theFol. theFol) annotation (Line(points={{-49,40},{-34,40},
          {-34,17},{-22,17}}, color={255,0,255}));
  connect(preTem.port, theFol.TRoo) annotation (Line(points={{-50,-50},{-30,-50},
          {-30,3},{-20,3}}, color={191,0,0}));
  connect(QLos.y,dQLos. u1) annotation (Line(points={{121,-80},{128,-80},{128,-74},
          {138,-74}}, color={0,0,127}));
  connect(QGen.y,dQGen. u1) annotation (Line(points={{121,-20},{128,-20},{128,-14},
          {138,-14}}, color={0,0,127}));
  connect(valDat.y[2], cooWat.m_flow_in) annotation (Line(points={{-149,80},{-80,
          80},{-80,18},{-70,18}}, color={0,0,127}));
  connect(valDat.y[3], TWatIn.u) annotation (Line(points={{-149,80},{-140,80},{-140,
          10},{-122,10}}, color={0,0,127}));
  connect(TWatIn.y, cooWat.T_in) annotation (Line(points={{-98,10},{-80,10},{-80,
          14},{-70,14}}, color={0,0,127}));
  connect(valDat.y[4], TRoo.u) annotation (Line(points={{-149,80},{-140,80},{-140,
          -50},{-122,-50}}, color={0,0,127}));
  connect(TRoo.y, preTem.T) annotation (Line(points={{-98,-50},{-72,-50}},
          color={0,0,127}));
  connect(valDat.y[12], TWatOutSet.u) annotation (Line(points={{-149,80},{-140,80},
          {-140,50},{-122,50}}, color={0,0,127}));
  connect(TWatOutSet.y,theFol. TWatOutSet) annotation (Line(points={{-98,50},{-30,
          50},{-30,15},{-22,15}}, color={0,0,127}));
  connect(TWatOutVal.y, dTWatOut.u2) annotation (Line(points={{82,64},{138,64}},
                             color={0,0,127}));
  connect(TWatOut.y, dTWatOut.u1) annotation (Line(points={{121,70},{130,70},{130,
          76},{138,76}}, color={0,0,127}));
  connect(TEng.y, dTEng.u1) annotation (Line(points={{121,40},{130,40},{130,46},
          {138,46}}, color={0,0,127}));
  connect(TEngVal.y, dTEng.u2) annotation (Line(points={{82,34},{138,34}},
                     color={0,0,127}));
  connect(valDat.y[10], TWatOutVal.u) annotation (Line(points={{-149,80},{50,80},
          {50,64},{58,64}}, color={0,0,127}));
  connect(valDat.y[11], TEngVal.u) annotation (Line(points={{-149,80},{50,80},{50,
          34},{58,34}}, color={0,0,127}));
  connect(valDat.y[1],theFol. PEleDem) annotation (Line(points={{-149,80},{-26,80},
          {-26,13},{-22,13}}, color={0,0,127}));
  connect(cooWatNeg.ports[1], theFolNeg.port_a)
    annotation (Line(points={{-48,-80},{-20,-80}}, color={0,127,255}));
  connect(theFolNeg.port_b, sin.ports[2]) annotation (Line(points={{0,-80},{10,-80},
          {10,-32},{20,-32}}, color={0,127,255}));
  connect(mWat_flow_negative.y, cooWatNeg.m_flow_in) annotation (Line(points={{-148,
          -80},{-100,-80},{-100,-72},{-70,-72}}, color={0,0,127}));
  connect(avaSig.y, theFolNeg.avaSig) annotation (Line(points={{-99,-20},{-36,-20},
          {-36,-71},{-22,-71}}, color={255,0,255}));
  connect(theFolSig.y, theFolNeg.theFol) annotation (Line(points={{-49,40},{-34,
          40},{-34,-73},{-22,-73}}, color={255,0,255}));
  connect(valDat.y[1], theFolNeg.PEleDem) annotation (Line(points={{-149,80},{-26,
          80},{-26,-77},{-22,-77}}, color={0,0,127}));
  connect(TWatOutSet.y, theFolNeg.TWatOutSet) annotation (Line(points={{-98,50},
          {-30,50},{-30,-76},{-26,-76},{-26,-75},{-22,-75}}, color={0,0,127}));
  connect(TWatIn.y, cooWatNeg.T_in) annotation (Line(points={{-98,10},{-80,10},{
          -80,-76},{-70,-76}}, color={0,0,127}));
  connect(valDat.y[5], PEleNetVal.u) annotation (Line(points={{-149,80},{50,80},
          {50,4},{58,4}}, color={0,0,127}));
  connect(PEleNetVal.y, dPEleNet.u2)
    annotation (Line(points={{81,4},{138,4}}, color={0,0,127}));
  connect(valDat.y[7], QGenVal_flow.u) annotation (Line(points={{-149,80},{50,80},
          {50,-26},{58,-26}}, color={0,0,127}));
  connect(QGenVal_flow.y, dQGen.u2)
    annotation (Line(points={{81,-26},{138,-26}}, color={0,0,127}));
  connect(valDat.y[8], QWatVal_flow.u) annotation (Line(points={{-149,80},{50,80},
          {50,-56},{58,-56}}, color={0,0,127}));
  connect(QWatVal_flow.y, dQWat.u2)
    annotation (Line(points={{81,-56},{138,-56}}, color={0,0,127}));
  connect(valDat.y[9], QLosVal_flow.u) annotation (Line(points={{-149,80},{50,80},
          {50,-86},{58,-86}}, color={0,0,127}));
  connect(QLosVal_flow.y, dQLos.u2)
    annotation (Line(points={{81,-86},{138,-86}}, color={0,0,127}));
  connect(PEleNetVal.y, EEleVal.u) annotation (Line(points={{81,4},{98,4},{98,-120},
          {116,-120}}, color={0,0,127}));
  connect(QWatVal_flow.y, ETheVal.u) annotation (Line(points={{81,-56},{94,-56},
          {94,-150},{116,-150}}, color={0,0,127}));
  connect(theFol.PEleNet, EEle.u) annotation (Line(points={{2,13},{44,13},{44,-120},
          {58,-120}}, color={0,0,127}));
  connect(theFol.QWat_flow, EThe.u) annotation (Line(points={{2,3},{42,3},{42,-150},
          {58,-150}}, color={0,0,127}));
annotation (
  experiment(StopTime=10000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Validation/ThermalFollowing.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.ThermalElectricalFollowing\">
Buildings.Fluid.CHPs.ThermalElectricalFollowing</a>
for the CHP unit simulation with the thermal demand priority. 
</p>
</html>", revisions="<html>
<ul>
<li>
December 04, 2019, by Jianjun Hu:<br/>
Refactored implementation. 
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-180},{180,100}}),
            graphics={
                  Rectangle(
          extent={{40,100},{182,-180}},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          pattern=LinePattern.Dot),
                              Text(
          extent={{86,98},{132,84}},
          textColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          textStyle={TextStyle.Bold},
          textString="Post-processing")}));
end ThermalFollowing;
