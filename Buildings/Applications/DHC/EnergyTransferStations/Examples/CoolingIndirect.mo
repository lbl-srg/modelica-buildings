within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingIndirect
  "Example model for indirect cooling energy transfer station"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 0.5
    "Nominal mass flow rate on district-side (primary)";
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = 0.5
    "Nominal mass flow rate on building-side (secondary)";

  parameter Modelica.SIunits.SpecificHeatCapacity cp=
    Medium.specificHeatCapacityCp(
    Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Specific heat capacity of medium 1";

  Modelica.Blocks.Sources.Constant TSet(k=273 + 7)
    "Setpoint temperature for building chilled water supply"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    T=287.15,
    nPorts=1) "District (primary) sink" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,80})));
  Buildings.Applications.DHC.EnergyTransferStations.CoolingIndirect coo(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mDis_flow_nominal,
    m2_flow_nominal=mBui_flow_nominal,
    dp1_nominal(displayUnit="Pa") = 500,
    dp2_nominal(displayUnit="Pa") = 500,
    Q_flow_nominal=18514,
    T_a1_nominal=278.15,
    T_a2_nominal=289.15,
    dp_nominal(displayUnit="Pa") = 5000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yCon_start=0,
    reverseAction=true) "Indirect cooling ETS"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=[0,-10E3; 6,-8E3; 6,-5E3; 12,-2E3; 18,-15E3; 24,-10E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
public
  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=mBui_flow_nominal,
    final from_dp=false,
    final linearizeFlowResistance=true,
    final show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final Q_flow_nominal=-1,
    final dp_nominal=100) "Aggregate building cooling load"
    annotation (Placement(transformation(extent={{40,-86},{60,-66}})));
  Modelica.Blocks.Math.Gain gai(k=-1/(cp*(16 - 7)))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumBui(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    dp_nominal=0) "Building-side (secondary) pump" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-10})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000 + 800,
    use_T_in=false,
    T=278.15,
    nPorts=1) "District (primary) source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,80})));
  Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
      V_start=1000) "Expansion tank"
    annotation (Placement(transformation(extent={{20,0},{40,-20}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h") = 18000,
    startTime(displayUnit="h") = 3600) "Ramp load from zero"
    annotation (Placement(transformation(extent={{-120,-86},{-100,-66}})));
  Modelica.Blocks.Math.Product pro "Multiplyer to ramp load from zero"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    T_start=278.15) "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    T_start=287.15) "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=289.15) "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=280.15) "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-50})));
  Modelica.Blocks.Sources.RealExpression dTDis(y=TDisRet.T - TDisSup.T)
    "Temperature change on district side (primary"
    annotation (Placement(transformation(extent={{96,-30},{136,-10}})));
  Modelica.Blocks.Sources.RealExpression dTBui(y=TBuiRet.T - TBuiSup.T)
    "Temperature change on building side (secondary)"
    annotation (Placement(transformation(extent={{96,-10},{136,10}})));
  Modelica.Blocks.Sources.RealExpression TApp(y=TBuiSup.T - TDisSup.T)
    "Approach temperature of heat exchanger"
    annotation (Placement(transformation(extent={{96,10},{136,30}})));
equation
  connect(coo.TSetCHWS,TSet. y)
    annotation (Line(points={{38,20},{-99,20}},color={0,0,127}));
  connect(coo.port_b2, pumBui.port_a)
    annotation (Line(points={{40,14},{0,14},{0,0}}, color={0,127,255}));
  connect(gai.y, pumBui.m_flow_in)
    annotation (Line(points={{-19,-10},{-12,-10}}, color={0,0,127}));
  connect(exp.port_a, pumBui.port_a)
    annotation (Line(points={{30,0},{30,14},{0,14},{0,0}}, color={0,127,255}));
  connect(pro.u1, QCoo.y[1]) annotation (Line(points={{-42,-64},{-70,-64},{-70,-40},
          {-99,-40}}, color={0,0,127}));
  connect(pro.u2, ram.y)
    annotation (Line(points={{-42,-76},{-99,-76}}, color={0,0,127}));
  connect(pro.y, loa.u)
    annotation (Line(points={{-19,-70},{38,-70}}, color={0,0,127}));
  connect(loa.port_b, TBuiRet.port_a)
    annotation (Line(points={{60,-76},{80,-76},{80,-60}}, color={0,127,255}));
  connect(loa.port_a, TBuiSup.port_b)
    annotation (Line(points={{40,-76},{0,-76},{0,-60}}, color={0,127,255}));
  connect(TBuiSup.port_a, pumBui.port_b)
    annotation (Line(points={{0,-40},{0,-20}}, color={0,127,255}));
  connect(coo.port_a1, TDisSup.port_b)
    annotation (Line(points={{40,26},{0,26},{0,40}}, color={0,127,255}));
  connect(coo.port_b1, TDisRet.port_a)
    annotation (Line(points={{60,26},{80,26},{80,40}}, color={0,127,255}));
  connect(coo.port_a2, TBuiRet.port_b)
    annotation (Line(points={{60,14},{80,14},{80,-40}}, color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{80,60},{80,70}}, color={0,127,255}));
  connect(TDisSup.port_a, souDis.ports[1])
    annotation (Line(points={{0,60},{0,70}}, color={0,127,255}));
  connect(gai.u, QCoo.y[1]) annotation (Line(points={{-42,-10},{-70,-10},{-70,-40},
          {-99,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    Documentation(info="<html>
<p>This model provides an example for the indirect cooling energy transfer station model. The cooling load ramps up from zero and is modulated according to the QCoo table specification. The secondary (building) chilled water is varaible flow, with the mass flow rate being adjusted depending on the total building load.</p>
</html>", revisions="<html>
<ul>
<li>November 1, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingIndirect.mos"
        "Simulate and plot"));
end CoolingIndirect;
