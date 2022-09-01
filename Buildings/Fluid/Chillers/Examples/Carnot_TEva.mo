within Buildings.Fluid.Chillers.Examples;
model Carnot_TEva
  "Test model for chiller based on Carnot efficiency and evaporator outlet temperature control signal"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal=-100E3
    "Evaporator heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=QEva_flow_nominal/
      dTEva_nominal/4200 "Nominal mass flow rate at chilled water side";

  Buildings.Fluid.Chillers.Carnot_TEva chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    m2_flow_nominal=m2_flow_nominal,
    show_T=true,
    QEva_flow_nominal=QEva_flow_nominal,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    dp1_nominal=6000,
    dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_T_in=false,
    use_m_flow_in=true,
    T=298.15)
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    m_flow=m2_flow_nominal,
    use_T_in=false,
    T=295.15)
    annotation (Placement(transformation(extent={{80,-16},{60,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,30})));
  Buildings.Fluid.Sources.Boundary_pT sin2(nPorts=1,
    redeclare package Medium = Medium2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-40,-30})));
  Modelica.Blocks.Sources.Ramp TEvaLvg(
    duration=60,
    startTime=1800,
    offset=273.15 + 6,
    height=10) "Control signal for evaporator leaving temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.Gain mCon_flow(k=-1/cp1_default/dTEva_nominal)
    "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  Modelica.Blocks.Math.Add QCon_flow(k2=-1) "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{48,-50},{68,-30}})));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp1_default=
      Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      Medium1.p_default,
      Medium1.T_default,
      Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
equation
  connect(sou1.ports[1], chi.port_a1)    annotation (Line(
      points={{-30,6},{10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2)    annotation (Line(
      points={{60,-6},{30,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1], chi.port_b2)    annotation (Line(
      points={{-30,-30},{0,-30},{0,-6},{10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaLvg.y, chi.TSet) annotation (Line(points={{-39,50},{-10,50},{-10,
          9},{8,9}},
                  color={0,0,127}));
  connect(chi.P, QCon_flow.u1) annotation (Line(points={{31,0},{40,0},{40,-34},{
          46,-34}}, color={0,0,127}));
  connect(chi.QEva_flow, QCon_flow.u2) annotation (Line(points={{31,-9},{36,-9},
          {36,-46},{46,-46}}, color={0,0,127}));
  connect(QCon_flow.y, mCon_flow.u) annotation (Line(points={{69,-40},{80,-40},
          {80,-60},{-92,-60},{-92,14},{-82,14}},color={0,0,127}));
  connect(mCon_flow.y, sou1.m_flow_in)
    annotation (Line(points={{-59,14},{-52,14}},          color={0,0,127}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{30,6},{50,6},{
          50,30},{60,30}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/Carnot_TEva.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that simulates a chiller whose efficiency is scaled based on the
Carnot cycle.
The chiller takes as an input the evaporator leaving water temperature.
The condenser mass flow rate is computed in such a way that it has
a temperature difference equal to <code>dTEva_nominal</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for 
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
November 25, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TEva;
