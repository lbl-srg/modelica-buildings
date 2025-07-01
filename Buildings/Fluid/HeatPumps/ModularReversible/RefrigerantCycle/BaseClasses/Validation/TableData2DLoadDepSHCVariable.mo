within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model TableData2DLoadDepSHCVariable
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature THwSup_nominal = 50 + 273.15
    "HW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THwRet_nominal = 42 + 273.15
    "HW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwSup_nominal = 7 + 273.15
    "CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwRet_nominal = 12 + 273.15
    "CHW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAmbHea_nominal = -5 + 273.15
    "OA temperature"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal = 58E3
    "Heating heat flow rate - Heating mode"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaShc_flow_nominal = 85E3
    "Heating heat flow rate - SHC mode"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.Temperature TAmbCoo_nominal = 35 + 273.15
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
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TChiWatSet(
    table=[0,0; 1500,0; 3000,TChwEnt.k - TChwSup_nominal; 3600,TChwEnt.k -
        TChwSup_nominal],
    offset={TChwSup_nominal},
    y(each final unit="K", each displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THwSet(
    amplitude=THwEnt.k - THwSup_nominal,
    freqHz=1/5000,
    offset=THwSup_nominal + (THwEnt.k - THwSup_nominal)/2,
    startTime=1000,
    y(final unit="K", displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THwEnt(k=THwSup_nominal +
    (THwRet_nominal - THwSup_nominal)*QHeaShc_flow_nominal/QHea_flow_nominal,
    y(final unit="K", displayUnit="degC")) "Condenser entering HW temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChwEnt(k=TChwSup_nominal +
    (TChwRet_nominal - TChwSup_nominal)* QCooShc_flow_nominal /QCoo_flow_nominal,
    y(final unit="K", displayUnit="degC"))
    "Evaporator entering CHW temperature"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mChw_flow(k=
        mChw_flow_nominal)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mHw_flow(k=mHw_flow_nominal)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp(
    k=Buildings.Media.Water.cp_const)
    "Specific heat capacity of load side fluid"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
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
    annotation (Placement(transformation(extent={{0,-20},{20,12}})));
  Modelica.Blocks.Sources.RealExpression TConLvgHpSup(y=hpSup.THwEnt + hpSup.QHea_flow
        /hpSup.mHw_flow/hpSup.cpHw) "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{30,60},{50,80}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgHpSup(y=hpSup.TChwEnt + hpSup.QCoo_flow
        /hpSup.mChw_flow/hpSup.cpChw)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=15 + 273.15, y(
        final unit="K", displayUnit="degC")) "OA temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Modelica.Blocks.Continuous.Filter filter(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=THwSup_nominal) "Filter to avoid algebraic loop"
    annotation (Placement(transformation(extent={{50,30},{30,50}})));
  Modelica.Blocks.Continuous.Filter filter1(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=TChwSup_nominal) "Filter to avoid algebraic loop"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Keep HW temperature setpoint below design value"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSwSupNom(k=THwSup_nominal,
      y(final unit="K", displayUnit="degC")) "Design HW supply temperature"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,3; 1,2; 2,1],
    timeScale=2000,
    period=6000)
                "Operating mode command"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable on(table=[0,1; 7000,0],
      period=7200)
                  "On/off command"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message=
        "Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hpSup.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(cp.y, hpSup.cpChw) annotation (Line(points={{-8,-100},{-4,-100},{-4,-16},
          {-2,-16}}, color={0,0,127}));
  connect(mHw_flow.y, hpSup.mHw_flow) annotation (Line(points={{-48,-100},{-40,
          -100},{-40,-6},{-2,-6}}, color={0,0,127}));
  connect(THwEnt.y, hpSup.THwEnt) annotation (Line(points={{-78,0},{-28,0},{-28,
          -2},{-2,-2}}, color={0,0,127}));
  connect(TChwEnt.y, hpSup.TChwEnt) annotation (Line(points={{-78,-40},{-12,-40},
          {-12,-10},{-2,-10}}, color={0,0,127}));
  connect(TOut.y, hpSup.TAmbEnt) annotation (Line(points={{-48,-60},{-26,-60},{
          -26,2},{-2,2}}, color={0,0,127}));
  connect(mChw_flow.y, hpSup.mChw_flow) annotation (Line(points={{-78,-80},{-6,
          -80},{-6,-14},{-2,-14}}, color={0,0,127}));
  connect(cp.y, hpSup.cpHw) annotation (Line(points={{-8,-100},{-4,-100},{-4,-8},
          {-2,-8}}, color={0,0,127}));
  connect(TConLvgHpSup.y, filter.u) annotation (Line(points={{51,70},{60,70},{
          60,40},{52,40}}, color={0,0,127}));
  connect(TEvaLvgHpSup.y, filter1.u) annotation (Line(points={{51,-70},{60,-70},
          {60,-40},{52,-40}}, color={0,0,127}));
  connect(filter1.y, hpSup.TChwLvg) annotation (Line(points={{29,-40},{-8,-40},
          {-8,-12},{-2,-12}}, color={0,0,127}));
  connect(TChiWatSet.y[1], hpSup.TChwSet) annotation (Line(points={{-28,60},{-12,
          60},{-12,4},{-2,4}}, color={0,0,127}));
  connect(THwSet.y, min1.u1) annotation (Line(points={{-78,40},{-44,40},{-44,26},
          {-42,26}}, color={0,0,127}));
  connect(min1.y, hpSup.THwSet) annotation (Line(points={{-18,20},{-14,20},{-14,
          6},{-2,6}}, color={0,0,127}));
  connect(TSwSupNom.y, min1.u2) annotation (Line(points={{-48,20},{-44,20},{-44,
          14},{-42,14}}, color={0,0,127}));
  connect(filter.y, hpSup.THwLvg) annotation (Line(points={{29,40},{-4,40},{-4,
          -4},{-2,-4}}, color={0,0,127}));
  connect(mode.y[1], hpSup.mode) annotation (Line(points={{-58,80},{-10,80},{-10,
          8},{-2,8}}, color={255,127,0}));
  connect(on.y[1], hpSup.on) annotation (Line(points={{-28,100},{-8,100},{-8,10},
          {-2,10}}, color={255,0,255}));
  connect(hpSup.nUniHea, sumNumUni.u[1]) annotation (Line(points={{22,-10},{26,
          -10},{26,-2.33333},{28,-2.33333}}, color={255,127,0}));
  connect(hpSup.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{22,-14},{26,
          -14},{26,0},{28,0}}, color={255,127,0}));
  connect(hpSup.nUniShc, sumNumUni.u[3]) annotation (Line(points={{22,-18},{26,
          -18},{26,2.33333},{28,2.33333}}, color={255,127,0}));
  connect(sumNumUni.y, intLesEquThr.u)
    annotation (Line(points={{52,0},{58,0}}, color={255,127,0}));
  connect(intLesEquThr.y, assMes.u)
    annotation (Line(points={{82,0},{88,0}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}}, grid={2,2})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/TableData2DLoadDepSHCVariable.mos"
        "Simulate and plot"),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the load calculation and staging logic of the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>.
</p>
<p>
The model represents a three-module system.
The operating mode switches between simultaneous heating and cooling, 
heating only, and cooling only.
The on/off command starts as <code>true</code> and is switched to 
<code>false</code> at the end of the simulated period.
</p>
<p>
The validation is carried out by computing the tracked temperature
using the heat flow rate calculated by the block, and feeding back 
this variable as input to the heat pump model.
It is then expected that the tracked temperature matches the setpoint,
under the constraints of step-by-step staging and minimum stage runtime.
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
end TableData2DLoadDepSHCVariable;
