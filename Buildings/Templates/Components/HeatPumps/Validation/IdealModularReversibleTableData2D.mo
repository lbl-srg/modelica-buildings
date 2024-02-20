within Buildings.Templates.Components.HeatPumps.Validation;
model IdealModularReversibleTableData2D
  extends Modelica.Icons.Example;
  parameter Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08 datCoo
    "Performance data in cooling mode"
    annotation (Placement(transformation(extent={{100,112},{120,132}})));
  parameter Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08 datHea
    "Performance data in heating mode"
    annotation (Placement(transformation(extent={{70,112},{90,132}})));
  HeatPumps.Controls.IdealModularReversibleTableData2D ctl(
    hea(
      QHea_flow_nominal=hea.QHea_flow_nominal,
      datTab=hea.datTab,
      TCon_nominal=hea.TCon_nominal,
      TEva_nominal=hea.TEva_nominal,
      dTCon_nominal=hea.dTCon_nominal,
      dTEva_nominal=hea.dTEva_nominal,
      cpCon=hea.cpCon,
      cpEva=hea.cpEva,
      useInHeaPum=true),
    coo(
      QCoo_flow_nominal=coo.QCoo_flow_nominal,
      datTab=coo.datTab,
      TCon_nominal=coo.TCon_nominal,
      TEva_nominal=coo.TEva_nominal,
      dTCon_nominal=coo.dTCon_nominal,
      dTEva_nominal=coo.dTEva_nominal,
      cpCon=coo.cpCon,
      cpEva=coo.cpEva,
      useInChi=false))
    "Controller"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D hea(
    QHea_flow_nominal=hea.datTab.tabQCon_flow[4, 4],
    final datTab=datHea,
    TCon_nominal=hea.datTab.tabPEle[4, 1],
    TEva_nominal=hea.datTab.tabPEle[1, 4],
    dTCon_nominal=hea.QHea_flow_nominal / hea.cpCon / hea.mCon_flow_nominal,
    dTEva_nominal=(hea.QHea_flow_nominal - hea.PEle_nominal) / hea.cpEva / hea.mEva_flow_nominal,
    cpCon=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cpEva=Buildings.Utilities.Psychrometrics.Constants.cpAir,
    useInHeaPum=true)
    "Compute performance in heating mode"
    annotation (Placement(transformation(extent={{102,-10},{122,10}})));
protected
  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus bus
    "Heat pump control bus"
    annotation (Placement(transformation(extent={{40,20},{80,60}}),
      iconTransformation(extent={{-176,-92},{-136,-52}})));
public
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConInMeaHea(
    y(unit="K",
      displayUnit="degC"),
    k=hea.TCon_nominal - hea.dTCon_nominal)
    "Condenser inlet temperature in heating mode"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TEvaInMea(
    y(unit="K",
      displayUnit="degC"),
    amplitude=40,
    freqHz=10 / 300,
    offset=10 + 273.15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatSupSet(
    y(unit="K",
      displayUnit="degC"),
    amplitude=8,
    freqHz=5 / 300,
    offset=hea.TCon_nominal)
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[
      0, 0, 0;
      1, 1, 0;
      2, 1, 1],
    timeScale=100,
    period=300)
    "Enable and heating/cooling mode command signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSetAct(
    y(unit="K",
      displayUnit="degC"))
    "Actual setpoint"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatSupSet(
    y(unit="K",
      displayUnit="degC"),
    amplitude=15,
    freqHz=5 / 300,
    offset=coo.TEva_nominal)
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D coo(
    QCoo_flow_nominal=coo.datTab.tabQEva_flow[2, 6],
    final datTab=datCoo,
    TCon_nominal=coo.datTab.tabPEle[1, 6],
    TEva_nominal=coo.datTab.tabPEle[2, 1],
    dTCon_nominal=(abs(coo.QCoo_flow_nominal) + coo.PEle_nominal) / coo.cpCon /
      coo.mCon_flow_nominal,
    dTEva_nominal=coo.QCoo_flow_nominal / coo.cpEva / coo.mEva_flow_nominal,
    cpCon=Buildings.Utilities.Psychrometrics.Constants.cpAir,
    cpEva=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    useInChi=false)
    "Compute performance in cooling mode"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TEvaOutMea(
    y(unit="K",
      displayUnit="degC"),
    amplitude=10,
    freqHz=10 / 300,
    offset=hea.TEva_nominal)
    "Evaporator outlet temperature - Placeholder value"
    annotation (Placement(transformation(extent={{-92,-50},{-72,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConInMeaCoo(
    y(unit="K",
      displayUnit="degC"),
    k=coo.TEva_nominal - coo.dTEva_nominal)
    "Condenser inlet temperature in cooling mode"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TConInMea(
    y(unit="K",
      displayUnit="degC"))
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
public
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mConMea_flow(
    k=datHea.mCon_flow_nominal)
    "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
equation
  connect(bus, hea.sigBus)
    annotation (Line(points={{60,40},{112,40},{112,26},{112.083,26},{112.083,10}},
      color={255,204,51},thickness=0.5));
  connect(bus, ctl.bus)
    annotation (Line(points={{60,40},{60,10}},color={255,204,51},thickness=0.5));
  connect(u1.y[1], ctl.u1)
    annotation (Line(points={{-98,120},{-20,120},{-20,8},{48,8}},color={255,0,255}));
  connect(u1.y[2], ctl.u1Hea)
    annotation (Line(points={{-98,120},{-20,120},{-20,4},{48,4}},color={255,0,255}));
  connect(TEvaInMea.y, bus.TEvaInMea)
    annotation (Line(points={{-98,-20},{-40,-20},{-40,40},{60,40}},color={0,0,127}));
  connect(TSetAct.y, ctl.TSupSet)
    annotation (Line(points={{12,-20},{14,-20},{14,0},{48,0}},color={0,0,127}));
  connect(u1.y[2], TSetAct.u2)
    annotation (Line(points={{-98,120},{-20,120},{-20,-20},{-12,-20}},color={255,0,255}));
  connect(THeaWatSupSet.y, TSetAct.u1)
    annotation (Line(points={{-98,-80},{-36,-80},{-36,-12},{-12,-12}},color={0,0,127}));
  connect(TChiWatSupSet.y, TSetAct.u3)
    annotation (Line(points={{-98,-120},{-32,-120},{-32,-28},{-12,-28}},color={0,0,127}));
  connect(ctl.y, bus.ySet)
    annotation (Line(points={{72,0},{80,0},{80,40},{60,40}},color={0,0,127}));
  connect(THeaWatSupSet.y, bus.TConOutMea)
    annotation (Line(points={{-98,-80},{-40,-80},{-40,40},{60,40}},color={0,0,127}));
  connect(bus, coo.sigBus)
    annotation (Line(points={{60,40},{90,40},{90,-20},{110.083,-20},{110.083,-30}},
      color={255,204,51},thickness=0.5));
  connect(TEvaOutMea.y, bus.TEvaOutMea)
    annotation (Line(points={{-70,-40},{-40,-40},{-40,40},{60,40}},color={0,0,127}));
  connect(TConInMeaCoo.y, TConInMea.u3)
    annotation (Line(points={{-98,20},{-56,20},{-56,52},{-12,52}},color={0,0,127}));
  connect(TConInMeaHea.y, TConInMea.u1)
    annotation (Line(points={{-68,40},{-60,40},{-60,68},{-12,68}},color={0,0,127}));
  connect(u1.y[2], TConInMea.u2)
    annotation (Line(points={{-98,120},{-20,120},{-20,60},{-12,60}},color={255,0,255}));
  connect(TConInMea.y, bus.TConInMea)
    annotation (Line(points={{12,60},{60,60},{60,40}},color={0,0,127}));
  connect(mConMea_flow.y, bus.mConMea_flow)
    annotation (Line(points={{-98,80},{-40,80},{-40,40},{60,40}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/HeatPumps/Validation/IdealModularReversibleTableData2D.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=300),
    Diagram(
      coordinateSystem(
        extent={{-140,-140},{140,140}})),
    Documentation(
      info="<html>
<p>
This model validates the ideal heat pump controller
<a href=\"modelica://Buildings.Templates.Components.HeatPumps.Controls.IdealModularReversibleTableData2D\">
Buildings.Templates.Components.HeatPumps.Controls.IdealModularReversibleTableData2D</a>
with varying supply temperature setpoint and operating mode switching.
</p>
<p>
The output signal of the controller is used as input for the components <code>hea</code>
and <code>coo</code>, which calculate the heat pump performance in heating and
cooling mode. 
The validation is based on the comparison of the required capacity 
<code>ctl.Q(Hea|Coo)Req_flow</code> computed by the controller
and the actual capacity <code>(hea|coo).Q(Con|Eva)_flow</code> 
computed by the heat pump components at the prescribed speed
and supply temperature setpoint is met.
</p>
</html>"));
end IdealModularReversibleTableData2D;
