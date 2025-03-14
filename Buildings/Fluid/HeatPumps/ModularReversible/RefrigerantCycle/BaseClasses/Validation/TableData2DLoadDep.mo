within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model TableData2DLoadDep
  extends Modelica.Icons.Example;


  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatSet(
    height=TEvaEnt.k - TEvaLvg.k,
    duration=80,
    offset=TEvaLvg.k,
    startTime=10,
    y(final unit="K", displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatSet(
    height=TConLvg.k - TConEnt.k,
    duration=80,
    offset=TConEnt.k,
    startTime=10,
    y(final unit="K", displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConEnt(k=TConLvg.k - 889828
        /datCoo.mCon_flow_nominal/cp.k,                                    y(
        final unit="K", displayUnit="degC"))
    "TConInMea in HP hea. cycle, TEvaInMea in HP coo. cycle, TConInMea in chiller coo. cycle, TEvaInMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConLvg(k=63 + 273.15, y(
        final unit="K", displayUnit="degC"))
    "TConOutMea in HP hea. cycle, TEvaOutMea in HP coo. cycle, TConOutMea in chiller coo. cycle, TEvaOutMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEvaEnt(k=TEvaLvg.k + 630369
        /datCoo.mEva_flow_nominal/cp.k,                                    y(
        final unit="K", displayUnit="degC"))
    "TEvaInMea in HP hea. cycle, TConInMea in HP coo. cycle, TEvaInMea in chiller coo. cycle, TConInMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEvaLvg(k=6 + 273.15, y(
        final unit="K", displayUnit="degC"))
    "TEvaOutMea in HP hea. cycle, TConOutMea in HP coo. cycle, TEvaOutMea in chiller coo. cycle, TConOutMea in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep
    chiSupLvg(
    typ=1,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datCoo.PLRSup,
    fileName=datCoo.fileName,
    TLoa_nominal=TEvaLvg.k,
    TSou_nominal=TConLvg.k)
    "Chiller with CHWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  parameter Data.TableData2DLoadDep.GenericHeatPump datHea(
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_HP.txt"),
    PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
    PLRCyc_min=0.2,
    P_min=50,
    mCon_flow_nominal=45,
    mEva_flow_nominal=30,
    dpCon_nominal=40E3,
    dpEva_nominal=37E3,
    devIde="30XW852",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    tabUppBou=[276.45,336.15; 303.15,336.15],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Heat pump performance data"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  parameter Chillers.ModularReversible.Data.TableData2DLoadDep.Generic datCoo(
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_Chiller.txt"),
    PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
    PLRCyc_min=0.2,
    P_min=50,
    mCon_flow_nominal=45,
    mEva_flow_nominal=30,
    dpCon_nominal=40E3,
    dpEva_nominal=37E3,
    devIde="30XW852",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    tabLowBou=[292.15,276.45; 336.15,276.45],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true) "On/off signal"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mEva_flow(k=datCoo.mEva_flow_nominal)
    "mEvaMea_flow in HP hea. cycle, mConMea_flow in HP coo. cycle, mEvaMea_flow in chiller coo. cycle, mConMea_flow in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mCon_flow(k=datCoo.mCon_flow_nominal)
    "mConMea_flow in HP hea. cycle, mEvaMea_flow in HP coo. cycle, mConMea_flow in chiller coo. cycle, mEvaMea_flow in chiller hea. cycle"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp(
    k=Buildings.Media.Water.cp_const)
    "Specific heat capacity of load side fluid"
    annotation (Placement(transformation(extent={{-68,90},{-48,110}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep
    chiRetEnt(
    typ=1,
    use_TLoaLvgForCtl=false,
    use_TEvaOutForTab=true,
    use_TConOutForTab=false,
    PLRSup=datCoo.PLRSup,
    fileName=datCoo.fileName,
    TLoa_nominal=TEvaLvg.k,
    TSou_nominal=TConEnt.k)
    "Chiller with CHWRT control and performance data interpolation based on CW entering temperature"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgChiSupLvg(y=chiSupLvg.TLoaEnt
         + chiSupLvg.Q_flow/chiSupLvg.mLoa_flow/chiSupLvg.cpLoa)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Sources.RealExpression TEvaEntChiRetEnt(y=chiRetEnt.TLoaLvg
         - chiRetEnt.Q_flow/chiRetEnt.mLoa_flow/chiRetEnt.cpLoa)
    "Calculate evaporator entering temperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse    coo(period=100)
    "Cooling mode enable"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep
    chiHeaSupLvg(
    typ=2,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datCoo.PLRSup,
    fileName=datCoo.fileName,
    TLoa_nominal=TEvaLvg.k,
    TSou_nominal=TConLvg.k)
    "Heat recovery chiller with CHWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgChiHeaSupLvg(y=chiHeaSupLvg.TLoaEnt
         + chiHeaSupLvg.Q_flow/chiHeaSupLvg.mLoa_flow/chiHeaSupLvg.cpLoa)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{20,-4},{40,16}})));
  Modelica.Blocks.Sources.RealExpression TConLvgChiHeaSupLvg(y=chiHeaSupLvg.TLoaEnt
         + (chiHeaSupLvg.P - chiHeaSupLvg.Q_flow)/chiHeaSupLvg.mLoa_flow/
        chiHeaSupLvg.cpLoa) "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{20,-18},{40,2}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor selChiHeaInp[6](each final
      nin=2)
    "Select input variable based on HRC operating mode: 1 for cooling, 2 for heating"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger cooInt(integerTrue=1,
      integerFalse=2) "Convert cooling mode enable to integer"
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repCooInt(nout=6)
    "Replicate cooling mode enable"
    annotation (Placement(transformation(extent={{20,-72},{40,-52}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep
    hpSupLvg(
    typ=3,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRSup=datHea.PLRSup,
    fileName=datHea.fileName,
    TLoa_nominal=TConLvg.k,
    TSou_nominal=TEvaLvg.k)
    "Heat pump with HWST control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Sources.RealExpression TConLvgHpSupLvg(y=hpSupLvg.TLoaEnt +
        hpSupLvg.Q_flow/hpSupLvg.mLoa_flow/hpSupLvg.cpLoa)
    "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
equation
  connect(on.y, chiSupLvg.on) annotation (Line(points={{-68,60},{-30,60},{-30,89},
          {-12,89}},
                   color={255,0,255}));
  connect(TChiWatSet.y, chiSupLvg.TSet) annotation (Line(points={{-108,80},{-40,
          80},{-40,85},{-12,85}},
                            color={0,0,127}));
  connect(TConEnt.y, chiSupLvg.TSouEnt)
    annotation (Line(points={{-108,0},{-26,0},{-26,81},{-12,81}},
                                                             color={0,0,127}));
  connect(TConLvg.y, chiSupLvg.TSouLvg) annotation (Line(points={{-68,-20},{-24,
          -20},{-24,79},{-12,79}},color={0,0,127}));
  connect(mEva_flow.y, chiSupLvg.mLoa_flow) annotation (Line(points={{-108,-80},
          {-18,-80},{-18,73},{-12,73}},
                                 color={0,0,127}));
  connect(cp.y, chiSupLvg.cpLoa) annotation (Line(points={{-46,100},{-16,100},{-16,
          71},{-12,71}},
                   color={0,0,127}));
  connect(on.y, chiRetEnt.on) annotation (Line(points={{-68,60},{-30,60},{-30,49},
          {-12,49}},
                   color={255,0,255}));
  connect(TChiWatSet.y, chiRetEnt.TSet) annotation (Line(points={{-108,80},{-40,
          80},{-40,45},{-12,45}},
                            color={0,0,127}));
  connect(TConEnt.y, chiRetEnt.TSouEnt)
    annotation (Line(points={{-108,0},{-24,0},{-24,41},{-12,41}},
                                                             color={0,0,127}));
  connect(TConLvg.y, chiRetEnt.TSouLvg) annotation (Line(points={{-68,-20},{-22,
          -20},{-22,40},{-12,40},{-12,39}},
                                  color={0,0,127}));
  connect(TEvaLvg.y, chiRetEnt.TLoaLvg) annotation (Line(points={{-68,-60},{-20,
          -60},{-20,35},{-12,35}},
                          color={0,0,127}));
  connect(mEva_flow.y, chiRetEnt.mLoa_flow) annotation (Line(points={{-108,-80},
          {-18,-80},{-18,33},{-12,33}},
                                 color={0,0,127}));
  connect(cp.y, chiRetEnt.cpLoa) annotation (Line(points={{-46,100},{-16,100},{-16,
          31},{-12,31}},
                   color={0,0,127}));
  connect(chiSupLvg.PLR, chiSupLvg.yMea) annotation (Line(points={{12,86},{16,86},
          {16,100},{-14,100},{-14,83},{-12,83}}, color={0,0,127}));
  connect(chiRetEnt.PLR, chiRetEnt.yMea) annotation (Line(points={{12,46},{16,46},
          {16,60},{-14,60},{-14,43},{-12,43}}, color={0,0,127}));
  connect(TEvaLvgChiSupLvg.y, chiSupLvg.TLoaLvg) annotation (Line(points={{41,80},
          {46,80},{46,64},{-20,64},{-20,75},{-12,75}}, color={0,0,127}));
  connect(TEvaEnt.y, chiSupLvg.TLoaEnt) annotation (Line(points={{-108,-40},{-22,
          -40},{-22,77},{-12,77}}, color={0,0,127}));
  connect(TEvaEntChiRetEnt.y, chiRetEnt.TLoaEnt) annotation (Line(points={{41,40},
          {46,40},{46,22},{-14,22},{-14,37},{-12,37}}, color={0,0,127}));
  connect(on.y, chiHeaSupLvg.on) annotation (Line(points={{-68,60},{-30,60},{-30,
          9},{-12,9}}, color={255,0,255}));
  connect(cp.y, chiHeaSupLvg.cpLoa) annotation (Line(points={{-46,100},{-16,100},
          {-16,-9},{-12,-9}}, color={0,0,127}));
  connect(cp.y, chiRetEnt.cpLoa) annotation (Line(points={{-46,100},{-16,100},{-16,
          31},{-12,31}},
                   color={0,0,127}));
  connect(chiHeaSupLvg.PLR, chiHeaSupLvg.yMea) annotation (Line(points={{12,6},{
          16,6},{16,20},{-14,20},{-14,3},{-12,3}}, color={0,0,127}));
  connect(coo.y, chiHeaSupLvg.coo) annotation (Line(points={{-68,20},{-34,20},{-34,
          7},{-12,7}}, color={255,0,255}));
  connect(TChiWatSet.y, selChiHeaInp[1].u[1]) annotation (Line(points={{-108,80},
          {-40,80},{-40,-30.5},{-12,-30.5}}, color={0,0,127}));
  connect(THeaWatSet.y, selChiHeaInp[1].u[2]) annotation (Line(points={{-108,40},
          {-42,40},{-42,-29.5},{-12,-29.5}}, color={0,0,127}));
  connect(TConEnt.y, selChiHeaInp[2].u[1]) annotation (Line(points={{-108,0},{-26,
          0},{-26,-30.5},{-12,-30.5}}, color={0,0,127}));
  connect(TEvaEnt.y, selChiHeaInp[2].u[2]) annotation (Line(points={{-108,-40},{
          -22,-40},{-22,-29.5},{-12,-29.5}}, color={0,0,127}));
  connect(TConLvg.y, selChiHeaInp[3].u[1]) annotation (Line(points={{-68,-20},{-40,
          -20},{-40,-30.5},{-12,-30.5}}, color={0,0,127}));
  connect(TEvaLvg.y, selChiHeaInp[3].u[2]) annotation (Line(points={{-68,-60},{-20,
          -60},{-20,-29.5},{-12,-29.5}}, color={0,0,127}));
  connect(TEvaEnt.y, selChiHeaInp[4].u[1]) annotation (Line(points={{-108,-40},{
          -22,-40},{-22,-30.5},{-12,-30.5}}, color={0,0,127}));
  connect(TConEnt.y, selChiHeaInp[4].u[2]) annotation (Line(points={{-108,0},{
          -22,0},{-22,-29.5},{-12,-29.5}},   color={0,0,127}));
  connect(TEvaLvgChiHeaSupLvg.y, selChiHeaInp[5].u[1]) annotation (Line(points={
          {41,6},{46,6},{46,-16},{-14,-16},{-14,-30.5},{-12,-30.5}}, color={0,0,
          127}));
  connect(TConLvgChiHeaSupLvg.y, selChiHeaInp[5].u[2]) annotation (Line(points={
          {41,-8},{44,-8},{44,-14},{-14,-14},{-14,-30},{-12,-30},{-12,-29.5}},
        color={0,0,127}));
  connect(mEva_flow.y, selChiHeaInp[6].u[1]) annotation (Line(points={{-108,-80},
          {-18,-80},{-18,-30.5},{-12,-30.5}}, color={0,0,127}));
  connect(mCon_flow.y, selChiHeaInp[6].u[2]) annotation (Line(points={{-68,-100},
          {-16,-100},{-16,-29.5},{-12,-29.5}}, color={0,0,127}));
  connect(cooInt.y, repCooInt.u)
    annotation (Line(points={{12,-62},{18,-62}}, color={255,127,0}));
  connect(repCooInt.y, selChiHeaInp.index) annotation (Line(points={{42,-62},{46,
          -62},{46,-44},{0,-44},{0,-42}}, color={255,127,0}));
  connect(coo.y, cooInt.u) annotation (Line(points={{-68,20},{-34,20},{-34,-62},
          {-12,-62}}, color={255,0,255}));
  connect(selChiHeaInp[1].y, chiHeaSupLvg.TSet) annotation (Line(points={{12,-30},
          {14,-30},{14,-12},{-14,-12},{-14,5},{-12,5}}, color={0,0,127}));
  connect(selChiHeaInp[2].y, chiHeaSupLvg.TSouEnt) annotation (Line(points={{12,-30},
          {14,-30},{14,-12},{-14,-12},{-14,1},{-12,1}}, color={0,0,127}));
  connect(selChiHeaInp[3].y, chiHeaSupLvg.TSouLvg) annotation (Line(points={{12,-30},
          {14,-30},{14,-12},{-14,-12},{-14,-1},{-12,-1}},
                                                        color={0,0,127}));
  connect(selChiHeaInp[4].y, chiHeaSupLvg.TLoaEnt) annotation (Line(points={{12,-30},
          {14,-30},{14,-12},{-14,-12},{-14,-3},{-12,-3}},
                                                        color={0,0,127}));
  connect(selChiHeaInp[5].y, chiHeaSupLvg.TLoaLvg) annotation (Line(points={{12,-30},
          {14,-30},{14,-12},{-14,-12},{-14,-5},{-12,-5}},
                                                        color={0,0,127}));
  connect(selChiHeaInp[6].y, chiHeaSupLvg.mLoa_flow) annotation (Line(points={{12,-30},
          {14,-30},{14,-12},{-14,-12},{-14,-7},{-12,-7}},
                                                        color={0,0,127}));



  connect(TConLvgHpSupLvg.y, hpSupLvg.TLoaLvg) annotation (Line(points={{41,
          -100},{46,-100},{46,-114},{-16,-114},{-16,-105},{-12,-105}}, color={0,
          0,127}));
  connect(on.y, hpSupLvg.on) annotation (Line(points={{-68,60},{-30,60},{-30,
          -91},{-12,-91}}, color={255,0,255}));
  connect(TEvaEnt.y, hpSupLvg.TSouEnt) annotation (Line(points={{-108,-40},{-22,
          -40},{-22,-99},{-12,-99}}, color={0,0,127}));
  connect(TEvaLvg.y, hpSupLvg.TSouLvg) annotation (Line(points={{-68,-60},{-20,
          -60},{-20,-101},{-12,-101}}, color={0,0,127}));
  connect(TConEnt.y, hpSupLvg.TLoaEnt) annotation (Line(points={{-108,0},{-26,0},
          {-26,-103},{-12,-103}}, color={0,0,127}));
  connect(THeaWatSet.y, hpSupLvg.TSet) annotation (Line(points={{-108,40},{-42,
          40},{-42,-95},{-12,-95}}, color={0,0,127}));
  connect(hpSupLvg.PLR, hpSupLvg.yMea) annotation (Line(points={{12,-94},{14,
          -94},{14,-86},{-14,-86},{-14,-97},{-12,-97}}, color={0,0,127}));
  connect(mCon_flow.y, hpSupLvg.mLoa_flow) annotation (Line(points={{-68,-100},
          {-16,-100},{-16,-107},{-12,-107}}, color={0,0,127}));
  connect(cp.y, hpSupLvg.cpLoa) annotation (Line(points={{-46,100},{-14,100},{
          -14,-108},{-12,-108},{-12,-109}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/TableData2DLoadDep.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=100.0),
    Documentation(info="<html>
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
heat recovery chiller applications with CHW supply temperature control 
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
</html>", revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDep;
