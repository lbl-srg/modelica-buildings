within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HexElementLatentLoop
  "Model that tests the basic element that is used to built heat exchanger models"
  extends Modelica.Icons.Example;
 package Medium_W = Buildings.Media.Water;
 package Medium_A = Buildings.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal=0.1
    "Water mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=0.14
    "Air mass flow rate";


  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    use_T_in=false,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-40,-82},{-20,-62}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
   redeclare package Medium = Medium_W, nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-2},{60,18}})));
  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium_W,
    m_flow=5,
    nPorts=1,
    use_T_in=true)
              "Mass flow source"
    annotation (Placement(transformation(extent={{-40,-2},{-20,18}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent hex(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    dp2_nominal=5,
    UA_nominal=1E3,
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=0,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                    "Hex element"
                    annotation (Placement(transformation(extent={{10,-8},{30,12}})));
  Modelica.Blocks.Sources.Constant hACon(k=70)    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium_A,
    m_flow_nominal=mA_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=5,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Fan"
    annotation (Placement(transformation(extent={{10,-82},{30,-62}})));
  Buildings.Utilities.Psychrometrics.pW_TDewPoi TDewPoi
    "Model to compute the water vapor pressure at the dew point"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
public
  Buildings.Utilities.Psychrometrics.X_pW humRatPre(use_p_in=false)
    "Model to convert water vapor pressure into humidity ratio"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Sources.Constant TWat(k=273.15 + 5) "Water inlet temperature"
    annotation (Placement(transformation(extent={{-80,2},{-60,22}})));
  Buildings.Fluid.HeatExchangers.PrescribedOutlet hea(
    redeclare package Medium = Medium_A,
    m_flow_nominal=mA_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_X_wSet=false)                                         "Heater"
    annotation (Placement(transformation(extent={{60,-82},{80,-62}})));
  Modelica.Blocks.Sources.Constant TAir(k=273.15 + 20) "Air inlet temperature"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Sources.RealExpression TSur(y=hex.masExc.TSur)
    "Surface temperature of heat exchanger"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(hACon.y, hex.Gc_1) annotation (Line(points={{1,30},{16,30},{16,12}},
        color={0,0,127}));
  connect(hACon.y, hex.Gc_2) annotation (Line(points={{1,30},{8,30},{8,-16},{24,
          -16},{24,-8}},  color={0,0,127}));
  connect(sou.ports[1], hex.port_a1) annotation (Line(points={{-20,8},{-16,8},{10,
          8}},             color={0,127,255}));
  connect(sin_1.ports[1], hex.port_b1)
    annotation (Line(points={{60,8},{46,8},{30,8}}, color={0,127,255}));
  connect(fan.port_a, hex.port_b2) annotation (Line(points={{10,-72},{-10,-72},{
          -10,-4},{10,-4}}, color={0,127,255}));
  connect(sin_2.ports[1], fan.port_a) annotation (Line(points={{-20,-72},{-14,-72},
          {10,-72}}, color={0,127,255}));
  connect(TDewPoi.p_w, humRatPre.p_w)
    annotation (Line(points={{-19,70},{-11,70}}, color={0,0,127}));
  connect(TWat.y, sou.T_in)
    annotation (Line(points={{-59,12},{-52,12},{-42,12}}, color={0,0,127}));
  connect(fan.port_b, hea.port_a)
    annotation (Line(points={{30,-72},{60,-72}}, color={0,127,255}));
  connect(hea.port_b, hex.port_a2) annotation (Line(points={{80,-72},{88,-72},{88,
          -4},{30,-4}}, color={0,127,255}));
  connect(TAir.y, hea.TSet) annotation (Line(points={{41,-40},{48,-40},{48,-64},
          {58,-64}}, color={0,0,127}));
  connect(TSur.y, TDewPoi.T)
    annotation (Line(points={{-59,70},{-41,70},{-41,70}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=50),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HexElementLatentLoop.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This test circulates air in a loop. Air has a constant inlet temperature into the coil.
The model verifies that the air will be dehumidified
to the dewpoint of the coil surface.
</p>
</html>", revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HexElementLatentLoop;
