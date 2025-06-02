within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model TableData2DLoadDep
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatSet(
    height=TEvaEnt.k - TEvaLvg.k,
    duration=80,
    offset=TEvaLvg.k,
    startTime=10,
    y(
      final unit="K",
      displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatSet(
    height=TConLvg.k - TConEnt.k,
    duration=80,
    offset=TConEnt.k,
    startTime=10,
    y(
      final unit="K",
      displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConEnt(
    k=TConLvg.k - 889828 / datCoo.mCon_flow_nominal / cp.k,
    y(
      final unit="K",
      displayUnit="degC"))
    "TConInMea in HP hea. cycle, TEvaInMea in HP coo. cycle, TConInMea in chiller coo. cycle, TEvaInMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConLvg(
    k=63 + 273.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "TConOutMea in HP hea. cycle, TEvaOutMea in HP coo. cycle, TConOutMea in chiller coo. cycle, TEvaOutMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEvaEnt(
    k=TEvaLvg.k + 630369 / datCoo.mEva_flow_nominal / cp.k,
    y(
      final unit="K",
      displayUnit="degC"))
    "TEvaInMea in HP hea. cycle, TConInMea in HP coo. cycle, TEvaInMea in chiller coo. cycle, TConInMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEvaLvg(
    k=6 + 273.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "TEvaOutMea in HP hea. cycle, TConOutMea in HP coo. cycle, TEvaOutMea in chiller coo. cycle, TConOutMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep chiSupLvg(
    typ=1,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datCoo.PLRSup,
    fileName=datCoo.fileName,
    TLoa_nominal=TEvaLvg.k,
    TSou_nominal=TConLvg.k)
    "Chiller with CHWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  parameter Data.TableData2DLoadDep.GenericHeatPump datHea(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_HP.txt"),
    PLRSup={0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 1.0},
    PLRCyc_min=0.2,
    P_min=50,
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
    PLRSup={0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 1.0},
    PLRCyc_min=0.2,
    P_min=50,
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
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep chiRetEnt(
    typ=1,
    use_TLoaLvgForCtl=false,
    use_TEvaOutForTab=true,
    use_TConOutForTab=false,
    PLRSup=datCoo.PLRSup,
    fileName=datCoo.fileName,
    TLoa_nominal=TEvaLvg.k,
    TSou_nominal=TConEnt.k)
    "Chiller with CHWRT control and performance data interpolation based on CW entering temperature"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgChiSupLvg(
    y=chiSupLvg.TLoaEnt + chiSupLvg.Q_flow / chiSupLvg.mLoa_flow / chiSupLvg.cpLoa)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Blocks.Sources.RealExpression TEvaEntChiRetEnt(
    y=chiRetEnt.TLoaLvg - chiRetEnt.Q_flow / chiRetEnt.mLoa_flow / chiRetEnt.cpLoa)
    "Calculate evaporator entering temperature"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant coo(
    k=false)
    "Cooling mode enable"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep chiHeaSupLvg(
    typ=2,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datCoo.PLRSup,
    fileName=datCoo.fileName,
    TLoa_nominal=TEvaLvg.k,
    TSou_nominal=TConLvg.k)
    "Heat recovery chiller with CHWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.RealExpression TConLvgChiHeaSupLvg(
    y=chiHeaSupLvg.TLoaEnt +(chiHeaSupLvg.P - chiHeaSupLvg.Q_flow) /
      chiHeaSupLvg.mLoa_flow / chiHeaSupLvg.cpLoa)
    "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep hpSupLvg(
    typ=3,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datHea.PLRSup,
    fileName=datHea.fileName,
    TLoa_nominal=TConLvg.k,
    TSou_nominal=TEvaLvg.k)
    "Heat pump with HWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Sources.RealExpression TConLvgHpSupLvg(
    y=hpSupLvg.TLoaEnt + hpSupLvg.Q_flow / hpSupLvg.mLoa_flow / hpSupLvg.cpLoa)
    "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
equation
  connect(on.y, chiSupLvg.on)
    annotation (Line(points={{-58,60},{-20,60},{-20,109},{-2,109}},color={255,0,255}));
  connect(TChiWatSet.y, chiSupLvg.TSet)
    annotation (Line(points={{-98,80},{-30,80},{-30,105},{-2,105}},color={0,0,127}));
  connect(TConEnt.y, chiSupLvg.TAmbEnt)
    annotation (Line(points={{-98,0},{-16,0},{-16,101},{-2,101}},color={0,0,127}));
  connect(TConLvg.y, chiSupLvg.TAmbLvg)
    annotation (Line(points={{-58,-20},{-14,-20},{-14,99},{-2,99}},color={0,0,127}));
  connect(mEva_flow.y, chiSupLvg.mLoa_flow)
    annotation (Line(points={{-98,-80},{-8,-80},{-8,93},{-2,93}},color={0,0,127}));
  connect(cp.y, chiSupLvg.cpLoa)
    annotation (Line(points={{-38,100},{-6,100},{-6,91},{-2,91}},color={0,0,127}));
  connect(on.y, chiRetEnt.on)
    annotation (Line(points={{-58,60},{-20,60},{-20,49},{-2,49}},color={255,0,255}));
  connect(TChiWatSet.y, chiRetEnt.TSet)
    annotation (Line(points={{-98,80},{-30,80},{-30,45},{-2,45}},color={0,0,127}));
  connect(TConEnt.y, chiRetEnt.TAmbEnt)
    annotation (Line(points={{-98,0},{-14,0},{-14,41},{-2,41}},color={0,0,127}));
  connect(TConLvg.y, chiRetEnt.TAmbLvg)
    annotation (Line(points={{-58,-20},{-14,-20},{-14,40},{-2,40},{-2,39}},color={0,0,127}));
  connect(TEvaLvg.y, chiRetEnt.TLoaLvg)
    annotation (Line(points={{-58,-60},{-10,-60},{-10,35},{-2,35}},color={0,0,127}));
  connect(mEva_flow.y, chiRetEnt.mLoa_flow)
    annotation (Line(points={{-98,-80},{-8,-80},{-8,33},{-2,33}},color={0,0,127}));
  connect(cp.y, chiRetEnt.cpLoa)
    annotation (Line(points={{-38,100},{-6,100},{-6,31},{-2,31}},color={0,0,127}));
  connect(chiSupLvg.PLR, chiSupLvg.yMea)
    annotation (Line(points={{22,106},{26,106},{26,118},{-4,118},{-4,103},{-2,103}},
      color={0,0,127}));
  connect(chiRetEnt.PLR, chiRetEnt.yMea)
    annotation (Line(points={{22,46},{26,46},{26,60},{-4,60},{-4,43},{-2,43}},
      color={0,0,127}));
  connect(TEvaLvgChiSupLvg.y, chiSupLvg.TLoaLvg)
    annotation (Line(points={{51,100},{56,100},{56,80},{-10,80},{-10,95},{-2,95}},
      color={0,0,127}));
  connect(TEvaEnt.y, chiSupLvg.TLoaEnt)
    annotation (Line(points={{-98,-40},{-12,-40},{-12,97},{-2,97}},color={0,0,127}));
  connect(TEvaEntChiRetEnt.y, chiRetEnt.TLoaEnt)
    annotation (Line(points={{51,40},{56,40},{56,22},{-4,22},{-4,37},{-2,37}},
      color={0,0,127}));
  connect(on.y, chiHeaSupLvg.on)
    annotation (Line(points={{-58,60},{-20,60},{-20,-11},{-2,-11}},color={255,0,255}));
  connect(cp.y, chiHeaSupLvg.cpLoa)
    annotation (Line(points={{-38,100},{-6,100},{-6,-29},{-2,-29}},color={0,0,127}));
  connect(cp.y, chiRetEnt.cpLoa)
    annotation (Line(points={{-38,100},{-6,100},{-6,31},{-2,31}},color={0,0,127}));
  connect(chiHeaSupLvg.PLR, chiHeaSupLvg.yMea)
    annotation (Line(points={{22,-14},{26,-14},{26,0},{-4,0},{-4,-17},{-2,-17}},
      color={0,0,127}));
  connect(coo.y, chiHeaSupLvg.coo)
    annotation (Line(points={{-58,20},{-22,20},{-22,-13},{-2,-13}},color={255,0,255}));
  connect(TConLvgHpSupLvg.y, hpSupLvg.TLoaLvg)
    annotation (Line(points={{51,-80},{56,-80},{56,-100},{-4,-100},{-4,-85},{-2,-85}},
      color={0,0,127}));
  connect(on.y, hpSupLvg.on)
    annotation (Line(points={{-58,60},{-20,60},{-20,-71},{-2,-71}},color={255,0,255}));
  connect(TEvaEnt.y, hpSupLvg.TAmbEnt)
    annotation (Line(points={{-98,-40},{-12,-40},{-12,-79},{-2,-79}},color={0,0,127}));
  connect(TEvaLvg.y, hpSupLvg.TAmbLvg)
    annotation (Line(points={{-58,-60},{-10,-60},{-10,-81},{-2,-81}},color={0,0,127}));
  connect(TConEnt.y, hpSupLvg.TLoaEnt)
    annotation (Line(points={{-98,0},{-16,0},{-16,-83},{-2,-83}},color={0,0,127}));
  connect(THeaWatSet.y, hpSupLvg.TSet)
    annotation (Line(points={{-98,40},{-32,40},{-32,-75},{-2,-75}},color={0,0,127}));
  connect(hpSupLvg.PLR, hpSupLvg.yMea)
    annotation (Line(points={{22,-74},{26,-74},{26,-60},{-4,-60},{-4,-77},{-2,-77}},
      color={0,0,127}));
  connect(mCon_flow.y, hpSupLvg.mLoa_flow)
    annotation (Line(points={{-58,-100},{-6,-100},{-6,-87},{-2,-87}},color={0,0,127}));
  connect(cp.y, hpSupLvg.cpLoa)
    annotation (Line(points={{-38,100},{-4,100},{-4,-89},{-2,-89}},color={0,0,127}));
  connect(TEvaLvg.y, chiHeaSupLvg.TAmbLvg)
    annotation (Line(points={{-58,-60},{-8,-60},{-8,-4},{-6,-4},{-6,-21},{-2,-21}},
      color={0,0,127}));
  connect(TEvaEnt.y, chiHeaSupLvg.TAmbEnt)
    annotation (Line(points={{-98,-40},{-12,-40},{-12,-19},{-2,-19}},color={0,0,127}));
  connect(TConEnt.y, chiHeaSupLvg.TLoaEnt)
    annotation (Line(points={{-98,0},{-16,0},{-16,-23},{-2,-23}},color={0,0,127}));
  connect(TConLvgChiHeaSupLvg.y, chiHeaSupLvg.TLoaLvg)
    annotation (Line(points={{51,-20},{56,-20},{56,-40},{-4,-40},{-4,-25},{-2,-25}},
      color={0,0,127}));
  connect(mCon_flow.y, chiHeaSupLvg.mLoa_flow)
    annotation (Line(points={{-58,-100},{-6,-100},{-6,-27},{-2,-27}},color={0,0,127}));
  connect(THeaWatSet.y, chiHeaSupLvg.TSet)
    annotation (Line(points={{-98,40},{-30,40},{-30,-15},{-2,-15}},color={0,0,127}));
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
