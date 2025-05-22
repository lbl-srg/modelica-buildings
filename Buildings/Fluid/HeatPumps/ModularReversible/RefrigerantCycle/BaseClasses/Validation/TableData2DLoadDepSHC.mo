within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model TableData2DLoadDepSHC
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatSet(
    height=TChwEnt.k - TChwSup_nominal,
    duration=80,
    offset=TChwSup_nominal,
    startTime=10,
    y(final unit="K", displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatSet(
    height=THwEnt.k - THwSup_nominal,
    duration=50,
    offset=THwSup_nominal,
    startTime=10,
    y(final unit="K", displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THwEnt(k=THwSup_nominal +
    (THwRet_nominal - THwSup_nominal)*QHeaShc_flow_nominal/QHea_flow_nominal,
    y(final unit="K", displayUnit="degC")) "Condenser entering HW temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChwEnt(k=TChwSup_nominal +
    (TChwRet_nominal - TChwSup_nominal)* QCooShc_flow_nominal /QCoo_flow_nominal,
    y(final unit="K", displayUnit="degC"))
    "Evaporator entering CHW temperature"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onHea(k=true)
    "Heating mode enable"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mChw_flow(k=
        mChw_flow_nominal)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mHw_flow(k=mHw_flow_nominal)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp(
    k=Buildings.Media.Water.cp_const)
    "Specific heat capacity of load side fluid"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onCoo(k=true)
    "Cooling mode enable"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC
    hpSupLvg(
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    use_TAmbOutForTab=false,
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
    annotation (Placement(transformation(extent={{30,-4},{50,16}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvgHpSupLvg(y=hpSupLvg.TChwEnt +
        hpSupLvg.QCoo_flow/hpSupLvg.mChw_flow/hpSupLvg.cpChw)
    "Calculate evaporator leaving temperature"
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=15 + 273.15, y(
        final unit="K", displayUnit="degC")) "OA temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
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
equation
  connect(cp.y, hpSupLvg.cpChw) annotation (Line(points={{-58,100},{-20,100},{-20,
          -18},{-2,-18}}, color={0,0,127}));
  connect(mHw_flow.y, hpSupLvg.mHw_flow) annotation (Line(points={{-58,-100},{-40,
          -100},{-40,-8},{-2,-8}}, color={0,0,127}));
  connect(THwEnt.y, hpSupLvg.THwEnt) annotation (Line(points={{-98,0},{-28,0},{
          -28,-4},{-2,-4}}, color={0,0,127}));
  connect(TChiWatSet.y, hpSupLvg.TChwSet) annotation (Line(points={{-98,80},{-22,
          80},{-22,4},{-2,4}}, color={0,0,127}));
  connect(THeaWatSet.y, hpSupLvg.THwSet) annotation (Line(points={{-98,40},{-24,
          40},{-24,6},{-2,6}}, color={0,0,127}));
  connect(onCoo.y, hpSupLvg.onCoo) annotation (Line(points={{-58,20},{-28,20},{-28,
          8},{-2,8}}, color={255,0,255}));
  connect(onHea.y, hpSupLvg.onHea) annotation (Line(points={{-58,60},{-26,60},{-26,
          10},{-2,10}}, color={255,0,255}));
  connect(TChwEnt.y, hpSupLvg.TChwEnt) annotation (Line(points={{-98,-40},{-12,
          -40},{-12,-12},{-2,-12}}, color={0,0,127}));
  connect(TOut.y, hpSupLvg.TAmbEnt) annotation (Line(points={{-58,-20},{-26,-20},
          {-26,0},{-2,0}}, color={0,0,127}));
  connect(TOut.y, hpSupLvg.TAmbLvg) annotation (Line(points={{-58,-20},{-26,-20},
          {-26,-2},{-2,-2}}, color={0,0,127}));
  connect(mChw_flow.y, hpSupLvg.mChw_flow) annotation (Line(points={{-98,-80},{
          -6,-80},{-6,-16},{-2,-16}}, color={0,0,127}));
  connect(cp.y, hpSupLvg.cpHw) annotation (Line(points={{-58,100},{-20,100},{
          -20,-10},{-2,-10}}, color={0,0,127}));
  connect(TConLvgHpSupLvg.y, filter.u)
    annotation (Line(points={{51,6},{60,6},{60,40},{52,40}}, color={0,0,127}));
  connect(TEvaLvgHpSupLvg.y, filter1.u) annotation (Line(points={{51,-10},{60,-10},
          {60,-40},{52,-40}}, color={0,0,127}));
  connect(filter.y, hpSupLvg.THwLvg) annotation (Line(points={{29,40},{-4,40},{
          -4,-6},{-2,-6}}, color={0,0,127}));
  connect(filter1.y, hpSupLvg.TChwLvg) annotation (Line(points={{29,-40},{-4,
          -40},{-4,-14},{-2,-14}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/TableData2DLoadDepSHC.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=100.0),
    Documentation(info="<html>
<p>
This model validates the load calculation logic of the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>
for different system configurations and operating modes.
</p>
<ul>
<li>
The component <code>hpSupLvg</code> validates the block for
applications with HW and CHW supply temperature control 
and performance data interpolation based on evaporator and condenser 
leaving temperature.
</li>
</ul>
<p>
The validation is carried out by computing the tracked temperature
using the heat flow rate calculated by the block, and feeding back 
this variable as input.
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
end TableData2DLoadDepSHC;
