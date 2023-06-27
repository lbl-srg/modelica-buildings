within Buildings.Fluid.Chillers.Validation;
model Carnot_TEva_reverseFlow
  "Test model for chiller based on Carnot efficiency and evaporator outlet temperature control signal"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal=-100E3
    "Evaporator heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=QEva_flow_nominal/
      dTEva_nominal/4200 "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=m2_flow_nominal*(
      COPc_nominal + 1)/COPc_nominal
    "Nominal mass flow rate at condenser water wide";

  Buildings.Fluid.Chillers.Carnot_TEva chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    use_eta_Carnot_nominal=true,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    show_T=true,
    QEva_flow_nominal=QEva_flow_nominal,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal=6000,
    dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    m_flow=m1_flow_nominal,
    use_T_in=false,
    use_m_flow_in=true,
    T=298.15)
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    m_flow=m2_flow_nominal,
    use_T_in=false,
    use_m_flow_in=true,
    T=295.15)
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={80,30})));
  Buildings.Fluid.Sources.Boundary_pT sin2(nPorts=1,
    redeclare package Medium = Medium2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-40,-30})));
  Modelica.Blocks.Sources.Constant TEvaLvg(k=273.15 + 10)
    "Control signal for evaporator leaving temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Gain mCon_flow(k=-1/cp1_default/dTEva_nominal)
    "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  Modelica.Blocks.Math.Add QCon_flow(k2=-1) "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp1_default=
      Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      Medium1.p_default,
      Medium1.T_default,
      Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
  Modelica.Blocks.Sources.Ramp mEva_flow(
    duration=60,
    startTime=1800,
    height=-2*m2_flow_nominal,
    offset=m2_flow_nominal) "Mass flow rate for evaporator"
    annotation (Placement(transformation(extent={{92,-8},{72,12}})));
equation
  connect(sou1.ports[1], chi.port_a1)    annotation (Line(
      points={{-30,6},{-2,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2)    annotation (Line(
      points={{40,-6},{18,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1], chi.port_b2)    annotation (Line(
      points={{-30,-30},{-12,-30},{-12,-6},{-2,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaLvg.y, chi.TSet) annotation (Line(points={{-19,40},{-12,40},{-12,10},
          {-12,9},{-4,9}},
                  color={0,0,127}));
  connect(chi.P, QCon_flow.u1) annotation (Line(points={{19,0},{34,0},{34,0},{
          34,-34},{38,-34}},
                    color={0,0,127}));
  connect(chi.QEva_flow, QCon_flow.u2) annotation (Line(points={{19,-9},{26,-9},
          {26,-10},{26,-46},{38,-46}},
                              color={0,0,127}));
  connect(QCon_flow.y, mCon_flow.u) annotation (Line(points={{61,-40},{80,-40},{
          80,-60},{-92,-60},{-92,14},{-82,14}}, color={0,0,127}));
  connect(mCon_flow.y, sou1.m_flow_in)
    annotation (Line(points={{-59,14},{-52,14}},          color={0,0,127}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{18,6},{30,6},{30,
          30},{70,30}},    color={0,127,255}));
  connect(mEva_flow.y, sou2.m_flow_in)
    annotation (Line(points={{71,2},{62,2}},        color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_TEva_reverseFlow.mos"
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
<p>
This example checks the correct behavior if a mass flow rate attains zero.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 10, 2023, by Michael Wetter:<br/>
Removed binding of parameter with same value as the default.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1692\">#1692</a>.
</li>
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
end Carnot_TEva_reverseFlow;
