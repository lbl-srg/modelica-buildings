within Buildings.Fluid.Geothermal.Borefields.Validation;
model ConstantHeatInjection_100Boreholes
  "Long-term temperature response of a borefield of 100 boreholes"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.Temperature T_start = 273.15
    "Initial temperature of the soil";

  Buildings.Fluid.Geothermal.Borefields.OneUTube borHol(
    redeclare package Medium = Medium, borFieDat=
    borFieDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=T_start,
    dT_dz=0,
    tLoaAgg=3600000)
    "Borehole"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    T_start=T_start,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=Buildings.Fluid.Types.InputType.Constant)
    annotation (Placement(transformation(extent={{-20,-10},{0,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorFieIn(
    redeclare package Medium = Medium,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorFieOut(
    redeclare package Medium = Medium,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  parameter Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses.ConstantHeatInjection_100Boreholes_Borefield borFieDat
    "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    m_flow(start=borFieDat.conDat.mBorFie_flow_nominal),
    p_start=100000,
    Q_flow_nominal=2*Modelica.Constants.pi*borFieDat.soiDat.kSoi*borFieDat.conDat.hBor
        *borFieDat.conDat.nBor)
      "Heater"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Modelica.Blocks.Sources.Constant heaRat(k=1)
    "Constant heat injection rate into the borefield"
    annotation (Placement(transformation(extent={{-88,10},{-68,30}})));
equation
  connect(TBorFieIn.port_b, borHol.port_a)
    annotation (Line(points={{30,-20},{40,-20}},   color={0,127,255}));
  connect(borHol.port_b, TBorFieOut.port_a)
    annotation (Line(points={{60,-20},{70,-20}},          color={0,127,255}));
  connect(pum.port_b, TBorFieIn.port_a) annotation (Line(points={{0,-20},{10,-20}},
                                         color={0,127,255}));
  connect(sin.ports[1], TBorFieOut.port_b) annotation (Line(points={{80,10},{100,
          10},{100,-20},{90,-20}},color={0,127,255}));
  connect(hea.port_b, pum.port_a)
    annotation (Line(points={{-30,-20},{-20,-20}},     color={0,127,255}));
  connect(hea.port_a, TBorFieOut.port_b) annotation (Line(points={{-50,-20},{-100,
          -20},{-100,40},{100,40},{100,-20},{90,-20}},
                                      color={0,127,255}));
  connect(hea.u, heaRat.y) annotation (Line(points={{-52,-14},{-60,-14},{-60,20},
          {-67,20}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=31536.0E+06),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Validation/ConstantHeatInjection_100Boreholes.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This validation case simulates a borefield of 100 boreholes on a square 10 by 10
grid.
</p>
<p>
The heat injection rate in the borefield is constant and equal to
<code>2*pi*kSoi*hBor*nBor</code>. In this case, the borehole wall temperature
variation corresponds to the g-function of the borefield, as evaluated in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation.GFunction_100boreholes\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation.GFunction_100boreholes</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 8, 2021, by Michael Wetter:<br/>
Added missing <code>parameter</code> keyword.<br/>
For <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1464\">IBPSA, issue 1464</a>.
</li>
<li>
June 24, 2019, by Michael Wetter:<br/>
Changed <code>StopTime</code> from integer to floating point.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1163\">issue 1163</a>.
</li>
<li>
May 27, 2019, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end ConstantHeatInjection_100Boreholes;
