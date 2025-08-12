within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model TableData2DLoadDep
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatSet(
    height=TEvaEnt.k - TEvaLvg.k,
    duration=80,
    offset=TEvaLvg.k,
    startTime=10,
    y(final unit="K",
      displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatSet(
    height=TConLvg.k - TConEnt.k,
    duration=40,
    offset=TConEnt.k,
    startTime=10,
    y(final unit="K",
      displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConEnt(
    k=TConLvg.k - 889828 / datCoo.mCon_flow_nominal / cp.k,
    y(final unit="K",
      displayUnit="degC"))
    "TConInMea in HP hea. cycle, TEvaInMea in HP coo. cycle, TConInMea in chiller coo. cycle, TEvaInMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConLvg(
    k=63 + 273.15,
    y(final unit="K",
      displayUnit="degC"))
    "TConOutMea in HP hea. cycle, TEvaOutMea in HP coo. cycle, TConOutMea in chiller coo. cycle, TEvaOutMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEvaEnt(
    k=TEvaLvg.k + 630369 / datCoo.mEva_flow_nominal / cp.k,
    y(final unit="K",
      displayUnit="degC"))
    "TEvaInMea in HP hea. cycle, TConInMea in HP coo. cycle, TEvaInMea in chiller coo. cycle, TConInMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEvaLvg(
    k=6 + 273.15,
    y(final unit="K",
      displayUnit="degC"))
    "TEvaOutMea in HP hea. cycle, TConOutMea in HP coo. cycle, TEvaOutMea in chiller coo. cycle, TConOutMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  parameter Data.TableData2DLoadDep.GenericHeatPump datHea(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_HP.txt"),
    PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
    PLRCyc_min=0.2,
    mCon_flow_nominal=45,
    mEva_flow_nominal=30,
    dpCon_nominal=40E3,
    dpEva_nominal=37E3,
    devIde="30XW852",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    tabUppBou=[
      276.45, 336.15;
      303.15, 336.15],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Heat pump performance data"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  parameter Chillers.ModularReversible.Data.TableData2DLoadDep.Generic datCoo(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_Chiller.txt"),
    PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
    PLRCyc_min=0.2,
    mCon_flow_nominal=45,
    mEva_flow_nominal=30,
    dpCon_nominal=40E3,
    dpEva_nominal=37E3,
    devIde="30XW852",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    tabLowBou=[
      292.15, 276.45;
      336.15, 276.45],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(
    k=true)
    "On/off signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mEva_flow(
    k=datCoo.mEva_flow_nominal)
    "mEvaMea_flow in HP hea. cycle, mConMea_flow in HP coo. cycle, mEvaMea_flow in chiller coo. cycle, mConMea_flow in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mCon_flow(
    k=datCoo.mCon_flow_nominal)
    "mConMea_flow in HP hea. cycle, mEvaMea_flow in HP coo. cycle, mConMea_flow in chiller coo. cycle, mEvaMea_flow in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp(
    k=Buildings.Media.Water.cp_const)
    "Specific heat capacity of load side fluid"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant coo(
    k=false)
    "Cooling mode enable"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep hpSupLvg(
    typ=3,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datHea.PLRSup,
    fileName=datHea.fileName,
    TLoa_nominal=TConLvg.k,
    TAmb_nominal=TEvaLvg.k)
    "Heat pump with HWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = Buildings.Media.Water "Water",
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{32,-90},{52,-70}})));
  Delays.DelayFirstOrder del(
    redeclare package Medium = Buildings.Media.Water "Water",
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TConEnt.k,
    m_flow_nominal=datCoo.mCon_flow_nominal,
    tau=5,
    nPorts=2) annotation (Placement(transformation(extent={{90,-20},{110,0}})));
  Sources.Boundary_pT bou(redeclare package Medium = Buildings.Media.Water
      "Water", nPorts=1)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water "Water", m_flow_nominal=datCoo.mCon_flow_nominal)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Sensors.TemperatureTwoPort senTem1(redeclare package Medium = Media.Water
      "Water", m_flow_nominal=datCoo.mCon_flow_nominal)
    annotation (Placement(transformation(extent={{90,-30},{70,-50}})));
equation
  connect(on.y, hpSupLvg.on)
    annotation (Line(points={{-58,60},{-20,60},{-20,-71},{-2,-71}},color={255,0,255}));
  connect(TEvaEnt.y, hpSupLvg.TAmbEnt)
    annotation (Line(points={{-98,-40},{-12,-40},{-12,-79},{-2,-79}},color={0,0,127}));
  connect(TEvaLvg.y, hpSupLvg.TAmbLvg)
    annotation (Line(points={{-58,-60},{-10,-60},{-10,-81},{-2,-81}},color={0,0,127}));
  connect(THeaWatSet.y, hpSupLvg.TSet)
    annotation (Line(points={{-98,40},{-32,40},{-32,-75},{-2,-75}},color={0,0,127}));
  connect(hpSupLvg.PLR, hpSupLvg.yMea)
    annotation (Line(points={{22,-74},{26,-74},{26,-60},{-4,-60},{-4,-77},{-2,-77}},
      color={0,0,127}));
  connect(mCon_flow.y, hpSupLvg.mLoa_flow)
    annotation (Line(points={{-58,-100},{-6,-100},{-6,-87},{-2,-87}},color={0,0,127}));
  connect(cp.y, hpSupLvg.cpLoa)
    annotation (Line(points={{-38,100},{-4,100},{-4,-89},{-2,-89}},color={0,0,127}));
  connect(TConEnt.y, boundary.T_in) annotation (Line(points={{-98,0},{0,0},{0,
          -16},{18,-16}}, color={0,0,127}));
  connect(hpSupLvg.Q_flow, preHeaFlo.Q_flow)
    annotation (Line(points={{22,-80},{32,-80}}, color={0,0,127}));
  connect(preHeaFlo.port, del.heatPort) annotation (Line(points={{52,-80},{60,
          -80},{60,-10},{90,-10}}, color={191,0,0}));
  connect(mCon_flow.y, boundary.m_flow_in) annotation (Line(points={{-58,-100},
          {-6,-100},{-6,-12},{18,-12}}, color={0,0,127}));
  connect(boundary.ports[1], senTem.port_a)
    annotation (Line(points={{40,-20},{60,-20}}, color={0,127,255}));
  connect(senTem.port_b, del.ports[1])
    annotation (Line(points={{80,-20},{99,-20}}, color={0,127,255}));
  connect(del.ports[2], senTem1.port_a) annotation (Line(points={{101,-20},{101,
          -40},{90,-40}}, color={0,127,255}));
  connect(senTem1.port_b, bou.ports[1])
    annotation (Line(points={{70,-40},{40,-40}}, color={0,127,255}));
  connect(senTem1.T, hpSupLvg.TLoaLvg) annotation (Line(points={{80,-51},{80,
          -94},{-10,-94},{-10,-85},{-2,-85}}, color={0,0,127}));
  connect(senTem.T, hpSupLvg.TLoaEnt) annotation (Line(points={{70,-9},{70,-6},
          {-8,-6},{-8,-83},{-2,-83}}, color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-140,-120},{140,120}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/TableData2DLoadDep.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=100.0),
    Documentation(
      info="<html>
<p>
This model validates the load calculation logic of the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
for different system configurations and operating modes.
</p>
<ul>
<li>
The component <code>chiSupLvg</code> validates the block for
chiller applications with CHW supply temperature control and 
performance data interpolation based on evaporator and condenser 
leaving temperature.
</li>
<li>
The component <code>chiRetEnt</code> validates the block for
chiller applications with CHW return temperature control and 
performance data interpolation based on evaporator leaving
and condenser entering temperature.
</li>
<li>
The component <code>chiHeaSupLvg</code> validates the block for
heat recovery chiller applications with HW supply temperature control 
and performance data interpolation based on evaporator and condenser 
leaving temperature.
</li>
<li>
The component <code>hpSupLvg</code> validates the block for
heat pump applications with HW supply temperature control 
and performance data interpolation based on evaporator and condenser 
leaving temperature.
</li>
</ul>
<p>
The validation is carried out by computing the tracked temperature
using the heat flow rate calculated by the block, and feeding back 
this variable along with the required part load ratio as inputs.
It is then expected that the tracked temperature matches the setpoint.
Further validation of the performance calculation algorithm 
by comparison to polynomial chiller models is available in the package
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Validation\">
Buildings.Fluid.Chillers.ModularReversible.Validation</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDep;
