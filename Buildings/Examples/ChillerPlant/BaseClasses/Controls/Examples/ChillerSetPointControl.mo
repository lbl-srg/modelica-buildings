within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model ChillerSetPointControl
  "Test model for chiller setpoint control using TrimAndResponse and LinearPieceWiseTwo"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Water;
  package MediumAir = Buildings.Media.Air "Medium model";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=61.6*2
    "Nominal mass flow rate at fan";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=15.2
    "Nominal mass flow rate at chilled water";
  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=mCHW_flow_nominal/
      COPc_nominal*(COPc_nominal + 1)
    "Nominal mass flow rate at condenser water";
  parameter Real QRoo=100;
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond triAndRes(
    yEqu0=0.1,
    uTri=0.8,
    yDec=-0.03,
    yInc=0.03,
    samplePeriod=120)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    y20=273.15 + 12.78,
    y21=273.15 + 7.22,
    x1=0.5,
    y10=0.1,
    y11=1) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=3000,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YK_1881kW_6_53COP_Vanes(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Chiller"
    annotation (Placement(transformation(extent={{84,18},{104,38}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness coi(
    redeclare package Medium1 = Medium2,
    m1_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=3000,
    dp2_nominal=3000,
    redeclare package Medium2 = MediumAir,
    m2_flow_nominal=mAir_flow_nominal,
    eps=1.0) "Cooling coil"
             annotation (Placement(transformation(extent={{86,-64},{106,-44}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = Medium1,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={174,88})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_T_in=false,
    m_flow=mCW_flow_nominal,
    T=283.15) annotation (Placement(transformation(extent={{-16,78},{4,98}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 20) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-170,30})));
  Buildings.Controls.Continuous.LimPID limPID(
    reverseActing=false,
    y_start=1,
    yMin=0,
    k=10,
    Ti=0.01,
    Td=10) "PI controller"
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-130,30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(redeclare package Medium =
        MediumAir, m_flow_nominal=999)
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    m_flow_nominal=1.2*mCHW_flow_nominal,
    dp(start=40474),
    redeclare package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    init=Modelica.Blocks.Types.Init.InitialState) "Chilled water pump"
                                                                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={134,-9})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(
    V_start=1,
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{124,26},{144,46}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k=true)
    annotation (Placement(transformation(extent={{-180,62},{-160,82}})));
  Modelica.Blocks.Math.Gain gain(k=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{86,-18},{106,2}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    use_T_in=true,
    redeclare package Medium = MediumAir,
    m_flow=mAir_flow_nominal,
    T=291.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={170,-90})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium =
        MediumAir, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-30,-60})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=5,
    offset=273.15 + 25,
    f=1/20000) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={130,-94})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(y_start=273.15 + 10, T=chi.tau1
        /2,
    initType=Modelica.Blocks.Types.Init.InitialState)
            annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium =
        MediumAir, m_flow_nominal=999)
    annotation (Placement(transformation(extent={{136,-70},{156,-50}})));
equation
  connect(sou1.ports[1], chi.port_a1) annotation (Line(
      points={{4,88},{74,88},{74,34},{84,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(coi.port_a1, chi.port_b2) annotation (Line(
      points={{86,-48},{36,-48},{36,22},{84,22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRet.T, limPID.u_m) annotation (Line(
      points={{10,-49},{10,-28},{-130,-28},{-130,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chi.port_a2, pum.port_b) annotation (Line(
      points={{104,22},{134,22},{134,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, coi.port_b1) annotation (Line(
      points={{134,-19},{134,-48},{106,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_a2, expVesChi.port_a) annotation (Line(
      points={{104,22},{134,22},{134,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanConstant1.y, chi.on) annotation (Line(
      points={{-159,72},{54,72},{54,31},{82,31}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(gain.y, pum.m_flow_in) annotation (Line(
      points={{107,-8},{116.4,-8},{116.4,-9},{122,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou2.T_in, sine.y) annotation (Line(
      points={{158,-94},{141,-94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(
      points={{104,34},{122,34},{122,88},{164,88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, limPID.u_s) annotation (Line(
      points={{-159,30},{-142,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRet.port_b, coi.port_b2) annotation (Line(
      points={{20,-60},{86,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRet.port_a, sin2.ports[1]) annotation (Line(
      points={{0,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(linPieTwo.y[2], firstOrder1.u) annotation (Line(
      points={{-39,30.3},{-20,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, chi.TSet) annotation (Line(
      points={{21,30},{44,30},{44,25},{82,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coi.port_a2, TSup.port_a) annotation (Line(
      points={{106,-60},{136,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSup.port_b, sou2.ports[1]) annotation (Line(
      points={{156,-60},{190,-60},{190,-90},{180,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(limPID.y, triAndRes.u) annotation (Line(
      points={{-119,30},{-102,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(triAndRes.y, linPieTwo.u) annotation (Line(
      points={{-79,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, linPieTwo.y[1]) annotation (Line(
      points={{84,-8},{-20,-8},{-20,29.3},{-39,29.3}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-200},{200,
            200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/ChillerSetPointControl.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-6),
    Documentation(revisions="<html>
<ul>
<li>
August 16, 2019, by Michael Wetter:<br/>
Changed initialization of PI controller for Dymola 2020.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
October 17, 2012, by Wangda Zuo:<br/>
Revised for the new trim and respond control.
</li>
<li>
July 21, 2011, by Wangda Zuo:<br/>
Added mos file and merged to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerSetPointControl;
