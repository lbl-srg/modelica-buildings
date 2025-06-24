within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model TableData2DLoadDepSHC
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature THwSup_nominal=323.15
    "HW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THwRet_nominal=315.15
    "HW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwSup_nominal=280.15
    "CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwRet_nominal=285.15
    "CHW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAmbHea_nominal=268.15
    "OA temperature"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal = 58E3
    "Heating heat flow rate - Heating mode"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaShc_flow_nominal = 85E3
    "Heating heat flow rate - SHC mode"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.Temperature TAmbCoo_nominal=308.15
    "Ambient side fluid temperature — Entering or leaving depending on use_TAmbOutForTab"
    annotation (Dialog(group="Nominal condition - Cooling mode"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal = -73E3
    "Cooling heat flow rate - Cooling mode"
    annotation (Dialog(group="Nominal condition - Cooling mode"));
  parameter Modelica.Units.SI.HeatFlowRate QCooShc_flow_nominal = -65E3
    "Cooling heat flow rate - SHC mode"
    annotation (Dialog(group="Nominal condition - Cooling mode"));
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal=
    QHea_flow_nominal / (THwSup_nominal - THwRet_nominal) /
    Buildings.Media.Water.cp_const
    "HW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChw_flow_nominal=
    QCoo_flow_nominal / (TChwSup_nominal - TChwRet_nominal) /
    Buildings.Media.Water.cp_const
    "CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChwSet(
    height=TChwEnt.k - TChwSup_nominal,
    duration=2500,
    offset=TChwSup_nominal,
    startTime=1000,
    y(final unit="K", displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THwSet(
    height=THwEnt.k - THwSup_nominal,
    duration=2000,
    offset=THwSup_nominal,
    startTime=500,
    y(final unit="K", displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THwEnt(k=THwSup_nominal +
    (THwRet_nominal - THwSup_nominal)*QHeaShc_flow_nominal/QHea_flow_nominal,
    y(final unit="K", displayUnit="degC")) "Condenser entering HW temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChwEnt(k=TChwSup_nominal +
    (TChwRet_nominal - TChwSup_nominal)* QCooShc_flow_nominal /QCoo_flow_nominal,
    y(final unit="K", displayUnit="degC"))
    "Evaporator entering CHW temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true)
    "On/off command"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mChw_flow(k=
        mChw_flow_nominal)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mHw_flow(k=mHw_flow_nominal)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp(
    k=Buildings.Media.Water.cp_const)
    "Specific heat capacity of load side fluid"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC
    hpSup(
    nUni=3,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRHeaSup={1},
    PLRCooSup={1},
    PLRShcSup={1},
    fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
    fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
    fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt"),
    final THw_nominal=THwSup_nominal,
    final TChw_nominal=TChwSup_nominal,
    TAmbHea_nominal=TAmbHea_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    final TAmbCoo_nominal=TAmbCoo_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHeaShc_flow_nominal=QHeaShc_flow_nominal,
    final QCooShc_flow_nominal=QCooShc_flow_nominal)
    "Heat pump with supply temperature control"
    annotation (Placement(transformation(extent={{0,62},{20,94}})));
  Modelica.Blocks.Sources.RealExpression TConLvgHpSup(y=hpSup.THwEnt + hpSup.QHea_flow
        /hpSup.mHw_flow/hpSup.cpHw) "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{30,140},{50,160}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgHpSup(y=hpSup.TChwEnt + hpSup.QCoo_flow
        /hpSup.mChw_flow/hpSup.cpChw)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=15 + 273.15, y(
        final unit="K", displayUnit="degC")) "OA temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Continuous.Filter filter(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=THwSup_nominal) "Filter to avoid algebraic loop"
    annotation (Placement(transformation(extent={{50,110},{30,130}})));
  Modelica.Blocks.Continuous.Filter filter1(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=TChwSup_nominal) "Filter to avoid algebraic loop"
    annotation (Placement(transformation(extent={{50,30},{30,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant mode(k=Buildings.Fluid.HeatPumps.Types.OperatingModes.shc)
    "Operating mode command"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hpSup.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC
    hpRet(
    nUni=3,
    use_TLoaLvgForCtl=false,
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    PLRHeaSup={1},
    PLRCooSup={1},
    PLRShcSup={1},
    fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
    fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
    fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt"),
    final THw_nominal=THwSup_nominal,
    final TChw_nominal=TChwSup_nominal,
    TAmbHea_nominal=TAmbHea_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    final TAmbCoo_nominal=TAmbCoo_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHeaShc_flow_nominal=QHeaShc_flow_nominal,
    final QCooShc_flow_nominal=QCooShc_flow_nominal)
    "Heat pump with return temperature control"
    annotation (Placement(transformation(extent={{0,-120},{20,-88}})));
  Modelica.Blocks.Sources.RealExpression TConEntHpRet(y=hpRet.THwLvg - hpRet.QHea_flow
        /hpRet.mHw_flow/hpRet.cpHw) "Calculate condenser entering temperature"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Modelica.Blocks.Sources.RealExpression TEvaEntHpRet(y=hpRet.TChwLvg - hpRet.QCoo_flow
        /hpRet.mChw_flow/hpRet.cpChw)
    "Calculate evaporator entering temperature"
    annotation (Placement(transformation(extent={{30,-180},{50,-160}})));
  Modelica.Blocks.Continuous.Filter filter2(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=THwSup_nominal) "Filter to avoid algebraic loop"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Modelica.Blocks.Continuous.Filter filter3(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=TChwSup_nominal) "Filter to avoid algebraic loop"
    annotation (Placement(transformation(extent={{50,-150},{30,-130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni1(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr1(t=hpSup.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(message=
        "Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChwLvg(k=TChwSup_nominal,
      y(final unit="K", displayUnit="degC")) "CHW leaving temperature"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THwLvg(k=THwSup_nominal, y(
        final unit="K", displayUnit="degC")) "HW leaving temperature"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
equation
  connect(cp.y, hpSup.cpChw) annotation (Line(points={{-58,180},{-20,180},{-20,
          66},{-2,66}}, color={0,0,127}));
  connect(mHw_flow.y, hpSup.mHw_flow) annotation (Line(points={{-58,20},{-24,20},
          {-24,76},{-2,76}}, color={0,0,127}));
  connect(THwEnt.y, hpSup.THwEnt)
    annotation (Line(points={{-98,80},{-2,80}}, color={0,0,127}));
  connect(TChwSet.y, hpSup.TChwSet) annotation (Line(points={{-98,160},{-22,160},
          {-22,86},{-2,86}}, color={0,0,127}));
  connect(THwSet.y, hpSup.THwSet) annotation (Line(points={{-98,120},{-30,120},
          {-30,88},{-2,88}}, color={0,0,127}));
  connect(TChwEnt.y, hpSup.TChwEnt) annotation (Line(points={{-98,40},{-12,40},
          {-12,72},{-2,72}}, color={0,0,127}));
  connect(TOut.y, hpSup.TAmbEnt) annotation (Line(points={{-58,60},{-26,60},{-26,
          84},{-2,84}}, color={0,0,127}));
  connect(mChw_flow.y, hpSup.mChw_flow) annotation (Line(points={{-98,0},{-6,0},
          {-6,68},{-2,68}}, color={0,0,127}));
  connect(cp.y, hpSup.cpHw) annotation (Line(points={{-58,180},{-20,180},{-20,
          74},{-2,74}}, color={0,0,127}));
  connect(TConLvgHpSup.y, filter.u) annotation (Line(points={{51,150},{60,150},
          {60,120},{52,120}}, color={0,0,127}));
  connect(TEvaLvgHpSup.y, filter1.u) annotation (Line(points={{51,10},{60,10},{
          60,40},{52,40}}, color={0,0,127}));
  connect(on.y, hpSup.on) annotation (Line(points={{-58,140},{-18,140},{-18,92},
          {-2,92}}, color={255,0,255}));
  connect(mode.y, hpSup.mode) annotation (Line(points={{-58,100},{-40,100},{-40,
          90},{-2,90}}, color={255,127,0}));
  connect(hpSup.nUniHea, sumNumUni.u[1]) annotation (Line(points={{22,72},{26,
          72},{26,77.6667},{28,77.6667}}, color={255,127,0}));
  connect(hpSup.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{22,68},{26,
          68},{26,80},{28,80}}, color={255,127,0}));
  connect(hpSup.nUniShc, sumNumUni.u[3]) annotation (Line(points={{22,64},{26,
          64},{26,82.3333},{28,82.3333}}, color={255,127,0}));
  connect(sumNumUni.y, intLesEquThr.u)
    annotation (Line(points={{52,80},{58,80}},
                                             color={255,127,0}));
  connect(intLesEquThr.y, assMes.u)
    annotation (Line(points={{82,80},{88,80}},
                                             color={255,0,255}));
  connect(filter.y, hpSup.THwLvg) annotation (Line(points={{29,120},{-12,120},{
          -12,78},{-2,78}}, color={0,0,127}));
  connect(filter1.y, hpSup.TChwLvg) annotation (Line(points={{29,40},{-10,40},{
          -10,70},{-2,70}}, color={0,0,127}));
  connect(TConEntHpRet.y, filter2.u) annotation (Line(points={{51,-30},{60,-30},
          {60,-60},{52,-60}}, color={0,0,127}));
  connect(TEvaEntHpRet.y, filter3.u) annotation (Line(points={{51,-170},{60,-170},
          {60,-140},{52,-140}}, color={0,0,127}));
  connect(sumNumUni1.y, intLesEquThr1.u)
    annotation (Line(points={{52,-100},{58,-100}}, color={255,127,0}));
  connect(intLesEquThr1.y, assMes1.u)
    annotation (Line(points={{82,-100},{88,-100}}, color={255,0,255}));
  connect(on.y, hpRet.on) annotation (Line(points={{-58,140},{-30,140},{-30,-90},
          {-2,-90}}, color={255,0,255}));
  connect(mode.y, hpRet.mode) annotation (Line(points={{-58,100},{-30,100},{-30,
          -92},{-2,-92}}, color={255,127,0}));
  connect(TOut.y, hpRet.TAmbEnt) annotation (Line(points={{-58,60},{-30,60},{-30,
          -98},{-2,-98}}, color={0,0,127}));
  connect(mChw_flow.y, hpRet.mChw_flow) annotation (Line(points={{-98,0},{-52,0},
          {-52,-114},{-2,-114}}, color={0,0,127}));
  connect(mHw_flow.y, hpRet.mHw_flow) annotation (Line(points={{-58,20},{-24,20},
          {-24,-106},{-2,-106}}, color={0,0,127}));
  connect(TChwSet.y, hpRet.TChwSet) annotation (Line(points={{-98,160},{-50,160},
          {-50,-96},{-2,-96}}, color={0,0,127}));
  connect(THwSet.y, hpRet.THwSet) annotation (Line(points={{-98,120},{-50,120},
          {-50,-94},{-2,-94}}, color={0,0,127}));
  connect(hpRet.nUniHea, sumNumUni1.u[1]) annotation (Line(points={{22,-110},{
          26,-110},{26,-102.333},{28,-102.333}}, color={255,127,0}));
  connect(hpRet.nUniCoo, sumNumUni1.u[2]) annotation (Line(points={{22,-114},{
          26,-114},{26,-100},{28,-100}}, color={255,127,0}));
  connect(hpRet.nUniShc, sumNumUni1.u[3]) annotation (Line(points={{22,-118},{
          26,-118},{26,-97.6667},{28,-97.6667}}, color={255,127,0}));
  connect(filter3.y, hpRet.TChwEnt) annotation (Line(points={{29,-140},{-20,-140},
          {-20,-110},{-2,-110}}, color={0,0,127}));
  connect(filter2.y, hpRet.THwEnt) annotation (Line(points={{29,-60},{-20,-60},
          {-20,-102},{-2,-102}}, color={0,0,127}));
  connect(TChwLvg.y, hpRet.TChwLvg) annotation (Line(points={{-98,-120},{-30,-120},
          {-30,-112},{-2,-112}}, color={0,0,127}));
  connect(THwLvg.y, hpRet.THwLvg) annotation (Line(points={{-98,-80},{-32,-80},
          {-32,-104},{-2,-104}}, color={0,0,127}));
  connect(cp.y, hpRet.cpChw) annotation (Line(points={{-58,180},{-22,180},{-22,
          -116},{-2,-116}}, color={0,0,127}));
  connect(cp.y, hpRet.cpHw) annotation (Line(points={{-58,180},{-22,180},{-22,-108},
          {-2,-108}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-140,-180},{140,200}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/TableData2DLoadDepSHC.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=3600.0),
    Documentation(info="<html>
<p>
This model validates the load calculation and staging logic of the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>.
The two available control options are tested. 
The component <code>hpSup</code> uses supply temperature control,
while the component <code>hpRet</code> uses return temperature control.
</p>
<p>
The model represents a three-module system operating in constant 
simultaneous heating and cooling mode with the on/off command 
always <code>true</code>.
</p>
<p>
The validation is carried out by computing the tracked temperature
using the heat flow rate calculated by the block, and feeding back 
this variable as input to the heat pump model.
It is then expected that the tracked temperature matches the setpoint.
Note that a filtered value of the tracked temperature is used to avoid
creating an algebraic loop.
</p>
</html>", revisions="<html>
<ul>
<li>
July 1, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDepSHC;
