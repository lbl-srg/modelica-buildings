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
    table=[0,0; 720,0; 2000,TChwEnt.k - TChwSup_nominal; 2500,TChwEnt.k -
        TChwSup_nominal],
    offset={TChwSup_nominal},
    y(each final unit="K", each displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatSet(
    amplitude=THwEnt.k - THwSup_nominal,
    freqHz=1/3600,
    offset=THwSup_nominal + (THwEnt.k - THwSup_nominal)/2,
    startTime=500,
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
    hpSupLvg(
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
    "Heat pump with supply temperature control and performance data interpolation based on leaving temperature"
    annotation (Placement(transformation(extent={{0,-20},{20,12}})));
  Modelica.Blocks.Sources.RealExpression TConLvgHpSupLvg(y=hpSupLvg.THwEnt +
        hpSupLvg.QHea_flow/hpSupLvg.mHw_flow/hpSupLvg.cpHw)
    "Calculate condenser leaving temperature"
    annotation (Placement(transformation(extent={{30,66},{50,86}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgHpSupLvg(y=hpSupLvg.TChwEnt +
        hpSupLvg.QCoo_flow/hpSupLvg.mChw_flow/hpSupLvg.cpChw)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{30,-86},{50,-66}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=15 + 273.15, y(
        final unit="K", displayUnit="degC")) "OA temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Modelica.Blocks.Continuous.Filter filter(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=THwSup_nominal)
    annotation (Placement(transformation(extent={{50,30},{30,50}})));
  Modelica.Blocks.Continuous.Filter filter1(
    f_cut=1,
    init=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=TChwSup_nominal)
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupNom(k=
        THwSup_nominal, y(final unit="K", displayUnit="degC"))
    "Design HW supply temperature"
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
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=
        hpSupLvg.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(cp.y, hpSupLvg.cpChw) annotation (Line(points={{-8,-100},{-4,-100},{
          -4,-16},{-2,-16}},
                          color={0,0,127}));
  connect(mHw_flow.y, hpSupLvg.mHw_flow) annotation (Line(points={{-48,-100},{
          -40,-100},{-40,-6},{-2,-6}},
                                   color={0,0,127}));
  connect(THwEnt.y, hpSupLvg.THwEnt) annotation (Line(points={{-78,0},{-28,0},{
          -28,-2},{-2,-2}}, color={0,0,127}));
  connect(TChwEnt.y, hpSupLvg.TChwEnt) annotation (Line(points={{-78,-40},{-12,
          -40},{-12,-10},{-2,-10}}, color={0,0,127}));
  connect(TOut.y, hpSupLvg.TAmbEnt) annotation (Line(points={{-48,-60},{-26,-60},
          {-26,2},{-2,2}}, color={0,0,127}));
  connect(mChw_flow.y, hpSupLvg.mChw_flow) annotation (Line(points={{-78,-80},{
          -6,-80},{-6,-14},{-2,-14}}, color={0,0,127}));
  connect(cp.y, hpSupLvg.cpHw) annotation (Line(points={{-8,-100},{-4,-100},{-4,
          -8},{-2,-8}},       color={0,0,127}));
  connect(TConLvgHpSupLvg.y, filter.u)
    annotation (Line(points={{51,76},{60,76},{60,40},{52,40}},
                                                             color={0,0,127}));
  connect(TEvaLvgHpSupLvg.y, filter1.u) annotation (Line(points={{51,-76},{60,
          -76},{60,-40},{52,-40}},
                              color={0,0,127}));
  connect(filter1.y, hpSupLvg.TChwLvg) annotation (Line(points={{29,-40},{-8,
          -40},{-8,-12},{-2,-12}}, color={0,0,127}));
  connect(TChiWatSet.y[1], hpSupLvg.TChwSet) annotation (Line(points={{-28,60},
          {-12,60},{-12,4},{-2,4}}, color={0,0,127}));
  connect(THeaWatSet.y, min1.u1) annotation (Line(points={{-78,40},{-44,40},{-44,
          26},{-42,26}},     color={0,0,127}));
  connect(min1.y, hpSupLvg.THwSet) annotation (Line(points={{-18,20},{-14,20},{
          -14,6},{-2,6}}, color={0,0,127}));
  connect(THeaWatSupNom.y, min1.u2) annotation (Line(points={{-48,20},{-44,20},{
          -44,14},{-42,14}},  color={0,0,127}));
  connect(filter.y, hpSupLvg.THwLvg) annotation (Line(points={{29,40},{-4,40},{
          -4,-4},{-2,-4}}, color={0,0,127}));
  connect(mode.y[1], hpSupLvg.mode) annotation (Line(points={{-58,80},{-10,80},{
          -10,8},{-2,8}}, color={255,127,0}));
  connect(on.y[1], hpSupLvg.on) annotation (Line(points={{-28,100},{-8,100},{-8,
          10},{-2,10}}, color={255,0,255}));
  connect(hpSupLvg.nUniHea,sumNumUni. u[1]) annotation (Line(points={{22,-10},{
          26,-10},{26,-2.33333},{28,-2.33333}},
                                            color={255,127,0}));
  connect(hpSupLvg.nUniCoo,sumNumUni. u[2]) annotation (Line(points={{22,-14},{
          26,-14},{26,0},{28,0}},
                               color={255,127,0}));
  connect(hpSupLvg.nUniShc,sumNumUni. u[3]) annotation (Line(points={{22,-18},{
          26,-18},{26,2.33333},{28,2.33333}},
                                           color={255,127,0}));
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
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
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
<code>false</code> at the end.
</p>
<p>
The validation is carried out by computing the tracked temperature
using the heat flow rate calculated by the block, and feeding back 
this variable as input.
It is then expected that the tracked temperature matches the setpoint.
Note that a filtered value of the tracked temperature is used to avoid
creating an algebraic loop.
</p>
</html>", revisions="<html>
<ul>
<li>
FIXME, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDepSHCVariable;
